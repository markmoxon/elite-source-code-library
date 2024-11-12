\ ******************************************************************************
\
\       Name: NLIN4
\       Type: Subroutine
\   Category: Drawing lines
IF NOT(_NES_VERSION)
\    Summary: Draw a horizontal line at pixel row 19 to box in a title
\
\ ------------------------------------------------------------------------------
\
\ This routine is used on the Inventory screen to draw a horizontal line at
\ pixel row 19 to box in the title.
ELIF _NES_VERSION
\    Summary: Draw a horizontal line on tile row 2 to box in a title
ENDIF
\
\ ******************************************************************************

.NLIN4

IF _APPLE_VERSION

 LDA text               \ ???
 BMI NLI4

ENDIF

IF NOT(_NES_VERSION)

 LDA #19                \ Jump to NLIN2 to draw a horizontal line at pixel row
 BNE NLIN2              \ 19, returning from the subroutine with using a tail
                        \ call (this BNE is effectively a JMP as A will never
                        \ be zero)

ELIF _NES_VERSION

 LDA #4                 \ Set A = 4, though this has no effect other than making
                        \ the BNE work, as NLIN2 overwrites this value

 BNE NLIN2              \ Jump to NLIN2 to draw the line, (this BNE is
                        \ effectively a JMP as A is never zero)

 LDA #1                 \ These instructions appear to be unused
 STA YC
 LDA #4

ENDIF

