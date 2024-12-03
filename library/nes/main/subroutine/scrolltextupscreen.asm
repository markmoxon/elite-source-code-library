\ ******************************************************************************
\
\       Name: ScrollTextUpScreen
\       Type: Subroutine
\   Category: Combat demo
\    Summary: Go through the line y-coordinate table at Y1TB, moving each line
\             coordinate up the screen by W2Y (i.e. by one full line of text)
\
\ ******************************************************************************

.ScrollTextUpScreen

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

                        \ We now work our way through every y-coordinate in the
                        \ Y1TB table (so that's the y-coordinate of each line in
                        \ the line coordinate tables), adding 51 to each of them
                        \ to move the scroll text up the screen, and removing
                        \ any lines that move off the top of the scroll text

 LDY #16                \ Set Y as a loop counter so we work our way through
                        \ the y-coordinates in Y1TB, from entry 239 down to
                        \ entry 224

.sups1

 LDA Y1TB+223,Y         \ Set A to the Y-th y-coordinate in this section of the
                        \ Y1TB table

 BEQ sups3              \ If A = 0 then this entry is already empty, so jump to
                        \ sups3 to move on to the next entry

 CLC                    \ Otherwise this is a valid y-coordinate, so add W2Y to
 ADC #(W2Y<<4 + W2Y)    \ the high nibble and W2Y to the low nibble, so we add
                        \ W2Y to both of the y-coordinates stored in this entry

 BCC sups2              \ If the addition overflowed, set A = 0 to remove this
 LDA #0                 \ entry from the table, as the line no longer fits
 CLC                    \ on-screen (we also clear the C flag, though this
                        \ doesn't appear to be necessary)

.sups2

 STA Y1TB+223,Y         \ Store the updated y-coordinate back in the Y1TB table

.sups3

 DEY                    \ Decrement the loop counter in Y

 BNE sups1              \ Loop back until we have processed all the entries in
                        \ this section of the Y1TB table

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDY #32                \ Set Y as a loop counter so we work our way through
                        \ the y-coordinates in Y1TB, from entry 223 down to
                        \ entry 192

.sups4

 LDA Y1TB+191,Y         \ Set A to the Y-th y-coordinate in this section of the
                        \ Y1TB table

 BEQ sups6              \ If A = 0 then this entry is already empty, so jump to
                        \ sups6 to move on to the next entry

 CLC                    \ Otherwise this is a valid y-coordinate, so add W2Y to
 ADC #(W2Y<<4 + W2Y)    \ the high nibble and W2Y to the low nibble, so we add
                        \ W2Y to both of the y-coordinates stored in this entry

 BCC sups5              \ If the addition overflowed, set A = 0 to remove this
 LDA #0                 \ entry from the table, as the line no longer fits
 CLC                    \ on-screen (we also clear the C flag, though this
                        \ doesn't appear to be necessary)

.sups5

 STA Y1TB+191,Y         \ Store the updated y-coordinate back in the Y1TB table

.sups6

 DEY                    \ Decrement the loop counter in Y

 BNE sups4              \ Loop back until we have processed all the entries in
                        \ this section of the Y1TB table

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDY #32                \ Set Y as a loop counter so we work our way through
                        \ the y-coordinates in Y1TB, from entry 191 down to
                        \ entry 160

.sups7

 LDA Y1TB+159,Y         \ Set A to the Y-th y-coordinate in this section of the
                        \ Y1TB table

 BEQ sups9              \ If A = 0 then this entry is already empty, so jump to
                        \ sups9 to move on to the next entry

 CLC                    \ Otherwise this is a valid y-coordinate, so add W2Y to
 ADC #(W2Y<<4 + W2Y)    \ the high nibble and W2Y to the low nibble, so we add
                        \ W2Y to both of the y-coordinates stored in this entry

 BCC sups8              \ If the addition overflowed, set A = 0 to remove this
 LDA #0                 \ entry from the table, as the line no longer fits
 CLC                    \ on-screen (we also clear the C flag, though this
                        \ doesn't appear to be necessary)

.sups8

 STA Y1TB+159,Y         \ Store the updated y-coordinate back in the Y1TB table

.sups9

 DEY                    \ Decrement the loop counter in Y

 BNE sups7              \ Loop back until we have processed all the entries in
                        \ this section of the Y1TB table

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDY #32                \ Set Y as a loop counter so we work our way through
                        \ the y-coordinates in Y1TB, from entry 159 down to
                        \ entry 128

.sups10

 LDA Y1TB+127,Y         \ Set A to the Y-th y-coordinate in this section of the
                        \ Y1TB table

 BEQ sups12             \ If A = 0 then this entry is already empty, so jump to
                        \ sups12 to move on to the next entry

 CLC                    \ Otherwise this is a valid y-coordinate, so add W2Y to
 ADC #(W2Y<<4 + W2Y)    \ the high nibble and W2Y to the low nibble, so we add
                        \ W2Y to both of the y-coordinates stored in this entry

 BCC sups11             \ If the addition overflowed, set A = 0 to remove this
 LDA #0                 \ entry from the table, as the line no longer fits
 CLC                    \ on-screen (we also clear the C flag, though this
                        \ doesn't appear to be necessary)

.sups11

 STA Y1TB+127,Y         \ Store the updated y-coordinate back in the Y1TB table

.sups12

 DEY                    \ Decrement the loop counter in Y

 BNE sups10             \ Loop back until we have processed all the entries in
                        \ this section of the Y1TB table

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDY #32                \ Set Y as a loop counter so we work our way through
                        \ the y-coordinates in Y1TB, from entry 127 down to
                        \ entry 96

.sups13

 LDA Y1TB+95,Y          \ Set A to the Y-th y-coordinate in this section of the
                        \ Y1TB table

 BEQ sups15             \ If A = 0 then this entry is already empty, so jump to
                        \ sups15 to move on to the next entry

 CLC                    \ Otherwise this is a valid y-coordinate, so add W2Y to
 ADC #(W2Y<<4 + W2Y)    \ the high nibble and W2Y to the low nibble, so we add
                        \ W2Y to both of the y-coordinates stored in this entry

 BCC sups14             \ If the addition overflowed, set A = 0 to remove this
 LDA #0                 \ entry from the table, as the line no longer fits
 CLC                    \ on-screen (we also clear the C flag, though this
                        \ doesn't appear to be necessary)
.sups14

 STA Y1TB+95,Y          \ Store the updated y-coordinate back in the Y1TB table

.sups15

 DEY                    \ Decrement the loop counter in Y

 BNE sups13             \ Loop back until we have processed all the entries in
                        \ this section of the Y1TB table

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDY #32                \ Set Y as a loop counter so we work our way through
                        \ the y-coordinates in Y1TB, from entry 95 down to
                        \ entry 64

.sups16

 LDA Y1TB+63,Y          \ Set A to the Y-th y-coordinate in this section of the
                        \ Y1TB table

 BEQ sups18             \ If A = 0 then this entry is already empty, so jump to
                        \ sups18 to move on to the next entry

 CLC                    \ Otherwise this is a valid y-coordinate, so add W2Y to
 ADC #(W2Y<<4 + W2Y)    \ the high nibble and W2Y to the low nibble, so we add
                        \ W2Y to both of the y-coordinates stored in this entry

 BCC sups17             \ If the addition overflowed, set A = 0 to remove this
 LDA #0                 \ entry from the table, as the line no longer fits
 CLC                    \ on-screen (we also clear the C flag, though this
                        \ doesn't appear to be necessary)
.sups17

 STA Y1TB+63,Y          \ Store the updated y-coordinate back in the Y1TB table

.sups18

 DEY                    \ Decrement the loop counter in Y

 BNE sups16             \ Loop back until we have processed all the entries in
                        \ this section of the Y1TB table

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDY #32                \ Set Y as a loop counter so we work our way through
                        \ the y-coordinates in Y1TB, from entry 63 down to
                        \ entry 32

.sups19

 LDA Y1TB+31,Y          \ Set A to the Y-th y-coordinate in this section of the
                        \ Y1TB table

 BEQ sups21             \ If A = 0 then this entry is already empty, so jump to
                        \ sups21 to move on to the next entry

 CLC                    \ Otherwise this is a valid y-coordinate, so add W2Y to
 ADC #(W2Y<<4 + W2Y)    \ the high nibble and W2Y to the low nibble, so we add
                        \ W2Y to both of the y-coordinates stored in this entry

 BCC sups20             \ If the addition overflowed, set A = 0 to remove this
 LDA #0                 \ entry from the table, as the line no longer fits
 CLC                    \ on-screen (we also clear the C flag, though this
                        \ doesn't appear to be necessary)

.sups20

 STA Y1TB+31,Y          \ Store the updated y-coordinate back in the Y1TB table

.sups21

 DEY                    \ Decrement the loop counter in Y

 BNE sups19             \ Loop back until we have processed all the entries in
                        \ this section of the Y1TB table

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDY #32                \ Set Y as a loop counter so we work our way through
                        \ the y-coordinates in Y1TB, from entry 31 down to
                        \ entry 0

.sups22

 LDA Y1TB-1,Y           \ Set A to the Y-th y-coordinate in this section of the
                        \ Y1TB table

 BEQ sups24             \ If A = 0 then this entry is already empty, so jump to
                        \ sups24 to move on to the next entry

 CLC                    \ Otherwise this is a valid y-coordinate, so add W2Y to
 ADC #(W2Y<<4 + W2Y)    \ the high nibble and W2Y to the low nibble, so we add
                        \ W2Y to both of the y-coordinates stored in this entry

 BCC sups23             \ If the addition overflowed, set A = 0 to remove this
 LDA #0                 \ entry from the table, as the line no longer fits
 CLC                    \ on-screen (we also clear the C flag, though this
                        \ doesn't appear to be necessary)

.sups23

 STA Y1TB-1,Y           \ Store the updated y-coordinate back in the Y1TB table

.sups24

 DEY                    \ Decrement the loop counter in Y

 BNE sups22             \ Loop back until we have processed all the entries in
                        \ this section of the Y1TB table

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 RTS                    \ Return from the subroutine

