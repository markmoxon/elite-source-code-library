\ ******************************************************************************
\
\       Name: TVT3
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Palette data for the mode 1 part of the screen (the top part)
\
\ ------------------------------------------------------------------------------
\
\ The following table contains four different mode 1 palettes, each of which
\ sets a four-colour palette for the top part of the screen. Mode 1 supports
\ four colours on-screen and in Elite colour 0 is always set to black, so each
\ of the palettes in this table defines the three other colours (1 to 3).
\
\ There is some consistency between the palettes:
\
\   * Colour 0 is always black
\   * Colour 1 (#YELLOW) is always yellow
\   * Colour 2 (#RED) is normally red-like (i.e. red or magenta)
\              ... except in the title screen palette, when it is white
\   * Colour 3 (#CYAN) is always cyan-like (i.e. white or cyan)
\
\ The configuration variables of #YELLOW, #RED and #CYAN are a bit misleading,
\ but if you think of them in terms of hue rather than specific colours, they
\ work reasonably well (outside of the title screen palette, anyway).
\
\ The palettes are set in the IRQ1 handler that implements the split screen
IF _6502SP_VERSION \ Comment
\ mode, and can be changed by the parasite sending a #SETVDU19 <offset> command
\ to point to the offset of the new palette in this table.
ELIF _MASTER_VERSION
\ mode, and can be changed by calling the SETVDU19 routine to set the offset to
\ the new palette in this table.
ENDIF
\
\ This table must start on a page boundary (i.e. an address that ends in two
\ zeroes in hexadecimal). In the release version of the game TVT3 is at &2C00.
IF _6502SP_VERSION \ Comment
\ This is so the #SETVDU19 command can switch palettes properly, as it does this
ELIF _MASTER_VERSION
\ This is so the SETVDU19 routine can switch palettes properly, as it does this
ENDIF
\ by overwriting the low byte of the palette data address with a new offset, so
\ the low byte for first palette's address must be 0.
\
\ Palette data is given as a set of bytes, with each byte mapping a logical
\ colour to a physical one. In each byte, the logical colour is given in bits
\ 4-7 and the physical colour in bits 0-3. See page 379 of the "Advanced User
\ Guide for the BBC Micro" by Bray, Dickens and Holmes for details of how
\ palette mapping works, as in modes 1 and 2 we have to do multiple palette
\ commands to change the colours correctly, and the physical colour value is
\ EOR'd with 7, just to make things even more confusing.
\
\ ******************************************************************************

.TVT3

 EQUB &00, &34          \ 1 = yellow, 2 = red, 3 = cyan (space view)
 EQUB &24, &17          \
IF _6502SP_VERSION \ Comment
 EQUB &74, &64          \ Set with a #SETVDU19 0 command, after which:
ELIF _MASTER_VERSION
 EQUB &74, &64          \ Set with a call to SETVDU19 with A = 0, after which:
ENDIF
 EQUB &57, &47          \
 EQUB &B1, &A1          \   #YELLOW = yellow
 EQUB &96, &86          \   #RED    = red
 EQUB &F1, &E1          \   #CYAN   = cyan
 EQUB &D6, &C6          \   #GREEN  = cyan/yellow stripe
                        \   #WHITE  = cyan/red stripe

 EQUB &00, &34          \ 1 = yellow, 2 = red, 3 = white (chart view)
 EQUB &24, &17          \
IF _6502SP_VERSION \ Comment
 EQUB &74, &64          \ Set with a #SETVDU19 16 command, after which:
ELIF _MASTER_VERSION
 EQUB &74, &64          \ Set with a call to SETVDU19 with A = 16, after which:
ENDIF
 EQUB &57, &47          \
 EQUB &B0, &A0          \   #YELLOW = yellow
 EQUB &96, &86          \   #RED    = red
 EQUB &F0, &E0          \   #CYAN   = white
 EQUB &D6, &C6          \   #GREEN  = white/yellow stripe
                        \   #WHITE  = white/red stripe

 EQUB &00, &34          \ 1 = yellow, 2 = white, 3 = cyan (title screen)
 EQUB &24, &17          \
IF _6502SP_VERSION \ Comment
 EQUB &74, &64          \ Set with a #SETVDU19 32 command, after which:
ELIF _MASTER_VERSION
 EQUB &74, &64          \ Set with a call to SETVDU19 with A = 32, after which:
ENDIF
 EQUB &57, &47          \
 EQUB &B1, &A1          \   #YELLOW = yellow
 EQUB &90, &80          \   #RED    = white
 EQUB &F1, &E1          \   #CYAN   = cyan
 EQUB &D0, &C0          \   #GREEN  = cyan/yellow stripe
                        \   #WHITE  = cyan/white stripe

 EQUB &00, &34          \ 1 = yellow, 2 = magenta, 3 = white (trade view)
 EQUB &24, &17          \
IF _6502SP_VERSION \ Comment
 EQUB &74, &64          \ Set with a #SETVDU19 48 command, after which:
ELIF _MASTER_VERSION
 EQUB &74, &64          \ Set with a call to SETVDU19 with A = 48, after which:
ENDIF
 EQUB &57, &47          \
 EQUB &B0, &A0          \   #YELLOW = yellow
 EQUB &92, &82          \   #RED    = magenta
 EQUB &F0, &E0          \   #CYAN   = white
 EQUB &D2, &C2          \   #GREEN  = white/yellow stripe
                        \   #WHITE  = white/magenta stripe

