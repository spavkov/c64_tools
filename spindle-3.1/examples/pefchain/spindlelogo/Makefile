CFLAGS=-Wall
MKPEF=../../../src/mkpef
PEF2PRG=../../../src/pef2prg

all:			spindlelogo.pef spindlelogo.prg

effect.efo:		effect.s graphics.bin
			xa -o $@ $<

spindlelogo.pef:	effect.efo
			$(MKPEF) -o $@ $^

%.prg:			%.pef
			$(PEF2PRG) -o $@ $^

graphics.bin:		mklogo
			./mklogo >$@
