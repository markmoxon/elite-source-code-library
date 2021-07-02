.new_shields

 SKIP 1                 \ Our current ship's shield level
                        \
                        \ If our ship is damaged and the level of damage is less
                        \ than our shield level, then the ship emerges unscathed
                        \
                        \ If the damage level is greater than the shield level,
                        \ then the damage level is reduced by the shield level
                        \ before being applied to the ship (i.e. the shields
                        \ absorb the amount of damage given in new_shields)

