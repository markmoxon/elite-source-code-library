\ ******************************************************************************
\
\       Name: SPRITE4_BYTE
\       Type: Macro
\   Category: Sprites
\    Summary: Macro definition for a four-colour sprite pixel byte
\
\ ------------------------------------------------------------------------------
\
\ This macro inserts one byte of a four-colour sprite pixel row, with four
\ pixels per byte (i.e. four pixels per character block).
\
\ In BeebAsm, true statements evaluate to -1 while false statements evaluate to
\ 0 (just as in BBC BASIC), so this statement:
\
\   bit67_1 = (%01 * -(ASC(MID$(pixel_byte, 1, 1)) = ASC("/"))) << 6
\
\ does the same as this longer statement:
\
\   IF ASC(MID$(pixel_byte, 1, 1)) = ASC("/")
\    bit67_1 = %01 << 6
\   ELSE
\    bit67_1 = 0
\   ENDIF
\
\ In other words, bit67_1 gets set to %01 << 6 (i.e. %01000000) if character 1
\ of pixel_byte is "/", otherwise it gets set to 0.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   pixel_byte          A string containing a row of 4 pixels, where each pixel
\                       is defined as follows:
\
\                         * "/" denotes colour 1
\
\                         * "*" denotes colour 2
\
\                         * "@" denotes colour 3
\
\                         * Anything else (e.g. ".") denotes colour 0
\
\ ******************************************************************************

MACRO SPRITE4_BYTE pixel_byte

 bit67_1 = (%01 * -(ASC(MID$(pixel_byte, 1, 1)) = ASC("/"))) << 6
 bit67_2 = (%10 * -(ASC(MID$(pixel_byte, 1, 1)) = ASC("*"))) << 6
 bit67_3 = (%11 * -(ASC(MID$(pixel_byte, 1, 1)) = ASC("@"))) << 6

 bit45_1 = (%01 * -(ASC(MID$(pixel_byte, 2, 1)) = ASC("/"))) << 4
 bit45_2 = (%10 * -(ASC(MID$(pixel_byte, 2, 1)) = ASC("*"))) << 4
 bit45_3 = (%11 * -(ASC(MID$(pixel_byte, 2, 1)) = ASC("@"))) << 4

 bit23_1 = (%01 * -(ASC(MID$(pixel_byte, 3, 1)) = ASC("/"))) << 2
 bit23_2 = (%10 * -(ASC(MID$(pixel_byte, 3, 1)) = ASC("*"))) << 2
 bit23_3 = (%11 * -(ASC(MID$(pixel_byte, 3, 1)) = ASC("@"))) << 2

 bit01_1 = (%01 * -(ASC(MID$(pixel_byte, 4, 1)) = ASC("/"))) << 0
 bit01_2 = (%10 * -(ASC(MID$(pixel_byte, 4, 1)) = ASC("*"))) << 0
 bit01_3 = (%11 * -(ASC(MID$(pixel_byte, 4, 1)) = ASC("@"))) << 0

 bit67 = bit67_1 + bit67_2 + bit67_3
 bit45 = bit45_1 + bit45_2 + bit45_3
 bit23 = bit23_1 + bit23_2 + bit23_3
 bit01 = bit01_1 + bit01_2 + bit01_3

 EQUB bit67 + bit45 + bit23 + bit01

ENDMACRO

