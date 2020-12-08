\ ******************************************************************************
\
\       Name: THERE
\       Type: Subroutine
\   Category: Missions
\    Summary: Check whether we are in the Constrictor's system in mission 1
\
\ ------------------------------------------------------------------------------
\
\ The stolen Constrictor is the target of mission 1. We finally track it down to
\ the Orarra system in the second galaxy, which is at galactic coordinates
\ (144, 33). This routine checks whether we are in this system and sets the C
\ flag accordingly.
\
\ Returns:
\
\   C flag              Set if we are in the Constrictor system, otherwise clear
\
\ ******************************************************************************

.THERE

 LDX GCNT               \ Set X = GCNT - 1
 DEX

 BNE THEX               \ If X is non-zero (i.e. GCNT is not 1, so we are not in
                        \ the second galaxy), then jump to THEX

 LDA QQ0                \ Set A = the current system's galactic x-coordinate

 CMP #144               \ If A <> 144 then jump to THEX
 BNE THEX

 LDA QQ1                \ Set A = the current system's galactic y-coordinate

 CMP #33                \ If A = 33 then set the C flag

 BEQ THEX+1             \ If A = 33 then jump to THEX+1, so we return from the
                        \ subroutine with the C flag set (otherwise we clear the
                        \ C flag with the next instruction)

.THEX

 CLC                    \ Clear the C flag

 RTS                    \ Return from the subroutine

