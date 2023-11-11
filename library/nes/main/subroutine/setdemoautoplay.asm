\ ******************************************************************************
\
\       Name: SetDemoAutoPlay
\       Type: Subroutine
\   Category: Combat demo
\    Summary: Set up the NMI handler to automatically play the demo using the
\             controller key presses in the autoPlayKeys table
\
\ ******************************************************************************

.SetDemoAutoPlay

 LDA #5                 \ Set the icon par pointer to button 5 (which is the
 JSR SetIconBarPointer  \ sixth button of 12, just before the halfway point)

 JSR SetupDemoUniverse  \ Configure the universe for the demo, which includes
                        \ setting the random number seeds to a known value so
                        \ the demo always runs in the same way

 LDX languageIndex      \ Set autoPlayKeys(1 0) to the chosen language's entry
 LDA autoPlayKeys1Lo,X  \ from the (autoPlayKeys1Hi autoPlayKeys1Lo) tables
 STA autoPlayKeys
 LDA autoPlayKeys1Hi,X
 STA autoPlayKeys+1

 LDA #0                 \ Set autoPlayKey = 0 to reset the current key being
 STA autoPlayKey        \ "pressed" in the auto-play

 STA autoPlayRepeat     \ Set autoPlayRepeat = 0 to reset the number of repeats
                        \ in the auto-play (as otherwise the first button press
                        \ would start repeating)

 LDX #%10000000         \ Set bit 7 of autoPlayDemo so the NMI handler will play
 STX autoPlayDemo       \ the demo automatically using the controller key
                        \ presses in the autoPlayKeys tables

 RTS                    \ Return from the subroutine

