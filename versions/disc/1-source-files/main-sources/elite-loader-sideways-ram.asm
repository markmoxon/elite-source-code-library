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

 XX21 = &5600           \ The address of the ship blueprints lookup table, where
                        \ the chosen ship blueprints file is loaded

 XX21_ROM = &8100       \ The address of the ship blueprints lookup table in the
                        \ sideways RAM image that we build

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
\       Name: L7400
\       Type: Variable
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

.L7400

 SKIP 16

\ ******************************************************************************
\
\       Name: L7410
\       Type: Variable
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

.L7410

 SKIP 16

\ ******************************************************************************
\
\       Name: L7420
\       Type: Variable
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

.L7420

 SKIP 16

\ ******************************************************************************
\
\       Name: L7430
\       Type: Variable
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

.L7430

 EQUB &FF

\ ******************************************************************************
\
\       Name: L7431
\       Type: Variable
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

.L7431

 SKIP 1

\ ******************************************************************************
\
\       Name: Entry points
\       Type: Subroutine
\   Category: Loader
\    Summary: ???
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
\    Summary: ???
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
 STA XX21_ROM,Y
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
\ ******************************************************************************

.proc1

 STA XX21_ROM+1,Y
 LDA P
 STA XX21_ROM,Y

.proc2

 RTS                    \ Return from the subroutine

.proc3

 LDA XX21_ROM,Y
 STA dodoStationAddr
 LDA XX21_ROM+1,Y
 STA dodoStationAddr+1
 BNE proc5

.ProcessBlueprint

 TXA                    \ Set Y = X * 2
 ASL A
 TAY

 LDA XX21+1,Y
 BEQ proc2

 CPX #1
 BNE proc4

 LDA shipFilename+4
 CMP #'B'
 BEQ proc3

.proc4

 LDA XX21_ROM+1,Y
 BNE proc2

.proc5

 LDA ZP
 STA XX21_ROM,Y
 LDA ZP+1
 STA XX21_ROM+1,Y
 LDA XX21+(31*2),X
 STA XX21_ROM+(31*2),X
 LDA XX21,Y
 STA P
 LDA XX21+1,Y
 STA Q
 CMP #&56
 BCC proc1
 CMP #&60
 BCS proc1
 JSR L75B1
 LDA #&00
 STA R
 TAY
 LDA #&60
 STA S

.proc6

 LDA P
 CMP XX21,Y
 LDA Q
 SBC XX21+1,Y
 BCS proc7
 LDA XX21,Y
 CMP R
 LDA XX21+1,Y
 SBC S
 BCS proc7
 LDA XX21,Y
 STA R
 LDA XX21+1,Y
 STA S

.proc7

 INY
 INY
 CPY #31 * 2
 BNE proc6
 LDY #&00

.proc8

 LDA (P),Y
 STA (ZP),Y
 INC P
 BNE proc9
 INC Q

.proc9

 INC ZP
 BNE proc10
 INC ZP+1

.proc10

 LDA P
 CMP R
 BNE proc8
 LDA Q
 CMP S
 BNE proc8
 RTS

\ ******************************************************************************
\
\       Name: L75B1
\       Type: Subroutine
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

.L75B1

 TYA
 PHA
 TXA
 PHA
 CLC
 LDY #3
 LDA (P),Y
 ADC P
 STA T
 LDY #&10
 LDA (P),Y
 ADC Q
 STA U
 LDY #0
 LDX #0
 LDA #LO(XX21)
 STA V
 LDA #HI(XX21)
 STA V+1

.L75D2

 LDA XX21,Y
 CMP T
 LDA XX21+1,Y
 SBC U
 BCS L75F6

.L75DE

 LDA XX21,Y
 CMP V
 LDA XX21+1,Y
 SBC V+1
 BCC L75F6
 LDA XX21,Y
 STA V
 LDA XX21+1,Y
 STA V+1
 TYA
 TAX

.L75F6

 INY
 INY
 CPY #31 * 2
 BNE L75D2
 SEC
 LDA T
 SBC XX21,X
 STA T
 LDA U
 SBC XX21+1,X
 STA U
 CLC
 LDA XX21_ROM,X
 ADC T
 STA T
 LDA XX21_ROM+1,X
 ADC U
 STA U
 SEC
 LDA T
 SBC ZP
 LDY #3
 STA (P),Y
 LDA U
 SBC ZP+1
 LDY #16
 STA (P),Y
 PLA
 TAX
 PLA
 TAY
 RTS

\ ******************************************************************************
\
\       Name: TestBBC
\       Type: Subroutine
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

.TestBBC

 LDA &F4
 PHA
 LDX #&0F

.tbbc1

 STX &F4
 STX VIA+&30
 LDA ROM+6
 PHA
 EOR #&01
 STA ROM+6
 CMP ROM+6
 BNE tbbc2
 DEC L7400,X

.tbbc2

 PLA
 STA ROM+6
 LDY ROM+7
 LDX #&FC

.tbbc3

 LDA L75DE,X
 CMP ROM,Y
 BNE tbbc4
 INY
 INX
 BNE tbbc3
 LDX &F4
 DEC L7410,X
 JMP tbbc5

.tbbc4

 LDX &F4
 TXA
 ORA #&F0
 STA ROM

.tbbc5

 BIT L7430
 BPL tbbc7
 LDY #&F2

.tbbc6

 LDA L75DE,Y
 CMP &7F17,Y
 BNE tbbc7
 INY
 BNE tbbc6
 STX L7430

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
 STA L7420,X
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
\    Summary: ???
\
\ ******************************************************************************

.TestPro

 LDA #0
 DEC A
 STA L7431
 RTS

 EQUB &53, &52          \ These bytes appear to be unused
 EQUB &41, &4D
 EQUB &20, &45
 EQUB &4C, &49
 EQUB &54, &45
 EQUB &00, &28
 EQUB &43, &29

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

 EQUB %10000001         \ ROM type:
                        \
                        \   * Bit 7 set = ROM contains a service entry
                        \
                        \   * Bits 0-3 = ROM CPU type (1 = Turbo6502)

 EQUB copyright - ROM   \ Offset to copyright string

 EQUB 0                 \ Version number

 EQUS "SRAM ELITE"      \ ROM title

.copyright

 EQUB 0                 \ NULL and "(C)", required for the MOS to recognise the
 EQUS "(C)Acornsoft"    \ ROM, followed by autho name
 EQUB 0

.srom1

 RTS                    \ Return from the subroutine, so the language and
                        \ service entry points do nothing

\ ******************************************************************************
\
\       Name: FileHandler
\       Type: Subroutine
\   Category: Loader
\    Summary: ???
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

 LDA XX21_ROM,Y
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