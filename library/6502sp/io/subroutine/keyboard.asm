\ ******************************************************************************
\
\       Name: KEYBOARD
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Implement the OSWORD 240 command (scan the keyboard and joystick
\             and log the results)
\
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends an OSWORD 240 command. It scans
\ the keyboard and joystick and stores the results in the key logger buffer
\ pointed to by OSSC, which is then sent across the Tube to the parasite's own
\ key logger buffer at KTRAN.
\
\ First, it scans the keyboard for the primary flight keys. If any of the
\ primary flight keys are pressed, the corresponding byte in the key logger is
\ set to &FF, otherwise it is set to 0. If multiple flight keys are being
\ pressed, they are all logged.
\
\ Next, it scans the keyboard for any other key presses, starting with internal
\ key number 16 ("Q") and working through the set of internal key numbers (see
\ p.142 of the "Advanced User Guide for the BBC Micro" by Bray, Dickens and
\ Holmes for a list of internal key numbers). If a key press is detected, the
\ internal key number is stored in byte #2 of the key logger table and scanning
\ stops.
\
\ Finally, the joystick is read for X, Y and fire button values. The rotation
\ value is also read from the Bitstik.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   OSSC                The address of the table in which to log the key presses
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   OSSC                The table is updated as follows:
\
\                         * Byte #2: If a non-primary flight control key is
\                           being pressed, its internal key number is put here
\
\                         * Byte #3: "?" is being pressed (0 = no, &FF = yes)
\
\                         * Byte #4: Space is being pressed (0 = no, &FF = yes)
\
\                         * Byte #5: "<" is being pressed (0 = no, &FF = yes)
\
\                         * Byte #6: ">" is being pressed (0 = no, &FF = yes)
\
\                         * Byte #7: "X" is being pressed (0 = no, &FF = yes)
\
\                         * Byte #8: "S" is being pressed (0 = no, &FF = yes)
\
\                         * Byte #9: "A" is being pressed (0 = no, &FF = yes)
\
\                         * Byte #10: Joystick X value (high byte)
\
\                         * Byte #11: Joystick Y value (high byte)
\
\                         * Byte #12: Bitstik rotation value (high byte)
\
\                         * Byte #14: Joystick 1 fire button is being pressed
\                           (Bit 4 set = no, Bit 4 clear = yes)
\
\ ******************************************************************************

.KEYBOARD

 LDY #9                 \ We're going to loop through the seven primary flight
                        \ controls in KYTB and update the block pointed to by
                        \ OSSC with their details. We want to store the seven
                        \ results in bytes #2 to #9 in the block, so we set a
                        \ loop counter in Y to count down from 9 to 3, so we can
                        \ use this as an index into both the OSSC block and the
                        \ KYTB table

.DKL2

 LDA KYTB-2,Y           \ Set A to the relevant internal key number from the
                        \ KYTB table (we add Y to KYTB-2 rather than KYTB as Y
                        \ is looping from 9 down to 3, so this grabs the key
                        \ numbers from 7 to 1, i.e. from "A" to "?"

 DKS4                   \ Include macro DKS4 to check whether the key in A is
                        \ being pressed, and if it is, set bit 7 of A

 ASL A                  \ Shift bit 7 of A into the C flag

 LDA #0                 \ Set A = 0 + &FF + C
 ADC #&FF               \
                        \ If the C flag is set (i.e. the key is being pressed)
                        \ then this sets A = 0, otherwise it sets A = &FF

 EOR #%11111111         \ Flip all the bits in A, so now A = &FF if the key is
                        \ being pressed, or A = 0 if it isn't

 STA (OSSC),Y           \ Store A in the Y-th byte of the block pointed to by
                        \ OSSC

 DEY                    \ Decrement the loop counter

 CPY #2                 \ Loop back until we have processed all seven primary
 BNE DKL2               \ flight keys, leaving the loop with Y = 2

                        \ We're now going to scan the keyboard to see if any
                        \ other keys are being pressed

 LDA #16                \ We start scanning from internal key number 16 ("Q"),
                        \ so we set A as a loop counter

 SED                    \ Set the D flag to enter decimal mode. Because
                        \ internal key numbers are all valid BCD (Binary Coded
                        \ Decimal) numbers, setting this flag ensures we only
                        \ loop through valid key numbers. To put this another
                        \ way, when written in hexadecimal, internal key numbers
                        \ only use the digits 0-9 and none of the letters A-F,
                        \ and setting the D flag makes the following loop
                        \ iterate through the following values of A:
                        \
                        \ &10, &11, &12, &13, &14, &15, &16, &17, &18, &19,
                        \ &20, &21, &22, &23, &24, &25, &26, &27, &28, &29,
                        \ &30, &31...
                        \
                        \ and so on up to &79, and then &80, at which point the
                        \ loop terminates. This lets us efficiently work our
                        \ way through all the internal key numbers without
                        \ wasting time on numbers that aren't valid in BCD

.DKL3

 DKS4                   \ Include macro DKS4 to check whether the key in A is
                        \ being pressed, and if it is, set bit 7 of A

 TAX                    \ Copy the key press result into X

 BMI DK1                \ If bit 7 is set, i.e. the key is being pressed, skip
                        \ to DK1

 CLC                    \ Otherwise this key is not being pressed, so increment
 ADC #1                 \ the loop counter in A. We couldn't use an INX or INY
                        \ instruction here because the only instructions that
                        \ support decimal mode are ADC and SBC. INX and INY
                        \ always increment in binary mode, whatever the setting
                        \ of the D flag, so instead we have to use an ADC

 BPL DKL3               \ Loop back to test the next key, ending the loop when
                        \ A is negative (i.e. A = &80 = 128 = %10000000)

.DK1

 CLD                    \ Clear the D flag to return to binary mode

 EOR #%10000000         \ EOR A with #%10000000 to flip bit 7, so A now contains
                        \ 0 if no key has been pressed, or the internal key
                        \ number if a key has been pressed

 STA (OSSC),Y           \ We exited the first loop above with Y = 2, so this
                        \ stores the "other key" result in byte #2 of the block
                        \ pointed to by OSSC

                        \ We now check the joystick or Bitstik

 LDX #1                 \ Call OSBYTE with A = 128 to fetch the 16-bit value
 LDA #128               \ from ADC channel 1 (the joystick X value), returning
 JSR OSBYTE             \ the value in (Y X)
                        \
                        \   * Channel 1 is the x-axis: 0 = right, 65520 = left

 TYA                    \ Copy Y to A, so the result is now in (A X)

 LDY #10                \ Store the high byte of the joystick X value in byte
 STA (OSSC),Y           \ #10 of the block pointed to by OSSC

 LDX #2                 \ Call OSBYTE with A = 128 to fetch the 16-bit value
 LDA #128               \ from ADC channel 2 (the joystick Y value), returning
 JSR OSBYTE             \ the value in (Y X)
                        \
                        \   * Channel 2 is the y-axis: 0 = down,  65520 = up

 TYA                    \ Copy Y to A, so the result is now in (A X)

 LDY #11                \ Store the high byte of the joystick Y value in byte
 STA (OSSC),Y           \ #11 of the block pointed to by OSSC

 LDX #3                 \ Call OSBYTE with A = 128 to fetch the 16-bit value
 LDA #128               \ from ADC channel 3 (the Bitstik rotation value),
 JSR OSBYTE             \ returning the value in (Y X)

 TYA                    \ Copy Y to A, so the result is now in (A X)

 LDY #12                \ Store the high byte of the Bitstik rotation value in
 STA (OSSC),Y           \ byte #12 of the block pointed to by OSSC

 LDY #14                \ Read 6522 System VIA input register IRB (SHEILA &40),
 LDA &FE40              \ which has bit 4 clear if joystick 1's fire button is
 STA (OSSC),Y           \ pressed (otherwise it's set), and store the value in
                        \ byte #14 of the block pointed to by OSSC

.DK2

 RTS                    \ Return from the subroutine

