#!/bin/python3
import sys
import os

# Made by D
# Has nothing to do with the package, just a fun script 
# used to generate our colored ascii art;

#Usage statement
if len(sys.argv) == 1:
    print(f"Usage {sys.argv[0]} <input_file> <output_file> [color_name=chars ...]" )
    sys.exit(1)

def color_file(input_file, output_file, args):
    color_to_ascii = {
        "red": "31",
        "green": "32",
        "yellow": "33",
        "blue": "34",
        "magenta": "35",
        "cyan": "36",
        "white": "37",
        "black": "30"
    }

    with open (input_file,'r') as orig, open (output_file,'w') as new:
        for c in orig.read():
            for i in args:
                a = i.split('=')
                if c in a[1]:
                    c = f"\033[{color_to_ascii[a[0]]}m{c}\033[m"
            new.write(c)

color_file(sys.argv[1],sys.argv[2],sys.argv[3:])
