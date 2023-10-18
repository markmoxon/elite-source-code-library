\ ******************************************************************************
\
\       Name: iNES header
\       Type: Variable
\   Category: Start and end
\    Summary: The iNES header for running in an emulator
\
\ ******************************************************************************

 EQUS "NES"             \ Bytes #0 to #2 = identification string for iNES file

 EQUB &1A               \ Byte #3 = identification string terminator

 EQUB 8                 \ Byte #4 = 8 pages of 16K ROM = 128K

 EQUB 0                 \ Byte #5 = 0 = board uses CHR RAM

 EQUB %00010010         \ Byte #6 = mapper and WRAM configuration
                        \
                        \   * Bit 1 set = Cartridge contains battery-backed RAM
                        \                 at &6000 to &7FFF
                        \
                        \   * Bits 4-7 = mapper number, %0001 = MMC1

 EQUB 0                 \ Bytes #7 to #15 are zero and have no effect
 EQUD 0
 EQUD 0

