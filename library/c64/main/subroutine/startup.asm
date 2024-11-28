\ ******************************************************************************
\
\       Name: STARTUP
\       Type: Subroutine
\   Category: Loader
\    Summary: Set the various vectors, interrupts and timers
\
\ ------------------------------------------------------------------------------
\
\ This routine is unused in this version of Elite (it is left over from the
\ 6502 Second Processor version).
\
\ ******************************************************************************

.STARTUP

 LDA #&FF               \ Set COL to &FF, which would set the colour to green
 STA COL                \ for a dashboard indicator (though this code is never
                        \ run)

                        \ Fall through into PUTBACK to return from the
                        \ subroutine

