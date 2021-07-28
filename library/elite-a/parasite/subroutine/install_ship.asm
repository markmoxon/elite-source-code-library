\ ******************************************************************************
\
\       Name: install_ship
\       Type: Subroutine
\   Category: Universe
\    Summary: Install a ship blueprint into the ship blueprints lookup table
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The type of the ship to install, with the number being
\                       taken from the full list of available blueprints in the
\                       ship_list table, so that's:
\
\                         * 0 = Dodo station
\                         * 1 = Coriolis station
\                         * 2 = Escape pod
\
\                           ...
\
\                         * 35 = Iguana
\                         * 36 = Shuttle Mk II
\                         * 37 = Chameleon
\
\   Y                   The position in which to install the ship blueprint in
\                       the ship blueprints lookup table at ship_data, so
\                       that's:
\
\                         * 0 = Our current ship
\                         * 1 = Missile
\                         * 2 = Space station
\
\                           ...
\
\                         * 29 = Thargoid
\                         * 30 = Thargon
\                         * 31 = Constrictor
\
\ ******************************************************************************

.install_ship

 TXA                    \ Store X * 2 on the stack so we can use it below as an
 ASL A                  \ index into the ship_list table, which has 2 bytes per
 PHA                    \ entry

 ASL A                  \ Set X = X * 4, so we can use it as an index into the
 TAX                    \ ship_bytes table, which has 4 bytes per entry
 
 LDA ship_flags,Y       \ Fetch the ship_flags byte for this ship position, i.e.
                        \ the Y-th entry in the ship_flags table, where the NEWB
                        \ flags live, so this sets A to the default NEWB flags
                        \ for the ship position that we are filling

 AND #%01111111         \ Set bit 7 of the NEWB flags to that of the second byte
 ORA ship_bytes+1,X     \ in this ship type's entry in the ship_bytes table, so
                        \ this determines whether this ship type has an escape
                        \ pod fitted as standard (if the second ship_byte is
                        \ %10000000) or not (if the second ship_byte is
                        \ %00000000)

 STA ship_flags,Y       \ Update the Y-th entry in the ship_flags table with the
                        \ updated bit 7, so when we spawn a ship from this
                        \ blueprint position, it correctly spawns with or
                        \ without an escape pod, depending on the ship type

 TYA                    \ Set Y = Y * 2, so we can use it as an index into the
 ASL A                  \ ship_data table, which has 2 bytes per entry
 TAY

 PLA                    \ Retrieve the value of X * 2 that we stored above, so
 TAX                    \ we can use it as an index into the ship_list table,
                        \ which has 2 bytes per entry

 LDA ship_list,X        \ Set the address at position Y in the ship_data table
 STA ship_data,Y        \ to the blueprint address for ship number X in the
 LDA ship_list+1,X      \ ship_list table (i.e. install ship number X into
 STA ship_data+1,Y      \ position Y)

 RTS                    \ Return from the subroutine

