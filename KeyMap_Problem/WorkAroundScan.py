#!/usr/bin/python

import sys
import os
import subprocess
import termios
import fcntl
from subprocess import PIPE
from subprocess import Popen

def run( dev_name ):
    keyline = Popen(["./keymap_update","-i", dev_name], stdout=PIPE, bufsize=0).communicate()[0].split("\n")[0]
    print keyline
    index = keyline.find( "esc" )
    if index == -1:
        return True
    return False

#find_key_p = Popen(["./findkeyboards"], stdout=PIPE)
#find_key_p.wait()
#DEV = find_key_p.communicate()[0].split("\n")[0]
DEV = Popen(["./findkeyboards"], stdout=PIPE).communicate()[0].split("\n")[0]
i=0
while run( DEV ):
    i += 1 
