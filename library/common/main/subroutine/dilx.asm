\ ******************************************************************************
\
\       Name: DILX
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Update a bar-based indicator on the dashboard
\  Deep dive: The dashboard indicators
\
\ ------------------------------------------------------------------------------
\
\ The range of values shown on the indicator depends on which entry point is
\ called. For the default entry point of DILX, the range is 0-255 (as the value
\ passed in A is one byte). The other entry points are shown below.
\
\ Arguments:
\
\   A                   The value to be shown on the indicator (so the larger
\                       the value, the longer the bar)
\
IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
\   T1                  The threshold at which we change the indicator's colour
\                       from the low value colour to the high value colour. The
\                       threshold is in pixels, so it should have a value from
\                       0-16, as each bar indicator is 16 pixels wide
\
ENDIF
IF _CASSETTE_VERSION OR _DISC_VERSION \ Comment
\   K                   The colour to use when A is a high value, as a 4-pixel
\                       mode 5 character row byte
\
\   K+1                 The colour to use when A is a low value, as a 4-pixel
\                       mode 5 character row byte
ELIF _6502SP_VERSION OR _MASTER_VERSION
\   K                   The colour to use when A is a high value, as a 2-pixel
\                       mode 2 character row byte
\
\   K+1                 The colour to use when A is a low value, as a 2-pixel
\                       mode 2 character row byte
ENDIF
\
\   SC(1 0)             The screen address of the first character block in the
\                       indicator
\
\ Other entry points:
\
IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
\   DILX+2              The range of the indicator is 0-64 (for the fuel
\                       indicator)
\
ENDIF
\   DIL-1               The range of the indicator is 0-32 (for the speed
\                       indicator)
\
\   DIL                 The range of the indicator is 0-16 (for the energy
\                       banks)
\
\ ******************************************************************************

.DILX

 LSR A                  \ If we call DILX, we set A = A / 16, so A is 0-15
 LSR A

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Screen

 LSR A                  \ If we call DILX+2, we set A = A / 4, so A is 0-15

ENDIF

 LSR A                  \ If we call DIL-1, we set A = A / 2, so A is 0-15

.DIL

                        \ If we call DIL, we leave A alone, so A is 0-15

 STA Q                  \ Store the indicator value in Q, now reduced to 0-15,
                        \ which is the length of the indicator to draw in pixels

 LDX #&FF               \ Set R = &FF, to use as a mask for drawing each row of
 STX R                  \ each character block of the bar, starting with a full
                        \ character's width of 4 pixels

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Electron: As the dashboard in the Electron version is monochrome, the dashboard indicators do not change colour when reaching their threshold

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

ENDIF

 LDY #2                 \ We want to start drawing the indicator on the third
                        \ line in this character row, so set Y to point to that
                        \ row's offset

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION \ Screen

 LDX #3                 \ Set up a counter in X for the width of the indicator,
                        \ which is 4 characters (each of which is 4 pixels wide,
                        \ to give a total width of 16 pixels)

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDX #7                 \ Set up a counter in X for the width of the indicator,
                        \ which is 8 characters (each of which is 2 pixels wide,
                        \ to give a total width of 16 pixels)

ENDIF

.DL1

 LDA Q                  \ Fetch the indicator value (0-15) from Q into A

IF _CASSETTE_VERSION OR _DISC_VERSION \ Screen

 CMP #4                 \ If Q < 4, then we need to draw the end cap of the
 BCC DL2                \ indicator, which is less than a full character's
                        \ width, so jump down to DL2 to do this

 SBC #4                 \ Otherwise we can draw a 4-pixel wide block, so
 STA Q                  \ subtract 4 from Q so it contains the amount of the
                        \ indicator that's left to draw after this character

ELIF _ELECTRON_VERSION

 CMP #8                 \ If Q < 8, then we need to draw the end cap of the
 BCC DL2                \ indicator, which is less than a full character's
                        \ width, so jump down to DL2 to do this

 SBC #8                 \ Otherwise we can draw an 8-pixel wide block, so
 STA Q                  \ subtract 8 from Q so it contains the amount of the
                        \ indicator that's left to draw after this character

ELIF _6502SP_VERSION OR _MASTER_VERSION

 CMP #2                 \ If Q < 2, then we need to draw the end cap of the
 BCC DL2                \ indicator, which is less than a full character's
                        \ width, so jump down to DL2 to do this

 SBC #2                 \ Otherwise we can draw a 2-pixel wide block, so
 STA Q                  \ subtract 2 from Q so it contains the amount of the
                        \ indicator that's left to draw after this character

ENDIF

 LDA R                  \ Fetch the shape of the indicator row that we need to
                        \ display from R, so we can use it as a mask when
                        \ painting the indicator. It will be &FF at this point
                        \ (i.e. a full 4-pixel row)

.DL5

IF _CASSETTE_VERSION OR _DISC_VERSION \ Comment

 AND COL                \ Fetch the 4-pixel mode 5 colour byte from COL, and
                        \ only keep pixels that have their equivalent bits set
                        \ in the mask byte in A

ELIF _6502SP_VERSION OR _MASTER_VERSION

 AND COL                \ Fetch the 2-pixel mode 2 colour byte from COL, and
                        \ only keep pixels that have their equivalent bits set
                        \ in the mask byte in A

ENDIF

 STA (SC),Y             \ Draw the shape of the mask on pixel row Y of the
                        \ character block we are processing

 INY                    \ Draw the next pixel row, incrementing Y
 STA (SC),Y

 INY                    \ And draw the third pixel row, incrementing Y
 STA (SC),Y

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Screen

 TYA                    \ Add 6 to Y, so Y is now 8 more than when we started
 CLC                    \ this loop iteration, so Y now points to the address
 ADC #6                 \ of the first line of the indicator bar in the next
 TAY                    \ character block (as each character is 8 bytes of
                        \ screen memory)

ELIF _ELECTRON_VERSION

 TYA                    \ Add 6 to Y, so Y is now 8 more than when we started
 CLC                    \ this loop iteration, so Y now points to the address
 ADC #6                 \ of the first line of the indicator bar in the next
                        \ character block (as each character is 8 bytes of
                        \ screen memory)

 BCC P%+4               \ If the addition of the low bytes of SC overflowed,
 INC SCH                \ increment the high byte

 TAY                    \ Transfer the updated value (Y + 6) back into Y

ENDIF

 DEX                    \ Decrement the loop counter for the next character
                        \ block along in the indicator

 BMI DL6                \ If we just drew the last character block then we are
                        \ done drawing, so jump down to DL6 to finish off

 BPL DL1                \ Loop back to DL1 to draw the next character block of
                        \ the indicator (this BPL is effectively a JMP as A will
                        \ never be negative following the previous BMI)

.DL2

IF _CASSETTE_VERSION OR _DISC_VERSION \ Screen

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

ENDIF

 LDA R                  \ Fetch the current mask from R, which will be &FF at
                        \ this point, so we need to turn Q of the columns on the
                        \ right side of the mask to black to get the correct end
                        \ cap shape for the indicator

.DL3

IF _CASSETTE_VERSION OR _DISC_VERSION \ Screen

 ASL A                  \ Shift the mask left so bit 0 is cleared, and then
 AND #%11101111         \ clear bit 4, which has the effect of shifting zeroes
                        \ from the left into each nibble (i.e. xxxx xxxx becomes
                        \ xxx0 xxx0, which blanks out the last column in the
                        \ 4-pixel mode 5 character block)

ELIF _ELECTRON_VERSION

 ASL A                  \ ???

ELIF _6502SP_VERSION OR _MASTER_VERSION

 ASL A                  \ Shift the mask left and clear bits 0, 2, 4 and 8,
 AND #%10101010         \ which has the effect of shifting zeroes from the left
                        \ into each two-bit segment (i.e. xx xx xx xx becomes
                        \ x0 x0 x0 x0, which blanks out the last column in the
                        \ 2-pixel mode 2 character block)

ENDIF

 DEC Q                  \ Decrement the counter for the number of columns to
                        \ blank out

 BPL DL3                \ If we still have columns to blank out in the mask,
                        \ loop back to DL3 until the mask is correct for the
                        \ end cap

 PHA                    \ Store the mask byte on the stack while we use the
                        \ accumulator for a bit

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Minor

 LDA #0                 \ Change the mask so no bits are set, so the characters
 STA R                  \ after the one we're about to draw will be all blank

ELIF _MASTER_VERSION

 STZ R                  \ Change the mask so no bits are set, so the characters
                        \ after the one we're about to draw will be all blank

ENDIF

 LDA #99                \ Set Q to a high number (99, why not) so we will keep
 STA Q                  \ drawing blank characters until we reach the end of
                        \ the indicator row

 PLA                    \ Restore the mask byte from the stack so we can use it
                        \ to draw the end cap of the indicator

 JMP DL5                \ Jump back up to DL5 to draw the mask byte on-screen

.DL6

IF _CASSETTE_VERSION OR _DISC_VERSION \ Screen

 INC SC+1               \ Increment the high byte of SC to point to the next
                        \ character row on-screen (as each row takes up exactly
                        \ one page of 256 bytes) - so this sets up SC to point
                        \ to the next indicator, i.e. the one below the one we
                        \ just drew

ELIF _ELECTRON_VERSION

 SEC                    \ ???
 JMP L293D

ELIF _6502SP_VERSION OR _MASTER_VERSION

 INC SC+1               \ Increment the high byte of SC to point to the next
 INC SC+1               \ character row on-screen (as each row takes up exactly
                        \ two pages of 256 bytes) - so this sets up SC to point
                        \ to the next indicator, i.e. the one below the one we
                        \ just drew

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Label

.DL9                    \ This label is not used but is in the original source

 RTS                    \ Return from the subroutine

ENDIF

