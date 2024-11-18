\ ******************************************************************************
\
\       Name: FONT%
\       Type: Variable
\   Category: Text
\    Summary: A copy of the character definition bitmap table from the MOS ROM
\
\ ------------------------------------------------------------------------------
\
\ This is used by the TT26 routine to save time looking up the character bitmaps
\ from the ROM. Note that FONT% contains just the high byte (i.e. the page
\ number) of the address of this table, rather than the full address.
\
\ The contents of the P.FONT.bin file included here are taken straight from the
\ following three pages in the BBC Micro OS 1.20 ROM:
\
\   ASCII 32-63  are defined in &C000-&C0FF (page 0)
\   ASCII 64-95  are defined in &C100-&C1FF (page 1)
\   ASCII 96-126 are defined in &C200-&C2F0 (page 2)
\
\ The code could look these values up each time (as the cassette version does),
\ but it's quicker to use a lookup table, at the expense of three pages of
\ memory.
\
IF _6502SP_VERSION \ Comment
\ The Executive version uses a different font to the standard OS, which is
\ included in the P.FONTEX.bin file. This means all in-game text uses this new
\ font, which is based on the 1960s Westminster font. The font style is similar
\ to the machine-readable font on cheques, and is in a style that we would now
\ call "retro-futuristic" (though presumably it was just "futuristic" back in
\ 1984).
\
ENDIF
\ ******************************************************************************

IF _6502SP_VERSION \ Platform

 ORG CODE%

ENDIF

 FONT% = HI(P%)

IF _6502SP_VERSION \ 6502SP: The Executive version uses a unique font, which is based on the 1960s Westminster font (it's similar to the machine-readable font on cheques - "retro-futuristic" is probably what we'd call it these days)

IF _SNG45 OR _SOURCE_DISC
 INCBIN "versions/6502sp/1-source-files/fonts/P.FONT.bin"
ELIF _EXECUTIVE
 INCBIN "versions/6502sp/1-source-files/fonts/P.FONTEX.bin"
ENDIF

ELIF _MASTER_VERSION

 INCBIN "versions/master/1-source-files/fonts/P.FONT.bin"

ENDIF

