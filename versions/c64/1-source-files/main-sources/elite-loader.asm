\ ******************************************************************************
\
\ COMMODORE 64 ELITE LOADER FILE
\
\ Commodore 64 Elite was written by Ian Bell and David Braben and is copyright
\ D. Braben and I. Bell 1985
\
\ The code on this site is identical to the source disks released on Ian Bell's
\ personal website at http://www.elitehomepage.org/ (it's just been reformatted
\ to be more readable)
\
\ The commentary is copyright Mark Moxon, and any misunderstandings or mistakes
\ in the documentation are entirely my fault
\
\ The terminology and notations used in this commentary are explained at
\ https://elite.bbcelite.com/terminology
\
\ The deep dive articles referred to in this commentary can be found at
\ https://elite.bbcelite.com/deep_dives
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * COMLOD.unprot.bin
\
\ after reading in the following files:
\
\   * LODATA.bin
\   * SHIPS.bin
\   * CODIALS.bin
\   * SPRITE.bin
\   * DATE4.bin
\
\ ******************************************************************************

 INCLUDE "versions/c64/1-source-files/main-sources/elite-build-options.asm"

 _CASSETTE_VERSION      = (_VERSION = 1)
 _DISC_VERSION          = (_VERSION = 2)
 _6502SP_VERSION        = (_VERSION = 3)
 _MASTER_VERSION        = (_VERSION = 4)
 _ELECTRON_VERSION      = (_VERSION = 5)
 _ELITE_A_VERSION       = (_VERSION = 6)
 _NES_VERSION           = (_VERSION = 7)
 _C64_VERSION           = (_VERSION = 8)
 _APPLE_VERSION         = (_VERSION = 9)
 _GMA85_NTSC            = (_VARIANT = 1)
 _GMA86_PAL             = (_VARIANT = 2)
 _GMA_RELEASE           = (_VARIANT = 1) OR (_VARIANT = 2)
 _SOURCE_DISK_BUILD     = (_VARIANT = 3)
 _SOURCE_DISK_FILES     = (_VARIANT = 4)
 _SOURCE_DISK           = (_VARIANT = 3) OR (_VARIANT = 4)

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

 CODE% = &4000          \ The address where the code will be run

 LOAD% = &4000          \ The address where the code will be loaded

 KEY3 = &8E             \ The seed for decrypting COMLOD from U% to V%, which is
                        \ the second block of data, after the decryption routine

 KEY4 = &6C             \ The seed for decrypting COMLOD from W% to X%, which is
                        \ the first block of data, before the decryption routine

 L1 = &0001             \ The 6510 input/output port register, which we can use
                        \ to configure the Commodore 64 memory layout (see page
                        \ 260 of the Programmer's Reference Guide)

 SCBASE = &4000         \ The address of the screen bitmap

IF _GMA_RELEASE

 DSTORE% = SCBASE + &AF90       \ The address of a copy of the dashboard bitmap,
                                \ which gets copied into screen memory when
                                \ setting up a new screen

 SPRITELOC% = SCBASE + &2800    \ The address where the sprite bitmaps get
                                \ copied to during the loading process

ELIF _SOURCE_DISK

 DSTORE% = SCBASE + &2800       \ The address of a copy of the dashboard bitmap,
                                \ which gets copied into screen memory when
                                \ setting up a new screen

 SPRITELOC% = SCBASE + &3100    \ The address where the sprite bitmaps get
                                \ copied to during the loading process

ENDIF

 D% = &D000             \ The address where the ship data will be loaded
                        \ (i.e. XX21)

 VIC = &D000            \ Registers for the VIC-II video controller chip, which
                        \ are memory-mapped to the 46 bytes from &D000 to &D02E
                        \ (see page 454 of the Programmer's Reference Guide)

 COLMEM = &D800         \ Colour RAM, which is used (along with screen RAM) to
                        \ define the colour map of the dashboard in multicolour
                        \ bitmap mode

 CIA = &DC00            \ Registers for the CIA1 I/O interface chip, which
                        \ are memory-mapped to the 16 bytes from &DC00 to &DC0F
                        \ (see page 428 of the Programmer's Reference Guide)

 CIA2 = &DD00           \ Registers for the CIA2 I/O interface chip, which
                        \ are memory-mapped to the 16 bytes from &DD00 to &DD0F
                        \ (see page 428 of the Programmer's Reference Guide)

INCLUDE "library/c64/loader/workspace/zp.asm"

\ ******************************************************************************
\
\ ELITE LOADER
\
\ ******************************************************************************

 ORG CODE%

INCLUDE "library/c64/loader/variable/w_per_cent.asm"
INCLUDE "library/c64/loader/variable/lodata.asm"
INCLUDE "library/c64/loader/variable/ships.asm"

IF _GMA_RELEASE

 EQUB &1F, &3F          \ These bytes appear to be unused and just contain
 EQUB &58               \ random workspace noise left over from the BBC Micro
                        \ assembly process

ELIF _SOURCE_DISK_BUILD

 EQUB &B3, &1F, &3F, &58, &98, &A0, &40, &20   \ These bytes appear to be
 EQUB &1F, &F0, &8C, &98, &1A, &46, &10, &8C   \ unused and just contain random
 EQUB &CF, &3C, &B2, &CF, &C2, &7D, &FF, &2A   \ workspace noise left over from
 EQUB &92, &AB, &A8, &BD, &3E, &85, &9E, &19   \ the BBC Micro assembly process
 EQUB &85, &F5, &3A, &EF, &06, &E6, &E4, &04
 EQUB &07, &E7, &E5, &EA, &AA, &2E, &98, &2F
 EQUB &10, &F0, &E2, &02, &12, &F2, &E3, &03
 EQUB &DA, &BA, &E4, &04, &DB, &BB, &E5, &19
 EQUB &39, &85, &25, &2E, &98, &3A, &BB, &B0
 EQUB &12, &13, &03, &E3, &F3, &F2, &E2, &7D
 EQUB &1A, &B2, &5D, &02, &E2, &F0, &10, &03
 EQUB &E3, &F2, &8D, &1A, &B2, &40, &78, &2F
 EQUB &E4, &01, &2C, &ED, &E3, &21, &2B, &5C
 EQUB &52, &22, &A8, &CB, &07, &2E, &DB, &BB
 EQUB &E5, &05, &DC, &BC

ELIF _SOURCE_DISK_FILES

 EQUB &38, &E0, &60, &3F, &0F, &7C, &24, &B2   \ These bytes appear to be
 EQUB &60, &56, &9C, &67, &23, &FA, &81, &91   \ unused and just contain random
 EQUB &3F, &7C, &29, &BC, &3D, &53, &65, &FB   \ workspace noise left over from
 EQUB &C3, &23, &B7, &9E, &7A, &2F, &29, &F5   \ the BBC Micro assembly process
 EQUB &EC, &CA, &E8, &0B, &EE, &CC, &CF, &94
 EQUB &D8, &C6, &C7, &3F, &00, &D2, &E4, &14
 EQUB &04, &D5, &E6, &DD, &94, &9E, &E8, &DF
 EQUB &96, &A0, &FE, &52, &BE, &AA, &53, &C6
 EQUB &D2, &F5, &6B, &C2, &25, &16, &E6, &D6
 EQUB &E5, &D4, &5F, &A3, &E5, &1D, &60, &E4
 EQUB &D2, &00, &13, &E6, &D5, &7F, &B3, &E5
 EQUB &00, &B9, &A7, &13, &E5, &2D, &19, &D0
 EQUB &04, &4C, &87, &AE, &74, &CA, &73, &D2
 EQUB &35, &09, &96, &A0, &EA, &E1, &98, &A2
 EQUB &66, &AE, &C6, &04

ENDIF

INCLUDE "library/c64/loader/variable/x_per_cent.asm"
INCLUDE "library/c64/loader/variable/frin.asm"
INCLUDE "library/c64/loader/subroutine/elite_loader_part_1_of_7.asm"
INCLUDE "library/c64/loader/subroutine/deeors.asm"
INCLUDE "library/c64/loader/subroutine/elite_loader_part_2_of_7.asm"
INCLUDE "library/c64/loader/subroutine/elite_loader_part_3_of_7.asm"
INCLUDE "library/c64/loader/subroutine/elite_loader_part_4_of_7.asm"
INCLUDE "library/c64/loader/subroutine/elite_loader_part_5_of_7.asm"
INCLUDE "library/c64/loader/subroutine/elite_loader_part_6_of_7.asm"
INCLUDE "library/c64/loader/subroutine/elite_loader_part_7_of_7.asm"
INCLUDE "library/c64/loader/subroutine/mvblock.asm"
INCLUDE "library/c64/loader/subroutine/mvsm.asm"
INCLUDE "library/c64/loader/variable/sdump.asm"

IF _GMA_RELEASE

 EQUB &60, &D3          \ These bytes appear to be unused and just contain
 EQUB &66, &1D          \ random workspace noise left over from the BBC Micro
 EQUB &A0, &40          \ assembly process
 EQUB &B3, &D3

ELIF _SOURCE_DISK_BUILD

 EQUB &B4, &48          \ These bytes appear to be unused and just contain
 EQUB &9F, &CD          \ random workspace noise left over from the BBC Micro
 EQUB &EA, &11          \ assembly process
 EQUB &F1, &19

ELIF _SOURCE_DISK_FILES

 EQUB &99, &02          \ These bytes appear to be unused and just contain
 EQUB &E5, &6B          \ random workspace noise left over from the BBC Micro
 EQUB &26, &B9          \ assembly process
 EQUB &37, &D7

ENDIF

INCLUDE "library/c64/loader/variable/cdump.asm"

IF _GMA_RELEASE

 EQUB &8D, &18          \ These bytes appear to be unused and just contain
 EQUB &8F, &50          \ random workspace noise left over from the BBC Micro
 EQUB &46, &7E          \ assembly process
 EQUB &A4, &F4

ELIF _SOURCE_DISK_BUILD

 EQUB &B3, &56          \ These bytes appear to be unused and just contain
 EQUB &2B, &6B          \ random workspace noise left over from the BBC Micro
 EQUB &74, &D4          \ assembly process
 EQUB &D8, &FF

ELIF _SOURCE_DISK_FILES

 EQUB &00, &FB          \ These bytes appear to be unused and just contain
 EQUB &0E, &F3          \ random workspace noise left over from the BBC Micro
 EQUB &79, &7D          \ assembly process
 EQUB &48, &96

ENDIF

INCLUDE "library/c64/loader/variable/spritp.asm"

IF _GMA_RELEASE

 EQUB &38, &35, &25, &67, &FA, &B5, &A5, &A2   \ These bytes appear to be
 EQUB &22, &C1, &DF, &EB, &77, &CE, &F4, &07   \ unused and just contain random
 EQUB &37, &CF, &33, &4D, &A5, &89, &76, &CD   \ workspace noise left over from
 EQUB &6D, &69, &8D, &56, &CD, &94, &98, &F6   \ the BBC Micro assembly process
 EQUB &B8, &CE, &14, &13, &D1, &98, &CE, &B1
 EQUB &77, &CE, &F4, &1C, &B1, &40, &68, &30
 EQUB &87, &CD, &A9, &90, &B2, &08, &C1, &DB
 EQUB &CF, &33, &49, &80, &6B, &CA, &3A, &CF

ELIF _SOURCE_DISK_BUILD

 EQUB &97, &F3, &4F, &73, &B6, &DB, &39, &7A   \ These bytes appear to be
 EQUB &56, &EE, &F5, &D3, &4F, &E4, &C4, &F5   \ unused and just contain random
 EQUB &FE, &05, &D3, &4F, &68, &91, &3E, &F9   \ workspace noise left over from
 EQUB &00, &D3, &4F, &27, &53, &41, &F6, &FD   \ the BBC Micro assembly process
 EQUB &D6, &26, &CB, &24, &C5, &ED, &14, &3C
 EQUB &E9, &F0, &D3, &4F, &62, &8E, &41, &F1
 EQUB &F8, &D3, &4F, &30, &5F, &44, &05, &0C
 EQUB &D3, &4F, &68, &99, &A1, &CB, &B7, &34

ELIF _SOURCE_DISK_FILES

 EQUB &DC, &80, &1F, &87, &29, &80, &80, &E3   \ These bytes appear to be
 EQUB &8A, &42, &CE, &41, &9D, &20, &CB, &DC   \ unused and just contain random
 EQUB &44, &E3, &C8, &22, &33, &A8, &B9, &F3   \ workspace noise left over from
 EQUB &03, &D8, &22, &B7, &F9, &CF, &37, &F9   \ the BBC Micro assembly process
 EQUB &D3, &22, &76, &7A, &94, &37, &F3, &D3
 EQUB &FC, &F1, &EF, &E9, &B2, &01, &50, &25
 EQUB &D9, &C3, &22, &B1, &F0, &CF, &32, &E9
 EQUB &CB, &22, &7F, &8F, &A3, &49, &11, &48

ENDIF

INCLUDE "library/c64/loader/variable/date.asm"
INCLUDE "library/c64/loader/variable/dials.asm"

IF _GMA_RELEASE

 EQUB &F5               \ This byte appears to be unused and just contains
                        \ random workspace noise left over from the BBC Micro
                        \ assembly process

ELIF _SOURCE_DISK_BUILD

 EQUB &B2               \ This byte appears to be unused and just contains
                        \ random workspace noise left over from the BBC Micro
                        \ assembly process

ELIF _SOURCE_DISK_FILES

 EQUB &DB               \ This byte appears to be unused and just contains
                        \ random workspace noise left over from the BBC Micro
                        \ assembly process

ENDIF

INCLUDE "library/c64/loader/variable/v_per_cent.asm"

\ ******************************************************************************
\
\ Save COMLOD.unprot.bin
\
\ ******************************************************************************

 PRINT "P% = ", ~P%
 PRINT "S.C.COMLOD ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
 SAVE "versions/c64/3-assembled-output/COMLOD.unprot.bin", CODE%, P%, LOAD%

 PRINT "Addresses for the scramble routines in elite-checksum.py"
 PRINT "W% = ", ~W%
 PRINT "X% = ", ~X%
 PRINT "U% = ", ~U%
 PRINT "V% = ", ~V%
