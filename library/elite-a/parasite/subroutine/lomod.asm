\ ******************************************************************************
\
\       Name: LOMOD
\       Type: Subroutine
\   Category: Universe
\    Summary: Populate the ship blueprints table at XX21 with a random selection
\             of ships and set the compass to point to the planet
\  Deep dive: Ship blueprints in Elite-A
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   SHIPinA             Populate the ship blueprints table but without setting
\                       the compass to show the planet
\
\ ******************************************************************************

.LOMOD

 LDA #0                 \ Set finder to 0, so the compass shows the planet
 STA finder

.SHIPinA

 LDX #0                 \ The first task is to fill blueprint position 2, which
                        \ contains the space station blueprint, so set X = 0,
                        \ which is the ship_list ship type for a Dodo space
                        \ station

 LDA tek                \ If the current system's tech level is 10 or more, then
 CMP #10                \ skip the following instruction, as we already have the
 BCS mix_station        \ correct space station type in X

 INX                    \ Increment X to 1, the ship_list ship type for a
                        \ Coriolis space station

.mix_station

 LDY #2                 \ Install a ship of type X (Dodo or Coriolis station)
 JSR install_ship       \ into blueprint position 2

 LDY #9                 \ The next blueprint position we need to fill is number
                        \ 9, for the shuttle, so set Y to point to this position
                        \ so we can use it as a counter, starting at position 9
                        \ and working our way up to position 28 (as positions 29
                        \ to 31 are already filled)

.mix_retry

 LDA #0                 \ Set X1 = 0 to act as a failure counter, so we can
 STA X1                 \ have 256 failed attempts to fill each blueprint
                        \ position before giving up and leaving it blank

.mix_match

 JSR DORND              \ Set A and X to random numbers

 CMP #ship_total        \ If A >= #ship_total then it is too big to be a
 BCS mix_match          \ ship_list ship type, so loop back to choose another
                        \ random number until it is a valid ship type

 ASL A                  \ Set Y1 = A * 4, so we can use it a random index into
 ASL A                  \ the ship_bits table, which has four bytes in each
 STA Y1                 \ entry

                        \ Y1 now contains the ship_list ship type of the ship we
                        \ are going to try installing into position Y, just
                        \ multiplied by 4 so it can be used as a four-byte index
                        \
                        \ We now want to check the ship_bits table to see if the
                        \ ship type in Y1 is allowed in ship blueprint position
                        \ Y. The table contains a 32-bit number for each ship
                        \ type, with the corresponding bits set for allowed
                        \ positions, so if a ship type were allowed in positions
                        \ 11 and 17, for example, only bits 11 and 17 would be
                        \ set in the ship_bits table entry for that type
                        \
                        \ To do this, we work out which of the four bytes in the
                        \ 32-bit number contains the bit we want to match, and
                        \ then create a byte that has the correct bit set for
                        \ that particular byte, so we can AND them together to
                        \ see if there is a match
                        \
                        \ For example, say we are trying to populate position 17
                        \ (so Y = 17), and we want to know whether our ship of
                        \ type Y1 is allowed in this position. We know what we
                        \ need to look at the 32-bit number in row Y1 of the
                        \ ship_bits table, and we also know that bit 17 appears
                        \ in the third byte of a 32-bit number (i.e. byte #2),
                        \ so we can set an index in X:
                        \
                        \   X = Y1 + 2
                        \
                        \ and we can use this as an index into the ship_bits
                        \ table to fetch the relevant byte from the 32-bit  
                        \ number we want to match, which is at this location:
                        \
                        \   ship_bits + X
                        \
                        \ Given this byte, we need to check the relevant bit. We
                        \ know that bit 17 of a 32-bit number corresponds to the
                        \ second bit of the third byte, so if we create a byte
                        \ with that bit set:
                        \
                        \   A = %00000010
                        \
                        \ then we can AND the two together, and if we get a
                        \ non-zero result, we know that bit 17 in the 32-bit
                        \ number is set:
                        \
                        \   result = ?(ship_bits + X) AND A
                        \
                        \ where ?(addr) is the contents of address addr
                        \
                        \ This is what we now do, starting with the byte in A,
                        \ which we can grab from the lookup table at mix_bits,
                        \ then calculating X, before extracting the relevant
                        \ byte from the ship_bits table and performing the AND

 TYA                    \ Set X = Y mod 8, so as Y works through the positions
 AND #7                 \ from 0 to 31, making its way from bit 0 to bit 31 of
 TAX                    \ the 32-bit number, X represents the position of the
                        \ current bit within each of the four bytes that make up
                        \ the 32-bit number

 LDA mix_bits,X         \ Set A to the X-th byte from mix_bits, which contains a
                        \ table of bytes with the relevant bit sit for each
                        \ value of X (so the value at mix_bits + X has bit X
                        \ set). This gives us our value of A in the above
                        \ explanation, so if we were looking to populate
                        \ blueprint position 17, A would now be %00000010

 LDX Y1                 \ Set X to the ship type we are going to try to install

                        \ We now want to add to X to point to the correct byte
                        \ within the 32-bit number, depending on the blueprint
                        \ position in Y that we are trying to fill:
                        \
                        \   * If Y is in the range  0 to  7, X = X + 0
                        \   * If Y is in the range  8 to 15, X = X + 1
                        \   * If Y is in the range 16 to 23, X = X + 2
                        \   * If Y is in the range 24 to 28, X = X + 3
                        \
                        \ note that because we are starting at position 9, we
                        \ can ignore the first case. In our above example, we
                        \ are filling positon 17, so we would add 2 to X

 CPY #16                \ If the blueprint position we are trying to fill is
 BCC mix_byte2          \ less than 16, jump to mix_byte2 so we increment X once

 CPY #24                \ If the blueprint position we are trying to fill is
 BCC mix_byte3          \ less than 24, jump to mix_byte3 so we increment X
                        \ twice

 INX                    \ Increment X as Y is in the range 24 to 28

.mix_byte3

 INX                    \ Increment X as Y is in the range 16 to 28

.mix_byte2

 INX                    \ Increment X as Y is in the range 9 to 28

                        \ We now have the correct values of A and X, as per the
                        \ above calculation, so it's time to do the AND logic:
                        \
                        \   result = ?(ship_bits + X) AND A
                        \
                        \ which we can do easily in assembly language:
                        \
                        \   AND ship_bits,X
                        \
                        \ followed by a BEQ to check whether the result is zero

 AND ship_bits,X        \ If the X-th byte of ship_bits does not have the same
 BEQ mix_fail           \ bit set as our moving bit counter in A, jump to
                        \ mix_fail to have another go at filling this blueprint
                        \ position, as the ship in Y1 is not allowed in
                        \ blueprint position Y

.mix_try

                        \ If we get here then the ship in Y1 is allowed in
                        \ blueprint position Y, so now we decide whether or not
                        \ to go ahead, depending on the probability figure for
                        \ this ship type, which we fetch from the first entry in
                        \ the ship_bytes table for this ship type

 JSR DORND              \ Set A and X to random numbers

 LDX Y1                 \ Set X to the ship type we are going to try to install

 CMP ship_bytes,X       \ If A < the X-th entry in ship_bytes, i.e. it is less
 BCC mix_ok             \ than the first byte in the ship_bytes entry for this
                        \ ship type, jump to mix_ok to install this ship into
                        \ the blueprint position. So, for example, if this ship
                        \ type has a value of 100 as the first byte in its entry
                        \ in the ship_bytes table, which is the case for the
                        \ Mamba and Sidewinder, then we only add it to this
                        \ blueprint position if A < 100, or a 39% chance. The
                        \ much rarer Dragon, meanwhile, has a ship_bytes entry
                        \ of 3, so the calculation is A < 3, or a 1.2% chance

.mix_fail

                        \ If we get here then either this ship isn't allowed in
                        \ this position, or it failed the probability test
                        \ above, so we decrement the failure counter and loop
                        \ back for another go (up to a maximum number of 256
                        \ attempts for each position)

 DEC X1                 \ Decrement the failure counter in X1

 BNE mix_match          \ If we haven't run out of failure attempts, jump back
                        \ to mix_match to have another go at filling this
                        \ blueprint position

 LDX #ship_total*4      \ Otherwise we have run out of attempts, so set X to
                        \ point to the last entry in the table, which contains
                        \ data for an empty position, so this blueprint position
                        \ will be empty

.mix_ok

 STY X2                 \ Store Y, the blueprint position we are trying to fill,
                        \ in X2 so we can retrieve it later

 CPX #13*4              \ If X is the four-byte index for ship number 13, then
 BEQ mix_anaconda       \ we just decided to add an Anaconda, so jump to
                        \ mix_anaconda to install it as the "large ship", along
                        \ with a Worm as the "small ship"

 CPX #29*4              \ If X is the four-byte index for ship number 29, then
 BEQ mix_dragon         \ we just decided to add a Dragon, so jump to mix_dragon
                        \ to install it as the "large ship", along with a
                        \ Sidewinder as the "small ship"

 TXA                    \ Set X = X / 4, so X is now the type of the ship we
 LSR A                  \ want to add, rather than an index into a four-byte
 LSR A                  \ table
 TAX

.mix_install

 JSR install_ship       \ Install a ship of type X into blueprint position Y

 LDY X2                 \ Set Y to the blueprint position we are trying to fill,
                        \ which we stored in X2 above

.mix_next

 INY                    \ Increment Y to point to the next blueprint position to
                        \ fill

 CPY #15                \ If the next position is not number 15 (the "small
 BNE mix_skip           \ ship") then jump to mix_skip to skip the following two
                        \ instructions

 INY                    \ The next position is 15, so increment Y twice so we
 INY                    \ skip over positions 15 (the "small ship") and 16 (the
                        \ cop), as the first one is only filled if we have an
                        \ Anaconda or Dragon as the "large ship" (see above),
                        \ and the second one is already filled with a Viper

.mix_skip

 CPY #29                \ If the next blueprint position we are trying to fill
 BNE mix_retry          \ is not 29, then loop back to mix_retry to fill the
                        \ next position

 RTS                    \ Otherwise we just filled the last position, number 28,
                        \ so return from the subroutine as we are done

.mix_anaconda

 LDX #13                \ Install ship number 13 (Anaconda) into blueprint
 LDY #14                \ position 14 (the "large ship")
 JSR install_ship

 LDX #14                \ Install ship number 14 (Worm) into blueprint position
 LDY #15                \ 15 (the "small ship"), so the Anaconda can spawn
 JMP mix_install        \ Worms, and rejoin the mix loop via mix_install

.mix_dragon

 LDX #29                \ Install ship number 29 (Dragon) into blueprint
 LDY #14                \ position 14 (the "large ship")
 JSR install_ship

 LDX #17                \ Install ship number 14 (Sidewinder) into blueprint
 LDY #15                \ position 15 (the "small ship"), so the Dragon can
 JMP mix_install        \ spawn Sidewinders, and rejoin the mix loop via
                        \ mix_install

