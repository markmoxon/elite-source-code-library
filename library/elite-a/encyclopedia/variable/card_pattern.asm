\ ******************************************************************************
\
\       Name: card_pattern
\       Type: Variable
\   Category: Encyclopedia
\    Summary: Layout pattern for the encyclopedia's ship cards
\  Deep dive: The Encyclopedia Galactica
\
\ ------------------------------------------------------------------------------
\
\ Each ship card in the encyclopedia consists of multiple sections, each of
\ which consists of one or more text labels, plus the corresponding ship data.
\ The card pattern table defines these sections and how they are laid out on
\ screen - in other words, this table contains a set of patterns, one for each
\ section, that define how to lay out that section on-screen.
\
\ Each line in the table below defines a screen position and something to print
\ there. The first two numbers are the text column and row, and the third number
\ specifies a text token from the msg_3 table (when non-zero) or the actual data
\ (when zero).
\
\ So, for example, the "cargo space" section looks like this:
\
\   EQUB  1, 12, 61
\   EQUB  1, 13, 45
\   EQUB  1, 14,  0
\
\ which defines the following layout pattern:
\
\   * Token 61 ("CARGO") at column 1, row 12
\   * Token 45 ("SPACE:") at column 1, row 13
\   * The relevant ship data (the ship's cargo capacity) at column 1, row 14
\
\ The data itself comes from the card data for the specific ship - see the table
\ at card_addr for a list of card data blocks. Each section corresponds to the
\ same section number in the card data, so the cargo space section is number 7,
\ for example.
\
\ As well as the ship data, the ship cards show the ship itself, rotating in the
\ middle of the card.
\
\ ******************************************************************************

.card_pattern

 EQUB  1,  3, 37        \ 1: Inservice date           "INSERVICE DATE:" @ (1, 3)
 EQUB  1,  4,  0        \                                          Data @ (1, 4)

 EQUB 24,  6, 38        \ 2: Combat factor                    "COMBAT" @ (24, 6)
 EQUB 24,  7, 47        \                                    "FACTOR:" @ (24, 7)
 EQUB 24,  8, 65        \                                         "CF" @ (24, 8)
 EQUB 26,  8,  0        \                                         Data @ (26, 8)

 EQUB  1,  6, 43        \ 3: Dimensions                   "DIMENSIONS:" @ (1, 6)
 EQUB  1,  7,  0        \                                          Data @ (1, 7)

 EQUB  1,  9, 36        \ 4: Speed                            "SPEED:" @ (1,  9)
 EQUB  1, 10,  0        \                                         Data @ (1, 10)

 EQUB 24, 10, 39        \ 5: Crew                             "CREW:" @ (24, 10)
 EQUB 24, 11,  0        \                                        Data @ (24, 11)

 EQUB 24, 13, 41        \ 6: Range                           "RANGE:" @ (24, 13)
 EQUB 24, 14,  0        \                                        Data @ (24, 14)

 EQUB  1, 12, 61        \ 7: Cargo space                       "CARGO" @ (1, 12)
 EQUB  1, 13, 45        \                                     "SPACE:" @ (1, 13)
 EQUB  1, 14,  0        \                                        Data  @ (1, 14)

 EQUB  1, 16, 35        \ 8: Armaments                    "ARMAMENTS:" @ (1, 16)
 EQUB  1, 17,  0        \                                         Data @ (1, 17)

 EQUB 23, 20, 44        \ 9: Hull                             "HULL:" @ (23, 20)
 EQUB 23, 21,  0        \                                        Data @ (23, 21)

 EQUB  1, 20, 40        \ 10: Drive motors             "DRIVE MOTORS:" @ (1, 20)
 EQUB  1, 21,  0        \                                         Data @ (1, 21)

 EQUB  1, 20, 45        \ 11: Space                           "SPACE:" @ (1, 20)
 EQUB  1, 21,  0        \                                         Data @ (1, 21)

