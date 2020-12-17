\ ******************************************************************************
\
\ 6502 SECOND PROCESSOR ELITE GAME SOURCE (I/O PROCESSOR)
\
\ 6502 Second Processor Elite was written by Ian Bell and David Braben and is
\ copyright Acornsoft 1985
\
\ The code on this site is identical to the version released on Ian Bell's
\ personal website at http://www.elitehomepage.org/
\
\ The commentary is copyright Mark Moxon, and any misunderstandings or mistakes
\ in the documentation are entirely my fault
\
\ The terminology and notations used in this commentary are explained at
\ https://www.bbcelite.com/about_site/terminology_used_in_this_commentary.html
\
\ ******************************************************************************

INCLUDE "versions/6502sp/sources/elite-header.h.asm"

CPU 1

_CASSETTE_VERSION       = TRUE AND (_VERSION = 1)
_DISC_VERSION           = TRUE AND (_VERSION = 2)
_6502SP_VERSION         = TRUE AND (_VERSION = 3)

CODE% = &2400
LOAD% = &2400

C% = &2400
L% = C%
D% = &D000

Z = 0
XX15 = &90
X1 = XX15
Y1 = XX15+1
X2 = XX15+2
Y2 = XX15+3
SC = XX15+6
SCH = SC+1
OSTP = SC
OSWRCH = &FFEE
OSBYTE = &FFF4
OSWORD = &FFF1
OSFILE = &FFDD
SCLI = &FFF7

VIA = &FE00             \ Memory-mapped space for accessing internal hardware,
                        \ such as the video ULA, 6845 CRTC and 6522 VIAs (also
                        \ known as SHEILA)

IRQ1V = &204
VSCAN = 57
XX21 = D%
WRCHV = &20E
WORDV = &20C
RDCHV = &210
NVOSWRCH = &FFCB
Tina = &B00
Y = 96
\protlen = 0
PARMAX = 15

YELLOW  = %00001111     \ Four mode 1 pixels of colour 1 (yellow)
RED     = %11110000     \ Four mode 1 pixels of colour 2 (red, magenta or white)
CYAN    = %11111111     \ Four mode 1 pixels of colour 3 (cyan or white)
GREEN   = %10101111     \ Four mode 1 pixels of colour 3, 1, 3, 1 (cyan/yellow)
WHITE   = %11111010     \ Four mode 1 pixels of colour 3, 2, 3, 2 (cyan/red)
MAGENTA = RED
DUST    = WHITE

RED2    = %00000011     \ Two mode 2 pixels of colour 1    (red)
GREEN2  = %00001100     \ Two mode 2 pixels of colour 2    (green)
YELLOW2 = %00001111     \ Two mode 2 pixels of colour 3    (yellow)
BLUE2   = %00110000     \ Two mode 2 pixels of colour 4    (blue)
MAG2    = %00110011     \ Two mode 2 pixels of colour 5    (magenta)
CYAN2   = %00111100     \ Two mode 2 pixels of colour 6    (cyan)
WHITE2  = %00111111     \ Two mode 2 pixels of colour 7    (white)
STRIPE  = %00100011     \ Two mode 2 pixels of colour 5, 1 (magenta/red)

INCLUDE "library/6502sp/io/workspace/zp.asm"
INCLUDE "library/6502sp/io/variable/table.asm"
INCLUDE "library/6502sp/io/workspace/font_per_cent.asm"
INCLUDE "library/6502sp/io/variable/log.asm"
INCLUDE "library/6502sp/io/variable/logl.asm"
INCLUDE "library/6502sp/io/variable/antilog.asm"
INCLUDE "library/6502sp/io/variable/antilogodd.asm"
INCLUDE "library/6502sp/io/variable/ylookup.asm"
INCLUDE "library/6502sp/io/variable/tvt3.asm"
INCLUDE "library/6502sp/io/workspace/io_variables.asm"
INCLUDE "library/6502sp/io/variable/jmptab.asm"
INCLUDE "library/6502sp/io/subroutine/startup.asm"
INCLUDE "library/6502sp/io/subroutine/putback.asm"
INCLUDE "library/6502sp/io/subroutine/usoswrch.asm"
INCLUDE "library/common/main/subroutine/det1-dodials.asm"
INCLUDE "library/6502sp/io/subroutine/dofe21.asm"
INCLUDE "library/6502sp/io/subroutine/dohfx.asm"
INCLUDE "library/6502sp/io/subroutine/doviae.asm"
INCLUDE "library/6502sp/io/subroutine/docatf.asm"
INCLUDE "library/6502sp/io/subroutine/docol.asm"
INCLUDE "library/6502sp/io/subroutine/dosvn.asm"
INCLUDE "library/6502sp/io/subroutine/dobrk.asm"
INCLUDE "library/6502sp/io/subroutine/printer.asm"
INCLUDE "library/6502sp/io/subroutine/poswrch.asm"
INCLUDE "library/6502sp/io/subroutine/tosend.asm"
INCLUDE "library/6502sp/io/subroutine/prilf.asm"
INCLUDE "library/6502sp/io/subroutine/dobulb.asm"
INCLUDE "library/6502sp/io/subroutine/ecblb.asm"
INCLUDE "library/common/main/variable/spbt.asm"
INCLUDE "library/common/main/variable/ecbt.asm"
INCLUDE "library/6502sp/io/subroutine/dot.asm"
INCLUDE "library/common/main/subroutine/cpix4.asm"
INCLUDE "library/common/main/subroutine/cpix2.asm"
INCLUDE "library/6502sp/io/subroutine/sc48.asm"
INCLUDE "library/6502sp/io/subroutine/beginlin.asm"
INCLUDE "library/6502sp/io/subroutine/addbyt.asm"
INCLUDE "library/6502sp/io/variable/twos.asm"
INCLUDE "library/6502sp/io/variable/twos2.asm"
INCLUDE "library/6502sp/io/variable/ctwos.asm"
INCLUDE "library/6502sp/io/subroutine/hloin2.asm"
INCLUDE "library/6502sp/io/subroutine/loin_part_1_of_7.asm"
INCLUDE "library/6502sp/io/subroutine/loin_part_2_of_7.asm"
INCLUDE "library/6502sp/io/subroutine/loin_part_3_of_7.asm"
INCLUDE "library/6502sp/io/subroutine/loin_part_4_of_7.asm"
INCLUDE "library/6502sp/io/subroutine/loin_part_5_of_7.asm"
INCLUDE "library/6502sp/io/subroutine/loin_part_6_of_7.asm"
INCLUDE "library/6502sp/io/subroutine/loin_part_7_of_7.asm"
INCLUDE "library/6502sp/io/subroutine/hloin.asm"
INCLUDE "library/6502sp/io/variable/twfl.asm"
INCLUDE "library/6502sp/io/variable/twfr.asm"
INCLUDE "library/6502sp/io/variable/orange.asm"
INCLUDE "library/6502sp/io/subroutine/pixel.asm"
INCLUDE "library/6502sp/io/variable/pxcl.asm"
INCLUDE "library/6502sp/io/subroutine/newosrdch.asm"
INCLUDE "library/common/main/subroutine/add.asm"
INCLUDE "library/6502sp/io/subroutine/hanger.asm"
INCLUDE "library/common/main/subroutine/dvid4.asm"
INCLUDE "library/6502sp/io/subroutine/adparams.asm"
INCLUDE "library/6502sp/io/subroutine/rdparams.asm"
INCLUDE "library/6502sp/io/macro/dks4.asm"
INCLUDE "library/6502sp/io/variable/kytb.asm"
INCLUDE "library/6502sp/io/subroutine/keyboard.asm"
INCLUDE "library/6502sp/io/variable/oswvecs.asm"
INCLUDE "library/6502sp/io/subroutine/nwoswd.asm"
INCLUDE "library/common/main/subroutine/msbar.asm"
INCLUDE "library/common/main/subroutine/wscan.asm"
INCLUDE "library/6502sp/io/subroutine/dodks4.asm"
INCLUDE "library/6502sp/io/subroutine/cls.asm"
INCLUDE "library/6502sp/io/subroutine/tt67.asm"
INCLUDE "library/common/main/subroutine/tt26.asm"
INCLUDE "library/6502sp/io/subroutine/ttx66.asm"
INCLUDE "library/common/main/subroutine/zes1.asm"
INCLUDE "library/common/main/subroutine/zes2.asm"
INCLUDE "library/6502sp/io/subroutine/setxc.asm"
INCLUDE "library/6502sp/io/subroutine/setyc.asm"
INCLUDE "library/6502sp/io/subroutine/someprot.asm"
INCLUDE "library/6502sp/io/subroutine/clyns.asm"
INCLUDE "library/common/main/subroutine/dials_part_1_of_4.asm"
INCLUDE "library/common/main/subroutine/dials_part_2_of_4.asm"
INCLUDE "library/common/main/subroutine/dials_part_3_of_4.asm"
INCLUDE "library/common/main/subroutine/dials_part_4_of_4.asm"
INCLUDE "library/6502sp/io/subroutine/pzw2.asm"
INCLUDE "library/common/main/subroutine/pzw.asm"
INCLUDE "library/common/main/subroutine/dilx.asm"
INCLUDE "library/common/main/subroutine/dil2.asm"
INCLUDE "library/6502sp/io/variable/tvt1.asm"
INCLUDE "library/6502sp/io/subroutine/do65c02.asm"
INCLUDE "library/common/main/subroutine/irq1.asm"
INCLUDE "library/6502sp/io/subroutine/setvdu19.asm"

\ ******************************************************************************
\
\ Save output/I.CODE.bin
\
\ ******************************************************************************

PRINT "I.CODE"
PRINT "Assembled at ", ~CODE%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD%
PRINT "protlen = ", ~protlen

PRINT "S.I.CODE ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
SAVE "versions/6502sp/output/I.CODE.bin", CODE%, P%, LOAD%
