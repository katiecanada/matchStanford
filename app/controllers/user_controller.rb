class UserController < ApplicationController
  # Restrict all controller actions to logged-in users
  before_filter :require_login, :except => [:login, :logout, :nouser]

  LIMIT = 14

  def login
    if session[:user] then
      redirect_to :action => :splash
      return
    end

    #commenting out webauth
   if !params[:WA_user] then
    #  # Redirect to Trusheim's WebAuth endpoint
     return_url = request.protocol + request.host_with_port
      @wa_url = "https://www.stanford.edu/~trusheim/cgi-bin/wa-authenticate-match13.php?return=#{return_url}&next="
      #redirect_to "https://www.stanford.edu/~trusheim/cgi-bin/wa-authenticate.php?return=#{return_url}&next="
      return
    end

    #test sunet id
    #sunetid='kredmond'
    sunetid = Base64.decode64(params[:WA_user])
 
    nonce, hash = params[:WA_hash].split("$")
    #secret = "test"
    secret = "Vma9K5xX625uF7gJTT5zuEkhsiYT96fmDsjbRDmH"
  
   hashstr = secret + nonce + sunetid
  expectedHash = Digest::SHA1.hexdigest(hashstr)

#don't require hashes to match for testing
    if expectedHash == hash then
      user = User.where(:username => sunetid)[0]
      if !user then
        redirect_to :action => :nouser
        return
      end
      session[:user] = sunetid

      if user.doSplash then
        redirect_to :action => :splash
      else
        redirect_to :action => :show
      end
    else
      redirect_to :action => :logout
    end
  end

  def logout
    reset_session
  end

  def splash
    @user = User.where(:username => session[:user])[0]

    if !@user then
      render :status => :bad_request, :text => "User does not exist."
      return
    end

    @limit = LIMIT
  end

  def show
    @user = User.where(:username => session[:user])[0]

    if !@user then
      render :status => :bad_request, :text => "User does not exist."
      return
    end

    @limit = LIMIT

    # TODO: remove these
    #@to_users = @user.to_users
    #@from_users = @user.from_users
  end

  def choices
    #to_users = User.where(:username => session[:user])[0].to_users
    #render :json => to_users
    #return

    #choices = []
    #to_users.each do |tu|
    #  choices.append(tu.id)
    #end

    choices = User.where(:username => session[:user])[0].choices
    if choices.nil? or choices.blank? then
      choices = "[]"
    end

    choiceUsers = []
    JSON.parse(choices).each do |i|
      choiceUsers.append User.select("firstname, middlename, lastname, id").find(i)
    end

    render :json => choiceUsers
  end

  def update
    user = User.where(:username => session[:user])[0]
    choices = params[:choices]
    if (!choices.kind_of?(Array)) then
      choices = []
    end

    if choices.length > LIMIT then
      choices = choices[0..(LIMIT-1)]
    end
    user.choices = choices.to_json
    user.doSplash = false

    # Delete all previous choices
    # c = user.to_choices
    # c.each do |c|
    #   c.delete
    # end

    # choices.each do |index|
    #   newChoice = Choice.new
    #   newChoice.to_id = index
    #   newChoice.from_id = user.id
    #   newChoice.save
    # end

    user.save()

    render :json => user
  end

  def saved
    @user = User.where(:username => session[:user])[0]
  end

  def nouser
  end

  def faq
  end

  def done
    # Just display the template
  end

  def all
    if params[:query].nil? || params[:query].empty? then
      render :json => []
      return
    end

    if params[:query].gsub(/\s+/, "").length < 3 then
      render :status => :bad_request, :text => "Query must be at least three characters long."
      return
    end

    users = User.select("firstname, middlename, lastname, id, username")
    queries = params[:query].downcase.split(' ')

    render :json => users.select { |u|
      rval = true
      queries.each do |query|
        if !((!u.firstname.nil? && u.firstname.downcase.start_with?(query)) || (!u.middlename.nil? && u.middlename.downcase.start_with?(query)) || (!u.lastname.nil? && u.lastname.downcase.start_with?(query))||(!u.username.nil? && u.lastname.downcase.start_with?(query)) then
          rval = false
        end
      end
      rval
    }
  end


  private

  def require_login
    unless session[:user]
      redirect_to :action => :logout
    end
  end
end
