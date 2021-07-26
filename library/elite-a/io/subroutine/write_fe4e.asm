\ ******************************************************************************
\
\       Name: write_fe4e
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Implement the write_fe4e command (update the System VIA interrupt
\             enable register)
\
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a write_fe4e command. It updates
\ the System VIA interrupt enable register in the I/O processor to the value
\ sent by the parasite, and returns that value back to the parasite once the
\ register has been set, so the parasite can know when the register has been
\ updated.
\
\ ******************************************************************************

.write_fe4e

 JSR tube_get           \ Get the parameter from the parasite for the command:
                        \
                        \   =write_fe4e(value)
                        \
                        \ and store it as follows:
                        \
                        \   * A = new value for the interrupt register

 STA VIA+&4E            \ Set 6522 System VIA interrupt enable register IER
                        \ (SHEILA &4E) to the new value

 JMP tube_put           \ Send A back to the parasite and return from the
                        \ subroutine using a tail call

