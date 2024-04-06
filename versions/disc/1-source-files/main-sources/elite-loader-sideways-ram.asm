\ ******************************************************************************
\
\ DISC ELITE SIDEWAYS RAM LOADER SOURCE
\
\ Elite was written by Ian Bell and David Braben and is copyright Acornsoft 1984
\
\ The code on this site has been reconstructed from a disassembly of the version
\ released on Ian Bell's personal website at http://www.elitehomepage.org/
\
\ The commentary is copyright Mark Moxon, and any misunderstandings or mistakes
\ in the documentation are entirely my fault
\
\ The terminology and notations used in this commentary are explained at
\ https://www.bbcelite.com/terminology
\
\ The deep dive articles referred to in this commentary can be found at
\ https://www.bbcelite.com/deep_dives
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * MNUCODE.bin
\
\ ******************************************************************************

 INCLUDE "versions/disc/1-source-files/main-sources/elite-build-options.asm"

 CPU 1                  \ Switch to 65SC12 assembly, as this code contains a
                        \ BBC Master DEC A instruction

 _CASSETTE_VERSION      = (_VERSION = 1)
 _DISC_VERSION          = (_VERSION = 2)
 _6502SP_VERSION        = (_VERSION = 3)
 _MASTER_VERSION        = (_VERSION = 4)
 _ELECTRON_VERSION      = (_VERSION = 5)
 _ELITE_A_VERSION       = (_VERSION = 6)
 _NES_VERSION           = (_VERSION = 7)
 _C64_VERSION           = (_VERSION = 8)
 _APPLE_VERSION         = (_VERSION = 9)
 _DISC_DOCKED           = FALSE
 _DISC_FLIGHT           = TRUE
 _ELITE_A_DOCKED        = FALSE
 _ELITE_A_FLIGHT        = FALSE
 _ELITE_A_SHIPS_R       = FALSE
 _ELITE_A_SHIPS_S       = FALSE
 _ELITE_A_SHIPS_T       = FALSE
 _ELITE_A_SHIPS_U       = FALSE
 _ELITE_A_SHIPS_V       = FALSE
 _ELITE_A_SHIPS_W       = FALSE
 _ELITE_A_ENCYCLOPEDIA  = FALSE
 _ELITE_A_6502SP_IO     = FALSE
 _ELITE_A_6502SP_PARA   = FALSE
 _IB_DISC               = (_VARIANT = 1)
 _STH_DISC              = (_VARIANT = 2)
 _SRAM_DISC             = (_VARIANT = 3)

 GUARD &7C00            \ Guard against assembling over screen memory

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

 CODE% = &7400          \ The address where the code will be run

 LOAD% = &7400          \ The address where the code will be loaded

 XX3 = &0100            \ Temporary storage space for complex calculations

 IND1V = &0230          \ The IND1 vector

 LANGROM = &028C        \ Current language ROM in MOS workspace

 ROMTYPE = &02A1        \ Paged ROM type table in MOS workspace

 XFILEV = &0DBA         \ The extended FILE vector

 XIND1V = &0DE7         \ The extended IND1 vector

 XX21 = &5600           \ The address of the ship blueprints lookup table in the
                        \ current blueprints file

 E% = &563E             \ The address of the default NEWB flags in the current
                        \ blueprints file

 ROM_XX21 = &8100       \ The address of the ship blueprints lookup table in the
                        \ sideways RAM image that we build

 ROM_E% = &813E         \ The address of the default NEWB flags in the sideways
                        \ RAM image that we build

 VIA = &FE00            \ Memory-mapped space for accessing internal hardware,
                        \ such as the video ULA, 6845 CRTC and 6522 VIAs (also
                        \ known as SHEILA)

 OSXIND1 = &FF48        \ IND1V's extended vector handler

 OSWRCH = &FFEE         \ The address for the OSWRCH routine

 OSFILE = &FFDD         \ The address for the OSFILE routine

INCLUDE "library/disc/loader-sideways-ram/workspace/zp.asm"

\ ******************************************************************************
\
\ ELITE LOADER
\
\ ******************************************************************************

 ORG CODE%

\ ******************************************************************************
\
\       Name: sram%
\       Type: Variable
\   Category: Loader
\    Summary: A table for storing the status of each ROM bank
\
\ ******************************************************************************

.sram%

 SKIP 16

\ ******************************************************************************
\
\       Name: used%
\       Type: Variable
\   Category: Loader
\    Summary: A table for storing the status of each ROM bank
\
\ ******************************************************************************

.used%

 SKIP 16

\ ******************************************************************************
\
\       Name: dupl%
\       Type: Variable
\   Category: Loader
\    Summary: A table for storing the status of each ROM bank
\
\ ******************************************************************************

.dupl%

 SKIP 16

\ ******************************************************************************
\
\       Name: eliterom%
\       Type: Variable
\   Category: Loader
\    Summary: The number of the bank containing the Elite ROM
\
\ ******************************************************************************

.eliterom%

 EQUB &FF

\ ******************************************************************************
\
\       Name: proflag%
\       Type: Variable
\   Category: Loader
\    Summary: A flag to record whether we are running this on a co-processor
\
\ ******************************************************************************

.proflag%

 SKIP 1

\ ******************************************************************************
\
\       Name: Entry points
\       Type: Subroutine
\   Category: Loader
\    Summary: This file contains four entry points into the four routines that
\             it provides
\
\ ******************************************************************************

.testbbc%

 JMP TestBBC

.testpro%

 JMP TestPro

.loadrom%

 JMP LoadRom

.makerom%

 JMP MakeRom

\ ******************************************************************************
\
\       Name: LoadRom
\       Type: Subroutine
\   Category: Loader
\    Summary: Copy a pre-generated ship blueprints ROM image from address &3400
\             into sideways RAM
\
\ ******************************************************************************

.LoadRom

 LDA &F4                \ Switch to the ROM bank in X, storing the current ROM
 PHA                    \ bank on the stack
 STX &F4
 STX VIA+&30

 LDA #&34
 STA lrom1+2

 LDA #HI(ROM)
 STA lrom2+2

 LDY #&00
 LDX #&40

.lrom1

 LDA &3400,Y

.lrom2

 STA ROM,Y

 INY

 BNE lrom1

 INC lrom1+2

 INC lrom2+2

 DEX

 BNE lrom1

 LDX &F4
 LDA ROM+6
 STA ROMTYPE,X

 PLA                    \ Switch back to the ROM bank number that we saved on
 STA &F4                \ the stack at the start of the routine
 STA VIA+&30

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: MakeRom
\       Type: Subroutine
\   Category: Loader
\    Summary: Create a ROM image in sideways RAM that contains all the ship
\             blueprint files
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The bank number of sideways RAM to use for Elite
\
\ ******************************************************************************

.MakeRom

 LDA &F4                \ Switch to the sideways RAM bank in X, storing the
 PHA                    \ current ROM bank on the stack
 STX &F4
 STX VIA+&30

                        \ We start by copying 256 bytes from ROMheader into the
                        \ sideways RAM bank at address ROM, and zeroing the next
                        \ 256 bytes at ROM + &100
                        \
                        \ This sets up the sideways RAM bank with the ROM header
                        \ needed for our sideways RAM image

 LDY #0                 \ Set a loop counter in Y to step through the 256 bytes

.mrom1

 LDA ROMheader,Y        \ Copy the Y-th byte from ROMheader to ROM
 STA ROM,Y

 LDA #0                 \ Zero the Y-th byte at ROM + &100
 STA ROM_XX21,Y
 INY                    \ Increment the loop counter

 BNE mrom1              \ Loop back until we have copied and zeroed all 256
                        \ bytes

                        \ Next we load all the ship blueprint files into our
                        \ sideways RAM image, from D.MOA to D.MOP, combining
                        \ them into a single, complete set of ship blueprints

 LDA #LO(ROM+&200)      \ Set ZP(1 0) = ROM + &200
 STA ZP                 \
 LDA #HI(ROM+&200)      \ So the call to LoadShipFiles loads the ship blueprint
 STA ZP+1               \ files to location &200 in the sideways RAM image

 JSR LoadShipFiles      \ Load all the ship blueprint files into the sideways
                        \ RAM image to the location in ZP(1 0)

                        \ Now that we have created our sideways RAM image, we
                        \ intercept calls to OSFILE so they call our custom file
                        \ handler routine, FileHandler, in sideways RAM
                        \
                        \ For this we need to use the extended vectors, which
                        \ work like the normal vectors, except they switch to a
                        \ specified ROM bank before calling the handler, and
                        \ switch back afterwards

 LDA XFILEV             \ Copy the extended vector XFILEV into XIND1V so we can
 STA XIND1V             \ pass any calls to XFILEV down the chain by calling
 LDA XFILEV+1           \ the IND1 vector
 STA XIND1V+1
 LDA XFILEV+2
 STA XIND1V+2

 LDA #LO(FileHandler)   \ Set the extended vector XFILEV to point to the
 STA XFILEV             \ FileHandler routine in the sideways RAM bank that we
 LDA #HI(FileHandler)   \ are building
 STA XFILEV+1           \ 
 LDA &F4                \ The format for the extended vector is the address of
 STA XFILEV+2           \ the handler in the first two bytes, followed by the
                        \ ROM bank number in the third byte, which we can fetch
                        \ from &F4

 LDA #LO(OSXIND1)       \ Point IND1V to IND1V's extended vector handler, so we
 STA IND1V              \ can pass any calls to XFILEV down the chain by calling
 LDA #HI(OSXIND1)       \ JMP (IND1V) from our custom file handler in the
 STA IND1V+1            \ FileHandler routine

 PLA                    \ Switch back to the ROM bank number that we saved on
 STA &F4                \ the stack at the start of the routine
 STA VIA+&30

 RTS                    \ Return from the subroutine


\ ******************************************************************************
\
\       Name: LoadShipFiles
\       Type: Subroutine
\   Category: Loader
\    Summary: Load all the ship blueprint files into sideways RAM
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   ZP(1 0)             The address in sideways RAM to load the ship files
\
\ ******************************************************************************

.LoadShipFiles

 LDA #'A'               \ Set the ship filename to D.MOA, so we start the
 STA shipFilename+4     \ loading process from this file

.ship1

 LDA #'.'               \ Print a full stop to show progress during loading
 JSR OSWRCH

 LDA #LO(XX21)          \ Set the load address in bytes 2 and 3 of the OSFILE 
 STA osfileBlock+2      \ block to XX21, which is where ship blueprint files
 LDA #HI(XX21)          \ get loaded in the normal disc version
 STA osfileBlock+3      \
 LDA #&FF               \ We set the address to the form &FFFFxxxx to ensure
 STA osfileBlock+4      \ that the files are loaded into the I/O Processor
 STA osfileBlock+5

 LDA #0                 \ Set byte 6 to zero to terminate the block
 STA osfileBlock+6

 LDX #LO(osfileBlock)   \ Set (Y X) = osfileBlock
 LDY #HI(osfileBlock)

 LDA #&FF               \ Call OSFILE with A = &FF to load the file specified
 JSR OSFILE             \ in the block, so this loads the ship blueprint file
                        \ to XX21

                        \ We now loop through each blueprint in the currently
                        \ loaded ship file, processing each one in turn to
                        \ merge them into one big ship blueprint file

 LDX #0                 \ Set a loop counter in X to work through the ship
                        \ blueprints

.ship2

 TXA                    \ Store the blueprint counter on the stack so we can
 PHA                    \ retrieve it after the call to ProcessBlueprint

 JSR ProcessBlueprint   \ Process blueprint entry X from the loaded blueprint
                        \ file, copying the blueprint into sideways RAM if it
                        \ hasn't already been copied

 PLA                    \ Restore the blueprint counter
 TAX

 INX                    \ Increment the blueprint counter

 CPX #31                \ Loop back until we have processed all 31 blueprint
 BNE ship2              \ entries in the blueprint file

 INC shipFilename+4     \ Increment the fifth character of the ship blueprint
                        \ filename so we step through them from D.MOA to D.MOP

 LDA shipFilename+4     \ Loop back until we have processed files D.MOA through
 CMP #'Q'               \ D.MOP
 BNE ship1

 RTS                    \ Return from the subroutine

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
                        \ blueprint in ship blueprint file D.MOB, which contains
                        \ a dodo space station, so we take this opportunity to
                        \ save the address of the dodo station blueprint in our
                        \ sideways RAM image, so systems with higher tech levels
                        \ can load the correct station blueprint from sideways
                        \ RAM

 LDA ROM_XX21,Y         \ Fetch the address of the dodo blueprint in sideways
 STA dodoStationAddr    \ RAM and store in dodoStationAddr(1 0)
 LDA ROM_XX21+1,Y
 STA dodoStationAddr+1

 BNE proc5              \ Jump to proc5 to process the dodo blueprint (this BNE
                        \ is effectively a JMP as the high byte of the dodo
                        \ blueprint address is never zero)

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
 CMP #'B'               \ proc3, as this file contains the dodo space station
 BEQ proc3              \ and we want to save the blueprint address before
                        \ processing the blueprint

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

\ ******************************************************************************
\
\       Name: SetEdgesOffset
\       Type: Subroutine
\   Category: Loader
\    Summary: Calculate the edges offset within sideways RAM for the blueprint
\             we are processing and set it in bytes #3 and #16 of the blueprint
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The blueprint number to process (0 to 30)
\
\   Y                   The offset within the XX21 table for blueprint X
\
\   P(1 0)              The address of the ship blueprint in the loaded ship
\                       blueprint file
\
\   ZP(1 0)             The address in sideways RAM where we are storing the
\                       ship blueprint that we are processing
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   X                   X is preserved
\
\   Y                   Y is preserved
\
\ ******************************************************************************

.SetEdgesOffset

 TYA                    \ Store X and Y on the stack so we can preserve them
 PHA                    \ through the subroutine
 TXA
 PHA

                        \ We start by calculating the following:
                        \
                        \   (U T) = P(1 0) + offset to the edges data
                        \
                        \ where the offset to the edges data is stored in bytes
                        \ #3 and #16 of the blueprint at P(1 0)
                        \
                        \ So (U T) will be the address of the edges data for
                        \ blueprint X within the loaded blueprints file

 CLC                    \ Clear the C flag for the following addition

 LDY #3                 \ Set A to byte #3 of the ship blueprint, which contains
 LDA (P),Y              \ the low byte of the offset to the edges data

 ADC P                  \ Set T = A + P
 STA T                  \
                        \ so this adds the low bytes of the calculation

 LDY #16                \ Set A to byte #16 of the ship blueprint, which
 LDA (P),Y              \ contains the high byte of the offset to the edges data

 ADC P+1                \ Set U = A + P+1
 STA U                  \
                        \ so this adds the high bytes of the calculation

 LDY #0                 \ We now step through the addresses in the XX21 table,
                        \ so set an address counter in Y, which we will
                        \ increment by 2 for each iteration (I will refer to
                        \ the address at index Y as the Y-th address, to keep
                        \ things simple)

 LDX #0                 \ We will store the blueprint number that contains the
                        \ edges data in X, so initialise it to zero

 LDA #LO(XX21)          \ Set V(1 0) to the address of the XX21 table in the
 STA V                  \ loaded blueprints file, which is the address of the
 LDA #HI(XX21)          \ start of the blueprints file (as XX21 is the first
 STA V+1                \ bit of data in the file)

.edge1

 LDA XX21,Y             \ If the Y-th address in XX21 >= (U T), jump to edge3 to
 CMP T                  \ move on to the next address in XX21
 LDA XX21+1,Y
 SBC U
 BCS edge3

.edge2

 LDA XX21,Y             \ If the Y-th address in XX21 < V(1 0), jump to edge3 to
 CMP V                  \ move on to the next address in XX21
 LDA XX21+1,Y
 SBC V+1
 BCC edge3

                        \ If we get here then the address in the Y-th entry in
                        \ XX21 is between V(1 0) and (U T), so it's between the
                        \ start of the loaded file and the edges data
                        \
                        \ We now store the entry number (in Y) in X, and update
                        \ V(1 0) so it contains the Y-th entry in XX21, as this
                        \ entry in the blueprints file contains the edges data

 LDA XX21,Y             \ Set V(1 0) to the Y-th address in XX21
 STA V
 LDA XX21+1,Y
 STA V+1

 TYA                    \ Set X = Y
 TAX

.edge3

 INY                    \ Increment the address counter in Y to point to the
 INY                    \ next address in XX21

 CPY #31 * 2            \ Loop back until we have worked our way through the
 BNE edge1              \ whole table

                        \ At this point, X is the number of the blueprint within
                        \ the loaded blueprint file that contains the edges data
                        \ for the blueprint we are processing, and (U T)
                        \ contains the address of the edges data for the
                        \ blueprint we are processing
                        \
                        \ We now use these valus to calculate the offset for the
                        \ edges data within sideways RAM
                        \
                        \ First, we take the address in (U T), which is an
                        \ address within the X-th blueprint in the loaded ship
                        \ blueprint file, and convert it to the equivalent
                        \ address within the sideways RAM blueprints
                        \
                        \ We can do this by subtracting the address of the X-th
                        \ blueprint in the loaded ship file, and adding the
                        \ address of the X-th blueprint in sideways RAM

 SEC                    \ Set (U T) = (U T) - the X-th address in XX21
 LDA T
 SBC XX21,X
 STA T
 LDA U
 SBC XX21+1,X
 STA U

 CLC                    \ Set (U T) = (U T) + the X-th address in ROM_XX21
 LDA ROM_XX21,X
 ADC T
 STA T
 LDA ROM_XX21+1,X
 ADC U
 STA U

                        \ We now have the address of the edges data in sideways
                        \ RAM in (U T), so we can convert this to an offset by
                        \ subtracting the address of the start of the blueprint
                        \ we are storing, which is in ZP(1 0)

 SEC                    \ Set the edges data offset in bytes #3 and #16 in the
 LDA T                  \ blueprint in sideways RAM to the following:
 SBC ZP                 \
 LDY #3                 \   (U T) - ZP(1 0)
 STA (P),Y
 LDA U
 SBC ZP+1
 LDY #16
 STA (P),Y

 PLA                    \ Restore X and Y from the stack so they are preserved
 TAX                    \ through the subroutine
 PLA
 TAY

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: TestBBC
\       Type: Subroutine
\   Category: Loader
\    Summary: Fetch details on all the ROMs in the BBC Micro (i.e. the host) and
\             populate the sram%, used%, dpl% and eliterom% variables
\
\ ******************************************************************************

.TestBBC

 LDA &F4
 PHA
 LDX #15

.tbbc1

 STX &F4
 STX VIA+&30
 LDA ROM+6
 PHA
 EOR #&01
 STA ROM+6
 CMP ROM+6
 BNE tbbc2
 DEC sram%,X

.tbbc2

 PLA
 STA ROM+6

 LDY ROM+7
 LDX #&FC

.tbbc3

 LDA romMatch-&F2,X
 CMP ROM,Y
 BNE tbbc4
 INY
 INX
 BNE tbbc3
 LDX &F4
 DEC used%,X
 JMP tbbc5

.tbbc4

 LDX &F4
 TXA
 ORA #&F0
 STA ROM

.tbbc5

 BIT eliterom%
 BPL tbbc7
 LDY #&F2

.tbbc6

 LDA romMatch-&F2,Y
 CMP romTitle-&F2,Y
 BNE tbbc7
 INY
 BNE tbbc6
 STX eliterom%

.tbbc7

 TXA
 LDY #&10

.tbbc8

 STX &F4
 STX VIA+&30
 DEY
 TYA
 CMP &F4
 BEQ tbbc10
 TYA
 EOR #&FF
 STA &F6
 LDA #&7F
 STA &F7

.tbbc9

 STX &F4
 STX VIA+&30
 LDA (&F6),Y
 STY &F4
 STY VIA+&30
 CMP (&F6),Y
 BNE tbbc8
 INC &F6
 BNE tbbc9
 INC &F7
 LDA &F7
 CMP #&84
 BNE tbbc9

.tbbc10

 TYA
 STA dupl%,X
 DEX
 BMI tbbc11
 JMP tbbc1

.tbbc11

 PLA
 STA &F4
 STA VIA+&30
 RTS

\ ******************************************************************************
\
\       Name: TestPro
\       Type: Subroutine
\   Category: Loader
\    Summary: Test whether we are running this on a co-processor
\
\ ******************************************************************************

.TestPro

 LDA #0
 DEC A
 STA proflag%
 RTS

\ ******************************************************************************
\
\       Name: romMatch
\       Type: Variable
\   Category: Loader
\    Summary: The start copyright string from the Elite ROM, used to check
\             whether the ROM is already installed in a ROM bank
\
\ ******************************************************************************

.romMatch

 EQUS "SRAM ELITE"      \ The ROM title

 EQUB 0                 \ NULL and "(C)", required for the MOS to recognise the
 EQUS "(C)"             \ ROM

\ ******************************************************************************
\
\       Name: osfileBlock
\       Type: Variable
\   Category: Loader
\    Summary: OSFILE configuration block for loading a ship blueprint file
\
\ ******************************************************************************

.osfileBlock

 EQUW shipFilename      \ The address of the filename to load

 EQUD &FFFF0000 + XX21  \ Load address of the file

 EQUD &00000000         \ Execution address (not used when loading a file)

 EQUD &00000000         \ Start address (not used when loading a file)

 EQUD &00000000         \ End address (not used when loading a file)

\ ******************************************************************************
\
\       Name: shipFilename
\       Type: Variable
\   Category: Loader
\    Summary: The filename of the ship blueprint file to load with OSFILE
\
\ ******************************************************************************

.shipFilename

 EQUS "D.MOA"
 EQUB 13

\ ******************************************************************************
\
\       Name: ROMheader
\       Type: Variable
\   Category: Loader
\    Summary: The ROM header code that gets copied to &8000 to create a sideways
\             RAM image containing the ship blueprint files
\
\ ******************************************************************************

.ROMheader

 CLEAR &7C00, &7C00     \ Clear the guard we set above so we can assemble into
                        \ the sideways ROM part of memory

 ORG &8000              \ Set the assembly address for sideways RAM

\ ******************************************************************************
\
\       Name: ROM
\       Type: Variable
\   Category: Loader
\    Summary: The ROM header code that forms the first part of the sideways RAM
\             image containing the ship blueprint files
\
\ ******************************************************************************

.ROM

 JMP srom1              \ Language entry point

 JMP srom1              \ Service entry point

 EQUB %10000001         \ The ROM type:
                        \
                        \   * Bit 7 set = ROM contains a service entry
                        \
                        \   * Bits 0-3 = ROM CPU type (1 = Turbo6502)

 EQUB romCopy - ROM     \ Offset to copyright string

 EQUB 0                 \ Version number

.romTitle

 EQUS "SRAM ELITE"      \ The ROM title

.romCopy

 EQUB 0                 \ NULL and "(C)", required for the MOS to recognise the
 EQUS "(C)Acornsoft"    \ ROM
 EQUB 0

.srom1

 RTS                    \ Return from the subroutine, so the language and
                        \ service entry points do nothing

\ ******************************************************************************
\
\       Name: FileHandler
\       Type: Subroutine
\   Category: Loader
\    Summary: The custom file handler that checks whether OSFILE is loading a
\             ship blueprint file and if so, redirects the load to sideways RAM
\
\ ******************************************************************************

.FileHandler

 PHA
 STX &F0
 STY &F1
 LDY #&00
 LDA (&F0),Y
 STA &F2
 INY
 LDA (&F0),Y
 STA &F3

 LDY #5

.file1

 LDA filenamePattern,Y
 BEQ file2
 CMP (&F2),Y
 BNE file5

.file2

 DEY
 BPL file1
 INY

.file3

 LDA ROM_XX21,Y
 STA XX21,Y
 INY
 BNE file3

 LDY #&04
 LDA (&F2),Y
 AND #&01
 BEQ file4

 LDA dodoStationAddr
 STA XX21+2
 LDA dodoStationAddr+1
 STA XX21+3

.file4

 TSX
 LDA &F4
 STA XX3+4,X
 STA LANGROM
 LDX &F0
 LDY &F1
 PLA
 RTS

.file5

 LDX &F0
 LDY &F1
 PLA
 JMP (IND1V)

\ ******************************************************************************
\
\       Name: filenamePattern
\       Type: Variable
\   Category: Loader
\    Summary: The filename pattern for which we intercept OSFILE to return the
\             ship blueprints from sideways RAM
\
\ ******************************************************************************

.filenamePattern

 EQUS "D.MO"
 EQUB 0
 EQUB 13

\ ******************************************************************************
\
\       Name: dodoStationAddr
\       Type: Variable
\   Category: Loader
\    Summary: The address in sideways RAM of the ship blueprint for the dodo
\             space station
\
\ ******************************************************************************

.dodoStationAddr

 SKIP 2

 COPYBLOCK ROM, P%, ROMheader

 ORG ROMheader + P% - ROM

\ ******************************************************************************
\
\ Save MNUCODE.bin
\
\ ******************************************************************************

 PRINT "T.MNUCODE ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
 SAVE "versions/disc/3-assembled-output/MNUCODE.bin", CODE%, P%, LOAD%