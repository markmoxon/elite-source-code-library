\ ******************************************************************************
\
\       Name: tube_write
\       Type: Subroutine
\   Category: Tube
\    Summary: As the parasite, send a byte across the Tube to the I/O processor
\  Deep dive: Tube communication in Elite-A
\
\ ------------------------------------------------------------------------------
\
\ Tube communication in Elite-A uses the following protocol:
\
\ Parasite -> I/O processor
\
\   * Uses the FIFO 1 status and data registers to transmit the data
\   * The parasite calls tube_write to send a byte to the I/O processor
\   * The I/O processor calls tube_get to receive that byte from the parasite
\
\ I/O processor -> Parasite
\
\   * Uses the FIFO 2 status and data registers to transmit the data
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
                        \ use it to transmit a byte to the I/O processor. We do
                        \ this by checking bit 6 of the FIFO 1 status register

 NOP                    \ Pause while the register is checked

 BVC tube_write         \ If FIFO 1 is available for use then bit 6 of the
                        \ status register will be set, so this loops back to
                        \ tube_write until FIFO 1 is available for us to use

 STA tube_r1d           \ FIFO 1 is available for use, so store the value we
                        \ want to transmit in the FIFO 1 data register, so it
                        \ gets sent to the I/O processor

 RTS                    \ Return from the subroutine

