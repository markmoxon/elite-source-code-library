\ ******************************************************************************
\
\       Name: tha
\       Type: Subroutine
\   Category: Main loop
\    Summary: Consider spawning a Thargoid (22% chance)
\
\ ******************************************************************************

.tha

 JSR DORND              \ Set A and X to random numbers

 CMP #200               \ If A < 200 (78% chance), skip the next instruction
 BCC P%+5

 JSR GTHG               \ Call GTHG to spawn a Thargoid ship

 JMP MLOOP              \ Jump back into the main loop at MLOOP, which is just
                        \ after the ship-spawning section

