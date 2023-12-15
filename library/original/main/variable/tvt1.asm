\ ******************************************************************************
\
\       Name: TVT1
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Palette data for space and the two dashboard colour schemes
\
\ ------------------------------------------------------------------------------
\
\ Palette bytes for use with the split-screen mode (see IRQ1 below for more
\ details).
\
\ Palette data is given as a set of bytes, with each byte mapping a logical
\ colour to a physical one. In each byte, the logical colour is given in bits
\ 4-7 and the physical colour in bits 0-3. See p.379 of the Advanced User Guide
\ for details of how palette mapping works, as in modes 4 and 5 we have to do
\ multiple palette commands to change the colours correctly, and the physical
\ colour value is EOR'd with 7, just to make things even more confusing.
\
\ Similarly, the palette at TVT1+16 is for the monochrome space view, where
\ logical colour 1 is mapped to physical colour 0 EOR 7 = 7 (white), and
\ logical colour 0 is mapped to physical colour 7 EOR 7 = 0 (black). Each of
\ these mappings requires six calls to SHEILA &21 - see p.379 of the Advanced
\ User Guide for an explanation.
\
\ The mode 5 palette table has two blocks which overlap. The block used depends
\ on whether or not we have an escape pod fitted. The block at TVT1 is used for
\ the standard dashboard colours, while TVT1+8 is used for the dashboard when an
\ escape pod is fitted. The colours are as follows:
\
\                 Normal (TVT1)     Escape pod (TVT1+8)
\
\   Colour 0      Black             Black
\   Colour 1      Red               Red
\   Colour 2      Yellow            White
\   Colour 3      Green             Cyan
\
\ ******************************************************************************

.TVT1

 EQUB &D4, &C4          \ This block of palette data is used to create two
 EQUB &94, &84          \ palettes used in three different places, all of them
 EQUB &F5, &E5          \ redefining four colours in mode 5:
 EQUB &B5, &A5          \
                        \ 12 bytes from TVT1 (i.e. the first 6 rows): applied
 EQUB &76, &66          \ when the T1 timer runs down at the switch from the
 EQUB &36, &26          \ space view to the dashboard, so this is the standard
                        \ dashboard palette
 EQUB &E1, &F1          \
 EQUB &B1, &A1          \ 8 bytes from TVT1+8 (i.e. the last 4 rows): applied
                        \ when the T1 timer runs down at the switch from the
                        \ space view to the dashboard, and we have an escape
                        \ pod fitted, so this is the escape pod dashboard
                        \ palette
                        \
                        \ 8 bytes from TVT1+8 (i.e. the last 4 rows): applied
                        \ at vertical sync in LINSCN when HFX is non-zero, to
                        \ create the hyperspace effect in LINSCN (where the
                        \ whole screen is switched to mode 5 at vertical sync)

 EQUB &F0, &E0          \ 12 bytes of palette data at TVT1+16, used to set the
 EQUB &B0, &A0          \ mode 4 palette in LINSCN when we hit vertical sync,
 EQUB &D0, &C0          \ so the palette is set to monochrome when we start to
 EQUB &90, &80          \ draw the first row of the screen
 EQUB &77, &67
 EQUB &37, &27

