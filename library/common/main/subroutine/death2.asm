\ ******************************************************************************
\
\       Name: DEATH2
\       Type: Subroutine
\   Category: Start and end
\    Summary: Reset most of the game and restart from the title screen
\
\ ------------------------------------------------------------------------------
\
\ This routine is called following death, and when the game is quit by pressing
\ ESCAPE when paused.
\
\ ******************************************************************************

.DEATH2

IF _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Platform

 LDX #&FF               \ Set the stack pointer to &01FF, which is the standard
 TXS                    \ location for the 6502 stack, so this instruction
                        \ effectively resets the stack

ENDIF

IF _NES_VERSION

 INX                    \ Set L0470 = 0 ???
 STX L0470

ENDIF

 JSR RES2               \ Reset a number of flight variables and workspaces
                        \ and fall through into the entry code for the game
                        \ to restart from the title screen

IF _DISC_FLIGHT \ Platform

 JSR CATD               \ Call CATD to reload the disc catalogue

 BNE INBAY              \ Jump to INBAY to load the docked code (this BNE is
                        \ effectively a JMP)

ELIF _ELITE_A_FLIGHT

 BMI INBAY              \ Jump to INBAY to load the docked code (this BMI is
                        \ effectively a JMP)

ELIF _ELITE_A_6502SP_PARA

 JMP INBAY              \ Jump to INBAY to restart the game following death

ELIF _NES_VERSION

 LDA #5                 \ Set the icon par pointer to button 5 (which is the
 JSR SetIconBarPointer  \ sixth button of 12, just before the halfway point)

 JSR U%                 \ Call U% to clear the key logger

 JSR DrawTitleScreen    \ Draw the title screen with the rotating ships,
                        \ returning when a key is pressed

 LDA controller1Select  \ If Select, Start, A and B are all pressed at the same
 AND controller1Start   \ time on controller 1, jump to dead2 to show the
 AND controller1A       \ credits scrolltext
 AND controller1B
 BNE dead2

 LDA controller1Select  \ If Select is pressed on either controller, jump to
 ORA controller2Select  \ dead3 to start the game straight away, skipping the
 BNE dead3              \ demo

                        \ If we get here then we start the game

 LDA #0                 \ Store 0 on the stack ???
 PHA

 JSR BR1                \ Reset a number of variables, ready to start a new game

 LDA #&FF               \ ???
 STA QQ11

 LDA autoPlayDemo
 BEQ dead1

 JSR SetupDemoUniverse

.dead1

 JSR WaitForNMI

 LDA #4
 JSR ChooseMusic_b6

 LDA L0305
 CLC
 ADC #6
 STA L0305

 PLA

 JMP subm_A5AB_b6

.dead2

                        \ If we get here then we show the credits scrolltext

 JSR BR1                \ Reset a number of variables, ready to start a new game

 LDA #&FF
 STA QQ11
 JSR WaitForNMI

 LDA #4
 JSR ChooseMusic_b6

 LDA #2
 JMP subm_A5AB_b6

.dead3

                        \ If we get here then we start the game without playing
                        \ the demo

 JSR subm_B63D_b3       \ ??? Something to do with palettes

                        \ Fall through into subm_B358 to reset the stack and go
                        \ to the docking bay (i.e. show the Status Mode screen)

ENDIF

