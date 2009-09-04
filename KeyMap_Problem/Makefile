
all: keymap_update keymap

keymap_update: keymap_update.c keys-from-name.h keys-to-name.h 
	gcc -o keymap_update keymap_update.c 

keymap: keymap.c keys-from-name.h keys-to-name.h 
	gcc -o keymap keymap.c 

keys.txt: /usr/include/linux/input.h
	gawk '/^#define.*KEY_/ { if ($$2 != "KEY_MAX" && $$2 != "KEY_CNT") { print $$2 } }' < $< > $@

keys-from-name.gperf: keys.txt
	gawk 'BEGIN{ print "struct key { const char* name; unsigned short id; };"; print "%null-strings"; print "%%";} { print $$1 ", " $$1 }' < $< > $@

keys-from-name.h: keys-from-name.gperf Makefile
	gperf -L ANSI-C -t --ignore-case -N lookup_key -H hash_key_name -p -C < $< > $@

keys-to-name.h: keys.txt Makefile
	gawk 'BEGIN{ print "const char* const key_names[KEY_CNT] = { "} { print "[" $$1 "] = \"" $$1 "\"," } END{print "};"}' < $< > $@


clean:
	rm -rf keys.txt keys-from-name.gperf keys-from-name.h keys-to-name.h keymap keymap_update
