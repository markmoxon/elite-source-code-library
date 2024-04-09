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

