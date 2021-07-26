\ ******************************************************************************
\
\       Name: write_0346
\       Type: Subroutine
\   Category: Tube
\    Summary: Implement the write_0346 command (update LASCT)
\
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a write_0346 command. It updates
\ the I/O processor's value of LASCT to the value sent by the parasite.
\
\ ******************************************************************************

.write_0346

 JSR tube_get           \ Get the parameter from the parasite for the command:
                        \
                        \   write_0346(value)
                        \
                        \ and store it as follows:
                        \
                        \   * A = the new value of LASCT

 STA LASCT              \ Update the value in LASCT to the value we just
                        \ received from the parasite

 RTS                    \ Return from the subroutine

