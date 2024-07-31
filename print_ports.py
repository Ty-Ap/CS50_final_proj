#!/bin/python3

import sys, os, re

#Usage statement
if len(sys.argv) == 1:
    print(f"Usage [ports] [data]" )
    sys.exit(1)
def color_text(color):
    return color.encode().decode('unicode_escape')
def remove_ansi(text):
    ansi_escape = re.compile(r'\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])')
    return ansi_escape.sub('',text)
ports = sys.argv[1].split(",")
clean_ports = [remove_ansi(i) for i in ports]
data = sys.argv[2].split(",")
color = color_text(sys.argv[3])
height, width = map(int, os.popen('stty size', 'r').read().split())

sumWidths = sum([len(i)+2 for i in ports])
padding = round((width - sumWidths) / (len(ports) + 1))
for i in range(len(ports)):
    ports[i] = color_text(ports[i])
for port in ports:
    print(color+" "*padding+"╔"+("═"*len(remove_ansi(port)))+"╗\033[m",end='')
print()
for port in ports:
    print(" "*padding+color+"║\033[m"+color_text(port)+color+"║\033[m", end='')
print()
for port in ports:
    print(" "*padding+color+"╚"+("═"*len(remove_ansi(port)))+"╝\033[m", end='')
print()


# Split each paragraph into lines of the specified width
lines = [p.split('\\n') for p in data]
# Find the maximum number of lines in any paragraph
max_lines = max(len(p) for p in lines)

# Print each line side by side
for i in range(max_lines): #iterate vertically
    line_parts = []
    for p,x in zip(lines,range(len(lines))): #iterate horizontally
        if i < len(p): #Check line exists
            if x == 0:
                line_parts.append(" "*padding+p[i])
            else:
                line_parts.append(" "*(padding-(len(p[i])-(len(remove_ansi(ports[x]))+1)))+p[i])
    
    print(''.join(line_parts))

