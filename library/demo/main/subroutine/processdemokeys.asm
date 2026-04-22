\ ******************************************************************************
\
\       Name: ProcessDemoKeys
\       Type: Subroutine
\   Category: Demo
\    Summary: Process the key presses that are supported in the demo (COPY to
\             pause, DELETE to unpause, ESCAPE to quit, "Q" and "S" for sound)
\
\ ******************************************************************************

.ProcessDemoKeys

 LDX #&10               \ Call DKS4 to see if the "Q" key is being pressed on
 JSR DKS4               \ the keyboard

 BPL keys1              \ If the key isn't being pressed, skip the following two
                        \ instructions

 LDA #&FF               \ "Q" is being pressed, so set DNOIZ to &FF to turn the
 STA DNOIZ              \ sound off

.keys1

 LDX #&51               \ Call DKS4 to see if the "S" key is being pressed on
 JSR DKS4               \ the keyboard

 BPL keys2              \ If the key isn't being pressed, skip the following two
                        \ instructions

 LDA #0                 \ "S" is being pressed, so set DNOIZ to 0 to turn the
 STA DNOIZ              \ sound on

.keys2

 LDX #&70               \ Call DKS4 to see if the ESCAPE key is being pressed on
 JSR DKS4               \ the keyboard

 BPL keys3              \ If the key isn't being pressed, skip the following
                        \ instruction

 JMP DEATH2             \ ESCAPE is being pressed, so jump to DEATH2 to restart
                        \ the game

.keys3

 LDX #&69               \ Call DKS4 to see if the COPY key is being pressed on
 JSR DKS4               \ the keyboard

 BPL keys5              \ If the key isn't being pressed, jump to keys5 to
                        \ return from the subroutine

                        \ If we get here then COPY is being pressed, so we now
                        \ pause the game by looping around until DELETE is
                        \ pressed to unpause the game

.keys4

 LDX #&59               \ Call DKS4 to see if the DELETE key is being pressed on
 JSR DKS4               \ the keyboard

 BPL keys4              \ If the key isn't being pressed, jump to keys4 until
                        \ DELETE is pressed

.keys5

 RTS                    \ Return from the subroutine

