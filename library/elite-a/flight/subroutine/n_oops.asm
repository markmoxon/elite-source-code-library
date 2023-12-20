\ ******************************************************************************
\
\       Name: n_oops
\       Type: Subroutine
\   Category: Flight
\    Summary: Take some damage, taking our ship's shields into consideration
\
\ ------------------------------------------------------------------------------
\
\ We just took some damage, so calculate whether the amount of damage will be
\ sucked up by the shields, and if not, apply that damage to our ship.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The amount of damage to take
\
\ ******************************************************************************

.n_oops

 SEC                    \ Reduce the amount of damage in A by the level of our
 SBC new_shields        \ shields in new_shields

 BCC n_shok             \ If the amount of damage is less than the level of our
                        \ shields, then return from the subroutine without
                        \ taking any damage (as b_shok contains an RTS)

                        \ The amount of damage is greater than our shield level,
                        \ so we need to take some damage. The amount of damage
                        \ has already been reduced by our shield level (as they
                        \ absorb the amount of damage in new_shields), so fall
                        \ into OOPS to take the remaining amount of damage

