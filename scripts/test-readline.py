#!//usr/bin/env python
# 
# test read file line by line 
#

import sys, re

print 'Number of arguments:', len(sys.argv), 'arguments.'
print 'Argument List:', str(sys.argv)

with open(sys.argv[1], 'r') as my_file:
    for line in my_file:
        line = line.split('#', 1)[0]
        if not re.match(r'^\s*$', line):
            print(line)

