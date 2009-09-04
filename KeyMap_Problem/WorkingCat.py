#!/usr/bin/python
import termios, subprocess, os

#lala = subprocess.Popen("/bin/cat", bufsize=0, shell=True, stdout=subprocess.PIPE)
lala = subprocess.Popen("/bin/cat", bufsize=0, stdout=subprocess.PIPE)

fdout = lala.stdout.fileno()

old_attr = termios.tcgetattr(0)
new_attr = old_attr[:]
new_attr[3] = new_attr[3] & ~termios.ICANON & ~termios.ECHO
termios.tcsetattr(0, termios.TCSAFLUSH, new_attr)

while lala.poll() == None :
       print os.read(fdout, 1)

termios.tcsetattr(0, termios.TCSAFLUSH, old_attr)
