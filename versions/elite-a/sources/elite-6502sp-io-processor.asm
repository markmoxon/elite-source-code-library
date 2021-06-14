\ ******************************************************************************
\
\ ELITE-A GAME SOURCE (I/O PROCESSOR)
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
\   * output/2.H.bin
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
_ELITE_A_FLIGHT         = FALSE
_ELITE_A_ENCYCLOPEDIA   = FALSE
_ELITE_A_6502SP_IO      = TRUE
_ELITE_A_6502SP_PARA    = FALSE
_RELEASED               = (_RELEASE = 1)
_SOURCE_DISC            = (_RELEASE = 2)

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

OSBYTE = &FFF4          \ The address for the OSBYTE routine
OSCLI = &FFF7           \ The address for the OSCLI routine

VIA = &FE00             \ Memory-mapped space for accessing internal hardware,
                        \ such as the video ULA, 6845 CRTC and 6522 VIAs (also
                        \ known as SHEILA)

X = 128                 \ The centre x-coordinate of the 256 x 192 space view
Y = 96                  \ The centre y-coordinate of the 256 x 192 space view


BRKV = &0202
WRCHV = &020E

rawrch = &FFBC

tube_r1s = &FEE0
tube_r1d = &FEE1
tube_r2s = &FEE2
tube_r2d = &FEE3
tube_r3s = &FEE4
tube_r3d = &FEE5
tube_r4s = &FEE6
tube_r4d = &FEE7

tube_brk = &16 \ tube BRK vector

DL = &8B
key_tube = &90

SC = &92
SCH = &93
font = &94
save_a = &96
save_x = &97
save_y = &98

ZZ = &94
X1 = &94
Y1 = &95
X2 = &96
COL = &96
Y2 = &97
P = &98
Q = &99
T = &99    \ Added for HLOIN
R = &9A
S = &9B
SWAP = &9C

bar_1 = &94
bar_2 = &95
bar_3 = &96

angle_1 = &94
missle_1 = &94
picture_1 = &94
picture_2 = &95

print_bits = &94

cursor_x = &9E
cursor_y = &9F

CODE% = &1200
LOAD% = &1200

ORG CODE%

\ ******************************************************************************
\
\       Name: tube_elite
\       Type: Subroutine
\   Category: Tube
\    Summary: AJD
\
\ ******************************************************************************

.tube_elite

 LDX #&FF
 TXS
 LDA #LO(tube_wrch)
 STA WRCHV
 LDA #HI(tube_wrch)
 STA WRCHV+&01
 LDA #LO(tube_brk)
 STA BRKV
 LDA #HI(tube_brk)
 STA BRKV+&01
 LDX #LO(tube_run)
 LDY #HI(tube_run)
 JMP OSCLI

\ ******************************************************************************
\
\       Name: tube_run
\       Type: Variable
\   Category: Tube
\    Summary: AJD
\
\ ******************************************************************************

.tube_run

 EQUS "R.2.T", &0D

\ ******************************************************************************
\
\       Name: tube_get
\       Type: Subroutine
\   Category: Tube
\    Summary: AJD
\
\ ******************************************************************************

.tube_get

 BIT tube_r1s
 NOP
 BPL tube_get
 LDA tube_r1d
 RTS

\ ******************************************************************************
\
\       Name: tube_put
\       Type: Subroutine
\   Category: Tube
\    Summary: AJD
\
\ ******************************************************************************

.tube_put

 BIT tube_r2s
 NOP
 BVC tube_put
 STA tube_r2d
 RTS

\ ******************************************************************************
\
\       Name: tube_func
\       Type: Subroutine
\   Category: Tube
\    Summary: AJD
\
\ ******************************************************************************

.tube_func

 CMP #&9D  \ OUT
 BCS return  \ OUT
 ASL A
 TAY
 LDA tube_table,Y
 STA tube_jump+&01
 LDA tube_table+&01,Y
 STA tube_jump+&02

.tube_jump

 JMP &FFFF

.return

 RTS

\ ******************************************************************************
\
\       Name: tube_table
\       Type: Variable
\   Category: Tube
\    Summary: AJD
\
\ ******************************************************************************

.tube_table

 EQUW LL30, HLOIN, PIXEL, clr_scrn
 EQUW CLYNS, sync_in, draw_bar, DIL2
 EQUW MSBAR, scan_fire, write_fe4e, scan_xin
 EQUW scan_10in, get_key, CHPR, write_pod
 EQUW draw_blob, draw_tail, SPBLB, ECBLB
 EQUW UNWISE, DET1, scan_y, write_0346
 EQUW read_0346, return, HANGER, HA2

\ ******************************************************************************
\
\       Name: CHPR
\       Type: Subroutine
\   Category: Text
\    Summary: AJD
\
\ ******************************************************************************

.CHPR

 JSR tube_get
 STA cursor_x
 JSR tube_get
 STA cursor_y
 JSR tube_get
 CMP #&20
 BNE tube_wrch
 LDA #&09

.tube_wrch

 STA save_a             \ Like CHPR
 STX save_x
 STY save_y
 TAY
 BMI tube_func
 BEQ wrch_quit
 CMP #&7F
 BEQ wrch_del
 CMP #&20
 BEQ wrch_spc 
 BCS wrch_char
 CMP #&0A
 BEQ wrch_nl
 CMP #&0D
 BEQ wrch_cr
 CMP #&09
 BNE wrch_quit

.wrch_tab

 INC cursor_x

.wrch_quit

 LDY save_y
 LDX save_x
 LDA save_a
 RTS

.wrch_char

 JSR wrch_font
 INC cursor_x
 LDY #&07

.wrch_or

 LDA (font),Y
 EOR (SC),Y \ORA (SC),Y
 STA (SC),Y
 DEY
 BPL wrch_or
 BMI wrch_quit

.wrch_del

 DEC cursor_x
 LDA #&20
 JSR wrch_font
 LDY #&07

.wrch_sta

 LDA (font),Y
 STA (SC),Y
 DEY
 BPL wrch_sta
 BMI wrch_quit

.wrch_nl

 INC cursor_y
 JMP wrch_quit

.wrch_cr

 LDA #&01
 STA cursor_x
 JMP wrch_quit

.wrch_spc

 LDA cursor_x
 CMP #&20
 BEQ wrch_quit
 CMP #&11
 BEQ wrch_quit
 BNE wrch_tab

.wrch_font

 LDX #&BF
 ASL A
 ASL A
 BCC font_c0
 LDX #&C1

.font_c0

 ASL A
 BCC font_cl
 INX

.font_cl

 STA font
 STX font+1
 LDA cursor_x
 ASL A
 ASL A
 ASL A
 STA SC
 LDA cursor_y
 ORA #&60
 STA SC+&01
 RTS

INCLUDE "library/common/main/variable/twos.asm"
INCLUDE "library/common/main/variable/twos2.asm"
INCLUDE "library/common/main/variable/ctwos.asm"
INCLUDE "library/common/main/subroutine/loin_part_1_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_2_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_3_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_4_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_5_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_6_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_7_of_7.asm"
INCLUDE "library/common/main/subroutine/hloin.asm"
INCLUDE "library/common/main/variable/twfl.asm"
INCLUDE "library/common/main/variable/twfr.asm"
INCLUDE "library/original/main/subroutine/px3.asm"
INCLUDE "library/common/main/subroutine/pixel.asm"

\ ******************************************************************************
\
\       Name: clr_scrn
\       Type: Subroutine
\   Category: Utility routines
\    Summary: AJD
\
\ ******************************************************************************

.clr_scrn

 LDX #&60               \ Set X to the screen memory page for the top row of the
                        \ screen (as screen memory starts at &6000)

.BOL1

 JSR ZES1               \ Call ZES1 to zero-fill the page in X, which clears
                        \ that character row on the screen

 INX                    \ Increment X to point to the next page, i.e. the next
                        \ character row

 CPX #&78               \ Loop back to BOL1 until we have cleared page &7700,
 BNE BOL1               \ the last character row in the space view part of the
                        \ screen (the space view)

 RTS                    \ Return from the subroutine

INCLUDE "library/common/main/subroutine/zes1.asm"
INCLUDE "library/common/main/subroutine/zes2.asm"
INCLUDE "library/common/main/subroutine/clyns.asm"
INCLUDE "library/original/main/subroutine/lyn.asm"

\ ******************************************************************************
\
\       Name: sync_in
\       Type: Subroutine
\   Category: Screen mode
\    Summary: Wait for the vertical sync
\
\ ******************************************************************************

.sync_in

 JSR WSCAN              \ AJD
 JMP tube_put

INCLUDE "library/common/main/subroutine/wscan.asm"

\ ******************************************************************************
\
\       Name: draw_bar
\       Type: Subroutine
\   Category: Dashboard
\    Summary: AJD
\
\ ******************************************************************************

.draw_bar

 JSR tube_get
 STA bar_1
 JSR tube_get
 STA bar_2
 JSR tube_get
 STA SC
 JSR tube_get
 STA SC+1
 LDX #&FF
 STX bar_3
 LDY #&02
 LDX #&03

.bar_byte

 LDA bar_1
 CMP #&04
 BCC bar_part
 SBC #&04
 STA bar_1
 LDA bar_3

.l_1edc

 AND bar_2
 STA (SC),Y
 INY
 STA (SC),Y
 INY
 STA (SC),Y
 TYA
 CLC
 ADC #&06
 TAY
 DEX
 BMI l_1f0a
 BPL bar_byte

.bar_part

 EOR #&03
 STA bar_1
 LDA bar_3

.l_1ef6

 ASL A
 AND #&EF
 DEC bar_1
 BPL l_1ef6
 PHA
 LDA #&00
 STA bar_3
 LDA #&63
 STA bar_1
 PLA
 JMP l_1edc

.l_1f0a

 RTS

INCLUDE "library/common/main/subroutine/dil2.asm"

\ ******************************************************************************
\
\       Name: MSBAR
\       Type: Subroutine
\   Category: Dashboard
\    Summary: AJD
\
\ ******************************************************************************

.MSBAR

 JSR tube_get           \ Like MSBAR
 ASL A
 ASL A
 ASL A
 STA missle_1
 LDA #&31-8
 SBC missle_1
 STA SC
 LDA #&7E
 STA SC+&01
 JSR tube_get
 LDY #&05

.l_33ba

 STA (SC),Y
 DEY
 BNE l_33ba
 RTS

\ ******************************************************************************
\
\       Name: scan_fire
\       Type: Subroutine
\   Category: Keyboard
\    Summary: AJD
\
\ ******************************************************************************

.scan_fire

 LDA #&51
 STA &FE60
 LDA &FE40
 AND #&10
 JMP tube_put

\ ******************************************************************************
\
\       Name: write_fe4e
\       Type: Subroutine
\   Category: Keyboard
\    Summary: AJD
\
\ ******************************************************************************

.write_fe4e

 JSR tube_get
 STA &FE4E
 JMP tube_put

\ ******************************************************************************
\
\       Name: scan_xin
\       Type: Subroutine
\   Category: Keyboard
\    Summary: AJD
\
\ ******************************************************************************

.scan_xin

 JSR tube_get
 TAX
 JSR DKS4
 JMP tube_put

INCLUDE "library/common/main/subroutine/dks4.asm"

\ ******************************************************************************
\
\       Name: scan_10in
\       Type: Subroutine
\   Category: Keyboard
\    Summary: AJD
\
\ ******************************************************************************

.scan_10in

 JSR RDKEY
 JMP tube_put

INCLUDE "library/common/main/subroutine/rdkey.asm"

\ ******************************************************************************
\
\       Name: get_key
\       Type: Subroutine
\   Category: Keyboard
\    Summary: AJD
\
\ ******************************************************************************

.get_key

 JSR WSCAN
 JSR WSCAN
 JSR RDKEY
 BNE get_key

.press

 JSR RDKEY
 BEQ press
 TAY
 LDA (key_tube),Y
 JMP tube_put

\ ******************************************************************************
\
\       Name: write_pod
\       Type: Subroutine
\   Category: Dashboard
\    Summary: AJD
\
\ ******************************************************************************

.write_pod

 JSR tube_get
 STA &0386
 JSR tube_get
 STA &0348
 RTS

\ ******************************************************************************
\
\       Name: draw_blob
\       Type: Subroutine
\   Category: Drawing pixels
\    Summary: AJD
\
\ ******************************************************************************

.draw_blob

 JSR tube_get
 STA X1
 JSR tube_get
 STA Y1
 JSR tube_get
 STA X2

INCLUDE "library/common/main/subroutine/cpix2.asm"

\ ******************************************************************************
\
\       Name: draw_tail
\       Type: Subroutine
\   Category: Dashboard
\    Summary: AJD
\
\ ******************************************************************************

.draw_tail

 JSR tube_get
 STA X1
 JSR tube_get
 STA Y1
 JSR tube_get
 STA X2
 JSR tube_get
 STA Y2
 JSR tube_get
 STA P

.SC48 

 JSR CPIX2              \ Like SC48 in SCAN
 DEC Y1
 JSR CPIX2

 LDA CTWOS+1,X
 AND COL \ iff
 STA COL

 LDA CTWOS+1,X
 AND Y2 \ COL2?
 STA Y2
 LDX P
 BEQ RTS
 BMI d_55db

.VLL1

 DEY
 BPL VL1
 LDY #&07
 DEC SC+&01

.VL1

 LDA COL
 EOR Y2 \ iff drawpix_4
 STA COL
 EOR (SC),Y
 STA (SC),Y
 DEX
 BNE VLL1

.RTS

 RTS

.d_55db

 INY
 CPY #&08
 BNE VLL2
 LDY #&00
 INC SC+&01

.VLL2

 INY
 CPY #&08
 BNE VL2
 LDY #&00
 INC SC+&01

.VL2

 LDA COL
 EOR Y2 \ iff drawpix_4
 STA COL
 EOR (SC),Y
 STA (SC),Y
 INX
 BNE VLL2
 RTS

INCLUDE "library/common/main/subroutine/ecblb.asm"
INCLUDE "library/common/main/subroutine/spblb-dobulb.asm"
INCLUDE "library/original/main/subroutine/bulb.asm"
INCLUDE "library/common/main/variable/ecbt.asm"
INCLUDE "library/common/main/variable/spbt.asm"
INCLUDE "library/enhanced/main/subroutine/unwise.asm"
INCLUDE "library/common/main/subroutine/det1-dodials.asm"
INCLUDE "library/common/main/variable/kytb.asm"
INCLUDE "library/elite-a/flight/variable/b_table.asm"
INCLUDE "library/elite-a/flight/subroutine/b_14.asm"

\ ******************************************************************************
\
\       Name: scan_y
\       Type: Subroutine
\   Category: Keyboard
\    Summary: AJD
\
\ ******************************************************************************

.scan_y

 JSR tube_get
 TAY
 JSR tube_get
 BMI b_14
 LDX KYTB-1,Y
 JSR DKS4
 BPL b_quit

.b_pressed

 LDA #&FF

.b_quit

 JMP tube_put

\ ******************************************************************************
\
\       Name: write_0346
\       Type: Subroutine
\   Category: Tube
\    Summary: AJD
\
\ ******************************************************************************

.write_0346

 JSR tube_get
 STA &0346
 RTS

\ ******************************************************************************
\
\       Name: read_0346
\       Type: Subroutine
\   Category: Tube
\    Summary: AJD
\
\ ******************************************************************************

.read_0346

 LDA &0346
 JMP tube_put

\ ******************************************************************************
\
\       Name: HANGER
\       Type: Subroutine
\   Category: Ship hanger
\    Summary: AJD
\
\ ******************************************************************************

.HANGER

 JSR tube_get
 STA picture_1
 JSR tube_get
 STA picture_2
 LDA picture_1
 CLC
 ADC #&60
 LSR A
 LSR A
 LSR A
 ORA #&60
 STA SC+&01
 LDA picture_1
 AND #&07
 STA SC
 LDY #&00
 JSR HAS2
 LDA #&04
 LDY #&F8
 JSR HAS3
 LDY picture_2
 BEQ l_2045
 JSR HAS2
 LDY #&80
 LDA #&40
 JSR HAS3

.l_2045

 RTS

.HA2

 JSR tube_get
 AND #&F8
 STA SC
 LDX #&60
 STX SC+&01
 LDX #&80
 LDY #&01

.HAL7

 TXA
 AND (SC),Y
 BNE HA6
 TXA
 ORA (SC),Y
 STA (SC),Y
 INY
 CPY #&08
 BNE HAL7
 INC SC+&01
 LDY #&00
 BEQ HAL7

.HA6

 RTS

INCLUDE "library/enhanced/main/subroutine/has2.asm"
INCLUDE "library/enhanced/main/subroutine/has3.asm"

\ ******************************************************************************
\
\       Name: printer
\       Type: Subroutine
\   Category: Text
\    Summary: AJD
\
\ ******************************************************************************

.printer

 LDA #2
 JSR print_safe
 LDA #'@'
 JSR print_esc
 LDA #'A'
 JSR print_esc
 LDA #8
 JSR print_wrch
 LDA #&60
 STA SC+1
 LDA #0
 STA SC

.print_view

 LDA #'K'
 JSR print_esc
 LDA #0
 JSR print_wrch
 LDA #1
 JSR print_wrch

.print_outer

 LDY #7
 LDX #&FF

.print_copy

 INX
 LDA (SC),Y
 STA print_bits,X
 DEY
 BPL print_copy
 LDA SC+1
 CMP #&78
 BCC print_inner

.print_radar

 LDY #7
 LDA #0

.print_split

 ASL print_bits,X
 BCC print_merge
 ORA print_tone,Y

.print_merge

 DEY
 BPL print_split
 STA print_bits,X
 DEX
 BPL print_radar

.print_inner

 LDY #7

.print_block

 LDX #7

.print_slice

 ASL print_bits,X
 ROL A
 DEX
 BPL print_slice
 JSR print_wrch
 DEY
 BPL print_block

.print_next

 CLC
 LDA SC
 ADC #8
 STA SC
 BNE print_outer
 LDA #13
 JSR print_wrch
 INC SC+1
 LDX SC+1
 INX
 BPL print_view
 LDA #3
 JMP print_safe
 \JSR print_safe
 \JMP tube_put


.print_tone

 EQUB &03, &0C, &30, &C0, &03, &0C, &30, &C0


.print_esc

 PHA
 LDA #27
 JSR print_wrch
 PLA

.print_wrch

 PHA
 LDA #1
 JSR print_safe
 PLA

.print_safe

 PHA
 TYA
 PHA
 TXA
 PHA
 TSX
 LDA &103,X
 JSR rawrch
 PLA
 TAX
 PLA
 TAY
 PLA
 RTS

\ ******************************************************************************
\
\ Save output/2.H.bin
\
\ ******************************************************************************

PRINT "S.2.H ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
SAVE "versions/elite-a/output/2.H.bin", CODE%, P%, LOAD%