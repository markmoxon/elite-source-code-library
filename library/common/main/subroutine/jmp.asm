\ ******************************************************************************
\
\       Name: jmp
\       Type: Subroutine
\   Category: Universe
\    Summary: Set the current system to the selected system
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   (QQ0, QQ1)          The galactic coordinates of the new system
\
\ Other entry points:
\
\   hy5                 Contains an RTS
\
\ ******************************************************************************

.jmp

 LDA QQ9                \ Set the current system's galactic x-coordinate to the
 STA QQ0                \ x-coordinate of the selected system

 LDA QQ10               \ Set the current system's galactic y-coordinate to the
 STA QQ1                \ y-coordinate of the selected system

.hy5

 RTS                    \ Return from the subroutine

