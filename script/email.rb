require 'erb'

class EmailRenderer
  def set_variables(to_email, subject, to_name, from_name)
    @headers = """From: MatchTHIRTEEN <matchfourteen@gmail.com>
To: #{to_email}
Subject: #{subject}
Mime-Version: 1.0
Content-Type: text/html"""

    @to_name = to_name
    @from_name = from_name
  end

  def read_file(file_name)
    file = File.open(file_name, "r")
    data = file.read
    file.close
    return data
  end

  def render_email(template, subject, to_suid, to_name, from_name)
    set_variables "#{to_suid}@stanford.edu", subject, to_name, from_name
    return ERB.new(read_file template).result(binding)
  end
end

#
# Get the list of chosen users. Also returns the lsit
# of non-chosen users as a second parameter
#
def get_chosen
  chosen = []
  allusers = []
  users = User.all

  users.each do |u|
    allusers.append({:name => u.firstname, :suid => u.username})

    choices = u.choices
    if choices.nil? or choices.blank? then
      choices = "[]"
    end

    choicesArray = JSON.parse(choices)

    if choicesArray.length > 0 then
      choicesArray.each do |i|
        to_user = User.find(i)
        chosen.append({:name => to_user.firstname, :suid => to_user.username})
      end
    end
  end

  chosen.uniq!

  notChosen = allusers.reject{ |u| chosen.include?(u) }

  return chosen, notChosen
end

#
# Send a teaser to one user
#
def send_teaser(to_suid, to_name)
  body = EmailRenderer.new.render_email("./script/crush-email.html", "MatchTHIRTEEN: You've Been Ranked!", to_suid, to_name, "")
  File.open("./tmp/send.html", 'w') { |file| file.write(body) }
  `cat tmp/send.html | sendmail -t`
end

#
# Send teasers to chosen users, plus a random subset of non-chosen users
#
def blast_teasers
  chosen, notChosen = get_chosen()
  c = 0

  notChosen = notChosen.keep_if{ |u|
    c += 1
    c % 4 == 0
  }
  puts notChosen.length

  sent_emails = 0

  chosen.each do |u|
    send_teaser u[:suid], u[:name]
    sent_emails += 1
    puts "Sent to #{u[:suid]}, #{u[:name]}"
  end

  puts "====================================================="

  notChosen.each do |u|
    send_teaser u[:suid], u[:name]
    sent_emails += 1
    puts "Sent to #{u[:suid]}, #{u[:name]}"
  end

  puts "Sent #{sent_emails} emails"
end

def get_matches
  choicesEdges = []

  users = User.all
  users.each do |u|
    choices = u.choices
    if choices.nil? or choices.blank? then
      choices = "[]"
    end

    choicesArray = JSON.parse(choices)
    if choicesArray.length > 0 then
      choicesArray.each do |i|
        fromu = User.find(i)
        choicesEdges.append({
          :from => { :suid => u.username, :name => "#{u.firstname} #{u.middlename} #{u.lastname}" },
          :to => { :suid => fromu.username, :name => "#{fromu.firstname} #{fromu.middlename} #{fromu.lastname}" },
        })
      end
    end
  end

  choicesEdges.uniq!

  mutuals = []

  choicesEdges.each do |edge|
    choicesEdges.select { |e| e[:from] == edge[:to] && e[:to] == edge[:from] }.each do |m|
      m2 = m
      if (m[:to][:suid] <=> m[:from][:suid]) < 0 then
        m2 = {:from => m[:to], :to => m[:from]}
      end
      mutuals.append m2
    end
  end

  mutuals.uniq!

  return mutuals
end

def send_match(to_suid, match_name)
  body = EmailRenderer.new.render_email("./script/match-email.html", "MatchTHIRTEEN: You've Got A Match!", to_suid, "", match_name)
  File.open("./tmp/send.html", 'w') { |file| file.write(body) }
  `cat tmp/send.html | sendmail -t`
end

def mail_matches
  matches = get_matches

  sent_mails = 0

  matches.each do |match|
    sent_mails += 1
    send_match(match[:to][:suid], match[:from][:name])
    send_match(match[:from][:suid], match[:to][:name])
    puts "Sent #{sent_mails}"
  end

  puts "Sent #{sent_mails} emails"
end


#
# Display help
#
puts """
===============================
Commands:
  send_teaser(to_suid, to_name)
  blast_teasers
  send_match(to_suid, match_name)
  matches = get_matches
  mail_matches
===============================

"""