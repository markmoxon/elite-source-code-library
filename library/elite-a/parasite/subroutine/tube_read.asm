\ ******************************************************************************
\
\       Name: tube_read
\       Type: Subroutine
\   Category: Tube
\    Summary: As the parasite, fetch a byte that's been sent over the Tube from
\             the I/O processor
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
\ This routine is called by the parasite to receive a byte from the I/O
\ processor.
\
\ The code is identical to Acorn's MOS routine that runs on the parasite to
\ implement OSWRCH across the Tube (except this uses FIFO 2 instead of FIFO 1).
\
\ ******************************************************************************

.tube_read

 BIT tube_r2s           \ Check whether FIFO 2 has received a byte from the I/O
                        \ processor (which it will have sent by calling its own
                        \ tube_put routine). We do this by checking bit 7 of the
                        \ FIFO 2 status register

 NOP                    \ Pause while the register is checked

 BPL tube_read          \ If FIFO 2 has received a byte then bit 7 of the status
                        \ register will be set, so this loops back to tube_read
                        \ until FIFO 2 contains the byte transmitted from the
                        \ I/O processor

 LDA tube_r2d           \ Fetch the transmitted byte by reading the FIFO 2 data
                        \ register into A

 RTS                    \ Return from the subroutine

