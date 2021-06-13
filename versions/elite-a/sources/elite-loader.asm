\ ******************************************************************************
\
\ ELITE-A LOADER SOURCE
\
\ Elite-A is an extended version of BBC Micro Elite by Angus Duggan
\
\ The original Elite was written by Ian Bell and David Braben and is copyright
\ Acornsoft 1984, and the extra code in Elite-A is copyright Angus Duggan
\
\ The code on this site is identical to Angus Duggan's source discs (it's just
\ been reformatted and variable names changed to be more readable)
\
\ The commentary is copyright Mark Moxon, and any misunderstandings or mistakes
\ in the documentation are entirely my fault
\
\ The terminology and notations used in this commentary are explained at
\ https://www.bbcelite.com/about_site/terminology_used_in_this_commentary.html
\
\ The deep dive articles referred to in this commentary can be found at
\ https://www.bbcelite.com/deep_dives
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * output/ELITE.bin
\
\ ******************************************************************************

INCLUDE "versions/elite-a/sources/elite-header.h.asm"

_CASSETTE_VERSION       = (_VERSION = 1)
_DISC_VERSION           = (_VERSION = 2)
_6502SP_VERSION         = (_VERSION = 3)
_MASTER_VERSION         = (_VERSION = 4)
_ELECTRON_VERSION       = (_VERSION = 5)
_ELITE_A_VERSION        = (_VERSION = 6)
_DISC_DOCKED            = FALSE
_DISC_FLIGHT            = FALSE
_ELITE_A_DOCKED         = FALSE
_ELITE_A_FLIGHT         = TRUE
_ELITE_A_ENCYCLOPEDIA   = FALSE
_ELITE_A_6502SP_PARA    = FALSE
_RELEASED               = (_RELEASE = 1)
_SOURCE_DISC            = (_RELEASE = 2)

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

Q% = _REMOVE_CHECKSUMS  \ Set Q% to TRUE to max out the default commander, FALSE
                        \ for the standard default commander (this is set to
                        \ TRUE if checksums are disabled, just for convenience)

key_io = &04
key_tube = &90

VIA = &FE00

BRKV = &0202
IRQ1V = &0204
BYTEV = &020A
WRCHV = &020E
FILEV = &0212
FSCV = &021E
NETV = &0224
IND2V = &0232
cmdr_iff = &036E
OSWRCH = &FFEE
OSWORD = &FFF1
OSBYTE = &FFF4
OSCLI = &FFF7

\EXEC = ENTRY

ZP = &70
T = &75
P = &72
Q = &73
YY = &74
CHKSM = &78
DL = &8B

VSCAN = 57

LASCT = &0346
HFX = &0348
ESCP = &0386
VEC = &7FFE

\ ******************************************************************************
\
\ ELITE LOADER
\
\ ******************************************************************************

CODE% = &1900
LOAD% = &1900

ORG CODE%

INCLUDE "library/common/loader/variable/b_per_cent.asm"
INCLUDE "library/common/loader/variable/e_per_cent.asm"
INCLUDE "library/common/loader/macro/fne.asm"

.ENTRY

 CLI
 LDA #&90
 LDX #&FF
 LDY #&01
 JSR OSBYTE
 LDA #LO(B%)
 STA &70
 LDA #HI(B%)
 STA &71
 LDY #&00

.vdu_loop

 LDA (&70),Y
 JSR OSWRCH
 INY 
 CPY #&43
 BNE vdu_loop
 JSR PLL1
 LDA #&10
 LDX #&02
 JSR OSBYTE
 LDA #&60
 STA IND2V
 LDA #HI(IND2V)
 STA NETV+&01
 LDA #LO(IND2V)
 STA NETV
 LDA #&BE
 LDX #&08
 JSR OSB
 LDA #&C8
 LDX #&03
 JSR OSB
 LDA #&0D
 LDX #&00
 JSR OSB
 LDA #&E1
 LDX #&80
 JSR OSB
 LDA #&0D
 LDX #&02
 JSR OSB
 LDA #&04
 LDX #&01
 JSR OSB
 LDA #&09
 LDX #&00
 JSR OSB
 LDA #&77
 JSR OSBYTE
 JSR or789
 LDA #&00
 STA &70
 LDA #&11
 STA &71
 LDA #LO(TVT1code)
 STA &72
 LDA #HI(TVT1code)
 STA &73
 JSR MVPG
 LDA #&EE
 STA BRKV
 LDA #&11
 STA BRKV+&01
 LDA #&00
 STA &70
 LDA #&78
 STA &71
 LDA #LO(DIALS)
 STA &72
 LDA #HI(DIALS)
 STA &73
 LDX #&08
 JSR MVBL
 LDA #&00
 STA &70
 LDA #&61
 STA &71
 LDA #LO(ASOFT)
 STA &72
 LDA #HI(ASOFT)
 STA &73
 JSR MVPG
 LDA #&63
 STA &71
 LDA #LO(ELITE)
 STA &72
 LDA #HI(ELITE)
 STA &73
 JSR MVPG
 LDA #&76
 STA &71
 LDA #LO(CpASOFT)
 STA &72
 LDA #HI(CpASOFT)
 STA &73
 JSR MVPG

 FNE 0                  \ Set up sound envelopes 0-3 using the FNE macro
 FNE 1
 FNE 2
 FNE 3

 LDX #LO(MESS1)
 LDY #HI(MESS1)
 JSR OSCLI
 LDA #&F0 \ set up DDRB
 STA &FE62
 LDA #0 \ Set up palatte flags
 STA &348
 STA &346
 LDA #&FF
 STA &386
 SEI 
 LDA &FE44
 \ STA &01
 LDA #&39
 STA &FE4E
 LDA #&7F
 STA &FE6E
 LDA IRQ1V
 STA &7FFE
 LDA IRQ1V+&01
 STA &7FFF
 LDA #&4B
 STA IRQ1V
 LDA #&11
 STA IRQ1V+&01
 LDA #&39
 STA &FE45
 CLI 
 LDA #0 \ test for BBC Master
 LDX #1
 JSR OSBYTE \ get OS version
 CPX #3
 BCC not_master
 LDX #0 \ copy master code to DD00

.cpmaster

 LDA to_dd00,X
 STA &DD00,X
 INX
 CPX #dd00_len
 BNE cpmaster
 LDA #&8F \ service call
 LDX #&21 \ ?
 LDY #&C0 \ ? top of absolute workspace
 JSR OSBYTE \ ? in XY
 STX put0+1 \ modify workspace save address
 STX put1+1
 STX put2+1
 STX get0+1 \ modify workspace restore address
 STX get1+1
 STX get2+1
 STY put0+2
 STY get0+2
 INY
 STY put1+2
 STY get1+2
 INY
 STY put2+2
 STY get2+2
 LDA FILEV \ modify address for old FILEV
 STA old_FILEV+1
 LDA FILEV+1
 STA old_FILEV+2
 LDA FSCV \ modify address for old FSCV
 STA old_FSCV+1
 LDA FSCV+1
 STA old_FSCV+2
 LDA BYTEV \ modify address for old BYTEV
 STA old_BYTEV+1
 LDA BYTEV+1
 STA old_BYTEV+2
 JSR set_vectors \ replace FILEV and FSCV

.not_master

 LDA #&EA \ test for tube
 LDY #&FF
 LDX #&00
 JSR OSBYTE
 TXA
 BNE tube_go
 LDA #&AC \ keyboard translation table
 LDX #&00
 LDY #&FF
 JSR OSBYTE
 STX key_io
 STY key_io+&01
 LDA #&00
 STA &70
 LDA #&04
 STA &71
 LDA #LO(WORDS)
 STA &72
 LDA #HI(WORDS)
 STA &73
 LDX #&04
 JSR MVBL
 LDA #&E9
 STA WRCHV
 LDA #&11
 STA WRCHV+&01
 LDA #&00
 STA &70
 LDA #&0B
 STA &71
 LDA #LO(tob00)
 STA &72
 LDA #HI(tob00)
 STA &73
 JSR MVPG
 LDY #&23

.copy_d7a

 LDA tod7a,Y
 STA &0D7A,Y
 DEY
 BPL copy_d7a
 JMP &0B00


.tube_go

 LDA #&AC \ keyboard translation table
 LDX #&00
 LDY #&FF
 JSR OSBYTE
 STX key_tube
 STY key_tube+&01
 \ LDX #LO(tube_400)
 \ LDY #HI(tube_400)
 \ LDA #1
 \ JSR &0406
 \ LDA #LO(WORDS)
 \ STA &72
 \ LDA #HI(WORDS)
 \ STA &73
 \ LDX #&04
 \ LDY #&00
 \tube_wr LDA (&72),Y
 \ JSR tube_wait
 \ BIT tube_r3s
 \ BVC tube_wr
 \ STA tube_r3d
 \ INY
 \ BNE tube_wr
 \ INC &73
 \ DEX
 \ BNE tube_wr
 \ LDA #LO(tube_wrch)
 \ STA WRCHV
 \ LDA #HI(tube_wrch)
 \ STA WRCHV+&01
 LDX #LO(tube_run)
 LDY #HI(tube_run)
 JMP OSCLI


.tube_run

 EQUS "R.2.H", &0D

 \tube_400 EQUD &0400

 \tube_wait
 \ JSR tube_wait2
 \tube_wait2
 \ JSR tube_wait3
 \tube_wait3
 \ RTS


.tod7a

 LDX cmdr_iff \ iff code
 BEQ iff_not
 LDY #&24
 LDA (&20),Y
 ASL A
 ASL A
 BCS iff_cop
 ASL A
 BCS iff_trade
 LDY &8C
 DEY
 BEQ iff_missle
 CPY #&08
 BCC iff_aster
 INX \ X=4

.iff_missle

 INX \ X=3

.iff_aster

 INX \ X=2

.iff_cop

 INX \ X=1

.iff_trade

 INX \ X=0

.iff_not

 RTS \ X=0


.tob00

 LDX #<(l_tcode-tob00+&B00)
 LDY #>(l_tcode-tob00+&B00)
 JSR OSCLI
 JMP &11E6


.l_tcode

 EQUS "L.1.D", &0D

INCLUDE "library/common/loader/subroutine/pll1.asm"
INCLUDE "library/common/loader/subroutine/dornd.asm"
INCLUDE "library/enhanced/loader/variable/rand.asm"
INCLUDE "library/common/loader/subroutine/squa2.asm"
INCLUDE "library/common/loader/subroutine/pix.asm"
INCLUDE "library/common/loader/variable/twos.asm"
INCLUDE "library/common/loader/variable/cnt.asm"
INCLUDE "library/common/loader/variable/cnt2.asm"
INCLUDE "library/common/loader/variable/cnt3.asm"

.or789

 LDA &78
 AND &79
 ORA #&0C
 ASL A
 STA &78
 RTS 

INCLUDE "library/common/loader/subroutine/root.asm"
INCLUDE "library/common/loader/subroutine/osb.asm"
INCLUDE "library/disc/loader3/subroutine/mvpg.asm"
INCLUDE "library/disc/loader3/subroutine/mvbl.asm"
INCLUDE "library/disc/loader3/variable/mess1.asm"

\INCLUDE "library/disc/loader3/subroutine/elite_loader_part_2_of_3.asm"

.DIALS

 INCBIN "versions/elite-a/binaries/P.DIALS.bin"

.SHIP_MISSILE

 INCBIN "versions/elite-a/output/MISSILE.bin"

.WORDS

INCLUDE "library/common/main/macro/char.asm"
INCLUDE "library/common/main/macro/twok.asm"
INCLUDE "library/common/main/macro/cont.asm"
INCLUDE "library/common/main/macro/rtok.asm"
INCLUDE "library/common/main/variable/qq18.asm"

INCLUDE "library/common/main/variable/sne.asm"
INCLUDE "library/common/main/variable/act.asm"
INCLUDE "library/disc/loader3/subroutine/tvt1code.asm"
INCLUDE "library/disc/loader3/subroutine/elite_loader_part_3_of_3.asm"


 \ BBC Master 128 code for save/restore characters
CPU 1
.to_dd00

ORG &DD00

 \ trap FILEV

.do_FILEV

 JSR restorews \ restore workspace

.old_FILEV

 JSR &100 \ address modified by master set-up

.savews

 PHP \ save workspace, copy in characters
 PHA
 PHX
 PHY
 LDA #8 \ select ROM workspace at &C000
 TSB &FE34
 LDX #0

.putws

 LDA &C000,X \ save absolute workspace

.put0

 STA &C000,X \ address modified by master set-up
 LDA &C100,X

.put1

 STA &C100,X \ address modified by master set-up
 LDA &C200,X

.put2

 STA &C200,X \ address modified by master set-up
 INX
 BNE putws
 LDA &F4 \ save ROM number
 PHA
 LDA #&80 \ select RAM from &8000-&8FFF
 STA &F4
 STA &FE30
 LDX #0

.copych

 LDA &8900,X \ copy character definitions
 STA &C000,X
 LDA &8A00,X
 STA &C100,X
 LDA &8B00,X
 STA &C200,X
 INX
 BNE copych
 PLA \ restore ROM selection
 STA &F4
 STA &FE30
 PLY
 PLX
 PLA
 PLP
 RTS

 \ trap FILEV

.do_FSCV

 JSR restorews \ restore workspace

.old_FSCV

 JSR &100 \ address modified by master setup
 JMP savews \ save workspace, restore characters

 \ restore ROM workspace

.restorews

 PHA
 PHX
 LDX #0

.getws

 \ restore absolute workspace

.get0

 LDA &C000,X \ address modified by master set-up
 STA &C000,X

.get1

 LDA &C100,X \ address modified by master set-up
 STA &C100,X

.get2

 LDA &C200,X \ address modified by master set-up
 STA &C200,X
 INX
 BNE getws
 PLX
 PLA
 RTS

 \ trap BYTEV

.do_BYTEV

 CMP #&8F \ ROM service request
 BNE old_BYTEV
 CPX #&F \ vector claim?
 BNE old_BYTEV
 JSR old_BYTEV

.set_vectors

 SEI
 PHA
 LDA #LO(do_FILEV) \ reset FILEV
 STA FILEV
 LDA #HI(do_FILEV)
 STA FILEV+1
 LDA #LO(do_FSCV) \ reset FSCV
 STA FSCV
 LDA #HI(do_FSCV)
 STA FSCV+1
 LDA #LO(do_BYTEV) \ replace BYTEV
 STA BYTEV
 LDA #HI(do_BYTEV)
 STA BYTEV+1
 PLA
 CLI
 RTS


.old_BYTEV

 JMP &100 \ address modified by master set_up

dd00_len = P%-&DD00 \ length of code at DD00


COPYBLOCK &DD00, P%, to_dd00
SAVE "versions/elite-a/output/ELITE.bin", CODE%, to_dd00+dd00_len, LOAD%