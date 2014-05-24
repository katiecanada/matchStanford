import subprocess
import sys

def search(suid):
  p = subprocess.Popen(["ldapsearch -h ldap.stanford.edu uid=" + suid], stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
  o, err = p.communicate()

  firstName = ""
  middleName = ""
  lastName = ""

  for line in o.split('\n'):
    if "suDisplayNameFirst" in line:
      firstName = line.split(':')[1][1:]
    if "suDisplayNameLast" in line:
      lastName = line.split(':')[1][1:]
    if "suDisplayNameMiddle" in line:
      middleName = line.split(':')[1][1:]

  return suid + "," + firstName + "," + middleName + "," + lastName

def suidFile(fileName):
  f = open(fileName, 'r')
  fo = open("out.txt", 'w')
  for line in f:
    fo.write(search(line.rstrip()))
    fo.write('\n')

#search(sys.argv[1])
suidFile(sys.argv[1])
