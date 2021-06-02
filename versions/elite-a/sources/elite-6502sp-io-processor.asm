\ ******************************************************************************
\
\ ELITE-A GAME SOURCE (I/O PROCESSOR)
\
\ Elite-A was written by Angus Duggan, and is an extended version of the BBC
\ Micro disc version of Elite; the extra code is copyright Angus Duggan
\
\ Elite was written by Ian Bell and David Braben and is copyright Acornsoft 1984
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

LS% = &0CFF             \ The start of the descending ship line heap

NOST = 18               \ The number of stardust particles in normal space (this
                        \ goes down to 3 in witchspace)

NOSH = 12               \ The maximum number of ships in our local bubble of
                        \ universe

NTY = 31                \ The number of different ship types

MSL = 1                 \ Ship type for a missile
SST = 2                 \ Ship type for a Coriolis space station
ESC = 3                 \ Ship type for an escape pod
PLT = 4                 \ Ship type for an alloy plate
OIL = 5                 \ Ship type for a cargo canister
AST = 7                 \ Ship type for an asteroid
SPL = 8                 \ Ship type for a splinter
SHU = 9                 \ Ship type for a Shuttle
CYL = 11                \ Ship type for a Cobra Mk III
ANA = 14                \ Ship type for an Anaconda
COPS = 16               \ Ship type for a Viper
SH3 = 17                \ Ship type for a Sidewinder
KRA = 19                \ Ship type for a Krait
ADA = 20                \ Ship type for a Adder
WRM = 23                \ Ship type for a Worm
CYL2 = 24               \ Ship type for a Cobra Mk III (pirate)
ASP = 25                \ Ship type for an Asp Mk II
THG = 29                \ Ship type for a Thargoid
TGL = 30                \ Ship type for a Thargon
CON = 31                \ Ship type for a Constrictor

JL = ESC                \ Junk is defined as starting from the escape pod

JH = SHU+2              \ Junk is defined as ending before the Cobra Mk III
                        \
                        \ So junk is defined as the following: escape pod,
                        \ alloy plate, cargo canister, asteroid, splinter,
                        \ Shuttle or Transporter

PACK = SH3              \ The first of the eight pack-hunter ships, which tend
                        \ to spawn in groups. With the default value of PACK the
                        \ pack-hunters are the Sidewinder, Mamba, Krait, Adder,
                        \ Gecko, Cobra Mk I, Worm and Cobra Mk III (pirate)

POW = 15                \ Pulse laser power

Mlas = 50               \ Mining laser power

Armlas = INT(128.5+1.5*POW) \ Military laser power

NI% = 37                \ The number of bytes in each ship's data block (as
                        \ stored in INWK and K%)

OSBYTE = &FFF4          \ The address for the OSBYTE routine
OSWORD = &FFF1          \ The address for the OSWORD routine
OSFILE = &FFDD          \ The address for the OSFILE routine
OSWRCH = &FFEE          \ The address for the OSWRCH routine
OSCLI = &FFF7           \ The address for the OSCLI routine

VIA = &FE00             \ Memory-mapped space for accessing internal hardware,
                        \ such as the video ULA, 6845 CRTC and 6522 VIAs (also
                        \ known as SHEILA)

VSCAN = 57              \ Defines the split position in the split-screen mode

X = 128                 \ The centre x-coordinate of the 256 x 192 space view
Y = 96                  \ The centre y-coordinate of the 256 x 192 space view

f0 = &20                \ Internal key number for red key f0 (Launch, Front)
f1 = &71                \ Internal key number for red key f1 (Buy Cargo, Rear)
f2 = &72                \ Internal key number for red key f2 (Sell Cargo, Left)
f3 = &73                \ Internal key number for red key f3 (Equip Ship, Right)
f4 = &14                \ Internal key number for red key f4 (Long-range Chart)
f5 = &74                \ Internal key number for red key f5 (Short-range Chart)
f6 = &75                \ Internal key number for red key f6 (Data on System)
f7 = &16                \ Internal key number for red key f7 (Market Price)
f8 = &76                \ Internal key number for red key f8 (Status Mode)
f9 = &77                \ Internal key number for red key f9 (Inventory)

NRU% = 25               \ The number of planetary systems with extended system
                        \ description overrides in the RUTOK table

VE = 0                  \ The obfuscation byte used to hide the extended tokens
                        \ table from crackers viewing the binary code, which is
                        \ zero in Elite-A as the token table is not obfuscated

LL = 30                 \ The length of lines (in characters) of justified text
                        \ in the extended tokens system

QQ18 = &0400            \ The address of the text token table, as set in
                        \ elite-loader3.asm

SNE = &07C0             \ The address of the sine lookup table, as set in
                        \ elite-loader3.asm

ACT = &07E0             \ The address of the arctan lookup table, as set in
                        \ elite-loader3.asm

QQ16_FLIGHT = &0880     \ The address of the two-letter text token table in the
                        \ flight code (this gets populated by the docked code at
                        \ the start of the game)

CATD = &0D7A            \ The address of the CATD routine that is put in place
                        \ by the third loader, as set in elite-loader3.asm

IRQ1 = &114B            \ The address of the IRQ1 routine that implements the
                        \ split screen interrupt handler, as set in
                        \ elite-loader3.asm

BRBR1 = &11D5           \ The address of the main break handler, which BRKV
                        \ points to as set in elite-loader3.asm

NA% = &1181             \ The address of the data block for the last saved
                        \ commander, as set in elite-loader3.asm

CHK2 = &11D3            \ The address of the second checksum byte for the saved
                        \ commander data file, as set in elite-loader3.asm

CHK = &11D4             \ The address of the first checksum byte for the saved
                        \ commander data file, as set in elite-loader3.asm

SHIP_MISSILE = &7F00    \ The address of the missile ship blueprint, as set in
                        \ elite-loader3.asm

\ ******************************************************************************
\
\ ELITE A FILE
\
\ ******************************************************************************

CODE% = &1200
LOAD% = &1200

ORG CODE%

LOAD_A% = LOAD%

key_tube = &90

brkv = &0202
wrchv = &020E

tube_r1s = &FEE0
tube_r1d = &FEE1
tube_r2s = &FEE2
tube_r2d = &FEE3
tube_r3s = &FEE4
tube_r3d = &FEE5
tube_r4s = &FEE6
tube_r4d = &FEE7

SC = &92
SCH = &93

font = &94
save_a = &96
save_x = &97
save_y = &98

X1 = &94
Y1 = &95
X2 = &96
Y2 = &97
P = &98
Q = &99
T = &99    \ Added for HLOIN
R = &9A
S = &9B
SWAP = &9C

ZZ = &94
drawpix_2 = &95
drawpix_3 = &96
drawpix_4 = &97
drawpix_5 = &98

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


.tube_elite

 LDX #&FF
 TXS
 LDA #LO(tube_wrch)
 STA wrchv
 LDA #HI(tube_wrch)
 STA wrchv+&01
 LDA #LO(tube_brk)
 STA brkv
 LDA #HI(tube_brk)
 STA brkv+&01
 LDX #LO(tube_run)
 LDY #HI(tube_run)
 JMP OSCLI

tube_brk = &16	\ tube BRK vector


.tube_run

 EQUS "R.2.T", &0D


.tube_get

 BIT tube_r1s
 NOP
 BPL tube_get
 LDA tube_r1d
 RTS


.tube_put

 BIT tube_r2s
 NOP
 BVC tube_put
 STA tube_r2d
 RTS


.tube_func

 CMP #&9D		\ OUT
 BCS return		\ OUT
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


.tube_table

 EQUW LL30, HLOIN, PIXEL, clr_scrn
 EQUW CLYNS, sync_in, draw_bar, draw_angle
 EQUW put_missle, scan_fire, write_fe4e, scan_xin
 EQUW scan_10in, get_key, write_xyc, write_pod
 EQUW draw_blob, draw_tail, draw_S, draw_E
 EQUW draw_mode, write_crtc, scan_y, write_0346
 EQUW read_0346, return, picture_h, picture_v

.write_xyc

 JSR tube_get
 STA cursor_x
 JSR tube_get
 STA cursor_y
 JSR tube_get
 CMP #&20
 BNE tube_wrch
 LDA #&09

.tube_wrch

 STA save_a
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
 EOR (SC),Y	\ORA (SC),Y
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

.clr_scrn

 LDX #&60

.l_254f

 JSR ZES1
 INX
 CPX #&78
 BNE l_254f
 RTS


.ZES1

 LDY #&00
 STY SC
 TYA
 STX SC+&01

.l_3a07

 STA (SC),Y
 INY
 BNE l_3a07
 RTS


.CLYNS

 LDA #&75
 STA SC+&01
 LDA #&07
 STA SC
 LDA #&00
 JSR LYN
 INC SC+&01
 JSR LYN
 INC SC+&01

.LYN

 LDY #&E9

.l_25c8

 STA (SC),Y
 DEY
 BNE l_25c8
 RTS


.sync_in

 JSR sync
 JMP tube_put


.sync

 LDA #&00
 STA &8B

.sync_wait

 LDA &8B
 BEQ sync_wait
 RTS


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


.draw_angle

 JSR tube_get
 STA angle_1
 JSR tube_get
 STA SC
 JSR tube_get
 STA SC+1
 LDY #&01

.l_1f11

 SEC
 LDA angle_1
 SBC #&04
 BCS l_1f26
 LDA #&FF
 LDX angle_1
 STA angle_1
 LDA CTWOS,X
 AND #&F0
 JMP l_1f2a

.l_1f26

 STA angle_1
 LDA #&00

.l_1f2a

 STA (SC),Y
 INY
 STA (SC),Y
 INY
 STA (SC),Y
 INY
 STA (SC),Y
 TYA
 CLC
 ADC #&05
 TAY
 CPY #&1E
 BCC l_1f11
 RTS


.put_missle

 JSR tube_get
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


.scan_fire

 LDA #&51
 STA &FE60
 LDA &FE40
 AND #&10
 JMP tube_put


.write_fe4e

 JSR tube_get
 STA &FE4E
 JMP tube_put


.scan_xin

 JSR tube_get
 TAX
 JSR DKS4
 JMP tube_put

INCLUDE "library/common/main/subroutine/dks4.asm"

.scan_10in

 JSR RDKEY
 JMP tube_put


.RDKEY

 LDX #&10

.Rd1

 JSR DKS4
 BMI Rd2
 INX
 BPL Rd1
 TXA

.Rd2

 EOR #&80
 CMP #&37	\ CTRL-P hack for printer
 BNE scan_test
 LDX #&01
 JSR DKS4
 BPL scan_p
 JSR printer
 LDA #0
 RTS	

.scan_p

 LDA #&37

.scan_test

 TAX
 RTS


.get_key

 JSR sync
 JSR sync
 JSR RDKEY
 BNE get_key

.press

 JSR RDKEY
 BEQ press
 TAY
 LDA (key_tube),Y
 JMP tube_put


.write_pod

 JSR tube_get
 STA &0386
 JSR tube_get
 STA &0348
 RTS


.draw_blob

 JSR tube_get
 STA ZZ
 JSR tube_get
 STA drawpix_2
 JSR tube_get
 STA drawpix_3

.d_36ac

 LDA drawpix_2
 LSR A
 LSR A
 LSR A
 ORA #&60
 STA SC+&01
 LDA ZZ
 AND #&F8
 STA SC
 LDA drawpix_2
 AND #&07
 TAY
 LDA ZZ
 AND #&06
 LSR A
 TAX
 LDA CTWOS,X
 AND drawpix_3
 EOR (SC),Y
 STA (SC),Y
 LDA CTWOS+1,X
 BPL d_36dd
 LDA SC
 ADC #&08
 STA SC
 LDA CTWOS+1,X

.d_36dd

 AND drawpix_3
 EOR (SC),Y
 STA (SC),Y
 RTS


.draw_tail

 JSR tube_get
 STA ZZ
 JSR tube_get
 STA drawpix_2
 JSR tube_get
 STA drawpix_3
 JSR tube_get
 STA drawpix_4
 JSR tube_get
 STA drawpix_5
 JSR d_36ac
 DEC drawpix_2
 JSR d_36ac
 LDA CTWOS+1,X
 AND drawpix_3	\ iff
 STA drawpix_3
 LDA CTWOS+1,X
 AND drawpix_4
 STA drawpix_4
 LDX drawpix_5
 BEQ d_55da
 BMI d_55db

.d_55ca

 DEY
 BPL d_55d1
 LDY #&07
 DEC SC+&01

.d_55d1

 LDA drawpix_3
 EOR drawpix_4	\ iff
 STA drawpix_3	\ iff
 EOR (SC),Y
 STA (SC),Y
 DEX
 BNE d_55ca

.d_55da

 RTS

.d_55db

 INY
 CPY #&08
 BNE d_55e4
 LDY #&00
 INC SC+&01

.d_55e4

 INY
 CPY #&08
 BNE d_55ed
 LDY #&00
 INC SC+&01

.d_55ed

 LDA drawpix_3
 EOR drawpix_4	\ iff
 STA drawpix_3	\ iff
 EOR (SC),Y
 STA (SC),Y
 INX
 BNE d_55e4
 RTS


.draw_E

 LDA #&38
 LDX #LO(d_3832)
 LDY #HI(d_3832)
 JMP draw_let

.draw_S

 LDA #&C0
 LDX #<(d_3832+3)
 LDY #>(d_3832+3)

.draw_let

 STA SC
 LDA #&7D
 STA SC+1
 STX font
 STY font+1
 LDY #&07

.draw_eor

 LDA (font),Y
 EOR (SC),Y
 STA (SC),Y
 DEY
 BPL draw_eor
 RTS


.d_3832

 EQUB &E0, &E0, &80, &E0, &E0, &80, &E0, &E0, &20, &E0, &E0


.draw_mode

 LDA LIL2+2
 EOR #&40
 STA LIL2+2
 \	LDA LIL3+2
 \	EOR #&40
 STA LIL3+2
 \	LDA LIL5+2
 \	EOR #&40
 STA LIL5+2
 \	LDA LIL6+2
 \	EOR #&40
 STA LIL6+2
 RTS


.write_crtc

 JSR tube_get
 LDX #&06
 SEI
 STX &FE00
 STA &FE01
 CLI
 RTS


.d_4419

 EQUB &E8, &E2, &E6, &E7, &C2, &D1, &C1
 EQUB &60, &70, &23, &35, &65, &22, &45, &63, &37

.b_table

 EQUB &61, &31, &80, &80, &80, &80, &51
 EQUB &64, &34, &32, &62, &52, &54, &58, &38, &68

.b_13

 LDA #&00

.b_14

 TAX
 EOR b_table-1,Y
 BEQ b_quit
 STA &FE60
 AND #&0F
 AND &FE60
 BEQ b_pressed
 TXA
 BMI b_13
 BPL b_quit

.scan_y

 JSR tube_get
 TAY
 JSR tube_get
 BMI b_14
 LDX d_4419-1,Y
 JSR DKS4
 BPL b_quit

.b_pressed

 LDA #&FF

.b_quit

 JMP tube_put


.write_0346

 JSR tube_get
 STA &0346
 RTS


.read_0346

 LDA &0346
 JMP tube_put


.picture_h

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
 JSR l_20e8
 LDA #&04
 LDY #&F8
 JSR l_2101
 LDY picture_2
 BEQ l_2045
 JSR l_20e8
 LDY #&80
 LDA #&40
 JSR l_2101

.l_2045

 RTS


.picture_v

 JSR tube_get
 AND #&F8
 STA SC
 LDX #&60
 STX SC+&01
 LDX #&80
 LDY #&01

.l_205c

 TXA
 AND (SC),Y
 BNE l_2071
 TXA
 ORA (SC),Y
 STA (SC),Y
 INY
 CPY #&08
 BNE l_205c
 INC SC+&01
 LDY #&00
 BEQ l_205c

.l_2071

 RTS


.l_20e8

 LDA #&20

.l_20ea

 TAX
 AND (SC),Y
 BNE l_2100
 TXA
 ORA (SC),Y
 STA (SC),Y
 TXA
 LSR A
 BCC l_20ea
 TYA
 ADC #&07
 TAY
 LDA #&80
 BCC l_20ea

.l_2100

 RTS

.l_2101

 TAX
 AND (SC),Y
 BNE l_2100
 TXA
 ORA (SC),Y
 STA (SC),Y
 TXA
 ASL A
 BCC l_2101
 TYA
 SBC #&08
 TAY
 LDA #&01
 BCS l_2101
 RTS

rawrch = &FFBC


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
 \	JSR print_safe
 \	JMP tube_put


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