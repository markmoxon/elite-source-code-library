\ ******************************************************************************
\
\ NES ELITE GAME SOURCE (BANK 1)
\
\ NES Elite was written by Ian Bell and David Braben and is copyright D. Braben
\ and I. Bell 1992
\
\ The code on this site has been reconstructed from a disassembly of the version
\ released on Ian Bell's personal website at http://www.elitehomepage.org/
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
\   * bank1.bin
\
\ ******************************************************************************

 INCLUDE "versions/nes/1-source-files/main-sources/elite-build-options.asm"

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

 _BANK = 1

 INCLUDE "versions/nes/1-source-files/main-sources/elite-source-common.asm"

 INCLUDE "versions/nes/1-source-files/main-sources/elite-source-bank-7.asm"

\ ******************************************************************************
\
\ ELITE BANK 1
\
\ Produces the binary file bank1.bin.
\
\ ******************************************************************************

 CODE% = &8000
 LOAD% = &8000

 ORG CODE%

INCLUDE "library/nes/main/subroutine/resetmmc1.asm"
INCLUDE "library/nes/main/subroutine/interrupts.asm"
INCLUDE "library/nes/main/variable/version_number.asm"
INCLUDE "library/nes/main/variable/unused_copy_of_xx21.asm"
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

 EQUB &00, &FF          \ These bytes appear to be unused
 EQUB &FF, &00

INCLUDE "library/enhanced/main/variable/ship_python_p.asm"
INCLUDE "library/enhanced/main/variable/ship_fer_de_lance.asm"
INCLUDE "library/enhanced/main/variable/ship_moray.asm"
INCLUDE "library/common/main/variable/ship_thargoid.asm"
INCLUDE "library/common/main/variable/ship_thargon.asm"
INCLUDE "library/enhanced/main/variable/ship_constrictor.asm"
INCLUDE "library/advanced/main/variable/ship_cougar.asm"
INCLUDE "library/enhanced/main/variable/ship_dodo.asm"

 EQUB &00, &FF          \ These bytes appear to be unused
 EQUB &FF, &00

INCLUDE "library/common/main/subroutine/shppt.asm"
INCLUDE "library/common/main/subroutine/ll38.asm"
INCLUDE "library/common/main/subroutine/ll51.asm"
INCLUDE "library/common/main/subroutine/ll9_part_1_of_12.asm"
INCLUDE "library/common/main/subroutine/ll9_part_2_of_12.asm"
INCLUDE "library/common/main/subroutine/ll9_part_3_of_12.asm"
INCLUDE "library/common/main/subroutine/ll9_part_4_of_12.asm"
INCLUDE "library/common/main/subroutine/ll9_part_5_of_12.asm"
INCLUDE "library/common/main/subroutine/ll9_part_6_of_12.asm"
INCLUDE "library/common/main/subroutine/ll61.asm"
INCLUDE "library/common/main/subroutine/ll62.asm"
INCLUDE "library/common/main/subroutine/ll9_part_7_of_12.asm"
INCLUDE "library/common/main/subroutine/ll9_part_8_of_12.asm"
INCLUDE "library/common/main/subroutine/ll9_part_9_of_12.asm"
INCLUDE "library/common/main/subroutine/ll9_part_10_of_12.asm"
INCLUDE "library/common/main/subroutine/ll145_part_1_of_4.asm"
INCLUDE "library/common/main/subroutine/ll145_part_2_of_4.asm"
INCLUDE "library/common/main/subroutine/ll145_part_3_of_4.asm"
INCLUDE "library/common/main/subroutine/ll145_part_4_of_4.asm"
INCLUDE "library/common/main/subroutine/ll9_part_11_of_12.asm"
INCLUDE "library/common/main/subroutine/ll118.asm"
INCLUDE "library/common/main/subroutine/ll120.asm"
INCLUDE "library/common/main/subroutine/ll123.asm"
INCLUDE "library/common/main/subroutine/ll129.asm"
INCLUDE "library/common/main/subroutine/doexp.asm"
INCLUDE "library/common/main/subroutine/planet.asm"
INCLUDE "library/common/main/subroutine/pl9_part_1_of_3.asm"
INCLUDE "library/common/main/subroutine/pl9_part_2_of_3.asm"
INCLUDE "library/common/main/subroutine/pl9_part_3_of_3.asm"
INCLUDE "library/common/main/subroutine/pls1.asm"
INCLUDE "library/common/main/subroutine/pls2.asm"
INCLUDE "library/common/main/subroutine/pls22.asm"
INCLUDE "library/common/main/subroutine/sun_part_1_of_4.asm"
INCLUDE "library/common/main/subroutine/sun_part_2_of_4.asm"
INCLUDE "library/common/main/subroutine/sun_part_3_of_4.asm"
INCLUDE "library/common/main/subroutine/sun_part_4_of_4.asm"
INCLUDE "library/common/main/subroutine/circle.asm"
INCLUDE "library/common/main/subroutine/circle2.asm"
INCLUDE "library/common/main/subroutine/edges.asm"

\ ******************************************************************************
\
\       Name: subm_B039
\       Type: Subroutine
\   Category: Drawing suns
\    Summary: ??? called from sun part 2
\
\ ******************************************************************************

.subm_B039

 LDX P                  \ ???
 STX X2
 EOR #&FF
 SEC
 ADC YY
 STA XX15
 LDA YY+1
 ADC #&FF
 BEQ CB04D
 BMI CB056

.CB04C

 RTS

.CB04D

 LDA XX15
 CMP X2
 BCS CB04C
 JMP subm_E0BA

.CB056

 LDA #0
 STA XX15
 JMP subm_E0BA

\ ******************************************************************************
\
\       Name: subm_B05D
\       Type: Subroutine
\   Category: Drawing suns
\    Summary: ??? called from sun part 2
\
\ ******************************************************************************

.subm_B05D

 CLC                    \ ???
 ADC YY
 STA X2
 LDA YY+1
 ADC #0
 BEQ CB04D
 BMI CB04C
 LDA #&FD
 STA X2
 CMP XX15
 BEQ CB04C
 BCC CB04C
 JMP subm_E0BA

INCLUDE "library/common/main/subroutine/chkon.asm"
INCLUDE "library/common/main/subroutine/pl21.asm"
INCLUDE "library/nes/main/subroutine/pl44.asm"
INCLUDE "library/common/main/subroutine/pls3.asm"
INCLUDE "library/common/main/subroutine/pls4.asm"
INCLUDE "library/common/main/subroutine/pls5.asm"
INCLUDE "library/common/main/subroutine/arctan.asm"
INCLUDE "library/common/main/subroutine/bline.asm"
INCLUDE "library/common/main/subroutine/stars.asm"
INCLUDE "library/common/main/subroutine/stars1.asm"
INCLUDE "library/common/main/subroutine/stars6.asm"
INCLUDE "library/common/main/subroutine/stars2.asm"
INCLUDE "library/nes/main/subroutine/hanger.asm"
INCLUDE "library/nes/main/subroutine/has2.asm"
INCLUDE "library/nes/main/subroutine/has3.asm"
INCLUDE "library/enhanced/main/variable/hatb.asm"
INCLUDE "library/enhanced/main/subroutine/hall.asm"
INCLUDE "library/nes/main/subroutine/zinf_b1.asm"
INCLUDE "library/enhanced/main/subroutine/has1.asm"
INCLUDE "library/common/main/subroutine/tidy.asm"
INCLUDE "library/common/main/subroutine/tis3.asm"
INCLUDE "library/common/main/subroutine/dvidt.asm"

\ ******************************************************************************
\
\       Name: SCAN
\   Category: Dashboard
\   Category: Drawing lines
\    Summary: ???
\
\ ******************************************************************************

.CB969

 LDA #&F0
 STA ySprite0,Y
 STA ySprite1,Y
 STA ySprite2,Y

.CB974

 RTS

.SCAN

 LDA QQ11               \ ???
 BNE CB974
 LDX TYPE
 BMI CB974
 LDA L002A
 BEQ CB974
 TAX
 ASL A
 ADC L002A
 ASL A
 ASL A
 ADC #&2C
 TAY
 LDA L037E,X
 STA attrSprite0,Y
 LDA INWK+1
 CMP INWK+4
 BCS CB998
 LDA INWK+4

.CB998

 CMP INWK+7
 BCS CB99E
 LDA INWK+7

.CB99E

 CMP #&40
 BCS CB969
 STA SC2
 LDA INWK+1
 ADC INWK+4
 ADC INWK+7
 BCS CB969
 SEC
 SBC SC2
 LSR A
 LSR A
 STA SC2+1
 LSR A
 LSR A
 ADC SC2+1
 ADC SC2
 CMP #&40
 BCS CB969
 LDA INWK+1
 CLC
 LDX INWK+2
 BPL CB9C8
 EOR #&FF
 ADC #1

.CB9C8

 ADC #&7C
 STA SC2
 LDA INWK+7
 LSR A
 LSR A
 CLC
 LDX INWK+8
 BMI CB9D8
 EOR #&FF
 SEC

.CB9D8

IF _NTSC

 ADC #&C7

ELIF _PAL

 ADC #&CD

ENDIF

 STA SC2+1
 LDA INWK+4
 CMP #&30
 BCC CB9E4
 LDA #&2F

.CB9E4

 LSR A
 STA Y1
 CLC
 BEQ CB9F1
 LDX INWK+5
 BPL CB9F1
 JMP CBA6C

.CB9F1

 LDA SC2+1
 SEC
 SBC #8
 STA SC2+1
 LDA Y1
 CMP #&10
 BCC CBA24
 LDA SC2
 STA xSprite0,Y
 STA xSprite1,Y
 LDA SC2+1
 STA ySprite0,Y
 SEC
 SBC #8
 STA ySprite1,Y
 LDA attrSprite0,Y
 AND #3
 STA attrSprite0,Y
 STA attrSprite1,Y
 LDA SC2+1
 SBC #&10
 STA SC2+1
 BNE CBA4F

.CBA24

 CMP #8
 BCC CBA47
 LDA #&F0
 STA ySprite0,Y
 LDA SC2
 STA xSprite1,Y
 LDA SC2+1
 STA ySprite1,Y
 LDA attrSprite0,Y
 AND #3
 STA attrSprite1,Y
 LDA SC2+1
 SBC #8
 STA SC2+1
 BNE CBA4F

.CBA47

 LDA #&F0
 STA ySprite0,Y
 STA ySprite1,Y

.CBA4F

 LDA Y1
 AND #7
 CLC
 ADC #&DB
 STA tileSprite2,Y
 LDA attrSprite0,Y
 AND #3
 STA attrSprite2,Y
 LDA SC2
 STA xSprite2,Y
 LDA SC2+1
 STA ySprite2,Y
 RTS

.CBA6C

 CLC
 ADC SC2+1

IF _NTSC

 CMP #&DC
 BCC CBA75
 LDA #&DC

ELIF _PAL

 CMP #&E2
 BCC CBA75
 LDA #&E2

ENDIF

.CBA75

 SEC
 SBC SC2+1
 STA Y1
 CMP #&10
 BCC CBAA5
 LDA SC2
 STA xSprite0,Y
 STA xSprite1,Y
 LDA SC2+1
 STA ySprite0,Y
 CLC
 ADC #8
 STA ySprite1,Y
 LDA attrSprite0,Y
 ORA #&20
 STA attrSprite0,Y
 STA attrSprite1,Y
 LDA SC2+1
 CLC
 ADC #&10
 STA SC2+1
 BNE CBAD0

.CBAA5

 CMP #8
 BCC CBAC8
 LDA #&F0
 STA ySprite0,Y
 LDA SC2
 STA xSprite1,Y
 LDA SC2+1
 STA ySprite1,Y
 LDA attrSprite0,Y
 ORA #&20
 STA attrSprite1,Y
 LDA SC2+1
 ADC #7
 STA SC2+1
 BNE CBAD0

.CBAC8

 LDA #&F0
 STA ySprite0,Y
 STA ySprite1,Y

.CBAD0

 LDA Y1
 AND #7
 CLC
 ADC #&DB
 STA tileSprite2,Y
 LDA attrSprite0,Y
 ORA #&E0
 STA attrSprite2,Y
 LDA SC2
 STA xSprite2,Y
 LDA SC2+1
 STA ySprite2,Y
 RTS

\ ******************************************************************************
\
\       Name: subm_BAED
\   Category: Dashboard
\   Category: Drawing ships
\    Summary: ??? Called from LL9 part 1
\
\ ******************************************************************************

.subm_BAED

 LDA #0                 \ ???
 LDY #&21
 STA (INF),Y

\ ******************************************************************************
\
\       Name: subm_BAF3
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_BAF3

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX L002A              \ ???
 BEQ CBB23
 LDA #0
 STA L0374,X
 TXA
 ASL A
 ADC L002A
 ASL A
 ASL A
 TAX
 LDA QQ11
 BNE CBB1F
 LDA #&F0
 STA ySprite11,X
 STA ySprite12,X
 STA ySprite13,X

.CBB1F

 LDA #0
 STA L002A

.CBB23

 RTS

INCLUDE "library/nes/main/subroutine/ptcls2.asm"
INCLUDE "library/common/main/subroutine/pixel2.asm"
INCLUDE "library/nes/main/variable/vectors.asm"

\ ******************************************************************************
\
\ Save bank1.bin
\
\ ******************************************************************************

 PRINT "S.bank1.bin ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
 SAVE "versions/nes/3-assembled-output/bank1.bin", CODE%, P%, LOAD%
