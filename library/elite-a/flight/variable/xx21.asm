\ ******************************************************************************
\
\       Name: XX21
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprints lookup table for flight in Elite-A
\  Deep dive: Ship blueprints in Elite-A
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   ship_data           The extended ship blueprints table for Elite-A, which
\                       includes an extra entry at the start for our current
\                       ship
\
\ ******************************************************************************

.ship_data

 EQUW 0                 \         0 = Our current ship

.XX21

 EQUW SHIP_MISSILE      \ MSL  =  1 = Missile                            Missile
 EQUW 0                 \                                                Station
 EQUW SHIP_ESCAPE_POD   \ ESC  =  3 = Escape pod                      Escape pod
 EQUW SHIP_PLATE        \ PLT  =  4 = Alloy plate                          Cargo
 EQUW SHIP_CANISTER     \ OIL  =  5 = Cargo canister                       Cargo
 EQUW SHIP_BOULDER      \         6 = Boulder                             Mining
 EQUW SHIP_ASTEROID     \ AST  =  7 = Asteroid                            Mining
 EQUW SHIP_SPLINTER     \ SPL  =  8 = Splinter                            Mining
 EQUW 0                 \                                                Shuttle
 EQUW SHIP_TRANSPORTER  \        10 = Transporter                    Transporter
 EQUW 0                 \                                                 Trader
 EQUW 0                 \                                                 Trader
 EQUW 0                 \                                                 Trader
 EQUW 0                 \                                             Large ship
 EQUW 0                 \                                             Small ship
 EQUW SHIP_VIPER        \ COPS = 16 = Viper                                  Cop
 EQUW 0                 \                                                 Pirate
 EQUW 0                 \                                                 Pirate
 EQUW 0                 \                                                 Pirate
 EQUW 0                 \                                                 Pirate
 EQUW 0                 \                                                 Pirate
 EQUW 0                 \                                                 Pirate
 EQUW 0                 \                                                 Pirate
 EQUW 0                 \                                                 Pirate
 EQUW 0                 \                                          Bounty hunter
 EQUW 0                 \                                          Bounty hunter
 EQUW 0                 \                                          Bounty hunter
 EQUW 0                 \                                          Bounty hunter
 EQUW SHIP_THARGOID     \ THG  = 29 = Thargoid                          Thargoid
 EQUW SHIP_THARGON      \ TGL  = 30 = Thargon                           Thargoid
 EQUW SHIP_CONSTRICTOR  \ CON  = 31 = Constrictor                    Constrictor

