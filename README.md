# MatchStanford

This is the repository for the code behind MatchStanford, originally developed for the Stanford
senior class of 2013.

# Setup

### Initialize Database

Like any other RoR database, begin by initializing the database from its migrations:

    rake db:migrate

### Users

To import a list of users, place a file called suids.txt in the root directory of the project, in
the following format

    suid,FirstName,MiddleName,LastName

Then, from the root directory, run 

    rails console
    >>> load('script/load_suids.rb')

This should load the list of users into the application's database.

### WebAuth

Stanford WebAuth login requires redirecting the browser to a PHP script set up to perform the login
request. This communication requires a shared secret key for security, which is specified in the
user\_controller.rb file.

The PHP script must be run from a privileged location. The details of setting this up must be worked out with someone with knowledge of the Stanford WebAuth system.
