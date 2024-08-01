#!/bin/python3
import sys
import os
import re

# Made by D
# Has nothing to do with the package, just a fun script 
# used to generate our centered text;

#Usage statement
if len(sys.argv) == 1:
    print(f"Usage {sys.argv[0]} <input_text>" )
    sys.exit(1)

def center_text(input_text):
    
    rows, columns = map(int, os.popen('stty size', 'r').read().split())
    ansi_escape = re.compile(r'\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])')
    maxLength = len(ansi_escape.sub('',input_text))
    print((' ' * int((columns - maxLength) / 2)) + input_text.lstrip())

center_text(sys.argv[1])
