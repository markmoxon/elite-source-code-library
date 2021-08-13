\ ******************************************************************************
\
\       Name: tube_get
\       Type: Subroutine
\   Category: Tube
\    Summary: As the I/O processor, fetch a byte that's been sent over the Tube
\             from the parasite
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
\ This routine is called by the I/O processor to receive a byte from the
\ parasite.
\
\ The code is identical to Acorn's MOS routine that runs on the parasite to
\ implement OSWRCH across the Tube.
\
\ ******************************************************************************

.tube_get

 BIT tube_r1s           \ Check whether FIFO 1 has received a byte from the
                        \ parasite (which it will have sent by calling its own
                        \ tube_write routine). We do this by checking bit 7 of
                        \ the FIFO 1 status register

 NOP                    \ Pause while the register is checked

 BPL tube_get           \ If FIFO 1 has received a byte then bit 7 of the status
                        \ register will be set, so this loops back to tube_get
                        \ until FIFO 1 contains the byte transmitted from the
                        \ parasite

 LDA tube_r1d           \ Fetch the transmitted byte by reading the FIFO 1 data
                        \ register into A

 RTS                    \ Return from the subroutine

