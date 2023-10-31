\ ******************************************************************************
\
\       Name: DrawScrollText
\       Type: Subroutine
\   Category: Combat demo
\    Summary: Display a Star Wars scroll text
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The number of lines in the middle part of the scroll
\                       text, which is the total number of text lines minus 4:
\
\                         * 2 for scrollText1 (6 lines)
\
\                         * 6 for scrollText2 and creditsText1 (10 lines)
\
\                         * 5 for creditsText2 (9 lines)
\
\                         * 3 for creditsText3 (7 lines)
\
\ ******************************************************************************

.DrawScrollText

 PHA                    \ Store the number of lines in the scroll text on the
                        \ stack so we can retrieve it later

 JSR CalculateGridLines \ Reset the line coordinate tables and populate them
                        \ with the characters for the scroll text at (Y X),
                        \ setting INF(1 0) to the scroll text in the process

 LDA #&28               \ Set the visible colour to orange (&28) so the scroll
 STA visibleColour      \ text appears in this colour

 LDA #0                 \ Clear bits 6 and 7 of allowInSystemJump to allow
 STA allowInSystemJump  \ in-system jumps, so the call to UpdateIconBar displays
                        \ the fast-forward icon (though choosing this in the
                        \ demo doesn't do an in-system jump, but skips the rest
                        \ of the demo instead)

 LDA #2                 \ Set the scroll text speed to 2 (normal speed)
 STA scrollTextSpeed

 JSR UpdateIconBar_b3   \ Update the icon bar to show the correct buttons for
                        \ the scroll text

 LDA #40                \ Tell the NMI handler to send nametable entries from
 STA firstNameTile      \ tile 40 * 8 = 320 onwards (i.e. from the start of tile
                        \ row 10)

                        \ We now draw the scroll text and move it up the screen,
                        \ which we do in three stages
                        \
                        \   * Stage 1 moves the first few lines of the scroll
                        \     text up the screen until the first line reaches
                        \     the middle of the screen (i.e. just before it will
                        \     start to disappear into the distance); stage 1 is
                        \     always 81 frames long at normal speed
                        \
                        \  *  Stage 2 then draws the rest of the scroll text
                        \     on-screen while moving everything up the screen,
                        \     reusing lines in the line coordinate tables as
                        \     they disappear into the distance; stage 2 is
                        \     longer with longer scroll texts
                        \
                        \   * Stage 3 takes over when everything has been drawn,
                        \     and just concentrates on moving the scroll text
                        \     into the distance without drawing anything new;
                        \     stage 3 is always 48 frames long at normal speed
                        \
                        \ We start with stage 1

 LDA #160               \ Set the size of the scroll text to 160 to pass to
 STA scrollProgress     \ DrawScrollFrames
                        \
                        \ This equates to 81 frames at normal speed, with each
                        \ frame taking scrollTextSpeed off the value of
                        \ scrollProgress (i.e. subtracting 2), and only
                        \ stopping when the subtraction goes past zero

 JSR DrawScrollFrames   \ Draw the frames for stage 1, so the scroll text gets
                        \ drawn and moves up the screen

                        \ We now move on to stage 2
                        \
                        \ Stage 2 takes longer for longer scroll texts, and its
                        \ length is based on the value of A passed to the
                        \ routine (which contains the total number of text lines
                        \ minus 4)
                        \
                        \ Specifically, stage 2 loop around A times, with each
                        \ loop taking a scrollProgress of 23 (which is 12 frames
                        \ at normal speed)
                        \
                        \ Each loop draws an extra line of text in the scroll
                        \ text, and scrolls up by one line of text

 PLA                    \ Set LASCT to the value that we stored on the stack, so
 STA LASCT              \ LASCT contains the number of lines in the scroll text

.dscr1

 LDA #23                \ Set the size of the scroll text to 23 to pass to
 STA scrollProgress     \ DrawScrollFrames

 JSR ScrollTextUpScreen \ Scroll the scroll text up the screen by one full line
                        \ of text

 JSR GRIDSET            \ Call GRIDSET to populate the line coordinate tables at
                        \ X1TB, Y1TB and X2TB (the TB tables) with the lines for
                        \ the scroll text in INF(1 0) at offset XC

 JSR DrawScrollFrames   \ Draw the frames for stage 2, so the scroll text gets
                        \ drawn and moves up the screen by one text line

 DEC LASCT              \ Loop back until we have done LASCT loops around the
 BNE dscr1              \ above

                        \ We now move on to stage 3
                        \
                        \ Stage 3 loops around four times, with each loop taking
                        \ a scrollProgress of 23 (which is 12 frames at normal
                        \ speed), so that's a grand total of 48 frames at normal
                        \ speed

 LDA #4                 \ Set LASCT = 4 so we do the following loop four times
 STA LASCT

.dscr2

 LDA #23                \ Set the size of the scroll text to 23 to pass to
 STA scrollProgress     \ DrawScrollFrames

 JSR ScrollTextUpScreen \ Scroll the scroll text up the screen by one full line
                        \ of text

 JSR DrawScrollFrames   \ Draw the frames for stage 3, so the scroll text moves
                        \ off-screen one text line at a time

 DEC LASCT              \ Loop back until we have done LASCT loops around the
 BNE dscr2              \ above

                        \ The scroll text is now done and is no longer on-screen

 LDA #0                 \ Reset the scroll speed to zero (though this isn't read
 STA scrollTextSpeed    \ again, so this has no effect)

 LDA #&2C               \ Set the visible colour back to cyan (&2C)
 STA visibleColour

 RTS                    \ Return from the subroutine

