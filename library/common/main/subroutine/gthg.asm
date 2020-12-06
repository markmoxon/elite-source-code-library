\ ******************************************************************************
\
\       Name: GTHG
\       Type: Subroutine
\   Category: Universe
\    Summary: Spawn a Thargoid ship and a Thargon companion
\
\ ******************************************************************************

.GTHG

 JSR Ze                 \ Call Ze to initialise INWK

 LDA #%11111111         \ Set the AI flag in byte #32 so that the ship has AI,
 STA INWK+32            \ is extremely and aggressively hostile, and has E.C.M.

 LDA #THG               \ Call NWSHP to add a new Thargoid ship to our local
 JSR NWSHP              \ bubble of universe

 LDA #TGL               \ Call NWSHP to add a new Thargon ship to our local
 JMP NWSHP              \ bubble of universe, and return from the subroutine
                        \ using a tail call

