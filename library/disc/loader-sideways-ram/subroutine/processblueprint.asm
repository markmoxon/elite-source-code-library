\ ******************************************************************************
\
\       Name: ProcessBlueprint
\       Type: Subroutine
\   Category: Loader
\    Summary: Process a blueprint entry from the loaded blueprint file, copying
\             the blueprint into sideways RAM if it hasn't already been copied
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The blueprint number to process (0 to 30)
\
\   ZP(1 0)             The address in sideways RAM to store the next ship
\                       blueprint that we add
\
\ ******************************************************************************

.proc1

                        \ If we get here then the address of the blueprint we
                        \ are adding to sideways RAM is outside of the loaded
                        \ blueprint file, so we just store the address in the
                        \ ROM_XX21 table and move on to the next blueprint
                        \
                        \ The address of the blueprint we are adding is in
                        \ P(1 0), and A still contains the high byte of P(1 0)

 STA ROM_XX21+1,Y       \ Set the X-th address in ROM_XX21 to (A P), which
 LDA P                  \ stores P(1 0) in the table as A contains the high
 STA ROM_XX21,Y         \ byte

.proc2

 RTS                    \ Return from the subroutine

.proc3

                        \ If we get here then we are processing the second
                        \ blueprint in ship blueprint file D.MOB
                        \
                        \ This means that the ROM_XX21 table contains the
                        \ addresses from the previous file, D.MOA, so the
                        \ second slot contains the address of the Coriolis space
                        \ station, as that's what D.MOA contains
                        \
                        \ We want the ROM_XX21 table to contain the Dodo space
                        \ station address, so we copy the Coriolis address to
                        \ coriolisStation(1 0), and then jump to proc5 so the
                        \ Dodo space station address gets written into ROM_XX21,
                        \ overwriting the Coriolis address
                        \
                        \ When intercepting OSFILE in FileHandler, we ensure
                        \ that the correct station blueprint is loaded from
                        \ sideways RAM, depending on the filename that is being
                        \ loaded

 LDA ROM_XX21,Y         \ Fetch the address of the Coriolis blueprint from
 STA coriolisStation    \ sideways RAM and store in coriolisStation(1 0)
 LDA ROM_XX21+1,Y
 STA coriolisStation+1

 BNE proc5              \ Jump to proc5 to process the Dodo blueprint and insert
                        \ its address into ROM_XX21, overwriting the Coriolis
                        \ address (this BNE is effectively a JMP as the high
                        \ byte of the Coriolis blueprint address is never zero)

.ProcessBlueprint

 TXA                    \ Set Y = X * 2
 ASL A                  \
 TAY                    \ So we can use Y as an index into the XX21 table to
                        \ fetch the address for blueprint number X in the
                        \ current blueprint file, as the XX21 table has two
                        \ bytes per entry (as each entry is an address)
                        \
                        \ I will refer to the two-byte address in XX21+Y as "the
                        \ X-th address in XX21", to keep things simple

 LDA XX21+1,Y           \ Set A to the high byte of the address of the blueprint
                        \ we are processing (i.e. blueprint number X)

 BEQ proc2              \ If the high byte of the address is zero then blueprint
                        \ number X is blank and has no ship allocated to it, so
                        \ jump to proc2 to return from the subroutine, as there
                        \ is nothing to process

 CPX #1                 \ If X = 1 then this is the second blueprint, which is
 BNE proc4              \ always the space station, so jump to proc4 if this
                        \ isn't the station

 LDA shipFilename+4     \ If we are processing blueprint file B.MOB then jump to
 CMP #'B'               \ proc3, so we can save the address of the Coriolis
 BEQ proc3              \ space station blueprint address before processing the
                        \ blueprint

.proc4

 LDA ROM_XX21+1,Y       \ If blueprint X in the ROM_XX21 table in sideways RAM
 BNE proc2              \ already has blueprint data associated with it, then
                        \ the X-th address in ROM_XX21 + Y will be non-zero,
                        \ so jump to proc2 to return from the subroutine and
                        \ move on to the next blueprint in the file

.proc5

                        \ If we get here then the blueprint table in sideways
                        \ RAM does not contain any data for blueprint X, so we
                        \ need to fill it with the data for blueprint X from the
                        \ file we have loaded at address XX21

 LDA ZP                 \ Set the X-th address in the ROM_XX21 table in sideways
 STA ROM_XX21,Y         \ RAM to the value of ZP(1 0), so this entry contains
 LDA ZP+1               \ the address where we should store the next ship
 STA ROM_XX21+1,Y       \ blueprint (as we are about to copy the blueprint data
                        \ to this address in sideways RAM)

 LDA E%,X               \ Set the X-th entry in the ROM_E% table in sideways
 STA ROM_E%,X           \ RAM to the X-th entry from the E% table in the loaded
                        \ ship blueprints file, so this sets the correct default
                        \ NEWB byte for the ship blueprint we are copying to
                        \ sideways RAM

 LDA XX21,Y             \ Set P(1 0) to the X-th address in the XX21 table, which
 STA P                  \ is the address of the blueprint X data within the ship
 LDA XX21+1,Y           \ blueprint file that we have loaded at address XX21
 STA P+1

 CMP #HI(XX21)          \ Ship blueprint files are 9 pages in size, so if the
 BCC proc1              \ high byte of the address in P(1 0) is outside of the
 CMP #HI(XX21) + 10     \ range XX21 to XX21 + 9, it is not pointing to an
 BCS proc1              \ an address within the blueprint file that we loaded,
                        \ so jump to proc1 to store P(1 0) in the ROM_XX21 table
                        \ in sideways RAM and return from the subroutine, so we
                        \ just set the address but don't copy the blueprint data
                        \ into sideways RAM
                        \
                        \ For example, the missile blueprint is stored above
                        \ screen memory in the disc version (at &7F00), so this
                        \ ensures that the address is set correctly in the
                        \ ROM_XX21 table, even though it's outside the blueprint
                        \ file itself

 JSR SetEdgesOffset     \ Set the correct edges offset for the blueprint we are
                        \ currently processing (as the edges offset can point to
                        \ the edges data in a different blueprint, so we need to
                        \ make sure this value is calculated correctly to point
                        \ to the right blueprint within sideways RAM)

                        \ We now want to copy the data for blueprint X into
                        \ sideways RAM
                        \
                        \ We know the address of the start of the blueprint
                        \ data (we stored it in P(1 0) above), but we don't
                        \ know the address of the end of the data, so we
                        \ calculate that now
                        \
                        \ We do this by looking at the addresses of the data for
                        \ all the blueprints after blueprint X in the file, and
                        \ picking the lowest address that is greater than the
                        \ address for blueprint X
                        \
                        \ This will give us the address of the blueprint data
                        \ for the blueprint whose data is directly after the
                        \ data for blueprint X in memory, which is the same as
                        \ the address of the end of blueprint X
                        \
                        \ We don't need to check blueprints in earlier positions
                        \ as blueprints are inserted into memory in the order in
                        \ which they appear in the blueprint file
                        \
                        \ We implement the above by keeping track of the lowest
                        \ address we have found in (S R), as we loop through the
                        \ blueprints after blueprint X
                        \
                        \ We loop through the blueprints by incrementing Y by 2
                        \ on each iteration, so I will refer to the address of
                        \ the blueprint at index Y in XX21 as "the Y-th address
                        \ in XX21", to keep things simple

 LDA #LO(XX21)          \ Set (S R) to the address of the end of the ship
 STA R                  \ blueprint file (which takes up 9 pages)
 TAY                    \
 LDA #HI(XX21) + 10     \ Also set Y = 0, as the blueprint file load at &5600,
 STA S                  \ so the low byte is zero

.proc6

 LDA P                  \ If P(1 0) >= the Y-th address in XX21, jump to proc7
 CMP XX21,Y             \ to move on to the next address in XX21
 LDA P+1
 SBC XX21+1,Y
 BCS proc7

 LDA XX21,Y             \ If the Y-th address in XX21 >= (S R), jump to proc7
 CMP R                  \ to move on to the next address in XX21
 LDA XX21+1,Y
 SBC S
 BCS proc7

                        \ If we get here then the following is true:
                        \
                        \   P(1 0) < the Y-th address in XX21 < (S R)
                        \
                        \ P(1 0) is the address of the start of blueprint X
                        \ and (S R) contains the lowest blueprint address we
                        \ have found so far, so this sets (S R) to the current
                        \ blueprint address if it is smaller than the lowest
                        \ address we already have
                        \
                        \ By the end of the loop, (S R) will contain the address
                        \ we need (i.e. that of the end of blueprint X)

 LDA XX21,Y             \ Set (S R) = the Y-th address in XX21
 STA R
 LDA XX21+1,Y
 STA S

.proc7

 INY                    \ Increment the address counter in Y to point to the
 INY                    \ next address in XX21

 CPY #31 * 2            \ Loop back until we have worked our way to the end of
 BNE proc6              \ the whole set of blueprints

                        \ We now have the following:
                        \
                        \   * P(1 0) is the address of the start of the
                        \     blueprint data to copy
                        \
                        \   * (S R) is the address of the end of the blueprint
                        \     data to copy
                        \
                        \   * ZP(1 0) is the address to which we need to copy
                        \     the blueprint data
                        \
                        \ So we now copy the blueprint data into sideways RAM

 LDY #0                 \ Set a byte counter in Y

.proc8

 LDA (P),Y              \ Copy the Y-th byte of P(1 0) to the Y-th byte of
 STA (ZP),Y             \ ZP(1 0)

 INC P                  \ Increment P(1 0)
 BNE proc9
 INC P+1

.proc9

 INC ZP                 \ Increment ZP(1 0)
 BNE proc10
 INC ZP+1

.proc10

 LDA P                  \ Loop back to copy the next byte until P(1 0) = (S R),
 CMP R                  \ starting by checking the low bytes
 BNE proc8

 LDA P+1                \ And then the high bytes
 CMP S
 BNE proc8

 RTS                    \ Return from the subroutine

