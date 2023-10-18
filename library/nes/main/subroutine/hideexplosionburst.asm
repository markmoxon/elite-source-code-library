\ ******************************************************************************
\
\       Name: HideExplosionBurst
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Hide the four sprites that make up the explosion burst that
\             flashes up when a ship explodes
\
\ ******************************************************************************

.HideExplosionBurst

 LDX #4                 \ Set X = 4 so we hide four sprites

 LDY #236               \ Set Y so we start hiding from sprite 236 / 4 = 59

 JMP HideSprites        \ Jump to HideSprites to hide four sprites from sprite
                        \ 59 onwards (i.e. 59 to 62), returning from the
                        \ subroutine using a tail call

