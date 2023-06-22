; This is an example demo bundled with Spindle
; linusakesson.net/software/spindle/

; The preparations are kept in a separate effect
; to allow looping without reloading the code itself.

ptr		= $10
count		= $12
currbuf		= $13

vm		= $400

speedcode	= $6000

BUFFER1		= $a000
BUFFER2		= $b000

BORDER		= $fffd

		; efo header

		.byt	"EFO2"		; fileformat magic
		.word	prepare		; prepare routine
		.word	setup		; setup routine
		.word	0		; irq handler
		.word	0		; main routine
		.word	0		; fadeout routine
		.word	0		; cleanup routine
		.word	call_play	; location of playroutine call

		; tags go here

		.byt	"I",$04,$07	; range of pages inherited
		.byt	"Z",$10,$1f	; range of zero-page addresses in use
		.byt	"P",$60,$8e	; range of pages in use

		;.byt	"X"		; avoid loading
		;.byt	"M",<play,>play	; install music playroutine

		.byt	"S"		; i/o safe
		.byt	0		; end of tags

		.word	loadaddr
		* = $3000
loadaddr

interrupt
		.(
		dec	0
		dec	BORDER

		sta	int_savea+1
		stx	int_savex+1
		sty	int_savey+1

+call_play	bit	!0		; gets replaced by jsr to playroutine

		lda	#$7e
		sta	$dc00
		lda	#$10
		bit	$dc01
		beq	hold

		lda	$d016
		sec
		sbc	#2
		and	#7
		sta	$d016

		cmp	#6
		bne	nonewcol

		ldy	#0
		jsr	speedcode
		tya
		clc
		adc	ptr
		sta	ptr
		bcc	noc1

		inc	ptr+1
noc1
		dec	count
		bne	nowrap

		lda	currbuf
		eor	#>(BUFFER1^BUFFER2)
		sta	currbuf
		jsr	setbuf
nowrap
nonewcol
hold

int_savea	lda	#0
int_savex	ldx	#0
int_savey	ldy	#0
		lsr	$d019
		inc	BORDER
		inc	0
		rti
		.)

prepare
		.(
		lda	#<speedcode
		sta	ptr
		lda	#>speedcode
		sta	ptr+1

		lda	#25
		sta	count
loop3
		ldx	#39
loop2
		ldy	#11
loop1
		lda	template,y
		sta	(ptr),y
		dey
		bpl	loop1

		inc	template+0*3+1
		inc	template+2*3+1
		bne	noc1

		inc	template+0*3+2
		inc	template+2*3+2
noc1
		inc	template+1*3+1
		inc	template+3*3+1
		bne	noc2

		inc	template+1*3+2
		inc	template+3*3+2
noc2
		lda	ptr
		clc
		adc	#12
		sta	ptr
		bcc	noc3

		inc	ptr+1
noc3
		dex
		bne	loop2

		ldy	#et_end-endtemplate-1
loop4
		lda	endtemplate,y
		sta	(ptr),y
		dey
		bpl	loop4

		lda	ptr
		clc
		adc	#et_end-endtemplate
		sta	ptr
		bcc	noc7

		inc	ptr+1
noc7
		lda	et_mod1+1
		clc
		adc	#40
		sta	et_mod1+1
		sta	et_mod2+1
		bcc	noc6

		inc	et_mod1+2
		inc	et_mod2+2
noc6
		inc	template+0*3+1
		inc	template+2*3+1
		bne	noc4

		inc	template+0*3+2
		inc	template+2*3+2
noc4
		inc	template+1*3+1
		inc	template+3*3+1
		bne	noc5

		inc	template+1*3+2
		inc	template+3*3+2
noc5
		dec	count
		bne	loop3

		ldy	#0
		lda	#$60	; rts
		sta	(ptr),y

		lda	#>BUFFER1
		sta	currbuf
+setbuf
		sta	ptr+1
		lda	#<BUFFER1
		sta	ptr
		lda	#40
		sta	count
		rts

template
		lda	vm+1
		sta	vm
		lda	$d800+1
		sta	$d800

endtemplate
		lda	(ptr),y
et_mod1
		sta	vm+39
		iny
		lda	(ptr),y
et_mod2
		sta	$d800+39
		iny
et_end
		.)

setup
		lda	#$3c
		sta	$dd02
		lda	#0
		sta	$d015
		sta	$d017
		sta	$d01b
		sta	$d01c
		sta	$d01d
		lda	#$1b
		sta	$d011
		lda	#$00
		sta	$d016
		lda	#$ff
		sta	$d012
		lda	#$0
		sta	$d020
		sta	$d021
		rts

