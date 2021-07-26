\ ******************************************************************************
\
\       Name: write_pod
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Implement the write_pod command (show the correct palette for the
\             dashboard and hyperspace tunnel)
\
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a write_pod command. It sets the
\ I/O processor's ESCP and HFX flags to ensure that the correct palette is
\ shown for the dashboard and hyperspace tunnel (ESCP affects the dashboard and
\ HFX affects the hyperspace tunnel).
\
\ ******************************************************************************

.write_pod

 JSR tube_get           \ Get the parameters from the parasite for the command:
 STA ESCP               \
 JSR tube_get           \   write_pod(escp, hfx)
 STA HFX                \
                        \ and store them as follows:
                        \
                        \   * ESCP = the new value of ESCP
                        \
                        \   * HFX = the new value of HFX

 RTS                    \ Return from the subroutine

