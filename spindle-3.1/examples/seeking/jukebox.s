; This is an example demo bundled with Spindle
; linusakesson.net/software/spindle/

curr_song	= $30

LOADER		= $200
entry		= $8000

	.word	entry
	* = entry

	lda	#$ff
	sta	$dc02
	lda	#$fe
	sta	$dc00

	lda	#$16
	sta	$d018

	ldx	#0
	stx	curr_song
loadsong
	jsr	LOADER

	ldx	#31
textloop
	lda	$4000,x
	bne	nospace

	lda	#$20
nospace
	cmp	#$60
	bcc	convdone

	sbc	#$60
convdone
	sta	$400,x
	dex
	bpl	textloop

	jsr	$1000
play
	bit	$d011
	bmi	*-3
	bit	$d011
	bpl	*-3
	dec	$d020
	jsr	$1003
	inc	$d020

	lda	$dc01

	ldx	#0
	cmp	#$ef		; f1
	beq	got_key

	inx
	cmp	#$df		; f3
	beq	got_key

	inx
	cmp	#$bf		; f5
	beq	got_key

	inx
	cmp	#$f7		; f7
	bne	play

got_key
	cpx	curr_song
	beq	play

	ldy	#$17
	lda	#0
clearsid
	sta	$d400,y
	dey
	bpl	clearsid

	stx	curr_song
	txa
	jsr	spin_seek
	jmp	loadsong

#include "../../template/seek.s"
