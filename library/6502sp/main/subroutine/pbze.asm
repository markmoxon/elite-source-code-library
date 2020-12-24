\ ******************************************************************************
\
\       Name: PBZE
\       Type: Subroutine
\   Category: Drawing pixels
\    Summary: Reset the pixel buffer
\
\ ******************************************************************************

.PBZE

 LDA #2                 \ Set PBUP = 2 to reset the pixel buffer (as the size in
 STA PBUP               \ PBUP includes the two OSWORD size bytes)

 RTS                    \ Return from the subroutine

