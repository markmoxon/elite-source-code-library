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
\ This routine is called by the parasite to receive a byte from the I/O
\ processor.
\
\ The code is identical to Acorn's MOS routine that runs on the parasite to
\ implement OSWRCH across the Tube (except this uses R2 instead of R1).
\
\ ******************************************************************************

.tube_read

 BIT tube_r2s           \ Check whether FIFO 2 has received a byte from the I/O
                        \ processor (which it will have sent by calling its own
                        \ tube_put routine)

 NOP                    \ Pause while the register is checked

 BPL tube_read          \ If FIFO 2 has received a byte then the N flag will be
                        \ set, so this loops back to tube_read until the N flag
                        \ is set, at which point FIFO 2 contains the byte
                        \ transmitted from the I/O processor

 LDA tube_r2d           \ Fetch the transmitted byte by reading Tube register R2
                        \ into A

 RTS                    \ Return from the subroutine

