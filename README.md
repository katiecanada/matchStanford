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

### Emails

There is a script in the script/ directory to send emails using the UNIX mailer installed on the Stanford servers. typing

	ruby script/email.rb

will give you a list of commands that are possible from the script. Keep in mind that these commands must be run from the rails console, and are actually loaded as functions. Thus, you must do something like this:

	rails console
	>>> load('script/email.rb')
	>>> blast_teasers()

### Statistics

There is also a ruby script for printing statistics about the application's usage. To run, load script/stats.rb from the rails console

	rails console
	>>> load('script/stats.rb')
	>>> crushed()