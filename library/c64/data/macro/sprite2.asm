\ ******************************************************************************
\
\       Name: SPRITE2
\       Type: Macro
\   Category: Sprites
\    Summary: Macro definition for a two-colour sprite pixel row
\
\ ------------------------------------------------------------------------------
\
\ This macro inserts three bytes of a two-colour sprite pixel row, with eight
\ pixels per byte (i.e. eight pixels per character block).
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   pixel_row           A string containing a row of 24 pixels, where each pixel
\                       is defined as follows:
\
\                         * X denotes colour 1
\
\                         * Anything else denotes colour 0
\
\ ******************************************************************************

MACRO SPRITE2 pixel_row

 SPRITE2_BYTE MID$(pixel_row, 1, 8)
 SPRITE2_BYTE MID$(pixel_row, 9, 8)
 SPRITE2_BYTE MID$(pixel_row, 17, 8)

ENDMACRO

