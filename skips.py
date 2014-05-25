import sys

def print_blanks(filename):
	f = open(filename, 'r')
	for line in f:
		if line[-4:] == ",,,\n":
			print line


print_blanks(sys.argv[1])