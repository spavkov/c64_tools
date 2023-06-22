CFLAGS=-Wall
MKPEF=../../src/mkpef
PEF2PRG=../../src/pef2prg
PEFCHAIN=../../src/pefchain

all:			slideshow.d64

%.efo:			%.s
			xa -o $@ $<

slideprep.pef:		prepare.efo
			$(MKPEF) -v -o $@ $<

slideshow.pef:		display.efo stream-01.prg stream-02.prg stream-03.prg stream-04.prg
			$(MKPEF) -v -o $@ $< --stream stream-*.prg

slideshow.d64:		script slideprep.pef slideshow.pef
			$(PEFCHAIN) $< -o $@ --loop 5

stream-01.prg:		gfx-tenbo.prg mkgfx
			./mkgfx $< a000 >$@

stream-02.prg:		gfx-reckoning.prg mkgfx
			./mkgfx $< b000 >$@

stream-03.prg:		gfx-downunder.prg mkgfx
			./mkgfx $< a000 >$@

stream-04.prg:		gfx-rawr.prg mkgfx
			./mkgfx $< b000 >$@

%.prg:			%.pef
			$(PEF2PRG) -m monscript -o $@ $^

graphics.bin:		mkgfx
			./mkgfx >$@
