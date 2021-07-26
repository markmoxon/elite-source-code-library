\ ******************************************************************************
\
\       Name: tube_write
\       Type: Subroutine
\   Category: Tube
\    Summary: As the parasite, send a byte across the Tube to the I/O processor
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
\ This routine is called by the parasite to send a byte to the I/O processor.
\
\ The code is identical to Acorn's MOS routine that runs on the parasite to
\ implement OSWRCH across the Tube.
\
\ ******************************************************************************

.tube_write

 BIT tube_r1s           \ Check whether FIFO 1 is available for use, so we can
                        \ use it to transmit a byte to the I/O processor

 NOP                    \ Pause while the register is checked

 BVC tube_write         \ If FIFO 1 is available for use then the V flag will be
                        \ set, so this loops back to tube_write until FIFO 1 is
                        \ available for us to use

 STA tube_r1d           \ FIFO 1 is available for use, so store the value we
                        \ want to transmit in Tube register R1, so it gets sent
                        \ to the I/O processor

 RTS                    \ Return from the subroutine

