\ ******************************************************************************
\
\       Name: KS1
\       Type: Subroutine
\   Category: Universe
\    Summary: Remove the current ship from our local bubble of universe
\
\ ------------------------------------------------------------------------------
\
\ Part 12 of the main flight loop calls this routine to remove the ship that is
\ currently being analysed by the flight loop. Once the ship is removed, it
\ jumps back to MAL1 to rejoin the main flight loop, with X pointing to the
\ same slot that we just cleared (and which now contains the next ship in the
\ local bubble of universe).
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   XX0                 The address of the blueprint for this ship
\
\   INF                 The address of the data block for this ship
\
IF _NES_VERSION
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   KS3                 Contains an RTS
\
ENDIF
\ ******************************************************************************

IF _NES_VERSION

.KS3

 RTS                    \ Return from the subroutine

ENDIF

.KS1

 LDX XSAV               \ Fetch the current ship's slot number from XSAV

 JSR KILLSHP            \ Call KILLSHP to remove the ship in slot X from our
                        \ local bubble of universe

 LDX XSAV               \ Restore the current ship's slot number from XSAV,
                        \ which now points to the next ship in the bubble

IF NOT(_NES_VERSION)

 JMP MAL1               \ Jump to MAL1 to rejoin the main flight loop at the
                        \ start of the ship analysis loop

ELIF _NES_VERSION

 RTS                    \ Return from the subroutine

ENDIF

