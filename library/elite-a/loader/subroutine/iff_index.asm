\ ******************************************************************************
\
\       Name: iff_index
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Return the type index for this ship in the I.F.F. system
\
\ ------------------------------------------------------------------------------
\
\ This routine is copied to &0D7A in part 1 above.
\
\ Returns:
\
\   X                   The index for the current ship in the I.F.F. system:
\
\                         * 0 = Clean
\                               Innocent trader, innocent bounty hunter
\
\                         * 1 = Station tracked
\                               Cop, space station, escape pod
\
\                         * 2 = Debris
\                               Cargo, alloy plate, asteroid, boulder, splinter
\
\                         * 3 = Missile
\
\                         * 4 = Offender/fugitive
\                               Pirate, non-innocent bounty hunter
\
\                       If there is no I.F.F. system fitted, the index returned
\                       in X is always 0
\
\ ******************************************************************************

.iff_index


 LDX CRGO               \ If we do not have an I.F.F. fitted (i.e. CRGO is
 BEQ iff_not            \ zero), jump to iff_not to return from the routine with
                        \ X = 0

                        \ If we get here then X = &FF (as CRGO is &FF if we have
                        \ an I.F.F. fitted)

 LDY #36                \ Set A to byte #36 of the ship's blueprint, i.e. the
 LDA (INF),Y            \ NEWB flags

 ASL A                  \ If bit 6 is set, i.e. this is a cop, a space station
 ASL A                  \ or an escape pod, jump to iff_cop to return X = 1
 BCS iff_cop

 ASL A                  \ If bit 5 is set, i.e. this is an innocent bystander
 BCS iff_trade          \ (which applies to traders and some bounty hunters),
                        \ jump to iff_trade to return X = 0

 LDY TYPE               \ Set Y to the ship's type - 1
 DEY

 BEQ iff_missle         \ If Y = 0, i.e. this is a missile, then jump to
                        \ iff_missle to return X = 3

 CPY #8                 \ If Y < 8, i.e. this is a cargo canister, alloy plate,
 BCC iff_aster          \ boulder, asteroid or splinter, then jump to iff_aster
                        \ to return X = 2

                        \ If we get here then the ship is not the following:
                        \
                        \   * A cop/station/escape pod
                        \   * An innocent bystander/trader/good bounty hunter
                        \   * A missile
                        \   * Cargo or an asteroid
                        \
                        \ So it must be a pirate or a non-innocent bounty hunter

 INX                    \ X is &FF at this point, so this INX sets X = 0, and we
                        \ then fall through into the four INX instructions below
                        \ to return X = 4

.iff_missle

 INX                    \ If we jump to this point, then return X = 3

.iff_aster

 INX                    \ If we jump to this point, then return X = 2

.iff_cop

 INX                    \ If we jump to this point, then return X = 1

.iff_trade

 INX                    \ If we jump to this point, then return X = 0

.iff_not

 RTS                    \ Return from the subroutine

