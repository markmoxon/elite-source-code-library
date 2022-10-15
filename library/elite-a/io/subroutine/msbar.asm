\ ******************************************************************************
\
\       Name: MSBAR
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Implement the put_missle command (update a missile indicator on
\             the dashboard)
\
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a put_missle command. It updates
\ a specified missile indicator on the dashboard to the specified colour.
\
\ ******************************************************************************

.MSBAR

 JSR tube_get           \ Get the first parameter from the parasite for the
                        \ command:
                        \
                        \   put_missle(number, colour)
                        \
                        \ and store it as follows:
                        \
                        \   * A = missile number

 ASL A                  \ Set missle_1 = A * 8
 ASL A
 ASL A
 STA missle_1

 LDA #41                \ Set SC = 41 - missle_1
 SBC missle_1           \        = 40 + 1 - (A * 8)
 STA SC                 \        = 48 + 1 - ((A + 1) * 8)
                        \
                        \ This is the same calculation as in the disc version's
                        \ MSBAR routine, but because the missile number in the
                        \ Elite-A version is in the range 0-3 rather than 1-3,
                        \ we subtract from 41 instead of 49 to get the screen
                        \ address

                        \ So the low byte of SC(1 0) contains the row address
                        \ for the rightmost missile indicator, made up as
                        \ follows:
                        \
                        \   * 48 (character block 7, as byte #7 * 8 = 48), the
                        \     character block of the rightmost missile
                        \
                        \   * 1 (so we start drawing on the second row of the
                        \     character block)
                        \
                        \   * Move left one character (8 bytes) for each count
                        \     of A, so when A = 0 we are drawing the rightmost
                        \     missile, for A = 1 we hop to the left by one
                        \     character, and so on

 LDA #&7E               \ Set the high byte of SC(1 0) to &7E, the character row
 STA SC+1               \ that contains the missile indicators (i.e. the bottom
                        \ row of the screen)

 JSR tube_get           \ Get the second parameter from the parasite for the
                        \ command:
                        \
                        \   put_missle(number, colour)
                        \
                        \ and store it as follows:
                        \
                        \   * A = new colour for this indicator

 LDY #5                 \ We now want to draw this line five times to do the
                        \ left two pixels of the indicator, so set a counter in
                        \ Y

.MBL1

 STA (SC),Y             \ Draw the 3-pixel row, and as we do not use EOR logic,
                        \ this will overwrite anything that is already there
                        \ (so drawing a black missile will delete what's there)

 DEY                    \ Decrement the counter for the next row

 BNE MBL1               \ Loop back to MBL1 if have more rows to draw

 RTS                    \ Return from the subroutine

