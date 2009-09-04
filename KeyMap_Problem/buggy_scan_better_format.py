#!/usr/bin/python

import sys
import os
import subprocess
import termios
import fcntl
from subprocess import PIPE
from subprocess import Popen
#import asyncproc
#from asynproc import *

#DEV = Popen(["./findkeyboards"], stdout=PIPE).communicate()[0].split("\n")[0]
#find_key_p = Popen(["./findkeyboards"], stdout=PIPE)
#find_key_p.wait()
#DEV = find_key_p.communicate()[0].split("\n")[0]
#keymap_p = Popen(["./keymap","-i", DEV], stdout=subprocess.PIPE, bufsize=0)
keymap_p = Popen(["./keymap","-i", "/dev/input/event0"], stdout=subprocess.PIPE, bufsize=0)
fdout = keymap_p.stdout.fileno()

old_attr = termios.tcgetattr(0)
new_attr = old_attr[:]
new_attr[3] = new_attr[3] & ~termios.ICANON & ~termios.ECHO
#new_attr[3] = new_attr[3] & ~termios.ICANON
termios.tcsetattr(0, termios.TCSAFLUSH, new_attr)
oldflags = fcntl.fcntl(0, fcntl.F_GETFL)
fcntl.fcntl(0, fcntl.F_SETFL, oldflags | os.O_NONBLOCK)  

i = 0

try:
    while keymap_p.poll() == None :
       line = ""
       temp = os.read(fdout,1)
       while ( temp != '\n' and temp != "" ):
           line += temp
           temp = os.read(fdout,1)
       #line = keymap_p.stdout.read()
       #if line != "": 
       if( line != "" ):
           i += 1
           sys.stdout.write (line + str( i ) +"\n" )
           sys.stdout.flush()
finally:
    termios.tcsetattr(0, termios.TCSAFLUSH, old_attr)
    fcntl.fcntl(0, fcntl.F_SETFL, oldflags)
