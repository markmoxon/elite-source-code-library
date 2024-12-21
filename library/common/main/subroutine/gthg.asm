\ ******************************************************************************
\
\       Name: GTHG
\       Type: Subroutine
\   Category: Universe
\    Summary: Spawn a Thargoid ship and a Thargon companion
\  Deep dive: Fixing ship positions
\
IF _NES_VERSION
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   GTHG+15             Spawn a lone Thargoid, without a Thargon companion and
\                       with slightly less aggression than normal
\
ENDIF
\ ******************************************************************************

.GTHG

 JSR Ze                 \ Call Ze to initialise INWK
                        \
                        \ Note that because Ze uses the value of X returned by
                        \ DORND, and X contains the value of A returned by the
                        \ previous call to DORND, this does not set the new ship
                        \ to a totally random location

 LDA #%11111111         \ Set the AI flag in byte #32 so that the ship has AI,
 STA INWK+32            \ is extremely and aggressively hostile, and has E.C.M.

IF NOT(_NES_VERSION)

 LDA #THG               \ Call NWSHP to add a new Thargoid ship to our local
 JSR NWSHP              \ bubble of universe

 LDA #TGL               \ Call NWSHP to add a new Thargon ship to our local
 JMP NWSHP              \ bubble of universe, and return from the subroutine
                        \ using a tail call

ELIF _NES_VERSION

 LDA #TGL               \ Call NWSHP to add a new Thargon ship to our local
 JSR NWSHP              \ bubble of universe

 JMP gthg1              \ Skip the following to add a Thargoid

                        \ We jump straight here if we call GTHG+15

 JSR Ze                 \ Call Ze to initialise INWK

 LDA #%11111001         \ Set the AI flag in byte #32 so that the ship has AI,
 STA INWK+32            \ is hostile and pretty aggressive (though not quite as
                        \ aggressive as the Thargoid we add if we get here via
                        \ GTHG), and has E.C.M.

.gthg1

 LDA #THG               \ Call NWSHP to add a new Thargoid ship to our local
 JMP NWSHP              \ bubble of universe, and return from the subroutine
                        \ using a tail call

ENDIF

