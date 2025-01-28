\ ******************************************************************************
\
\       Name: write
\       Type: Subroutine
\   Category: Save and load
\    Summary: Write a sector's worth of data from the buffr2 buffer to the
\             current track and sector
\
\ ------------------------------------------------------------------------------
\
\ This routine does nothing except clear the C flag to indicate success, as we
\ do not need to write to disk in the game loader.
\
\ ******************************************************************************

.write

 CLC                    \ Clear the C flag to indicate success

 RTS                    \ Return from the subroutine

