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

 INX                    \ ???
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

 LDA #5                 \ ???
 JSR subm_E909

 JSR U%                 \ Call U% to clear the key logger

 JSR subm_F3BC          \ ???
 LDA controller1Select
 AND controller1Start
 AND controller1A
 AND controller1B
 BNE CB341
 LDA controller1Select
 ORA controller2Select
 BNE CB355
 LDA #0
 PHA
 JSR BR1
 LDA #&FF
 STA QQ11
 LDA autoPlayDemo
 BEQ CB32C
 JSR subm_F362

.CB32C

 JSR WSCAN
 LDA #4
 JSR subm_8021_b6
 LDA L0305
 CLC
 ADC #6
 STA L0305
 PLA
 JMP subm_A5AB_b6

.CB341

 JSR BR1
 LDA #&FF
 STA QQ11
 JSR WSCAN
 LDA #4
 JSR subm_8021_b6
 LDA #2
 JMP subm_A5AB_b6

.CB355

 JSR subm_B63D_b3

ENDIF

