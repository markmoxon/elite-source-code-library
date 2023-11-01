\ ******************************************************************************
\
\       Name: NMI
\       Type: Subroutine
\   Category: Utility routines
\    Summary: The NMI interrupt handler that gets called every VBlank and which
\             updates the screen, reads the controllers and plays music
\  Deep dive: The split-screen mode in NES Elite
\             Drawing vector graphics using NES tiles
\
\ ******************************************************************************

.NMI

 JSR SendPaletteSprites \ Send the current palette and sprite data to the PPU

 LDA showUserInterface  \ Set the value of setupPPUForIconBar so that if there
 STA setupPPUForIconBar \ is an on-screen user interface (which there will be if
                        \ this isn't the game over screen), then the calls to
                        \ the SETUP_PPU_FOR_ICON_BAR macro sprinkled throughout
                        \ the codebase will make sure we set nametable 0 and
                        \ palette table 0 when the PPU starts drawing the icon
                        \ bar

IF _NTSC

 LDA #HI(6797)          \ Set cycleCount = 6797
 STA cycleCount+1       \
 LDA #LO(6797)          \ We use this to keep track of how many cycles we have
 STA cycleCount         \ left in the current VBlank, so we only send data to
                        \ the PPU when VBlank is in progress, splitting up the
                        \ larger PPU operations across multiple VBlanks

ELIF _PAL

 LDA #HI(7433)          \ Set cycleCount = 7433
 STA cycleCount+1       \
 LDA #LO(7433)          \ We use this to keep track of how many cycles we have
 STA cycleCount         \ left in the current VBlank, so we only send data to
                        \ the PPU when VBlank is in progress, splitting up the
                        \ larger PPU operations across multiple VBlanks

ENDIF

 JSR SendScreenToPPU    \ Update the screen by sending the nametable and pattern
                        \ data from the buffers to the PPU, configuring the PPU
                        \ registers accordingly, and clearing the buffers if
                        \ required

 JSR ReadControllers    \ Read the buttons on the controllers and update the
                        \ control variables

 LDA autoPlayDemo       \ If bit 7 of autoPlayDemo is clear then the demo is not
 BPL inmi1              \ being played automatically, so jump to inmi1 to skip
                        \ the following

 JSR AutoPlayDemo       \ Bit 7 of autoPlayDemo is set, so call AutoPlayDemo to
                        \ automatically play the demo using the controller key
                        \ presses in the autoplayKeys tables

.inmi1

 JSR MoveIconBarPointer \ Move the sprites that make up the icon bar pointer and
                        \ record any choices

 JSR UpdateJoystick     \ Update the values of JSTX and JSTY with the values
                        \ from the controller

 JSR UpdateNMITimer     \ Update the NMI timer, which we can use in place of
                        \ hardware timers (which the NES does not support)

 LDA runningSetBank     \ If the NMI handler was called from within the SetBank
 BNE inmi2              \ routine, then runningSetBank will be &FF, so jump to
                        \ inmi2 to skip the call to MakeSounds

 JSR MakeSounds_b6      \ Call the MakeSounds routine to make the current sounds
                        \ (music and sound effects)

 LDA nmiStoreA          \ Restore the values of A, X and Y that we stored at
 LDX nmiStoreX          \ the start of the NMI handler
 LDY nmiStoreY

 RTI                    \ Return from the interrupt handler

.inmi2

 INC runningSetBank     \ Increment runningSetBank

 LDA nmiStoreA          \ Restore the values of A, X and Y that we stored at
 LDX nmiStoreX          \ the start of the NMI handler
 LDY nmiStoreY

 RTI                    \ Return from the interrupt handler

