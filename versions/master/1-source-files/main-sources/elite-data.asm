\ ******************************************************************************
\
\ BBC MASTER ELITE GAME DATA SOURCE
\
\ BBC Master Elite was written by Ian Bell and David Braben and is copyright
\ Acornsoft 1986
\
\ The code in this file has been reconstructed from a disassembly of the version
\ released on Ian Bell's personal website at http://www.elitehomepage.org/
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
\ This source file contains the game data for BBC Master Elite, including the
\ ship blueprints and game text.
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * BDATA.bin
\
\ after reading in the following file:
\
\   * P.DIALS2P.bin
\
\ ******************************************************************************

 INCLUDE "versions/master/1-source-files/main-sources/elite-build-options.asm"

 CPU 1                  \ Switch to 65SC12 assembly, as this code runs on a
                        \ BBC Master

 _CASSETTE_VERSION      = (_VERSION = 1)
 _DISC_VERSION          = (_VERSION = 2)
 _6502SP_VERSION        = (_VERSION = 3)
 _MASTER_VERSION        = (_VERSION = 4)
 _ELECTRON_VERSION      = (_VERSION = 5)
 _ELITE_A_VERSION       = (_VERSION = 6)
 _NES_VERSION           = (_VERSION = 7)
 _C64_VERSION           = (_VERSION = 8)
 _APPLE_VERSION         = (_VERSION = 9)
 _SNG47                 = (_VARIANT = 1)
 _COMPACT               = (_VARIANT = 2)
 _DISC_DOCKED           = FALSE
 _DISC_FLIGHT           = FALSE
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

 GUARD &C000            \ Guard against assembling over MOS memory

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

 CODE% = &7000          \ The address where the code will be run

 LOAD% = &1300          \ The address where the code will be loaded

 RE = &23               \ The obfuscation byte used to hide the recursive tokens
                        \ table from crackers viewing the binary code

 VE = &57               \ The obfuscation byte used to hide the extended tokens
                        \ table from crackers viewing the binary code

\ ******************************************************************************
\
\ ELITE GAME DATA SOURCE
\
\ ******************************************************************************

 ORG CODE%              \ Set the assembly address to CODE%

INCLUDE "library/master/data/variable/dashboard_image.asm"

 SKIP 256               \ These bytes appear to be unused, but they get moved to
                        \ &7E00-&7EFF along with the dashboard

\ ******************************************************************************
\
\ ELITE SHIP BLUEPRINTS FILE
\
\ ******************************************************************************

 SKIP 256               \ These bytes appear to be unused, but they get moved to
                        \ &7F00-&7FFF along with the ship blueprints and text
                        \ tokens

INCLUDE "library/common/main/variable/xx21.asm"
INCLUDE "library/advanced/main/variable/e_per_cent.asm"
INCLUDE "library/master/data/variable/kwl_per_cent.asm"
INCLUDE "library/master/data/variable/kwh_per_cent.asm"
INCLUDE "library/common/main/macro/vertex.asm"
INCLUDE "library/common/main/macro/edge.asm"
INCLUDE "library/common/main/macro/face.asm"
INCLUDE "library/common/main/variable/ship_missile.asm"
INCLUDE "library/common/main/variable/ship_coriolis.asm"
INCLUDE "library/common/main/variable/ship_escape_pod.asm"
INCLUDE "library/enhanced/main/variable/ship_plate.asm"
INCLUDE "library/common/main/variable/ship_canister.asm"
INCLUDE "library/enhanced/main/variable/ship_boulder.asm"
INCLUDE "library/common/main/variable/ship_asteroid.asm"
INCLUDE "library/enhanced/main/variable/ship_splinter.asm"
INCLUDE "library/enhanced/main/variable/ship_shuttle.asm"
INCLUDE "library/enhanced/main/variable/ship_transporter.asm"
INCLUDE "library/common/main/variable/ship_cobra_mk_3.asm"
INCLUDE "library/common/main/variable/ship_python.asm"
INCLUDE "library/enhanced/main/variable/ship_boa.asm"
INCLUDE "library/enhanced/main/variable/ship_anaconda.asm"
INCLUDE "library/advanced/main/variable/ship_rock_hermit.asm"
INCLUDE "library/common/main/variable/ship_viper.asm"
INCLUDE "library/common/main/variable/ship_sidewinder.asm"
INCLUDE "library/common/main/variable/ship_mamba.asm"
INCLUDE "library/enhanced/main/variable/ship_krait.asm"
INCLUDE "library/enhanced/main/variable/ship_adder.asm"
INCLUDE "library/enhanced/main/variable/ship_gecko.asm"
INCLUDE "library/enhanced/main/variable/ship_cobra_mk_1.asm"
INCLUDE "library/enhanced/main/variable/ship_worm.asm"
INCLUDE "library/enhanced/main/variable/ship_cobra_mk_3_p.asm"
INCLUDE "library/enhanced/main/variable/ship_asp_mk_2.asm"

 EQUB &45, &4D          \ These bytes appear to be unused
 EQUB &41, &36

INCLUDE "library/enhanced/main/variable/ship_python_p.asm"
INCLUDE "library/enhanced/main/variable/ship_fer_de_lance.asm"
INCLUDE "library/enhanced/main/variable/ship_moray.asm"
INCLUDE "library/common/main/variable/ship_thargoid.asm"
INCLUDE "library/common/main/variable/ship_thargon.asm"
INCLUDE "library/enhanced/main/variable/ship_constrictor.asm"
INCLUDE "library/advanced/main/variable/ship_cougar.asm"
INCLUDE "library/enhanced/main/variable/ship_dodo.asm"

\ ******************************************************************************
\
\ ELITE RECURSIVE TEXT TOKEN FILE
\
\ ******************************************************************************

IF _MATCH_ORIGINAL_BINARIES

 IF _SNG47

  EQUB &41, &44, &43, &23, &D7, &FB, &1F, &66   \ These bytes appear to be
  EQUB &2D, &94, &A9, &2A, &B5, &58, &48, &95   \ unused and just contain random
  EQUB &B6, &61, &6C, &8C, &E2, &A2, &86, &3E   \ workspace noise left over from
  EQUB &A0, &6E, &3D, &17, &80, &3B, &5C, &61   \ the BBC Micro assembly process
  EQUB &A8, &C9, &61, &A8, &C9, &61, &B7, &02
  EQUB &8B, &95, &B6, &8D, &98, &8C, &26, &9E
  EQUB &61, &28, &04, &3E, &89, &15, &E7, &A2
  EQUB &86, &18, &18, &40, &5F, &2A, &95, &30
  EQUB &65, &8F, &8F, &90, &55, &B3, &AB, &6C
  EQUB &EF, &3E, &5E, &EF, &54, &D3, &D5, &BC
  EQUB &73, &68, &F0, &55, &B3, &AB, &6C, &EF
  EQUB &3F, &5F, &F0, &55, &D3, &D5, &BC, &64
  EQUB &3A, &3F, &5E, &57, &37, &CF, &EF, &59
  EQUB &39, &D0, &F0, &5B, &3B, &D1, &EC, &B0
  EQUB &30, &73, &94, &4B, &D3, &0B, &F2, &66
  EQUB &D6, &CA, &EA, &E5, &C3, &EE, &D5, &0B
  EQUB &C6, &F8, &9E, &26, &20, &09, &CE, &AA
  EQUB &BF, &E3, &AD, &89, &C0, &DB, &A2, &22
  EQUB &4F, &70, &E1, &A5, &25, &4F, &70, &E1
  EQUB &A8, &B9, &EB, &83, &C9, &05, &DE, &E1
  EQUB &39, &EB, &BF, &DD, &E0, &39, &EB, &BF
  EQUB &DC, &DB, &FC, &1E, &1E, &98, &D7, &F0
  EQUB &DD, &1C, &0D, &AB, &BB, &FD, &ED, &AA
  EQUB &BA, &FC, &EC, &A9, &74, &1E, &E3, &29
  EQUB &8A, &FF, &1E, &EF, &6A, &61, &87, &04
  EQUB &E5, &2B, &8A, &FF, &1E, &F0, &6B, &87
  EQUB &AD, &CB, &00, &01, &00, &38, &E7, &2D
  EQUB &8A, &FF, &1E, &F1, &98, &B3, &AD, &EB
  EQUB &EF, &93, &C9, &05, &CF, &EF, &F0, &94
  EQUB &C9, &05, &D0, &F0, &F1, &95, &C9, &05
  EQUB &D1, &AC, &80, &AB, &CC, &EE, &DC, &33
  EQUB &A6, &A2, &20, &C0, &E1, &EE, &DE, &35
  EQUB &A6, &A5, &23, &C0, &E1, &EE, &E0, &37
  EQUB &A6, &A8, &10, &8F, &FF, &23, &A9, &6A
  EQUB &B3, &C9, &D5, &6B, &46, &3B, &B0, &1F
  EQUB &EF, &89, &A9, &A9, &A4, &92, &F8, &0B
  EQUB &75, &15, &C9, &4C, &1D, &5F, &0F, &A9
  EQUB &C9, &CA, &FE, &E9, &95, &AA, &C5, &A0
  EQUB &A5, &C9, &5D, &48, &68, &6A, &96, &A9
  EQUB &C9, &CA, &5E, &48, &68, &69, &95, &AA
  EQUB &CA, &CB, &5F, &C9, &15, &AB, &62, &02
  EQUB &F7, &59, &BD, &49, &74, &09, &DE, &2A
  EQUB &B5, &65, &DA, &60, &E4, &49, &25, &A2
  EQUB &A2, &A5, &70, &FB, &D0, &41, &BC, &54
  EQUB &79, &CA, &00, &20, &B1, &91, &FF, &1F
  EQUB &44, &BF, &54, &79, &EF, &4F, &B1, &71
  EQUB &DF, &FF, &FF, &04, &EF, &E0, &2B, &C0
  EQUB &95, &00, &1B, &A2, &B3, &E7, &FB, &40
  EQUB &4B, &D5, &8D, &39, &E7, &FB, &3F, &DA
  EQUB &78, &78, &80, &B9, &FC, &0C, &C5, &A1
  EQUB &24, &E9, &CF, &27, &4B, &29, &05, &26
  EQUB &46, &00, &65, &13, &89, &05, &41, &65
  EQUB &09, &E5, &2F, &B3, &89, &05, &37, &57
  EQUB &1A, &9F, &AF, &3C, &41, &D6, &3E, &4D
  EQUB &FD, &A3, &21, &40, &62, &D2, &E4, &FA
  EQUB &01, &7B, &23, &4D, &07, &FE, &4F, &2E
  EQUB &85, &A7, &E2, &A0, &20, &B3, &EF, &2A
  EQUB &35, &79, &B2, &A8, &28, &BF, &B2, &DC
  EQUB &CB, &F2, &1F, &CF, &C4, &D5, &E9, &61
  EQUB &49, &10, &F3, &23, &B8, &DA, &E2, &C0
  EQUB &D1, &E9, &28, &93, &AC, &89, &11, &C9
  EQUB &D8, &BC, &C5, &AB, &93, &C9, &42, &AA
  EQUB &BE, &AF, &C9, &DD, &2A, &4E, &D4, &9B
  EQUB &98, &A8, &C4, &D5, &E9, &41, &0D, &95
  EQUB &C9, &98, &0D, &F6, &4D, &0D, &0D, &91
  EQUB &D6, &4D, &64, &09, &72, &15, &22, &43
  EQUB &0F, &A5, &AC, &A7, &83, &8B, &90, &D2
  EQUB &ED, &DB, &7E, &ED, &DC, &7F, &ED, &DD
  EQUB &80, &ED, &DE, &81, &E8, &C4, &DD, &55
  EQUB &9C, &99, &99, &01, &B2, &E9, &D1, &35
  EQUB &9C, &88, &98, &02, &97, &2A, &4E, &CB
  EQUB &D2, &ED, &A7, &D2, &F1, &C9, &A5, &3C
  EQUB &59, &A2, &A5, &4B, &C6, &4C, &6F, &E5
  EQUB &A5, &A8, &4D, &C8, &4C, &6F, &E5, &A8
  EQUB &AB, &4F, &CA, &4C, &6F, &AB, &12, &4F
  EQUB &AB, &8B, &41, &02, &FF, &BF, &BF, &43
  EQUB &53, &D2, &B9, &C6, &DF, &CD, &94, &A2
  EQUB &5A, &68, &21

 ELIF _COMPACT

  EQUB &41, &44, &43, &23, &D7, &FC, &20, &66   \ These bytes appear to be
  EQUB &2D, &94, &A9, &2B, &B6, &58, &48, &95   \ unused and just contain random
  EQUB &B6, &61, &6C, &8C, &E2, &A2, &86, &3F   \ workspace noise left over from
  EQUB &A1, &6E, &3E, &18, &80, &3B, &5C, &61   \ the BBC Micro assembly process
  EQUB &A8, &C9, &61, &A8, &C9, &61, &EA, &35
  EQUB &8B, &95, &B6, &8D, &98, &8C, &26, &9F
  EQUB &62, &28, &04, &3F, &8A, &15, &E7, &A2
  EQUB &86, &19, &19, &41, &60, &2B, &96, &30
  EQUB &65, &90, &90, &91, &56, &B3, &AB, &6C
  EQUB &EF, &3F, &5F, &F0, &55, &D3, &D5, &BC
  EQUB &73, &68, &F1, &56, &B3, &AB, &6C, &EF
  EQUB &40, &60, &F1, &56, &D3, &D5, &BC, &64
  EQUB &3A, &40, &5F, &58, &38, &D0, &F0, &5A
  EQUB &3A, &D1, &F1, &5C, &3C, &D2, &ED, &B0
  EQUB &30, &73, &94, &4B, &D3, &0B, &F2, &66
  EQUB &D6, &CA, &EA, &E5, &C4, &EF, &D5, &0B
  EQUB &C7, &F9, &9E, &27, &21, &09, &CE, &AA
  EQUB &C0, &E4, &AD, &89, &C1, &DC, &A2, &22
  EQUB &4F, &70, &E1, &A5, &25, &4F, &70, &E1
  EQUB &A8, &B9, &EC, &84, &C9, &05, &DF, &E2
  EQUB &39, &EC, &C0, &DE, &E1, &39, &EC, &C0
  EQUB &DD, &DC, &FD, &1F, &1F, &99, &D7, &F0
  EQUB &DD, &1D, &0E, &AC, &BC, &FE, &EE, &AB
  EQUB &BB, &FD, &ED, &AA, &75, &1E, &E3, &29
  EQUB &8A, &00, &1F, &F0, &6B, &61, &87, &04
  EQUB &E5, &2B, &8A, &00, &1F, &F1, &6C, &87
  EQUB &AD, &CB, &01, &02, &01, &39, &E7, &2D
  EQUB &8A, &00, &1F, &F2, &99, &B3, &AD, &EB
  EQUB &F0, &94, &C9, &05, &D0, &F0, &F1, &95
  EQUB &C9, &05, &D1, &F1, &F2, &96, &C9, &05
  EQUB &D2, &AD, &80, &AB, &CC, &EE, &DC, &33
  EQUB &A6, &A2, &20, &C0, &E1, &EE, &DE, &35
  EQUB &A6, &A5, &23, &C0, &E1, &EE, &E0, &37
  EQUB &A6, &A8, &10, &8F, &00, &24, &A9, &6A
  EQUB &B3, &C9, &D5, &6C, &47, &3B, &B0, &20
  EQUB &F0, &8A, &AA, &AA, &A5, &92, &F8, &0C
  EQUB &76, &15, &CA, &4D, &1D, &60, &10, &AA
  EQUB &CA, &CB, &FF, &E9, &95, &AB, &C6, &A0
  EQUB &A5, &CA, &5E, &48, &68, &6A, &96, &AA
  EQUB &CA, &CB, &5F, &48, &68, &69, &95, &AB
  EQUB &CB, &CC, &60, &C9, &15, &AC, &63, &02
  EQUB &F7, &59, &BD, &4A, &75, &09, &DE, &2B
  EQUB &B6, &65, &DA, &61, &E5, &49, &25, &A3
  EQUB &A3, &A6, &71, &FB, &D0, &42, &BD, &54
  EQUB &79, &CA, &01, &21, &B2, &92, &00, &20
  EQUB &45, &C0, &54, &79, &EF, &4F, &B2, &72
  EQUB &E0, &00, &00, &05, &EF, &E1, &2C, &C0
  EQUB &95, &01, &1C, &A2, &B3, &E8, &FC, &41
  EQUB &4C, &D5, &8D, &39, &E8, &FC, &40, &DB
  EQUB &78, &78, &80, &C2, &05, &0C, &C5, &A1
  EQUB &25, &EA, &CF, &28, &4C, &29, &05, &27
  EQUB &47, &01, &66, &13, &89, &05, &42, &66
  EQUB &09, &E5, &30, &B4, &89, &05, &38, &58
  EQUB &1B, &A0, &AF, &3D, &42, &D6, &3E, &4D
  EQUB &FD, &A3, &21, &40, &62, &D2, &E4, &FA
  EQUB &02, &7C, &23, &4D, &07, &FE, &4F, &2E
  EQUB &85, &A7, &E2, &A0, &20, &B3, &EF, &2A
  EQUB &36, &7A, &B2, &A8, &28, &BF, &B2, &DC
  EQUB &CB, &F2, &1F, &CF, &C4, &D5, &EA, &62
  EQUB &49, &10, &F3, &23, &B8, &DA, &E2, &C0
  EQUB &D1, &EA, &29, &93, &AC, &89, &11, &CA
  EQUB &D9, &BC, &C5, &AB, &93, &CA, &43, &AA
  EQUB &BE, &AF, &CA, &DE, &2B, &4F, &D4, &9B
  EQUB &98, &A8, &C4, &D5, &EA, &42, &0D, &95
  EQUB &CA, &99, &0D, &F6, &4D, &0D, &0D, &91
  EQUB &D6, &4D, &64, &09, &72, &15, &39, &5A
  EQUB &0F, &A5, &AC, &A7, &83, &8C, &91, &D2
  EQUB &ED, &DC, &7F, &ED, &DD, &80, &ED, &DE
  EQUB &81, &ED, &DF, &82, &E8, &C4, &DD, &56
  EQUB &9D, &99, &99, &01, &B2, &EA, &D2, &36
  EQUB &9D, &88, &98, &02, &97, &2B, &4F, &CB
  EQUB &D2, &ED, &A7, &D2, &F1, &C9, &A5, &3D
  EQUB &5A, &A2, &A5, &4C, &C7, &4C, &6F, &E5
  EQUB &A5, &A8, &4E, &C9, &4C, &6F, &E5, &A8
  EQUB &AB, &50, &CB, &4C, &6F, &AB, &12, &4F
  EQUB &AC, &8C, &42, &03, &00, &C0, &C0, &44
  EQUB &53, &D2, &B9, &C6, &DF, &CD, &94, &A2
  EQUB &5A, &68, &2A

 ENDIF

ELSE

 SKIP 619               \ These bytes appear to be unused

ENDIF

INCLUDE "library/common/main/macro/char.asm"
INCLUDE "library/common/main/macro/twok.asm"
INCLUDE "library/common/main/macro/cont.asm"
INCLUDE "library/common/main/macro/rtok.asm"
INCLUDE "library/common/main/variable/qq18.asm"
INCLUDE "library/common/main/variable/sne.asm"
INCLUDE "library/common/main/variable/act.asm"

\ ******************************************************************************
\
\ ELITE EXTENDED TEXT TOKEN FILE
\
\ ******************************************************************************

.IANTOK

INCLUDE "library/enhanced/main/macro/ejmp.asm"
INCLUDE "library/enhanced/main/macro/echr.asm"
INCLUDE "library/enhanced/main/macro/etok.asm"
INCLUDE "library/enhanced/main/macro/etwo.asm"
INCLUDE "library/enhanced/main/macro/ernd.asm"
INCLUDE "library/enhanced/main/macro/tokn.asm"
INCLUDE "library/enhanced/main/variable/tkn1.asm"
INCLUDE "library/enhanced/main/variable/rupla.asm"
INCLUDE "library/enhanced/main/variable/rugal.asm"
INCLUDE "library/enhanced/main/variable/rutok.asm"

IF _MATCH_ORIGINAL_BINARIES

 IF _SNG47

  EQUS " \mutilate"     \ These bytes appear to be unused and just contain
  EQUS " from here"     \ random workspace noise left over from the BBC Micro
  EQUS " to F%"         \ assembly processs (this snippet looks like an assembly
  EQUB 13               \ language comment from the encryption process, which
  EQUB &0B, &B8         \ the authors presumably liked to call "mutilation")

 ELIF _COMPACT

  EQUS "\red herring"   \ These bytes appear to be unused and just contain
  EQUB 13               \ random workspace noise left over from the BBC Micro
  EQUB &0B              \ assembly processs (this snippet looks like an assembly
  EQUS ","              \ language comment from the encryption process, which
  EQUB &05              \ the authors presumably liked to call "mutilation",
  EQUS "\"              \ though this could also be a "red herring")
  EQUB 13
  EQUB &0B
  EQUS "T!.G% \mutilate"

 ENDIF

ELSE

 IF _SNG47

  SKIP 29               \ These bytes appear to be unused

 ELIF _COMPACT

  SKIP 34               \ These bytes appear to be unused

 ENDIF

ENDIF

\ ******************************************************************************
\
\ Save BDATA.unprot.bin
\
\ ******************************************************************************

 PRINT "S.BDATA ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
 SAVE "versions/master/3-assembled-output/BDATA.unprot.bin", CODE%, P%, LOAD%
