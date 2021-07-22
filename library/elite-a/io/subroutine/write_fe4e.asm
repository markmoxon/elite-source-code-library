\ ******************************************************************************
\
\       Name: write_fe4e
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Receive a new value from the parasite for the System VIA interrupt
\             enable register
\
\ ******************************************************************************

.write_fe4e

 JSR tube_get           \ Get the new value for the interrupt register from the
                        \ parasite

 STA VIA+&4E            \ Set 6522 System VIA interrupt enable register IER
                        \ (SHEILA &4E) to the new value

 JMP tube_put           \ Send A back to the parasite (so it can wait until we
                        \ have set the register) and return from the subroutine
                        \ using a tail call

