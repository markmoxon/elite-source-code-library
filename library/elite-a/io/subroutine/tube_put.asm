\ ******************************************************************************
\
\       Name: tube_put
\       Type: Subroutine
\   Category: Tube
\    Summary: As the I/O processor, send a byte across the Tube to the parasite
\
\ ------------------------------------------------------------------------------
\
\ Tube communication in Elite-A uses the following protocol:
\
\ Parasite -> I/O processor
\
\   * Uses Tube register R1 to transmit the data across FIFO 1
\   * The parasite calls tube_write to send a byte to the I/O processor
\   * The I/O processor calls tube_get to receive that byte from the parasite
\
\ I/O processor -> Parasite
\
\   * Uses Tube register R2 to transmit the data across FIFO 2
\   * The I/O processor calls tube_put to send a byte to the parasite
\   * The parasite calls tube_read to receive that byte from the I/O processor
\
\ This routine is called by the I/O processor to send a byte to the parasite.
\
\ The code is identical to Acorn's MOS routine that runs on the parasite to
\ implement OSWRCH across the Tube (except this uses R2 instead of R1).
\
\ ******************************************************************************

.tube_put

 BIT tube_r2s           \ Check whether FIFO 2 is available for use, so we can
                        \ use it to transmit a byte to the parasite

 NOP                    \ Pause while the register is checked

 BVC tube_put           \ If FIFO 2 is available for use then the V flag will be
                        \ set, so this loops back to tube_put until FIFO 2 is
                        \ available for us to use

 STA tube_r2d           \ FIFO 2 is available for use, so store the value we
                        \ want to transmit in Tube register R2, so it gets sent
                        \ to the parasite

 RTS                    \ Return from the subroutine

