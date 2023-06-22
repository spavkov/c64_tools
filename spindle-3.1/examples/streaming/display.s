; This is an example demo bundled with Spindle
; linusakesson.net/software/spindle/

; The preparations are kept in a separate effect
; to allow looping without reloading the code itself.

		; efo header

		.byt	"EFO2"		; fileformat magic
		.word	0		; prepare routine
		.word	0		; setup routine
		.word	$3000		; irq handler
		.word	0		; main routine
		.word	0		; fadeout routine
		.word	0		; cleanup routine
		.word	0		; location of playroutine call

		; tags go here

		.byt	"I",$04,$07	; range of pages inherited
		.byt	"I",$60,$8e	; range of pages in use
		.byt	"I",$30,$33	; range of pages in use
		;.byt	"Z",$10,$1f	; range of zero-page addresses in use

		;.byt	"X"		; avoid loading
		;.byt	"M",<play,>play	; install music playroutine

		.byt	"S"		; i/o safe
		.byt	0		; end of tags

		.word	loadaddr
		* = $4000
loadaddr
		; no new data---everything is inherited
		; but pefchain will append a driver here
