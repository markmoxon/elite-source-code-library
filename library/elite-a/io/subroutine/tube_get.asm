\ ******************************************************************************
\
\       Name: tube_get
\       Type: Subroutine
\   Category: Tube
\    Summary: As the I/O processor, fetch a byte that's been sent over the Tube
\             from the parasite
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
                        \ tube_write routine)

 NOP                    \ Pause while the register is checked

 BPL tube_get           \ If FIFO 1 has received a byte then the N flag will be
                        \ set, so this loops back to tube_get until the N flag
                        \ is set, at which point FIFO 1 contains the byte
                        \ transmitted from the parasite

 LDA tube_r1d           \ Fetch the transmitted byte by reading Tube register R1
                        \ into A

 RTS                    \ Return from the subroutine

