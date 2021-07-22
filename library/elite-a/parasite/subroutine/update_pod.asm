\ ******************************************************************************
\
\       Name: update_pod
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Ensure the correct palette is shown for the dashboard/hyperspace 
\             tunnel, by sending a write_pod command to the I/O processor
\
\ ******************************************************************************

.update_pod

 LDA #&8F               \ Send command &8F to the I/O processor:
 JSR tube_write         \
                        \   write_pod(escp, hfx)
                        \
                        \ which will update the values of ESCP and HFX in the
                        \ I/O processor, so the palette gets set correctly for
                        \ the dashboard (ESCP) and hyperspace tunnel (HFX)

 LDA ESCP               \ Send the first parameter to the I/O processor:
 JSR tube_write         \
                        \   * escp = ESCP

 LDA HFX                \ Send the second parameter to the I/O processor:
 JMP tube_write         \
                        \   * hfx = HFX
                        \
                        \ and return from the subroutine using a tail call

