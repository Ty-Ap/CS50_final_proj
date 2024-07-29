#!/bin/python3
import sys
import os
import re

# Made by D
# Has nothing to do with the package, just a fun script 
# used to generate our centered text;

#Usage statement
if len(sys.argv) == 1:
    print(f"Usage {sys.argv[0]} <input_file>" )
    sys.exit(1)

def center_file(input_file):
    
    rows, columns = map(int, os.popen('stty size', 'r').read().split())
    ansi_escape = re.compile(r'\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])')
    
    with open(input_file, 'r') as file:
        
        lines = file.readlines()
        maxLength = len(max([ansi_escape.sub('',i) for i in lines], key = len))
        
        for line in lines:
            print((' ' * int((columns - maxLength) / 2)) + line.lstrip(),end='')

center_file(sys.argv[1])
