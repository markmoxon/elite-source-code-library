\ ******************************************************************************
\
\       Name: DILX
\       Type: Subroutine
\   Category: Dashboard
IF NOT(_ELITE_A_6502SP_IO OR _ELITE_A_6502SP_PARA)
\    Summary: Update a bar-based indicator on the dashboard
ELIF _ELITE_A_6502SP_IO
\    Summary: Implement the draw_bar command (update a bar-based indicator on
\             the dashboard
ELIF _ELITE_A_6502SP_PARA
\    Summary: Update a bar-based indicator on the dashboard by sending a
\             draw_bar command to the I/O processor
ENDIF
\  Deep dive: The dashboard indicators
\
\ ------------------------------------------------------------------------------
\
IF _ELITE_A_6502SP_IO
\ This routine is run when the parasite sends a draw_bar command. It updates a
\ bar-based indicator on the dashboard.
\
ENDIF
\ The range of values shown on the indicator depends on which entry point is
\ called. For the default entry point of DILX, the range is 0-255 (as the value
\ passed in A is one byte). The other entry points are shown below.
\
IF NOT(_ELITE_A_6502SP_IO)
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The value to be shown on the indicator (so the larger
\                       the value, the longer the bar)
\
ENDIF
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
\   T1                  The threshold at which we change the indicator's colour
\                       from the low value colour to the high value colour. The
\                       threshold is in pixels, so it should have a value from
\                       0-16, as each bar indicator is 16 pixels wide
\
ENDIF
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA \ Comment
\   K                   The colour to use when A is a high value, as a
\                       four-pixel mode 5 character row byte
\
\   K+1                 The colour to use when A is a low value, as a
\                       four-pixel mode 5 character row byte
\
ELIF _6502SP_VERSION OR _MASTER_VERSION
\   K                   The colour to use when A is a high value, as a two-pixel
\                       mode 2 character row byte
\
\   K+1                 The colour to use when A is a low value, as a two-pixel
\                       mode 2 character row byte
\
ELIF _C64_VERSION
\   K                   The colour to use when A is a high value
\
\   K+1                 The colour to use when A is a low value
\
ENDIF
IF NOT(_ELITE_A_6502SP_IO)
\   SC(1 0)             The screen address of the first character block in the
\                       indicator
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   DILX+2              The range of the indicator is 0-64 (for the fuel
\                       indicator)
\
\   DIL-1               The range of the indicator is 0-32 (for the speed
\                       indicator)
\
\   DIL                 The range of the indicator is 0-16 (for the energy
\                       banks)
\
ENDIF
\ ******************************************************************************

.DILX

IF NOT(_ELITE_A_6502SP_IO)

 LSR A                  \ If we call DILX, we set A = A / 16, so A is 0-15
 LSR A

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _6502SP_VERSION OR _C64_VERSION OR _MASTER_VERSION \ Screen

 LSR A                  \ If we call DILX+2, we set A = A / 4, so A is 0-15

ENDIF

IF NOT(_ELITE_A_6502SP_IO)

 LSR A                  \ If we call DIL-1, we set A = A / 2, so A is 0-15

.DIL

                        \ If we call DIL, we leave A alone, so A is 0-15

ENDIF

IF NOT(_ELITE_A_6502SP_PARA OR _ELITE_A_6502SP_IO)

 STA Q                  \ Store the indicator value in Q, now reduced to 0-15,
                        \ which is the length of the indicator to draw in pixels

ELIF _ELITE_A_6502SP_PARA

 PHA                    \ Store the indicator value on the stack

 LDA #&86               \ Send command &86 to the I/O processor:
 JSR tube_write         \
                        \   draw_bar(value, colour, screen_low, screen_high)
                        \
                        \ which will update the bar-based dashboard indicator at
                        \ the specified screen address to a given value and
                        \ colour

 PLA                    \ Send the first parameter to the I/O processor:
 JSR tube_write         \
                        \   * value = A

ELIF _ELITE_A_6502SP_IO

 JSR tube_get           \ Get the parameters from the parasite for the command:
 STA bar_1              \
 JSR tube_get           \   draw_bar(value, colour, screen_low, screen_high)
 STA bar_2              \
 JSR tube_get           \ and store them as follows:
 STA SC                 \
 JSR tube_get           \   * bar_1 = the value to display in the indicator
 STA SC+1               \
                        \   * bar_2 = the mode 5 colour of the indicator
                        \
                        \   * SC(1 0) = the screen address of the indicator

ENDIF

IF NOT(_ELITE_A_6502SP_IO)

 LDX #&FF               \ Set R = &FF, to use as a mask for drawing each row of
 STX R                  \ each character block of the bar, starting with a full
                        \ character's width of 4 pixels

ELIF _ELITE_A_6502SP_IO

 LDX #&FF               \ Set bar_3 = &FF, to use as a mask for drawing each row
 STX bar_3              \ of each character block of the bar, starting with a
                        \ full character's width of 4 pixels

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT OR _6502SP_VERSION OR _C64_VERSION OR _MASTER_VERSION \ Electron: As the dashboard in the Electron version is monochrome, the dashboard indicators do not change colour when reaching their threshold

 CMP T1                 \ If A >= T1 then we have passed the threshold where we
 BCS DL30               \ change bar colour, so jump to DL30 to set A to the
                        \ "high value" colour

 LDA K+1                \ Set A to K+1, the "low value" colour to use

 BNE DL31               \ Jump down to DL31 (this BNE is effectively a JMP as A
                        \ will never be zero)

.DL30

 LDA K                  \ Set A to K, the "high value" colour to use

.DL31

 STA COL                \ Store the colour of the indicator in COL

ELIF _ELITE_A_DOCKED

 CMP T1                 \ If A >= T1 then we have passed the threshold where we
 BCS DL30               \ change bar colour, so jump to DL30 to set A to the
                        \ "high value" colour

 LDA K+1                \ Set A to K+1, the "low value" colour to use

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A5 &40, or BIT &40A5, which does nothing apart
                        \ from affect the flags

.DL30

 LDA K                  \ Set A to K, the "high value" colour to use

.DL31

 STA COL                \ Store the colour of the indicator in COL

ELIF _ELITE_A_6502SP_PARA

 CMP T1                 \ If A >= T1 then we have passed the threshold where we
 BCS DL30               \ change bar colour, so jump to DL30 to set A to the
                        \ "high value" colour

 LDA K+1                \ Set A to K+1, the "low value" colour to use

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A5 &40, or BIT &40A5, which does nothing apart
                        \ from affect the flags

.DL30

 LDA K                  \ Set A to K, the "high value" colour to use

.DL31

 JSR tube_write         \ Send the second parameter to the I/O processor:
                        \
                        \   * colour = A

 LDA SC                 \ Send the third parameter to the I/O processor:
 JSR tube_write         \
                        \   * screen_low = SC

 LDA SC+1               \ Send the fourth parameter to the I/O processor:
 JSR tube_write         \
                        \   * sch = SC+1

 INC SC+1               \ Increment the high byte of SC to point to the next
                        \ character row on-screen (as each row takes up exactly
                        \ one page of 256 bytes) - so this sets up SC to point
                        \ to the next indicator, i.e. the one below the one we
                        \ just drew

ENDIF

IF NOT(_ELITE_A_6502SP_PARA)

 LDY #2                 \ We want to start drawing the indicator on the third
                        \ line in this character row, so set Y to point to that
                        \ row's offset

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_IO \ Screen

 LDX #3                 \ Set up a counter in X for the width of the indicator,
                        \ which is 4 characters (each of which is 4 pixels wide,
                        \ to give a total width of 16 pixels)

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDX #7                 \ Set up a counter in X for the width of the indicator,
                        \ which is 8 characters (each of which is 2 pixels wide,
                        \ to give a total width of 16 pixels)

ENDIF

IF NOT(_ELITE_A_6502SP_PARA OR _ELITE_A_6502SP_IO)

.DL1

 LDA Q                  \ Fetch the indicator value (0-15) from Q into A

ELIF _ELITE_A_6502SP_IO

.DL1

 LDA bar_1              \ Fetch the indicator value (0-15) from bar_1 into A

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED \ Screen

 CMP #4                 \ If Q < 4, then we need to draw the end cap of the
 BCC DL2                \ indicator, which is less than a full character's
                        \ width, so jump down to DL2 to do this

 SBC #4                 \ Otherwise we can draw a four-pixel wide block, so
 STA Q                  \ subtract 4 from Q so it contains the amount of the
                        \ indicator that's left to draw after this character

ELIF _ELECTRON_VERSION

 CMP #8                 \ If Q < 8, then we need to draw the end cap of the
 BCC DL2                \ indicator, which is less than a full character's
                        \ width, so jump down to DL2 to do this

 SBC #8                 \ Otherwise we can draw an eight-pixel wide block, so
 STA Q                  \ subtract 8 from Q so it contains the amount of the
                        \ indicator that's left to draw after this character

ELIF _6502SP_VERSION OR _MASTER_VERSION

 CMP #2                 \ If Q < 2, then we need to draw the end cap of the
 BCC DL2                \ indicator, which is less than a full character's
                        \ width, so jump down to DL2 to do this

 SBC #2                 \ Otherwise we can draw a two-pixel wide block, so
 STA Q                  \ subtract 2 from Q so it contains the amount of the
                        \ indicator that's left to draw after this character

ELIF _ELITE_A_6502SP_IO

 CMP #4                 \ If bar_1 < 4, then we need to draw the end cap of the
 BCC DL2                \ indicator, which is less than a full character's
                        \ width, so jump down to DL2 to do this

 SBC #4                 \ Otherwise we can draw a four-pixel wide block, so
 STA bar_1              \ subtract 4 from bar_1 so it contains the amount of the
                        \ indicator that's left to draw after this character

ENDIF

IF NOT(_ELITE_A_6502SP_PARA OR _ELITE_A_6502SP_IO)

 LDA R                  \ Fetch the shape of the indicator row that we need to
                        \ display from R, so we can use it as a mask when
                        \ painting the indicator. It will be &FF at this point
                        \ (i.e. a full four-pixel row)

.DL5

ELIF _ELITE_A_6502SP_IO

 LDA bar_3              \ Fetch the shape of the indicator row that we need to
                        \ display from bar_3, so we can use it as a mask when
                        \ painting the indicator. It will be &FF at this point
                        \ (i.e. a full four-pixel row)

.DL5

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED \ Comment

 AND COL                \ Fetch the four-pixel mode 5 colour byte from COL, and
                        \ only keep pixels that have their equivalent bits set
                        \ in the mask byte in A

ELIF _6502SP_VERSION OR _MASTER_VERSION

 AND COL                \ Fetch the two-pixel mode 2 colour byte from COL, and
                        \ only keep pixels that have their equivalent bits set
                        \ in the mask byte in A

ELIF _C64_VERSION

 AND COL                \ Fetch the four-pixel colour byte from COL, and only
                        \ keep pixels that have their equivalent bits set in the
                        \ mask byte in A

ELIF _ELITE_A_6502SP_IO

 AND bar_2              \ Fetch the four-pixel mode 5 colour byte from bar_2,
                        \ and only keep pixels that have their equivalent bits
                        \ set in the mask byte in A

ENDIF

IF NOT(_ELITE_A_6502SP_PARA)

 STA (SC),Y             \ Draw the shape of the mask on pixel row Y of the
                        \ character block we are processing

 INY                    \ Draw the next pixel row, incrementing Y
 STA (SC),Y

 INY                    \ And draw the third pixel row, incrementing Y
 STA (SC),Y

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_IO OR _6502SP_VERSION OR _MASTER_VERSION \ Screen

 TYA                    \ Add 6 to Y, so Y is now 8 more than when we started
 CLC                    \ this loop iteration, so Y now points to the address
 ADC #6                 \ of the first line of the indicator bar in the next
 TAY                    \ character block (as each character is 8 bytes of
                        \ screen memory)

ELIF _ELECTRON_VERSION OR _C64_VERSION

 TYA                    \ Add 6 to Y, so Y is now 8 more than when we started
 CLC                    \ this loop iteration, so Y now points to the address
 ADC #6                 \ of the first line of the indicator bar in the next
                        \ character block (as each character is 8 bytes of
                        \ screen memory)

 BCC P%+4               \ If the addition of the low bytes of SC overflowed,
 INC SC+1               \ increment the high byte

 TAY                    \ Transfer the updated value (Y + 6) back into Y

ENDIF

IF NOT(_ELITE_A_6502SP_PARA)

 DEX                    \ Decrement the loop counter for the next character
                        \ block along in the indicator

 BMI DL6                \ If we just drew the last character block then we are
                        \ done drawing, so jump down to DL6 to finish off

 BPL DL1                \ Loop back to DL1 to draw the next character block of
                        \ the indicator (this BPL is effectively a JMP as A will
                        \ never be negative following the previous BMI)

.DL2

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED \ Screen

 EOR #3                 \ If we get here then we are drawing the indicator's
 STA Q                  \ end cap, so Q is < 4, and this EOR flips the bits, so
                        \ instead of containing the number of indicator columns
                        \ we need to fill in on the left side of the cap's
                        \ character block, Q now contains the number of blank
                        \ columns there should be on the right side of the cap's
                        \ character block

ELIF _ELECTRON_VERSION

 EOR #7                 \ If we get here then we are drawing the indicator's
 STA Q                  \ end cap, so Q is < 8, and this EOR flips the bits, so
                        \ instead of containing the number of indicator columns
                        \ we need to fill in on the left side of the cap's
                        \ character block, Q now contains the number of blank
                        \ columns there should be on the right side of the cap's
                        \ character block

ELIF _6502SP_VERSION OR _MASTER_VERSION

 EOR #1                 \ If we get here then we are drawing the indicator's
 STA Q                  \ end cap, so Q is < 2, and this EOR flips the bits, so
                        \ instead of containing the number of indicator columns
                        \ we need to fill in on the left side of the cap's
                        \ character block, Q now contains the number of blank
                        \ columns there should be on the right side of the cap's
                        \ character block

ELIF _ELITE_A_6502SP_IO

 EOR #3                 \ If we get here then we are drawing the indicator's end
 STA bar_1              \ cap, so bar_1 is < 4, and this EOR flips the bits, so
                        \ instead of containing the number of indicator columns
                        \ we need to fill in on the left side of the cap's
                        \ character block, bar_1 now contains the number of
                        \ blank columns there should be on the right side of the
                        \ cap's character block

ENDIF

IF NOT(_ELITE_A_6502SP_PARA OR _ELITE_A_6502SP_IO)

 LDA R                  \ Fetch the current mask from R, which will be &FF at
                        \ this point, so we need to turn Q of the columns on the
                        \ right side of the mask to black to get the correct end
                        \ cap shape for the indicator

.DL3

ELIF _ELITE_A_6502SP_IO

 LDA bar_3              \ Fetch the current mask from bar_3, which will be &FF
                        \ at this point, so we need to turn bar_1 of the columns
                        \ on the right side of the mask to black to get the
                        \ correct end cap shape for the indicator

.DL3

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_IO \ Screen

 ASL A                  \ Shift the mask left so bit 0 is cleared, and then
 AND #%11101111         \ clear bit 4, which has the effect of shifting zeroes
                        \ from the left into each nibble (i.e. xxxx xxxx becomes
                        \ xxx0 xxx0, which blanks out the last column in the
                        \ four-pixel mode 5 character block)

ELIF _ELECTRON_VERSION

 ASL A                  \ Shift the mask left so bit 0 is cleared

ELIF _6502SP_VERSION OR _MASTER_VERSION

 ASL A                  \ Shift the mask left and clear bits 0, 2, 4 and 8,
 AND #%10101010         \ which has the effect of shifting zeroes from the left
                        \ into each two-bit segment (i.e. xx xx xx xx becomes
                        \ x0 x0 x0 x0, which blanks out the last column in the
                        \ two-pixel mode 2 character block)

ELIF _C64_VERSION

 ASL A                  \ Shift the mask left so bits 0 and 1 are cleared
 ASL A

ENDIF

IF NOT(_ELITE_A_6502SP_PARA OR _ELITE_A_6502SP_IO)

 DEC Q                  \ Decrement the counter for the number of columns to
                        \ blank out

 BPL DL3                \ If we still have columns to blank out in the mask,
                        \ loop back to DL3 until the mask is correct for the
                        \ end cap

 PHA                    \ Store the mask byte on the stack while we use the
                        \ accumulator for a bit

ELIF _ELITE_A_6502SP_IO

 DEC bar_1              \ Decrement the counter for the number of columns to
                        \ blank out

 BPL DL3                \ If we still have columns to blank out in the mask,
                        \ loop back to DL3 until the mask is correct for the
                        \ end cap

 PHA                    \ Store the mask byte on the stack while we use the
                        \ accumulator for a bit

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _6502SP_VERSION \ Minor

 LDA #0                 \ Change the mask so no bits are set, so the characters
 STA R                  \ after the one we're about to draw will be all blank

ELIF _MASTER_VERSION

 STZ R                  \ Change the mask so no bits are set, so the characters
                        \ after the one we're about to draw will be all blank

ELIF _ELITE_A_6502SP_IO

 LDA #0                 \ Change the mask so no bits are set, so the characters
 STA bar_3              \ after the one we're about to draw will be all blank

ENDIF

IF NOT(_ELITE_A_6502SP_PARA OR _ELITE_A_6502SP_IO)

 LDA #99                \ Set Q to a high number (99, why not) so we will keep
 STA Q                  \ drawing blank characters until we reach the end of
                        \ the indicator row

 PLA                    \ Restore the mask byte from the stack so we can use it
                        \ to draw the end cap of the indicator

 JMP DL5                \ Jump back up to DL5 to draw the mask byte on-screen

.DL6

ELIF _ELITE_A_6502SP_IO

 LDA #99                \ Set bar_1 to a high number (99, why not) so we will
 STA bar_1              \ keep drawing blank characters until we reach the end
                        \ of the indicator row

 PLA                    \ Restore the mask byte from the stack so we can use it
                        \ to draw the end cap of the indicator

 JMP DL5                \ Jump back up to DL5 to draw the mask byte on-screen

.DL6

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED \ Screen

 INC SC+1               \ Increment the high byte of SC to point to the next
                        \ character row on-screen (as each row takes up exactly
                        \ one page of 256 bytes) - so this sets up SC to point
                        \ to the next indicator, i.e. the one below the one we
                        \ just drew

ELIF _ELECTRON_VERSION

 SEC                    \ Jump to NEXTR with the C flag set to move the screen
 JMP NEXTR              \ address in SC(1 0) down by one character row,
                        \ returning from the subroutine using a tail call

ELIF _6502SP_VERSION OR _MASTER_VERSION

 INC SC+1               \ Increment the high byte of SC to point to the next
 INC SC+1               \ character row on-screen (as each row takes up exactly
                        \ two pages of 256 bytes) - so this sets up SC to point
                        \ to the next indicator, i.e. the one below the one we
                        \ just drew

ELIF _C64_VERSION

                        \ We now need to move down into the character block
                        \ below, and each character row in screen memory takes
                        \ up &140 bytes (&100 for the visible part and &20 for
                        \ each of the blank borders on the side of the screen),
                        \ so that's what we need to add to SC(1 0)

 LDA SC                 \ Set SC(1 0) = SC(1 0) + &140
 CLC                    \
 ADC #&40               \ Starting with the low bytes
 STA SC

 LDA SC+1               \ And then adding the high bytes
 ADC #&01
 STA SC+1

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _MASTER_VERSION \ Label

.DL9

 RTS                    \ Return from the subroutine

ENDIF

