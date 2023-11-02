\ ******************************************************************************
\
\       Name: MoveIconBarPointer
\       Type: Subroutine
\   Category: Icon bar
\    Summary: Move the sprites that make up the icon bar pointer and record any
\             choices
\  Deep dive: Sprite usage in NES Elite
\
\ ******************************************************************************

.MoveIconBarPointer

                        \ This routine is called every VBlank and manages the
                        \ movement of the icon bar pointer and choosing icon bar
                        \ buttons
                        \
                        \ We start by updating a couple of counters that are
                        \ only used in the PAL version, and which are ignored in
                        \ the NTSC version

 DEC pointerTimer       \ Decrement the pointer timer
                        \
                        \ This timer is used in the PAL version to detect the B
                        \ button being pressed twice in quick succession
                        \
                        \ The pointer timer is updated in the NTSC version but
                        \ is otherwise ignored

IF _PAL

 BNE mbar1              \ If the pointer timer has not reached zero, jump to
                        \ mbar1 to skip the following instruction

 LSR pointerTimerB      \ Zero pointerTimerB (this works because pointerTimerB
                        \ is only ever 0 or 1)
                        \
                        \ The pointerTimerB timer is used in the PAL version to
                        \ detect the B button being pressed twice in quick
                        \ succession, so zeroing it indicates that the timer has
                        \ run down before the B button was pressed for the
                        \ second time, so this can't be a double-tap
                        \
                        \ The NTSC version does away with this variable
                        \ altogether, as well as ignoring pointerTimer

.mbar1

ENDIF

 BPL mbar2              \ If pointerTimer is positive, jump to mbar2 to skip
                        \ the following instruction

 INC pointerTimer       \ Increment pointerTimer so it doesn't decrement past
                        \ zero

.mbar2

 DEC pointerMoveCounter \ Decrement the pointer move counter, which is used to
                        \ keep track of whether the icon bar pointer is moving
                        \ between two buttons (if the counter is non-zero, then
                        \ the pointer is currently moving between two buttons)

 BPL mbar3              \ If pointerMoveCounter is positive, jump to mbar3 to
                        \ skip the following instruction

 INC pointerMoveCounter \ Increment pointerMoveCounter so it doesn't decrement
                        \ past zero

.mbar3

                        \ We now confirm that there is an icon bar for us to
                        \ manage (if not, we leave the subroutine at this point)

 LDA screenFadedToBlack \ If bit 7 of screenFadedToBlack is set then we have
 BMI hipo2              \ already faded the screen to black, so jump to hipo2
                        \ to clear the icon button choice and hide the icon bar
                        \ pointer

 LDA showIconBarPointer \ If showIconBarPointer = 0 then the icon bar pointer
 BEQ HideIconBarPointer \ should be hidden, so jump to HideIconBarPointer to do
                        \ just that

                        \ If we get here then the icon bar pointer is visible,
                        \ so we now need to process any movement before drawing
                        \ the pointer in its new location
                        \
                        \ The pointer coordinates are stored in xIconBarPointer
                        \ and yIconBarPointer, though note that the x-coordinate
                        \ in xIconBarPointer is multiplied by 5 to get the final
                        \ pixel x-coordinate (the yIconBarPointer value, on the
                        \ other hand, contains a pixel coordinate from the off)
                        \
                        \ The movement of the pointer is stored in xPointerDelta
                        \ as a delta, which is set later in the routine
                        \ according to the buttons being pressed on the
                        \ controller
                        \
                        \ The xPointerDelta variable is set to zero by default,
                        \ and is only non-zero if the previous call to this
                        \ routine detected the correct movement buttons

 LDA xPointerDelta      \ Set xIconBarPointer = xIconBarPointer + xPointerDelta
 CLC                    \
 ADC xIconBarPointer    \ So this updates the x-coordinate of the icon bar
 STA xIconBarPointer    \ to move it in the direction of xPointerDelta (which
                        \ was set to -1, 0 or +1 depending on which directional
                        \ keys were being pressed the last time we were here)

 AND #3                 \ If xIconBarPointer mod 4 is non-zero, jump to mbar9 to
 BNE mbar9              \ skip updating the movement delta in xPointerDelta, so
                        \ we only scan for movement keys every four movements of
                        \ the pointer (this ensures that when a movement starts,
                        \ it runs for four VBlanks without being interrupted, so
                        \ the pointer keeps moving towards the next button, one
                        \ step for each VBlank)
                        \
                        \ In other words, when xIconBarPointer mod 4 is 0, the
                        \ pointer is on a button, while other values mean it is
                        \ between buttons

                        \ If we get here then the movement has been applied for
                        \ four VBlanks, so the pointer has now moved onto the
                        \ next button

 LDA #0                 \ Set xPointerDelta = 0 so the pointer is not moving by
 STA xPointerDelta      \ default, though we now change that if the movement
                        \ buttons are being pressed

 LDA pointerMoveCounter \ If pointerMoveCounter is non-zero then we are already
 BNE mbar9              \ moving the pointer between two buttons, so jump to
                        \ mbar9 to leave xPointerDelta at zero and ignore any
                        \ button presses, as we need to finish the jump from one
                        \ button to another before we can move it again
                        \
                        \ This ensures that once we start a movement between
                        \ icon bar buttons, we wait until pointerMoveCounter
                        \ VBlanks have passed before listening for the next move
                        \
                        \ pointerMoveCounter is set to 12 at the start of each
                        \ move, so we spend the first four VBlanks moving the
                        \ pointer, then xPointerDelta is zeroed above, and then
                        \ we wait for another eight VBlanks before listening for
                        \ button presses again
                        \
                        \ This gives the icon bar pointer a stepped movement
                        \ that jumps from button to button if the left or right
                        \ buttons are held down

 LDA controller1B       \ If the B button is not being pressed on controller 1
 ORA numberOfPilots     \ and the game is configured for one pilot, jump to
 BPL mbar9              \ mbar9 to skip updating the movement delta in
                        \ xPointerDelta, as in one-pilot mode we can only move
                        \ the icon bar pointer when the B button is held down
                        \
                        \ If the game is configured for two pilots, we always
                        \ pass through this branch as numberOfPilots = 1, so
                        \ we don't need the B button to be held down when there
                        \ are two pilots

                        \ We now process the left button, which moves the icon
                        \ bar pointer to the left

 LDX controller1Left    \ If the left button on controller 1 is being pressed,
 BMI mbar4              \ jump to mbar4 to set xPointerDelta to -1

 LDA #0                 \ Otherwise reset controller1Left to 0 to clear out the
 STA controller1Left    \ left button history in the controller variable, to
                        \ make the logic below slightly simpler (see mbar13)

 JMP mbar6              \ Jump to mbar6 to check for the right button

.mbar4

                        \ If we get here then the left button is being pressed
                        \ and X contains the value of controller1Left

 LDA #&FF               \ Set A = -1 to set as the value of xPointerDelta

 CPX #%10000000         \ If the left button has just been pressed but wasn't
 BNE mbar5              \ being pressed before, keep going, otherwise jump to
                        \ mbar5 to skip the following

                        \ The following is therefore only run when we first
                        \ press the left button

 LDX #12                \ The left button was just pressed but wasn't being
 STX pointerMoveCounter \ pressed before, so set pointerMoveCounter to 12 so it
                        \ can count down to zero, during which time we don't
                        \ check for any more directional button presses (as the
                        \ pointer will be moving between icon bar buttons)

.mbar5

 STA xPointerDelta      \ Set xPointerDelta = -1, so the pointer moves to the
                        \ left

.mbar6

                        \ We now process the right button, which moves the icon
                        \ bar pointer to the right

 LDX controller1Right   \ If the right button on controller 1 is being pressed,
 BMI mbar7              \ jump to mbar7 to set xPointerDelta to 1

 LDA #0                 \ Reset controller1Right to 0 to clear out the right
 STA controller1Right   \ button history in the controller variable, to
                        \ make the logic below slightly simpler (see mbar13)

 JMP mbar9              \ Jump to mbar9 to move on to clipping the pointer's
                        \ x-coordinate

.mbar7

 LDA #1                 \ Set A = 1 to set as the value of xPointerDelta

 CPX #%10000000         \ If the right button has just been pressed but wasn't
 BNE mbar8              \ being pressed before, keep going, otherwise jump to
                        \ mbar8 to skip the following

                        \ The following is therefore only run when we first
                        \ press the right button

 LDX #12                \ The right button was just pressed but wasn't being
 STX pointerMoveCounter \ pressed before, so set pointerMoveCounter to 12 so it
                        \ can count down to zero, during which time we don't
                        \ check for any more directional button presses (as the
                        \ pointer will be moving between icon bar buttons)

.mbar8

 STA xPointerDelta      \ Set xPointerDelta = 1, so the pointer moves to the
                        \ left

.mbar9

                        \ We now clip the x-coordinate of the pointer to ensure
                        \ it is in the range 0 to 44 (which equates to a pixel
                        \ range of 0 to 44 * 5 = 220)

 LDA xIconBarPointer    \ If xIconBarPointer < 128, jump to mbar10 to skip the
 BPL mbar10             \ following

 LDA #0                 \ If we get here then xIconBarPointer >= 128, so set
 STA xPointerDelta      \ xPointerDelta = 0 to stop the pointer from moving

 BEQ mbar11             \ Jump to mbar11 with A = 0 to set xIconBarPointer = 0,
                        \ so the value of xIconBarPointer wraps around to zero
                        \ if it goes above 127 (this BEQ is effectively a JMP
                        \ as A is always zero)

.mbar10

 CMP #45                \ If xIconBarPointer < 45, jump to mbar11 to move on to
 BCC mbar11             \ the next set of checks

 LDA #0                 \ If we get here then 45 <= xIconBarPointer < 127, so
 STA xPointerDelta      \ set xPointerDelta = 0 to stop the pointer from moving

 LDA #44                \ Set A = 44 to store in xIconBarPointer, so the value
                        \ of xIconBarPointer never gets above 44

.mbar11

 STA xIconBarPointer    \ Set xIconBarPointer to the clipped value in A, so
                        \ xIconBarPointer is in the range 0 to 44

                        \ We now draw the icon bar pointer in either the up or
                        \ down position
                        \
                        \ We draw it in the up position if any of the following
                        \ are true:
                        \
                        \   * xIconBarPointer mod 4 is non-zero (in which case
                        \     we know that the pointer is moving between
                        \     buttons)
                        \
                        \   * xPointerDelta is non-zero (so the pointer only
                        \     ever moves when it is in the up position)
                        \
                        \   * The B button is being pressed (which is the button
                        \     we press to lift the pointer up)
                        \
                        \   * The Select button is being pressed (so the pointer
                        \     jumps up when we choose an icon from the icon bar
                        \     with Select)
                        \
                        \ Otherwise we draw it in the down position

 LDA xIconBarPointer    \ If xIconBarPointer mod 4 is non-zero or xPointerDelta
 AND #3                 \ is non-zero, then as noted above, this means that the
 ORA xPointerDelta      \ pointer is between buttons, so jump to mbar12 to draw
 BNE mbar12             \ the icon bar pointer in the up position

 LDA controller1B       \ If the B button is being pressed, jump to mbar12 to
 BMI mbar12             \ draw the icon bar pointer in the up position (this
 LDA controller1B       \ comparison is repeated, but that doesn't seem to have
 BMI mbar12             \ any effect)

 LDA controller1Select  \ If the Select button is being pressed, jump to mbar12
 BNE mbar12             \ to draw the icon bar pointer in the up position

                        \ If we get here then the B button is not being pressed,
                        \ so we draw the icon bar pointer in the down position,
                        \ so it looks as if it goes around the bottom of the
                        \ button
                        \
                        \ The pointer is made up of the following sprites, which
                        \ are ordered in a clockwise fashion:
                        \
                        \   * Sprite 1 in the top-left
                        \   * Sprite 2 in the top-right
                        \   * Sprite 3 in the bottom-right
                        \   * Sprite 4 in the bottom-left
                        \
                        \ The value of yIconBarPointer contains the y-coordinate
                        \ of the icon bar, which is 148 when there is a
                        \ dashboard or this is the Game Over screen, or 204
                        \ otherwise
                        \
                        \ The value of xIconBarPointer is in the range 0 to 44,
                        \ which represents the icon bar with buttons on each
                        \ multiple of 4

 LDA #251               \ Set the pattern number for the sprites 1 and 2 to
 STA pattSprite1        \ pattern 251, so the top part of the pointer appears to
 STA pattSprite2        \ go behind the button

 LDA yIconBarPointer    \ Set the y-coordinate of the top of the pointer in
 CLC                    \ sprites 1 and 2 to yIconBarPointer + 11, so the
 ADC #11+YPAL           \ pointer is drawn in the down position (three pixels
 STA ySprite1           \ lower down the screen than the up position)
 STA ySprite2

 LDA xIconBarPointer    \ Set A = 6 + xIconBarPointer * 4 + xIconBarPointer
 ASL A                  \       = 6 + 5 * xIconBarPointer
 ASL A                  \
 ADC xIconBarPointer    \ As noted above, xIconBarPointer is in the range 0 to
 ADC #6                 \ 44, so the pixel x-coordinate of the pointer is in
                        \ the range 6 to 226

                        \ We now use A as the x-coordinate of the bottom-left
                        \ corner of the four-sprite pointer by setting the
                        \ sprite's coordinates as follows (with the bottom
                        \ sprites being spread out slightly more than the top
                        \ sprites)

 STA xSprite4           \ Set the x-coordinate of sprite 4 in the bottom-left
                        \ of the pointer to A

 ADC #1                 \ Set the x-coordinate of sprite 1 in the top-left of
 STA xSprite1           \ the pointer to A + 1

 ADC #13                \ Set the x-coordinate of sprite 2 in the top-right of
 STA xSprite2           \ the pointer to A + 14

 ADC #1                 \ Set the x-coordinate of sprite 3 in the bottom-right
 STA xSprite3           \ of the pointer to A + 15

 LDA yIconBarPointer    \ Set the y-coordinate of the bottom of the pointer in
 CLC                    \ sprites 3 and 4 to yIconBarPointer + 19, so the
 ADC #19+YPAL           \ pointer is drawn in the down position (three pixels
 STA ySprite4           \ lower down the screen than the up position)
 STA ySprite3

 LDA xIconBarPointer    \ If xIconBarPointer is non-zero then jump to mbar13
 BNE mbar13             \ (though this has no effect as that's what we're about
                        \ to do anyway)

 JMP mbar13             \ Jump to mbar13 to continue checking for button presses

.mbar12

                        \ If we get here then the B button is being pressed, so
                        \ we draw the icon bar pointer in the up position, so it
                        \ looks as if can be moved left or right without being
                        \ blocked by the buttons
                        \
                        \ The pointer is made up of the following sprites, which
                        \ are ordered in a clockwise fashion:
                        \
                        \   * Sprite 1 in the top-left
                        \   * Sprite 2 in the top-right
                        \   * Sprite 3 in the bottom-right
                        \   * Sprite 4 in the bottom-left
                        \
                        \ The value of yIconBarPointer contains the y-coordinate
                        \ of the icon bar, which is 148 when there is a
                        \ dashboard or this is the Game Over screen, or 204
                        \ otherwise
                        \
                        \ The value of xIconBarPointer is in the range 0 to 44,
                        \ which represents the icon bar with buttons on each
                        \ multiple of 4

 LDA #252               \ Set the pattern number for the sprites 1 and 2 to
 STA pattSprite1        \ pattern 252, so the top part of the pointer appears to
 STA pattSprite2        \ pop up from behind the top of the button

 LDA yIconBarPointer    \ Set the y-coordinate of the top of the pointer in
 CLC                    \ sprites 1 and 2 to yIconBarPointer + 8, so the
 ADC #8+YPAL            \ pointer is drawn in the up position (three pixels
 STA ySprite1           \ higher up the screen than the down position)
 STA ySprite2

 LDA xIconBarPointer    \ Set A = 6 + xIconBarPointer * 4 + xIconBarPointer
 ASL A                  \       = 6 + 5 * xIconBarPointer
 ASL A                  \
 ADC xIconBarPointer    \ As noted above, xIconBarPointer is in the range 0 to
 ADC #6                 \ 44, so the pixel x-coordinate of the pointer is in
                        \ the range 6 to 226

                        \ We now use A as the x-coordinate of the bottom-left
                        \ corner of the four-sprite pointer by setting the
                        \ sprite's coordinates as follows (with the bottom
                        \ sprites being spread out slightly more than the top
                        \ sprites)

 STA xSprite4           \ Set the x-coordinate of sprite 4 in the bottom-left
                        \ of the pointer to A

 ADC #1                 \ Set the x-coordinate of sprite 1 in the top-left of
 STA xSprite1           \ the pointer to A + 1

 ADC #13                \ Set the x-coordinate of sprite 2 in the top-right of
 STA xSprite2           \ the pointer to A + 14

 ADC #1                 \ Set the x-coordinate of sprite 3 in the bottom-right
 STA xSprite3           \ of the pointer to A + 15

 LDA yIconBarPointer    \ Set the y-coordinate of the bottom of the pointer in
 CLC                    \ sprites 3 and 4 to yIconBarPointer + 16, so the
 ADC #16+YPAL           \ pointer is drawn in the up position (three pixels
 STA ySprite4           \ higher up the screen than the down position)
 STA ySprite3

.mbar13

                        \ We now check the controller buttons to see if an icon
                        \ bar button has been chosen
                        \
                        \ The logic for the PAL version is rather more
                        \ convoluted than the NTSC version

 LDA controller1Left    \ If none of the directional buttons are being pressed,
 ORA controller1Right   \ jump to mbar14 to skip the following
 ORA controller1Up
 ORA controller1Down
 BPL mbar14

 LDA #0                 \ At least one of the directional buttons is being
 STA pointerPressedB    \ pressed, so set pointerPressedB = 0 so we don't look
                        \ for a double-tap of the B button

.mbar14

 LDA controller1Select  \ If the Select button has just been pressed but wasn't
 AND #%11110000         \ being pressed before, jump to mbar17 to choose the
 CMP #%10000000         \ button under the pointer
 BEQ mbar17

 LDA controller1B       \ If the B button has just been pressed but wasn't being
 AND #%11000000         \ pressed before, keep going, otherwise jump to mbar15
 CMP #%10000000         \ to skip the following
 BNE mbar15

 LDA #30                \ The B button has just been pressed but wasn't being
 STA pointerPressedB    \ pressed before, so set pointerPressedB to a non-zero
                        \ value so we start looking for a double-tap of the B
                        \ button
                        \
                        \ This value of A also ensures that we jump to mbar18
                        \ in the next comparison, as %01000000 does not match
                        \ 30, so this essentially sets pointerPressedB to a
                        \ non-zero value and then moves on to the next VBlank,
                        \ leaving the non-zero value to be picked up in a future
                        \ VBlank below

.mbar15

 CMP #%01000000         \ If the B button was being pressed but has just been
 BNE mbar18             \ released, keep going, otherwise jump to mbar18 to move
                        \ onto the next set of checks

IF _NTSC

 LDA pointerPressedB    \ If pointerPressedB = 0 then jump to mbar18 to move
 BEQ mbar18             \ onto the next set of checks

                        \ If we get here then pointerPressedB is non-zero, so we
                        \ know the B button was pressed and released in a
                        \ previous VBlank, and we know that in this VBlank, the
                        \ B button was being pressed but has just been released,
                        \ so that's a double-tap on the B button
                        \
                        \ This is one of the ways of choosing an icon bar icon,
                        \ so fall through into mbar17 to choose the button under
                        \ the pointer

ELIF _PAL

 LDA pointerPressedB    \ If pointerPressedB is non-zero then the B button was
 BNE mbar16             \ tapped and released in a previous VBlank, so jump to
                        \ mbar16 to potentially process a double-tap on the B
                        \ button

 STA pointerTimerB      \ Otherwise zero pointerTimerB, so pointerTimerB is zero
                        \ if we are not looking for a double-tap

 BEQ mbar18             \ Jump to mbar18 to move on to the next set of checks
                        \ (this BEQ is effectively a JMP as A is always zero)

.mbar16

                        \ If we get here then the B button was tapped and
                        \ released in a previous VBlank

 LDA #40                \ Set pointerTimer = 40 so it counts down over the next
 STA pointerTimer       \ 40 VBlanks, zeroing pointerTimerB if it runs out
                        \ before the second tap on the B button is detected

 LDA pointerTimerB      \ If pointerTimerB = 1 then we are already looking for
 BNE mbar17             \ the second tap of a double-tap on the B button, which
                        \ we just found, so jump to mbar17 to choose the button
                        \ under the pointer

 INC pointerTimerB      \ Otherwise increment pointerTimerB to 1 and skip the
 BNE mbar18             \ following instruction, so we will be on the lookout
                        \ for the second tap of the B button in future VBlanks

ENDIF

.mbar17

IF _PAL

 LSR pointerTimerB      \ Set pointerTimerB = 0 as we have now chosen an icon
                        \ bar button, so we don't need to check for a double-tap
                        \ on the B button any more

ENDIF

                        \ If we get here then we have chosen a button on the
                        \ icon bar, so we update iconBarChoice accordingly

 LDA xIconBarPointer    \ Set Y to the button number that the icon bar pointer
 LSR A                  \ is over
 LSR A
 TAY

 LDA (barButtons),Y     \ Set iconBarChoice to the Y-th entry from the button
 STA iconBarChoice      \ table for this icon bar to indicate that this icon bar
                        \ button has been selected

.mbar18

                        \ Finally, we check to see if the Start button has been
                        \ tapped, and if so, we record that as an iconBarChoice
                        \ of 80

 LDA controller1Start   \ If the Start button on controller 1 was being held
 AND #%11000000         \ down (bit 6 is set) but is no longer being held down
 CMP #%01000000         \ (bit 7 is clear) then keep going, otherwise jump to
 BNE mbar19             \ mbar19

 LDA #80                \ Set iconBarChoice to indicate that the Start button
 STA iconBarChoice      \ has been pressed

.mbar19

 RTS                    \ Return from the subroutine

