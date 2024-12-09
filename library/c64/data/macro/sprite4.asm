\ ******************************************************************************
\
\       Name: SPRITE4
\       Type: Macro
\   Category: Sprites
\    Summary: Macro definition for a four-colour sprite pixel row
\
\ ------------------------------------------------------------------------------
\
\ This macro inserts three bytes of a four-colour sprite pixel row, with four
\ pixels per byte (i.e. four pixels per character block).
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   pixel_row           A string containing a row of 12 pixels, where each pixel
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

MACRO SPRITE4 pixel_row

 SPRITE4_BYTE MID$(pixel_row, 1, 4)
 SPRITE4_BYTE MID$(pixel_row, 5, 4)
 SPRITE4_BYTE MID$(pixel_row, 9, 4)

ENDMACRO

