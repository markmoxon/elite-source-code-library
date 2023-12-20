\ ******************************************************************************
\
\       Name: IncreaseTally
\       Type: Subroutine
\   Category: Status
\    Summary: Add the kill count to the fractional and low bytes of our combat
\             rank tally following a kill
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The type of the ship that was killed
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              If set, the addition overflowed
\
\ ******************************************************************************

.IncreaseTally

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #1                 \ Page ROM bank 1 into memory at &8000
 JSR SetBank

                        \ The fractional kill count is taken from the KWL%
                        \ table, according to the ship's type (we look up the
                        \ X-1-th value from KWL% because ship types start at 1
                        \ rather than 0)

 LDA KWL%-1,X           \ Double the fractional kill count and push the low byte
 ASL A                  \ onto the stack
 PHA

 LDA KWH%-1,X           \ Double the integer kill count and put the high byte
 ROL A                  \ in Y
 TAY

 PLA                    \ Add the doubled fractional kill count to our tally,
 ADC TALLYL             \ starting by adding the fractional bytes:
 STA TALLYL             \
                        \   TALLYL = TALLYL + fractional kill count

 TYA                    \ And then we add the low byte of TALLY(1 0):
 ADC TALLY              \
 STA TALLY              \   TALLY = TALLY + carry + integer kill count

                        \ Fall through into ResetBankP to reset the ROM bank to
                        \ the value we stored on the stack

