\ ******************************************************************************
\
\       Name: SPRITE2_BYTE
\       Type: Macro
\   Category: Sprites
\    Summary: Macro definition for a two-colour sprite pixel byte
\
\ ------------------------------------------------------------------------------
\
\ This macro inserts one byte of a two-colour sprite pixel row, with eight
\ pixels per byte (i.e. eight pixels per character block).
\
\ In BeebAsm, true statements evaluate to -1 while false statements evaluate to
\ 0 (just as in BBC BASIC), so this statement:
\
\   bit7 = -(ASC(MID$(pixel_byte, 1, 1)) = ASC("X")) << 7
\
\ does the same as this longer statement:
\
\   IF ASC(MID$(pixel_byte, 1, 1)) = ASC("X")
\    bit7 = 1 << 7
\   ELSE
\    bit7 = 0
\   ENDIF
\
\ In other words, bit7 gets set to 1 << 7 (i.e. %10000000) if character 1 of
\ pixel_byte is "X", otherwise it gets set to 0.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   pixel_byte          A string containing a row of 8 pixels, where each pixel
\                       is defined as follows:
\
\                         * "X" denotes colour 1
\
\                         * Anything else (e.g. "." or "+") denotes colour 0
\
\ ******************************************************************************

MACRO SPRITE2_BYTE pixel_byte

 bit7 = -(ASC(MID$(pixel_byte, 1, 1)) = ASC("X")) << 7
 bit6 = -(ASC(MID$(pixel_byte, 2, 1)) = ASC("X")) << 6
 bit5 = -(ASC(MID$(pixel_byte, 3, 1)) = ASC("X")) << 5
 bit4 = -(ASC(MID$(pixel_byte, 4, 1)) = ASC("X")) << 4
 bit3 = -(ASC(MID$(pixel_byte, 5, 1)) = ASC("X")) << 3
 bit2 = -(ASC(MID$(pixel_byte, 6, 1)) = ASC("X")) << 2
 bit1 = -(ASC(MID$(pixel_byte, 7, 1)) = ASC("X")) << 1
 bit0 = -(ASC(MID$(pixel_byte, 8, 1)) = ASC("X")) << 0

 EQUB bit7 + bit6 + bit5 + bit4 + bit3 + bit2 + bit1 + bit0

ENDMACRO

