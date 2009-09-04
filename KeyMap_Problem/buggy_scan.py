#!/usr/bin/python

import sys
import os
import subprocess
import termios
from subprocess import PIPE
from subprocess import Popen
#import asyncproc
#from asynproc import *

#DEV = Popen(["./findkeyboards"], stdout=PIPE).communicate()[0].split("\n")[0]
find_key_p = Popen(["./findkeyboards"], stdout=PIPE)
find_key_p.wait()
DEV = find_key_p.communicate()[0].split("\n")[0]


lala = subprocess.Popen(["./keymap -i "+ DEV], bufsize=0, shell=True, stdout=subprocess.PIPE)

fdout = lala.stdout.fileno()

old_attr = termios.tcgetattr(0)
new_attr = old_attr[:]
new_attr[3] = new_attr[3] & ~termios.ICANON
termios.tcsetattr(0, termios.TCSAFLUSH, new_attr)

while lala.poll() == None :
       print os.read(fdout, 1)

termios.tcsetattr(0, termios.TCSAFLUSH, old_attr)
