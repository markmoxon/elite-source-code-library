\ ******************************************************************************
\
\       Name: HBZE
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Reset the horizontal line buffer
\
\ ******************************************************************************

.HBZE

 LDA #2                 \ Set HBUP = 2 to reset the horizontal line buffer (as
 STA HBUP               \ the size in HBUP includes the two OSWORD size bytes)

 RTS                    \ Return from the subroutine

