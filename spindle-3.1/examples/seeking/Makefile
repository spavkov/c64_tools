all:		disk.d64

jukebox.prg:	jukebox.s ../../template/seek.s
		xa -o $@ $<

disk.d64:	script jukebox.prg *.sid
		../../src/spin -vv -o $@ $<
