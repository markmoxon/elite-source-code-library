\ ******************************************************************************
\
\       Name: HAS2
\       Type: Subroutine
\   Category: Ship hanger
\    Summary: Draw a hanger background line from left to right
\
\ ------------------------------------------------------------------------------
\
\ This routine draws a line to the right, starting with the third pixel of the
\ pixel row at screen address SC(1 0), and aborting if we bump into something
\ that's already on-screen. HAL2 draws from the left edge of the screen to the
\ halfway point, and then HAL3 takes over to draw from the halfway point across
\ the right half of the screen.
\
IF _DISC_DOCKED OR _ELITE_A_VERSION \ Comment
\ Other entry points:
\
\   HA3                 Contains an RTS
\
ENDIF
\ ******************************************************************************

.HAS2

IF _DISC_DOCKED OR _ELITE_A_VERSION \ Screen

 LDA #%00100000         \ Set A to the pixel pattern for a mode 4 character row
                        \ byte with the third pixel set, so we start drawing the
                        \ horizontal line just to the right of the 2-pixel
                        \ border along the edge of the screen

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDA #%00100010         \ Set A to the pixel pattern for a mode 1 character row
                        \ byte with the third pixel set, so we start drawing the
                        \ horizontal line just to the right of the 2-pixel
                        \ border along the edge of the screen

ENDIF

.HAL2

 TAX                    \ Store A in X so we can retrieve it after the following
                        \ check and again after updating screen memory

 AND (SC),Y             \ If the pixel we want to draw is non-zero (using A as a
 BNE HA3                \ mask), then this means it already contains something,
                        \ so we stop drawing because we have run into something
                        \ that's already on-screen, and return from the
                        \ subroutine (as HA3 contains an RTS)

 TXA                    \ Retrieve the value of A we stored above, so A now
                        \ contains the pixel mask again

IF _6502SP_VERSION OR _MASTER_VERSION \ Screen

 AND #RED               \ Apply the pixel mask in A to a four-pixel block of
                        \ red pixels, so we now know which bits to set in screen
                        \ memory

ENDIF

 ORA (SC),Y             \ OR the byte with the current contents of screen
                        \ memory, so the pixel we want is set to red (because
                        \ we know the bits are already 0 from the above test)

 STA (SC),Y             \ Store the updated pixel in screen memory

 TXA                    \ Retrieve the value of A we stored above, so A now
                        \ contains the pixel mask again

 LSR A                  \ Shift A to the right to move on to the next pixel

 BCC HAL2               \ If bit 0 before the shift was clear (i.e. we didn't
                        \ just do the fourth pixel in this block), loop back to
                        \ HAL2 to check and draw the next pixel

 TYA                    \ Set Y = Y + 8 (as we know the C flag is set) to point
 ADC #7                 \ to the next character block along
 TAY

IF _DISC_DOCKED OR _ELITE_A_VERSION \ Screen

 LDA #%10000000         \ Reset the pixel mask in A to the first pixel in the
                        \ new 8-pixel character block

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDA #%10001000         \ Reset the pixel mask in A to the first pixel in the
                        \ new 4-pixel character block

ENDIF

 BCC HAL2               \ If the above addition didn't overflow, jump back to
                        \ HAL2 to keep drawing the line in the next character
                        \ block

IF _6502SP_VERSION OR _MASTER_VERSION \ Screen

 INC SC+1               \ The addition overflowed, so we have reached the last
                        \ character block in this page of memory, so increment
                        \ the high byte of SC(1 0) in SC+1 to point to the next
                        \ page (i.e. the right half of this screen row) and fall
                        \ into HAL3 to repeat the performamce

.HAL3

 TAX                    \ Store A in X so we can retrieve it after the following
                        \ check and again after updating screen memory

 AND (SC),Y             \ If the pixel we want to draw is non-zero (using A as a
 BNE HA3                \ mask), then this means it already contains something,
                        \ so we stop drawing because we have run into something
                        \ that's already on-screen, and return from the
                        \ subroutine (as HA3 contains an RTS)

 TXA                    \ Retrieve the value of A we stored above, so A now
                        \ contains the pixel mask again

 AND #RED               \ Apply the pixel mask in A to a four-pixel block of
                        \ red pixels, so we now know which bits to set in screen
                        \ memory

 ORA (SC),Y             \ OR the byte with the current contents of screen
                        \ memory, so the pixel we want is set to red (because
                        \ we know the bits are already 0 from the above test)

 STA (SC),Y             \ Store the updated pixel in screen memory

 TXA                    \ Retrieve the value of A we stored above, so A now
                        \ contains the pixel mask again

 LSR A                  \ Shift A to the right to move on to the next pixel

 BCC HAL3               \ If bit 0 before the shift was clear (i.e. we didn't
                        \ just do the fourth pixel in this block), loop back to
                        \ HAL3 to check and draw the next pixel

 TYA                    \ Set Y = Y + 8 (as we know the C flag is set) to point
 ADC #7                 \ to the next character block along
 TAY

 LDA #%10001000         \ Reset the pixel mask in A to the first pixel in the
                        \ new 4-pixel character block

 BCC HAL3               \ If the above addition didn't overflow, jump back to
                        \ HAL3 to keep drawing the line in the next character
                        \ block

ENDIF

IF _DISC_DOCKED OR _ELITE_A_VERSION \ Label

.HA3

ENDIF

 RTS                    \ The addition overflowed, so we have reached the last
                        \ character block in this page of memory, which is the
                        \ end of the line, so we return from the subroutine

