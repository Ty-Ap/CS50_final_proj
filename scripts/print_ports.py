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

numPorts = int(sys.argv[1]) + 3
ports = sys.argv[3:numPorts]
data = sys.argv[numPorts:]
color = color_text(sys.argv[2])
height, width = map(int, os.popen('stty size', 'r').read().split())
sumWidths = sum([len(remove_ansi(color_text(i))) for i in ports])
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

if len(data) > 0:
    # Split each paragraph into lines of the specified width
    lines = [p.split(',') for p in data]
    # Find the maximum number of lines in any paragraph
    max_lines = max(len(p) for p in lines)

    # Print each line side by side
    for i in range(max_lines): #iterate vertically
        line_parts = []
        for p,x in zip(lines,range(len(lines))): #iterate horizontally
            if i < len(p): #Check line exists
                    if x == 0:
                        line_parts.append(" "*padding+p[i].replace("_"," "))
                    else:
                        line_parts.append(" "*(padding-(len(p[i])-(len(remove_ansi(ports[x]))+1)))+p[i].replace("_"," "))
    
        print(''.join(line_parts))

