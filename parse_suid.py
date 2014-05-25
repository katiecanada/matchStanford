import sys

#raw subscriber list added here
def parse(filename):
	f = open(filename, 'r')
	fo = open('suids.txt', 'w+')
	for line in f:
		terms = line.split()
		suid = terms[0]
		if suid[0] == '(':
			suid = suid[1:]
		fo.write(suid)
		fo.write('\n')

parse(sys.argv[1])