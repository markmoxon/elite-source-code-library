\ ******************************************************************************
\
\       Name: TT66
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Clear the screen and set the new view type
\  Deep dive: Views and view types in NES Elite
\
\ ------------------------------------------------------------------------------
\
\ This routine does a similar job to the routine of the same name in the BBC
\ Master version of Elite, but the code is significantly different.
\
\ Arguments:
\
\   A                   The type of the new view (see QQ11 for a list of view
\                       types)
\
\ ******************************************************************************

.TT66

 STA QQ11               \ Set the new view type in QQ11 to A

 LDA QQ11a              \ If bit 7 is set in either QQ11 or QQ11a, then either
 ORA QQ11               \ there is no dashboard in either view, or it is being
 BMI scrn1              \ added or removed, so jump to scrn1 to skip clearing
                        \ the existing scanner, as we don't need to worry about
                        \ preserving it

 LDA QQ11               \ If bit 7 of QQ11 is clear, then bit 7 must be clear in
 BPL scrn1              \ both QQ11 and QQ11a as we didn't take the branch
                        \ above, so we are switching between views that both
                        \ have dashboards, so jump to scrn1 to skip clearing the
                        \ scanner as we want to retain it

                        \ Strangely, we can never get here, as we take the first
                        \ branch above when bit 7 of QQ11 is set, and we take
                        \ the second branch when bit 7 of QQ11 is clear

 JSR ClearScanner       \ Remove all ships from the scanner and hide the scanner
                        \ sprites

.scrn1

 JSR WaitForPPUToFinish \ Wait until both bitplanes of the screen have been
                        \ sent to the PPU, so the screen is fully updated and
                        \ there is no more data waiting to be sent to the PPU

 JSR ClearScreen_b3     \ Clear the screen by zeroing patterns 66 to 255 in
                        \ both pattern buffer, and clearing both nametable
                        \ buffers to the background tile

 LDA #16                \ Set the text row for in-flight messages in the space
 STA messYC             \ view to row 16

 LDX #0                 \ Set sendDashboardToPPU = 0 to reset the logic behind
 STX sendDashboardToPPU \ the sending of drawing bitplane 0 to the PPU in part 3
                        \ of the main loop

 JSR SetDrawingBitplane \ Set the drawing bitplane to bitplane 0

 LDA #%10000000         \ Set bit 7 of QQ17 to switch to Sentence Case
 STA QQ17

 STA DTW2               \ Set bit 7 of DTW2 to indicate we are not currently
                        \ printing a word

 STA DTW1               \ Set bit 7 of DTW1 to indicate that we do not change
                        \ case to lower case

 LDA #%00000000         \ Set DTW6 = %00000000 to disable lower case
 STA DTW6

 STA LAS2               \ Set LAS2 = 0 to stop any laser pulsing

 STA DLY                \ Set the delay in DLY to 0, to indicate that we are
                        \ no longer showing an in-flight message, so any new
                        \ in-flight messages will be shown instantly

 STA de                 \ Clear de, the flag that appends " DESTROYED" to the
                        \ end of the next text token, so that it doesn't

 LDA #1                 \ Move the text cursor to column 1 on row 1
 STA XC
 STA YC

 JSR SetLinePatterns_b3 \ Load the line patterns for the new view into the
                        \ pattern buffers

                        \ We now set X to the type of icon bar to show in the
                        \ new view

 LDA QQ11               \ If bit 6 of the new view in QQ11 is set then it
 LDX #&FF               \ doesn't have an icon bar, so jump to scrn2 with
 AND #%01000000         \ X = &FF to hide the icon bar on row 27
 BNE scrn2

 LDX #4                 \ If the new view in QQ11 is 1, then we are on the title
 LDA QQ11               \ screen, so jump to scrn2 with X = 4 so we show the
 CMP #1                 \ copyright message in the icon bar
 BEQ scrn2

 LDX #2                 \ If the new view in QQ11 is %0000110x (i.e. 12 or 13,
 LDA QQ11               \ which are the Short-range Chart and Long-range Chart),
 AND #%00001110         \ jump to scrn2 with X = 2 to show the icon bar for the
 CMP #%00001100         \ charts
 BEQ scrn2

 LDX #1                 \ If we are not docked (QQ12 = 0), jump to scrn2 with
 LDA QQ12               \ X = 1 to show the Flight icon bar
 BEQ scrn2

 LDX #0                 \ Otherwise fall through into scrn2 with X = 0 to show
                        \ the Docked icon bar

.scrn2

 LDA QQ11               \ If bit 7 of the new view in QQ11 is set then there is
 BMI scrn5              \ no dashboard, so jump to scrn5 to show the icon bar
                        \ type with type X on row 27

                        \ If we get here then the new view has the dashboard, so
                        \ we initialise it if required

 TXA                    \ Show the icon bar with type X
 JSR SetupIconBar_b3

 LDA QQ11a              \ If bit 7 of the old view in QQ11a is clear, then the
 BPL scrn3              \ old view has a dashboard, so jump to scrn3 to skip the
                        \ following two instructions, as we don't need to
                        \ initialise the dashboard

 JSR SetScreenForUpdate \ Get the screen ready for updating by hiding all
                        \ sprites, after fading the screen to black if we are
                        \ changing view

 JSR ResetScanner_b3    \ Reset the sprites used for drawing ships on the
                        \ scanner

.scrn3

 JSR DrawDashNames_b3   \ Draw the dashboard into the nametable buffers for
                        \ both bitplanes

 JSR msblob             \ Display the dashboard's missile indicators in black

 JMP scrn8              \ Jump to scrn8 to continue setting up the view

.scrn4

 JMP SetViewAttrs_b3    \ Set up attribute buffer 0 for the chosen view,
                        \ returning from the subroutine using a tail call

.scrn5

                        \ If we get here then there is no dashboard in the new
                        \ view

 TXA                    \ Show the icon bar with type X
 JSR SetupIconBar_b3

                        \ The next two comparisons aren't necessary as both &C4
                        \ and &8D have bit 4 clear, so they would be caught by
                        \ the AND #%00010000 below anyway, but there's no harm
                        \ in being explicit, I guess

 LDA QQ11               \ If the view type in QQ11 is &C4 (Game Over screen),
 CMP #&C4               \ jump to scrn4 to set up attribute buffer 0 and
 BEQ scrn4              \ return from the subroutine

 LDA QQ11               \ If the view type in QQ11 is &8D (Long-range Chart),
 CMP #&8D               \ jump to scrn6 to skip loading the font into pattern
 BEQ scrn6              \ buffer 0

 CMP #&CF               \ If the view type in QQ11 is &CF (Start screen with
 BEQ scrn6              \ no fonts loaded), jump to scrn6 to skip loading
                        \ the font into pattern buffer 0

 AND #%00010000         \ If bit 4 of the new view in QQ11 is clear, jump to
 BEQ scrn6              \ scrn6 to skip loading the font into pattern buffer 0

                        \ If we get here then the new view we are setting up is
                        \ not the Game Over screen, the Long-range Chart or the
                        \ Start screen, and bit 4 of QQ11 is set

 LDA #66                \ Load the font into pattern buffer 0, and a set of
 JSR LoadNormalFont_b3  \ filled blocks into pattern buffer 1, from pattern 66
                        \ to 160
                        \
                        \ If the view type in QQ11 is &BB (Save and load with
                        \ the normal and highlight fonts loaded), then this also
                        \ loads an inverted font into pattern buffer 1, from
                        \ pattern 66 to 160

.scrn6

 LDA QQ11               \ If bit 5 of the new view in QQ11 is clear, jump to
 AND #%00100000         \ scrn7 to skip loading the normal font
 BEQ scrn7

 JSR LoadHighFont_b3    \ Load the font into pattern buffer 1, and a set of
                        \ filled blocks into pattern buffer 0, from pattern 161
                        \ to 255

.scrn7

                        \ The new view doesn't have a dashboard, so now we draw
                        \ the left and right edges of the box on the rows where
                        \ the dashboard would be, overwriting the edges of the
                        \ dashboard from the old view (if it had one)

 LDA #1                 \ Draw the left edge of the box on rows 20 to 26
 STA nameBuffer0+20*32+1
 STA nameBuffer0+21*32+1
 STA nameBuffer0+22*32+1
 STA nameBuffer0+23*32+1
 STA nameBuffer0+24*32+1
 STA nameBuffer0+25*32+1
 STA nameBuffer0+26*32+1

 LDA #2                 \ Draw the right edge of the box on rows 20 to 26
 STA nameBuffer0+20*32
 STA nameBuffer0+21*32
 STA nameBuffer0+22*32
 STA nameBuffer0+23*32
 STA nameBuffer0+24*32
 STA nameBuffer0+25*32
 STA nameBuffer0+26*32

 LDA QQ11               \ If bit 6 of the new view in QQ11 is set, then there is
 AND #%01000000         \ no icon bar, so jump to scrn8... which has no effect,
 BNE scrn8              \ as that's the next instruction anyway, so presumably
                        \ this was left behind after deleting the code that
                        \ would be skipped

.scrn8

 JSR SetViewAttrs_b3    \ Set up attribute buffer 0 for the chosen view

                        \ The six instructions between here and scrn9 have no
                        \ effect, as we always end up at scrn9 and don't take
                        \ any notice of the flags

 LDA demoInProgress     \ If bit 7 of demoInProgress is set then we are
 BMI scrn9              \ initialising the demo, so jump to scrn9

 LDA QQ11               \ If bit 7 of the new view in QQ11 is clear, jump to
 BPL scrn9              \ scrn9

 CMP QQ11a              \ If the view we are switching from in QQ11a is 0 (the
 BEQ scrn9              \ space view), jump to scrn9... which has no effect,
                        \ as that's the next instruction anyway, so presumably
                        \ this was left behind after deleting the code that
                        \ would be skipped

.scrn9

 JSR DrawBoxTop         \ Draw the top edge of the box along the top of the
                        \ screen in nametable buffer 0

 LDX languageIndex      \ Set X to the index of the chosen language

 LDA QQ11               \ If this is the space view (QQ11 = 0), jump to scrn10
 BEQ scrn10             \ to print the view name at the top of the screen

 CMP #1                 \ If this is not the title screen (QQ11 = 1), jump to
 BNE scrn12             \ scrn12 to skip printing a title at the top of the
                        \ screen

                        \ If we get here then the new view is the title screen

 LDA #0                 \ Move the text cursor to row 0
 STA YC

 LDX languageIndex      \ Move the text cursor to the correct column for the
 LDA xTitleScreen,X     \ title screen in the chosen language
 STA XC

 LDA #30                \ Set A = 30 so we print recursive token 144 when we
                        \ jump to scrn11 ("--- E L I T E ---")

 BNE scrn11             \ Jump to scrn11 to print ("--- E L I T E ---") at the
                        \ top of the screen (this BNE is effectively a JMP as
                        \ A is never zero)

.scrn10

                        \ If we get here then the new view is the space view
                        \ and we jumped here with A = 0

 STA YC                 \ Move the text cursor to row 0

 LDA xSpaceView,X       \ Move the text cursor to the correct column for the
 STA XC                 \ space view name in the chosen language

 LDA languageNumber     \ If bit 1 of languageNumber is set, then the chosen
 AND #%00000010         \ language is German, so jump to scrn13 to print the
 BNE scrn13             \ view name after the view noun (so we print "ANSICHT
                        \ VORN" and "ANSICHT HINTEN" instead of "FRONT VIEW"
                        \ and "REAR VIEW", for example)

 JSR PrintSpaceViewName \ Print the name of the current space view (i.e.
                        \ "FRONT", "REAR", "LEFT" or "RIGHT")

 JSR TT162              \ Print a space

 LDA #175               \ Set A = 175 so the next instruction prints recursive
                        \ token 15 ("VIEW ")

.scrn11

 JSR TT27_b2            \ Print the text token in A

.scrn12

 LDX #1                 \ Move the text cursor to column 1 on row 1
 STX XC
 STX YC

 DEX                    \ Set QQ17 = 0 to switch to ALL CAPS
 STX QQ17

 RTS                    \ Return from the subroutine

.scrn13

                        \ If we get here then we want to print the view name
                        \ after the view noun

 LDA #175               \ Print recursive token 15 ("VIEW ") followed by a space
 JSR spc

 JSR PrintSpaceViewName \ Print the name of the current space view (i.e.
                        \ "FRONT", "REAR", "LEFT" or "RIGHT")

 JMP scrn12             \ Jump back to scrn12 to finish off

