\ ******************************************************************************
\
\       Name: AutoPlayDemo
\       Type: Subroutine
\   Category: Combat demo
\    Summary: Automatically play the demo using the auto-play commands from the
\             autoplayKeys tables
\  Deep dive: Auto-playing the combat demo
\
\ ******************************************************************************

.AutoPlayDemo

 LDA controller1A       \ If no buttons are being pressed on controller 1, jump
 ORA controller1B       \ to auto1 to continue with the auto-playing of the demo
 ORA controller1Left
 ORA controller1Right
 ORA controller1Up
 ORA controller1Down
 ORA controller1Start
 ORA controller1Select
 BPL auto1

 LDA #0                 \ Otherwise a button has been pressed, so we disable
 STA autoPlayDemo       \ auto-play by setting autoPlayDemo to zero

 RTS                    \ Return from the subroutine

.auto1

 LDX autoPlayRepeat     \ If autoPlayRepeat is non-zero then this means a
 BNE auto4              \ previous auto-play step has set a repeat action and
                        \ we still have some repeats to go, so jump to auto4
                        \ to decrement the repeat counter and press the buttons
                        \ in autoPlayKey for this VBlank

 LDY #0                 \ Set Y = 0 to use as an index when fetching auto-play
                        \ bytes from the relevant autoPlayKeys table

 LDA (autoPlayKeys),Y   \ Set A to byte #1 of this auto-play command

 BMI auto5              \ If bit 7 of byte #1 is set, jump to auto5

                        \ If we get here then bit 7 of byte #1 is clear and A
                        \ contains byte #1

 STA autoPlayKey        \ Set autoPlayKey to byte #1 so we perform the button
                        \ presses in byte #1

 INY                    \ Set A to byte #2 of this auto-play command
 LDA (autoPlayKeys),Y

 SEC                    \ Set the C flag so the addition below adds an extra 1,
                        \ so autoPlayKeys(1 0) gets incremented by 2 (as we have
                        \ just processed two bytes)

 TAX                    \ Set X to byte #2, so this gets set as the number of
                        \ repeats in autoPlayRepeat

.auto2

 LDA #1                 \ Set A = 1 so the following adds 1 + C to the address
                        \ in autoPlayKeys(1 0), so we move the pointer to the
                        \ byte we are processing next on by 1 + C bytes

.auto3

 ADC autoPlayKeys       \ Set autoPlayKeys(1 0) = autoPlayKeys(1 0) + 1 + C
 STA autoPlayKeys
 BCC auto4
 INC autoPlayKeys+1

.auto4

 DEX                    \ Decrement the repeat counter in autoPlayRepeat, as we
 STX autoPlayRepeat     \ are about to press the buttons

 LDA autoPlayKey        \ Set A to the buttons to be pressed in autoPlayKey,
                        \ which has the following format:
                        \
                        \   * Bit 0 = right button
                        \   * Bit 1 = left button
                        \   * Bit 2 = down button
                        \   * Bit 3 = up button
                        \   * Bit 4 = Select button
                        \   * Bit 5 = B button
                        \   * Bit 6 = A button
                        \
                        \ Bit 7 is always clear

 ASL controller1Right   \ Set bit 7 of controller1Right to bit 0 of autoPlayKey
 LSR A                  \ to "press" the right button
 ROR controller1Right

 ASL controller1Left    \ Set bit 7 of controller1Left to bit 0 of autoPlayKey
 LSR A                  \ to "press" the left button
 ROR controller1Left

 ASL controller1Down    \ Set bit 7 of controller1Down to bit 0 of autoPlayKey
 LSR A                  \ to "press" the down button
 ROR controller1Down

 ASL controller1Up      \ Set bit 7 of controller1Up to bit 0 of autoPlayKey
 LSR A                  \ to "press" the up button
 ROR controller1Up

 ASL controller1Select  \ Set bit 7 of controller1Select to bit 0 of autoPlayKey
 LSR A                  \ to "press" the Select button
 ROR controller1Select

 ASL controller1B       \ Set bit 7 of controller1B to bit 0 of autoPlayKey
 LSR A                  \ to "press" the B button
 ROR controller1B

 ASL controller1A       \ Set bit 7 of controller1A to bit 0 of autoPlayKey
 LSR A                  \ to "press" the A button
 ROR controller1A

 RTS                    \ We have now pressed the correct buttons for this
                        \ VBlank, so return from the subroutine

.auto5

                        \ If we get here then bit 7 of byte #1 is set and A
                        \ contains byte #1

 ASL A                  \ Set A = A << 1, so A contains byte #1 << 1

 BEQ auto14             \ If the result is zero then byte #1 must be &80, so
                        \ jump to auto14 with A = 0 to terminate auto-play

 BMI auto7              \ If bit 6 of byte #1 is set, jump to auto7

                        \ If we get here then bit 7 of byte #1 is set, bit 6 of
                        \ byte #1 is clear, and A contains byte #1 << 1
                        \
                        \ So byte #1 = &C0, which means we do nothing for
                        \ 4 * byte #1 (ignoring bit 7 of byte #1)

 ASL A                  \ Set A = A << 1, so A contains byte #1 << 2

 TAX                    \ Set X to byte #1 << 2, so this gets set as the number
                        \ of repeats in autoPlayRepeat when we jump up to auto2
                        \ below (so this sets the number of repetitions to
                        \ byte #1 << 2, which is 4 * byte #1 (if we ignore bit 7
                        \ of byte #1)

.auto6

 LDA #0                 \ Set autoPlayKey = 0 so no buttons are pressed in the
 STA autoPlayKey        \ next VBlank

 BEQ auto2              \ Jump to auto2 to process the button-pressing in this
                        \ VBlank (this BEQ is effectively a JMP as A is always
                        \ zero)

.auto7

                        \ If we get here then bits 6 and 7 of byte #1 are set
                        \ and A contains byte #1 << 1, so byte #1 is of the form
                        \ &Cx, where x is any value

 ASL A                  \ Set A = A << 1, so A contains byte #1 << 2

 BEQ auto13             \ If the result is zero then byte #1 must be &C0, so
                        \ jump to auto13 to switch to the auto-play commands in
                        \ the autoPlayKeys2 table, which we will start
                        \ processing in the next NMI

                        \ If we get here then bits 6 and 7 of byte #1 are set
                        \ and A contains byte #1 << 1, so byte #1 is of the form
                        \ &Cx where x is non-zero

 PHA                    \ Store byte #1 << 2 on the stack

 INY                    \ Set A to byte #2 of this auto-play command
 LDA (autoPlayKeys),Y

 STA autoPlayKey        \ Set autoPlayKey to byte #2 so we perform the button
                        \ presses in byte #2

 INY                    \ Set A to byte #3 of this auto-play command
 LDA (autoPlayKeys),Y

 STA addr               \ Set the low byte of addr(1 0) to byte #3

 INY                    \ Set A to byte #4 of this auto-play command
 LDA (autoPlayKeys),Y

 STA addr+1             \ Set the high byte of addr(1 0) to byte #3, so we now
                        \ have addr(1 0) = (byte #3 byte #4)

                        \ We now process the auto-play commands for when byte #1
                        \ is &C1 through &C5

 LDY #0                 \ Set Y = 0 so we can use indirect addressing below (we
                        \ do not change the value of Y, this is just so we can
                        \ implement the non-existent LDA (addr) instruction by
                        \ using LDA (addr),Y instead)

 LDX #1                 \ Set X = 1 this gets set as the number of repeats in
                        \ autoPlayRepeat when we jump up to auto2 below, so the
                        \ command will do each button press just once before
                        \ re-checking the criteria in the next VBlank

 PLA                    \ Set A = byte #1 << 2
                        \
                        \ In other words A is the low nibble of byte #1
                        \ multiplied by 4, so we can check this value to
                        \ determine the command in byte #1, as follows:
                        \
                        \   * If byte #1 = &C1, A = 1 * 4 = 4
                        \
                        \   * If byte #1 = &C2, A = 2 * 4 = 8
                        \
                        \   * If byte #1 = &C3, A = 3 * 4 = 12
                        \
                        \   * If byte #1 = &C4, A = 4 * 4 = 16
                        \
                        \   * If byte #1 = &C5, A = 5 * 4 = 20

 CMP #8                 \ If A >= 8 then byte #1 is not &C1, so jump to auto9
 BCS auto9

                        \ If we get here then byte #1 is &C1, so we repeat the
                        \ button presses in byte #2 while addr(1 0) <> 0

 LDA (addr),Y           \ Set A = addr(1 0)

 BNE auto4              \ If addr(1 0) <> 0, jump to auto4 to do the button
                        \ presses in byte #2 (which we put into autoPlayKey
                        \ above), and because we have not updated the pointer
                        \ in autoPlayKeys(1 0), we will come back to this exact
                        \ same check in the next VBlank, and so on until the
                        \ condition changes and addr(1 0) = 0

                        \ If addr(1 0) = 0 then fall through into auto8 to
                        \ advance the pointer in autoPlayKeys(1 0) by 4, so in
                        \ the next VBlank, we move on to the next command after
                        \ byte #3

.auto8

 LDA #4                 \ Set A = 4 and clear the C flag, so in the jump to
 CLC                    \ auto3, we advance the pointer in autoPlayKeys(1 0) by
                        \ 4 and return from the subroutine

 BCC auto3              \ Jump to auto3 to advance the pointer and return from
                        \ the subroutine (this BCC is effectively a JMP as we
                        \ just cleared the C flag)

.auto9

                        \ If we get here then byte #1 is &C2 to &C5, we just
                        \ performed a CMP #8, and A = byte #1 << 2

 BNE auto10             \ If A <> 8 then byte #1 is not &C2, so jump to auto10

                        \ If we get here then byte #1 is &C2, so we repeat the
                        \ button presses in byte #2 while addr(1 0) = 0

 LDA (addr),Y           \ Set A = addr(1 0)

 BEQ auto4              \ If addr(1 0) = 0, jump to auto4 to do the button
                        \ presses in byte #2 (which we put into autoPlayKey
                        \ above), and because we have not updated the pointer
                        \ in autoPlayKeys(1 0), we will come back to this exact
                        \ same check in the next VBlank, and so on until the
                        \ condition changes and addr(1 0) <> 0

 BNE auto8              \ If addr(1 0) <> 0 then jump to auto8 to advance the
                        \ pointer in autoPlayKeys(1 0) by 4, so in the next
                        \ VBlank, we move on to the next command after byte #3
                        \ (this BNE is effectively a JMP as we just passed
                        \ through a BEQ)

.auto10

                        \ If we get here then byte #1 is &C3 to &C5, and
                        \ A = byte #1 << 2

 CMP #16                \ if A >= 16 then byte #1 is not &C3, so jump to auto11
 BCS auto11

                        \ If we get here then byte #1 is &C3, so we repeat the
                        \ button presses in byte #2 while bit 7 of addr(1 0) is
                        \ set

 LDA (addr),Y           \ Set A = addr(1 0)

 BMI auto4              \ If bit 7 of addr(1 0) is set, jump to auto4 to do the
                        \ button presses in byte #2 (which we put into
                        \ autoPlayKey above), and because we have not updated
                        \ the pointer in autoPlayKeys(1 0), we will come back to
                        \ this exact same check in the next VBlank, and so on
                        \ until the condition changes and bit 7 of addr(1 0) is
                        \ clear

 BPL auto8              \ If bit 7 of addr(1 0) is clear then jump to auto8 to
                        \ advance the pointer in autoPlayKeys(1 0) by 4, so in
                        \ the next VBlank, we move on to the next command after
                        \ byte #3 (this BPL is effectively a JMP as we just
                        \ passed through a BMI)

.auto11

                        \ If we get here then byte #1 is &C4 to &C5, we just
                        \ performed a CMP #16, and A = byte #1 << 2

 BNE auto12             \ If A <> 16 then byte #1 is not &C4, so jump to auto12

                        \ If we get here then byte #1 is &C4, so we repeat the
                        \ button presses in byte #2 while bit 7 of addr(1 0) is
                        \ clear

 LDA (addr),Y           \ Set A = addr(1 0)

 BMI auto8              \ If bit 7 of addr(1 0) is set then jump to auto8 to
                        \ advance the pointer in autoPlayKeys(1 0) by 4, so in
                        \ the next VBlank, we move on to the next command after
                        \ byte #3 (this BPL is effectively a JMP as we just
                        \ passed through a BMI)

 JMP auto4              \ Otherwise bit 7 of addr(1 0) is clear, so jump to
                        \ auto4 to do the button presses in byte #2 (which we
                        \ put into autoPlayKey above), and because we have not
                        \ updated the pointer in autoPlayKeys(1 0), we will come
                        \ back to this exact same check in the next VBlank, and
                        \ so on until the condition changes and bit 7 of
                        \ addr(1 0) is set


.auto12

                        \ If we get here then byte #1 is &C5, so we terminate
                        \ auto-play with the Start button being held down

 LDA #%11000000         \ Set bits 6 and 7 of controller1Start to simulate the
 STA controller1Start   \ Start button being held down for two VBlanks

 LDX #22                \ Set X = 22, so this gets set as the number of repeats
                        \ autoPlayRepeat when we jump to auto2 via auto6 below
                        \ (so this ensures we do nothing for 22 VBlanks after
                        \ pressing the Start button)

 CLC                    \ Clear the C flag so the jump to auto2 via auto6 only
                        \ adds one to the pointer in autoPlayKeys(1 0), so we
                        \ move on to the command after byte #1 when we have
                        \ completed the 22 VBlanks of inactivity

 BCC auto6              \ Jump to auto6 to set autoPlayKey = 0 so no buttons are
                        \ pressed in the following VBlanks, and move on to auto2
                        \ to process the button-pressing in this VBlank (this
                        \ BCC is effectively a JMP as we just cleared the C
                        \ flag)

.auto13

                        \ If we get here then byte #1 is &C0 and we need to
                        \ switch to the auto-play commands in the autoPlayKeys2
                        \ table, which we will start processing in the next NMI

 LDA #HI(autoPlayKeys2) \ Set autoPlayKeys(1 0) = autoPlayKeys2
 STA autoPlayKeys+1     \
 LDA #LO(autoPlayKeys2) \ So the next time we call AutoPlayDemo, in the next
 STA autoPlayKeys       \ call to the NMI handler at the next VBlank, we will
                        \ start pulling auto-play commands from autoPlayKeys2
                        \ instead of the language-specific table we've been
                        \ using up to this point

 RTS                    \ Return from the subroutine

.auto14

                        \ If we get here then byte #1 is &80 and we need to
                        \ terminate auto-play

 STA autoPlayDemo       \ We jump here with A = 0, so this disables auto-play
                        \ by setting autoPlayDemo to zero

 RTS                    \ Return from the subroutine

