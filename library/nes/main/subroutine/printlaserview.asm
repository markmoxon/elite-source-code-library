\ ******************************************************************************
\
\       Name: PrintLaserView
\       Type: Subroutine
\   Category: Equipment
\    Summary: Print the name of a laser view in the laser-buying popup, filled
\             to the right by the correct number of spaces to fill the popup
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The number of the laser view:
\
\                         * 0 = front
\                         * 1 = rear
\                         * 2 = left
\                         * 3 = right
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Y                   Y is preserved
\
\ ******************************************************************************

.PrintLaserView

 LDA #12                \ Move the text cursor to column 12
 STA XC

 TYA                    \ Store Y on the stack so we can retrieve it at the end
 PHA                    \ of the subroutine

 CLC                    \ Move the text cursor to row Y + 8, so we print the
 ADC #8                 \ view on row 8 (front) to 11 (right)
 STA YC

 JSR TT162              \ Print a space

 LDA languageNumber     \ If either bit 1 or bit 2 of languageNumber is set then
 AND #%00000110         \ the chosen language is German or French, so jump to
 BNE lasv1              \ lasv1 to skip the following

 JSR TT162              \ The chosen language is English, so print a space

.lasv1

 PLA                    \ Set A to the argument Y, which we stored on the stack
 PHA                    \ above

 CLC                    \ Print recursive token 96 + A, which will print from 96
 ADC #96                \ ("FRONT") through to 99 ("RIGHT")
 JSR TT27_b2

.lasv2

 JSR TT162              \ Print a space

 LDA XC                 \ Keep printing spaces until we reach the column given
 LDX languageIndex      \ in the xLaserView table for the chosen language, so we
 CMP xLaserView,X       \ blank out the rest of the line to the edge of the
 BNE lasv2              \ popup (so the popup covers what's underneath it)

 PLA                    \ Retrieve Y from the stack so it is unchanged by the
 TAY                    \ subroutine call

 RTS                    \ Return from the subroutine

