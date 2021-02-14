\ ******************************************************************************
\
\ BBC MASTER ELITE DATA FILE SOURCE
\
\ BBC Master Elite was written by Ian Bell and David Braben and is copyright
\ Acornsoft 1986
\
\ The code on this site has been disassembled from the version released on Ian
\ Bell's personal website at http://www.elitehomepage.org/
\
\ The commentary is copyright Mark Moxon, and any misunderstandings or mistakes
\ in the documentation are entirely my fault
\
\ The terminology and notations used in this commentary are explained at
\ https://www.bbcelite.com/about_site/terminology_used_in_this_commentary.html
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * output/BDATA.bin
\
\ ******************************************************************************

INCLUDE "versions/master/sources/elite-header.h.asm"

CPU 1                   \ Switch to 65SC12 assembly, as this code runs on a
                        \ BBC Master

_CASSETTE_VERSION       = (_VERSION = 1)
_DISC_VERSION           = (_VERSION = 2)
_6502SP_VERSION         = (_VERSION = 3)
_MASTER_VERSION         = (_VERSION = 4)
_DISC_DOCKED            = FALSE
_DISC_FLIGHT            = FALSE

VE = &57                \ The obfuscation byte used to hide the extended tokens
                        \ table from crackers viewing the binary code

CODE% = &7000
LOAD% = &1300

ORG CODE%

INCLUDE "library/master/data/variable/dashboard_image.asm"

SKIP 256                \ These bytes are unused, but they get moved to
                        \ &7E00-&7EFF along with the dashboard

SKIP 256                \ These bytes are unused, but they get moved to
                        \ &7F00-&7FFF along with the ship blueprints and text
                        \ tokens

INCLUDE "library/common/main/variable/xx21.asm"
INCLUDE "library/6502sp/main/variable/e_per_cent.asm"
INCLUDE "library/master/data/variable/tallyfrac.asm"
INCLUDE "library/master/data/variable/tallyint.asm"
INCLUDE "library/common/main/macro/vertex.asm"
INCLUDE "library/common/main/macro/edge.asm"
INCLUDE "library/common/main/macro/face.asm"
INCLUDE "library/common/main/variable/ship_missile.asm"
INCLUDE "library/common/main/variable/ship_coriolis.asm"
INCLUDE "library/common/main/variable/ship_escape_pod.asm"
INCLUDE "library/6502sp/main/variable/ship_plate.asm"
INCLUDE "library/common/main/variable/ship_canister.asm"
INCLUDE "library/6502sp/main/variable/ship_boulder.asm"
INCLUDE "library/common/main/variable/ship_asteroid.asm"
INCLUDE "library/6502sp/main/variable/ship_splinter.asm"
INCLUDE "library/6502sp/main/variable/ship_shuttle.asm"
INCLUDE "library/6502sp/main/variable/ship_transporter.asm"
INCLUDE "library/common/main/variable/ship_cobra_mk_iii.asm"
INCLUDE "library/common/main/variable/ship_python.asm"
INCLUDE "library/6502sp/main/variable/ship_boa.asm"
INCLUDE "library/6502sp/main/variable/ship_anaconda.asm"
INCLUDE "library/6502sp/main/variable/ship_rock_hermit.asm"
INCLUDE "library/common/main/variable/ship_viper.asm"
INCLUDE "library/common/main/variable/ship_sidewinder.asm"
INCLUDE "library/common/main/variable/ship_mamba.asm"
INCLUDE "library/6502sp/main/variable/ship_krait.asm"
INCLUDE "library/6502sp/main/variable/ship_adder.asm"
INCLUDE "library/6502sp/main/variable/ship_gecko.asm"
INCLUDE "library/6502sp/main/variable/ship_cobra_mk_i.asm"
INCLUDE "library/6502sp/main/variable/ship_worm.asm"
INCLUDE "library/6502sp/main/variable/ship_cobra_mk_iii_pirate.asm"
INCLUDE "library/6502sp/main/variable/ship_asp_mk_ii.asm"

 EQUB &45, &4D          \ This data appears to be unused
 EQUB &41, &36

INCLUDE "library/6502sp/main/variable/ship_python_pirate.asm"
INCLUDE "library/6502sp/main/variable/ship_fer_de_lance.asm"
INCLUDE "library/6502sp/main/variable/ship_moray.asm"
INCLUDE "library/common/main/variable/ship_thargoid.asm"
INCLUDE "library/common/main/variable/ship_thargon.asm"
INCLUDE "library/6502sp/main/variable/ship_constrictor.asm"
INCLUDE "library/6502sp/main/variable/ship_cougar.asm"
INCLUDE "library/6502sp/main/variable/ship_dodo.asm"

\ ******************************************************************************
\
\       Name: NOT_USED
\       Type: Variable
\   Category: Status
\    Summary: Probably not used, yet to confirm this
\
\ ******************************************************************************

.NOT_USED

 EQUB &41, &44, &43
 EQUB &23, &D7, &FB, &1F, &66, &2D, &94, &A9
 EQUB &2A, &B5, &58, &48, &95, &B6, &61, &6C
 EQUB &8C, &E2, &A2, &86, &3E, &A0, &6E, &3D
 EQUB &17, &80, &3B, &5C, &61, &A8, &C9, &61
 EQUB &A8, &C9, &61, &B7, &02, &8B, &95, &B6
 EQUB &8D, &98, &8C, &26, &9E, &61, &28, &04
 EQUB &3E, &89, &15, &E7, &A2, &86, &18, &18
 EQUB &40, &5F, &2A, &95, &30, &65, &8F, &8F
 EQUB &90, &55, &B3, &AB, &6C, &EF, &3E, &5E
 EQUB &EF, &54, &D3, &D5, &BC, &73, &68, &F0
 EQUB &55, &B3, &AB, &6C, &EF, &3F, &5F, &F0
 EQUB &55, &D3, &D5, &BC, &64, &3A, &3F, &5E
 EQUB &57, &37, &CF, &EF, &59, &39, &D0, &F0
 EQUB &5B, &3B, &D1, &EC, &B0, &30, &73, &94
 EQUB &4B, &D3, &0B, &F2, &66, &D6, &CA, &EA
 EQUB &E5, &C3, &EE, &D5, &0B, &C6, &F8, &9E
 EQUB &26, &20, &09, &CE, &AA, &BF, &E3, &AD
 EQUB &89, &C0, &DB, &A2, &22, &4F, &70, &E1
 EQUB &A5, &25, &4F, &70, &E1, &A8, &B9, &EB
 EQUB &83, &C9, &05, &DE, &E1, &39, &EB, &BF
 EQUB &DD, &E0, &39, &EB, &BF, &DC, &DB, &FC
 EQUB &1E, &1E, &98, &D7, &F0, &DD, &1C, &0D
 EQUB &AB, &BB, &FD, &ED, &AA, &BA, &FC, &EC
 EQUB &A9, &74, &1E, &E3, &29, &8A, &FF, &1E
 EQUB &EF, &6A, &61, &87, &04, &E5, &2B, &8A
 EQUB &FF, &1E, &F0, &6B, &87, &AD, &CB, &00
 EQUB &01, &00, &38, &E7, &2D, &8A, &FF, &1E
 EQUB &F1, &98, &B3, &AD, &EB, &EF, &93, &C9
 EQUB &05, &CF, &EF, &F0, &94, &C9, &05, &D0
 EQUB &F0, &F1, &95, &C9, &05, &D1, &AC, &80
 EQUB &AB, &CC, &EE, &DC, &33, &A6, &A2, &20
 EQUB &C0, &E1, &EE, &DE, &35, &A6, &A5, &23
 EQUB &C0, &E1, &EE, &E0, &37, &A6, &A8, &10
 EQUB &8F, &FF, &23, &A9, &6A, &B3, &C9, &D5
 EQUB &6B, &46, &3B, &B0, &1F, &EF, &89, &A9
 EQUB &A9, &A4, &92, &F8, &0B, &75, &15, &C9
 EQUB &4C, &1D, &5F, &0F, &A9, &C9, &CA, &FE
 EQUB &E9, &95, &AA, &C5, &A0, &A5, &C9, &5D
 EQUB &48, &68, &6A, &96, &A9, &C9, &CA, &5E
 EQUB &48, &68, &69, &95, &AA, &CA, &CB, &5F
 EQUB &C9, &15, &AB, &62, &02, &F7, &59, &BD
 EQUB &49, &74, &09, &DE, &2A, &B5, &65, &DA
 EQUB &60, &E4, &49, &25, &A2, &A2, &A5, &70
 EQUB &FB, &D0, &41, &BC, &54, &79, &CA, &00
 EQUB &20, &B1, &91, &FF, &1F, &44, &BF, &54
 EQUB &79, &EF, &4F, &B1, &71, &DF, &FF, &FF
 EQUB &04, &EF, &E0, &2B, &C0, &95, &00, &1B
 EQUB &A2, &B3, &E7, &FB, &40, &4B, &D5, &8D
 EQUB &39, &E7, &FB, &3F, &DA, &78, &78, &80
 EQUB &B9, &FC, &0C, &C5, &A1, &24, &E9, &CF
 EQUB &27, &4B, &29, &05, &26, &46, &00, &65
 EQUB &13, &89, &05, &41, &65, &09, &E5, &2F
 EQUB &B3, &89, &05, &37, &57, &1A, &9F, &AF
 EQUB &3C, &41, &D6, &3E, &4D, &FD, &A3, &21
 EQUB &40, &62, &D2, &E4, &FA, &01, &7B, &23
 EQUB &4D, &07, &FE, &4F, &2E, &85, &A7, &E2
 EQUB &A0, &20, &B3, &EF, &2A, &35, &79, &B2
 EQUB &A8, &28, &BF, &B2, &DC, &CB, &F2, &1F
 EQUB &CF, &C4, &D5, &E9, &61, &49, &10, &F3
 EQUB &23, &B8, &DA, &E2, &C0, &D1, &E9, &28
 EQUB &93, &AC, &89, &11, &C9, &D8, &BC, &C5
 EQUB &AB, &93, &C9, &42, &AA, &BE, &AF, &C9
 EQUB &DD, &2A, &4E, &D4, &9B, &98, &A8, &C4
 EQUB &D5, &E9, &41, &0D, &95, &C9, &98, &0D
 EQUB &F6, &4D, &0D, &0D, &91, &D6, &4D, &64
 EQUB &09, &72, &15, &22, &43, &0F, &A5, &AC
 EQUB &A7, &83, &8B, &90, &D2, &ED, &DB, &7E
 EQUB &ED, &DC, &7F, &ED, &DD, &80, &ED, &DE
 EQUB &81, &E8, &C4, &DD, &55, &9C, &99, &99
 EQUB &01, &B2, &E9, &D1, &35, &9C, &88, &98
 EQUB &02, &97, &2A, &4E, &CB, &D2, &ED, &A7
 EQUB &D2, &F1, &C9, &A5, &3C, &59, &A2, &A5
 EQUB &4B, &C6, &4C, &6F, &E5, &A5, &A8, &4D
 EQUB &C8, &4C, &6F, &E5, &A8, &AB, &4F, &CA
 EQUB &4C, &6F, &AB, &12, &4F, &AB, &8B, &41
 EQUB &02, &FF, &BF, &BF, &43, &53, &D2, &B9
 EQUB &C6, &DF, &CD, &94, &A2, &5A, &68, &21

INCLUDE "library/common/main/macro/char.asm"
INCLUDE "library/common/main/macro/twok.asm"
INCLUDE "library/common/main/macro/ctrl.asm"
INCLUDE "library/common/main/macro/rtok.asm"
INCLUDE "library/common/main/variable/qq18.asm"
INCLUDE "library/common/main/variable/sne.asm"
INCLUDE "library/common/main/variable/act.asm"
INCLUDE "library/6502sp/main/macro/ejmp.asm"
INCLUDE "library/6502sp/main/macro/echr.asm"
INCLUDE "library/6502sp/main/macro/etok.asm"
INCLUDE "library/6502sp/main/macro/etwo.asm"
INCLUDE "library/6502sp/main/macro/ernd.asm"
INCLUDE "library/6502sp/main/macro/tokn.asm"
INCLUDE "library/6502sp/main/variable/tkn1.asm"
INCLUDE "library/6502sp/main/variable/rupla.asm"
INCLUDE "library/6502sp/main/variable/rugal.asm"
INCLUDE "library/6502sp/main/variable/rutok.asm"

 EQUS " \mutilate"      \ These bytes appear to be unused and are presumably
 EQUS " from here"      \ workspace noise from the compilation process (it looks
 EQUS " to F%"          \ like an assembly language comment)
 EQUB 13
 EQUB &0B, &B8

\ ******************************************************************************
\
\ Save output/BDATA.unprot.bin
\
\ ******************************************************************************

PRINT "S.BDATA ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
SAVE "versions/master/output/BDATA.unprot.bin", CODE%, P%, LOAD%
