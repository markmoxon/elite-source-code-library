\ ******************************************************************************
\
\ 6502 SECOND PROCESSOR ELITE GAME SOURCE (I/O PROCESSOR)
\
\ 6502 Second Processor Elite was written by Ian Bell and David Braben and is
\ copyright Acornsoft 1985
\
\ The code on this site is identical to the source discs released on Ian Bell's
\ personal website at http://www.elitehomepage.org/ (it's just been reformatted
\ to be more readable)
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
\   * I.CODE.bin
\
\ ******************************************************************************

 INCLUDE "versions/6502sp/1-source-files/main-sources/elite-build-options.asm"

 _CASSETTE_VERSION      = (_VERSION = 1)
 _DISC_VERSION          = (_VERSION = 2)
 _6502SP_VERSION        = (_VERSION = 3)
 _MASTER_VERSION        = (_VERSION = 4)
 _ELECTRON_VERSION      = (_VERSION = 5)
 _ELITE_A_VERSION       = (_VERSION = 6)
 _SOURCE_DISC           = (_VARIANT = 1)
 _SNG45                 = (_VARIANT = 2)
 _EXECUTIVE             = (_VARIANT = 3)
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

 GUARD &4000            \ Guard against assembling over screen memory

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

 VSCAN = 57             \ Defines the split position in the split-screen mode

 Y = 96                 \ The centre y-coordinate of the 256 x 192 space view

 YELLOW  = %00001111    \ Four mode 1 pixels of colour 1 (yellow)
 RED     = %11110000    \ Four mode 1 pixels of colour 2 (red, magenta or white)
 CYAN    = %11111111    \ Four mode 1 pixels of colour 3 (cyan or white)
 GREEN   = %10101111    \ Four mode 1 pixels of colour 3, 1, 3, 1 (cyan/yellow)
 WHITE   = %11111010    \ Four mode 1 pixels of colour 3, 2, 3, 2 (cyan/red)
 MAGENTA = RED          \ Four mode 1 pixels of colour 2 (red, magenta or white)
 DUST    = WHITE        \ Four mode 1 pixels of colour 3, 2, 3, 2 (cyan/red)

 RED2    = %00000011    \ Two mode 2 pixels of colour 1    (red)
 GREEN2  = %00001100    \ Two mode 2 pixels of colour 2    (green)
 YELLOW2 = %00001111    \ Two mode 2 pixels of colour 3    (yellow)
 BLUE2   = %00110000    \ Two mode 2 pixels of colour 4    (blue)
 MAG2    = %00110011    \ Two mode 2 pixels of colour 5    (magenta)
 CYAN2   = %00111100    \ Two mode 2 pixels of colour 6    (cyan)
 WHITE2  = %00111111    \ Two mode 2 pixels of colour 7    (white)
 STRIPE  = %00100011    \ Two mode 2 pixels of colour 5, 1 (magenta/red)

 PARMAX = 15            \ The number of dashboard parameters transmitted with
                        \ the #RDPARAMS and OSWRCH 137 <param> commands

 IRQ1V = &0204          \ The IRQ1V vector that we intercept to implement the
                        \ split-screen mode

 WRCHV = &020E          \ The WRCHV vector that we intercept to implement our
                        \ own custom OSWRCH commands for communicating over the
                        \ Tube

 WORDV = &020C          \ The WORDV vector that we intercept to implement our
                        \ own custom OSWORD commands for communicating over the
                        \ Tube

 RDCHV = &0210          \ The RDCHV vector that we intercept to add validation
                        \ when reading characters using OSRDCH

 Tina = &0B00           \ The address of the code block for the TINA command,
                        \ which should start with "TINA" and then be followed by
                        \ code that executes on the I/O processor before the
                        \ main game code terminates

 VIA = &FE00            \ Memory-mapped space for accessing internal hardware,
                        \ such as the video ULA, 6845 CRTC and 6522 VIAs (also
                        \ known as SHEILA)

 NVOSWRCH = &FFCB       \ The address for the non-vectored OSWRCH routine

 OSWRCH = &FFEE         \ The address for the OSWRCH routine
 OSBYTE = &FFF4         \ The address for the OSBYTE routine
 OSWORD = &FFF1         \ The address for the OSWORD routine

 CODE% = &2400          \ The assembly address of the main I/O processor code
 LOAD% = &2400          \ The load address of the main I/O processor code

INCLUDE "library/6502sp/io/workspace/zp.asm"
INCLUDE "library/6502sp/io/variable/table.asm"
INCLUDE "library/advanced/main/variable/font_per_cent.asm"
INCLUDE "library/6502sp/io/variable/log.asm"
INCLUDE "library/6502sp/io/variable/logl.asm"
INCLUDE "library/6502sp/io/variable/antilog.asm"
INCLUDE "library/6502sp/io/variable/antilogodd.asm"
INCLUDE "library/advanced/main/variable/ylookup.asm"
INCLUDE "library/advanced/main/variable/tvt3.asm"
INCLUDE "library/6502sp/io/workspace/i_o_variables.asm"
INCLUDE "library/6502sp/io/variable/jmptab.asm"
INCLUDE "library/advanced/main/subroutine/startup.asm"
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
INCLUDE "library/common/main/subroutine/spblb-dobulb.asm"
INCLUDE "library/common/main/subroutine/ecblb.asm"
INCLUDE "library/common/main/variable/spbt.asm"
INCLUDE "library/common/main/variable/ecbt.asm"
INCLUDE "library/common/main/subroutine/dot.asm"
INCLUDE "library/common/main/subroutine/cpix4.asm"
INCLUDE "library/common/main/subroutine/cpix2.asm"
INCLUDE "library/6502sp/io/subroutine/sc48.asm"
INCLUDE "library/6502sp/io/subroutine/beginlin.asm"
INCLUDE "library/6502sp/io/subroutine/addbyt.asm"
INCLUDE "library/advanced/main/variable/twos.asm"
INCLUDE "library/advanced/main/variable/twos2.asm"
INCLUDE "library/advanced/main/variable/ctwos.asm"
INCLUDE "library/6502sp/io/subroutine/hloin2.asm"
INCLUDE "library/common/main/subroutine/loin_part_1_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_2_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_3_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_4_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_5_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_6_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_7_of_7.asm"
INCLUDE "library/common/main/subroutine/hloin.asm"
INCLUDE "library/advanced/main/variable/twfl.asm"
INCLUDE "library/advanced/main/variable/twfr.asm"
INCLUDE "library/advanced/main/variable/orange.asm"
INCLUDE "library/common/main/subroutine/pixel.asm"
INCLUDE "library/advanced/main/variable/pxcl.asm"
INCLUDE "library/6502sp/io/subroutine/newosrdch.asm"
INCLUDE "library/common/main/subroutine/add.asm"
INCLUDE "library/enhanced/main/subroutine/hanger.asm"
INCLUDE "library/enhanced/main/subroutine/has2.asm"
INCLUDE "library/enhanced/main/subroutine/has3.asm"
INCLUDE "library/common/main/subroutine/dvid4-dvid4_duplicate.asm"
INCLUDE "library/6502sp/io/subroutine/adparams.asm"
INCLUDE "library/6502sp/io/subroutine/rdparams.asm"
INCLUDE "library/common/main/subroutine/dks4.asm"
INCLUDE "library/6502sp/io/variable/kytb.asm"
INCLUDE "library/6502sp/io/subroutine/keyboard.asm"
INCLUDE "library/6502sp/io/variable/oswvecs.asm"
INCLUDE "library/6502sp/io/subroutine/nwoswd.asm"
INCLUDE "library/common/main/subroutine/msbar.asm"
INCLUDE "library/common/main/subroutine/wscan.asm"
INCLUDE "library/6502sp/io/subroutine/dodks4.asm"
INCLUDE "library/advanced/main/subroutine/cls.asm"
INCLUDE "library/advanced/main/subroutine/tt67-tt67_duplicate.asm"
INCLUDE "library/common/main/subroutine/tt26-chpr.asm"
INCLUDE "library/advanced/main/subroutine/ttx66.asm"
INCLUDE "library/common/main/subroutine/zes1.asm"
INCLUDE "library/common/main/subroutine/zes2.asm"
INCLUDE "library/advanced/main/subroutine/setxc-doxc.asm"
INCLUDE "library/advanced/main/subroutine/setyc-doyc.asm"
INCLUDE "library/6502sp/io/subroutine/someprot.asm"
INCLUDE "library/common/main/subroutine/clyns.asm"
INCLUDE "library/common/main/subroutine/dials_part_1_of_4.asm"
INCLUDE "library/common/main/subroutine/dials_part_2_of_4.asm"
INCLUDE "library/common/main/subroutine/dials_part_3_of_4.asm"
INCLUDE "library/common/main/subroutine/dials_part_4_of_4.asm"
INCLUDE "library/advanced/main/subroutine/pzw2.asm"
INCLUDE "library/common/main/subroutine/pzw.asm"
INCLUDE "library/common/main/subroutine/dilx.asm"
INCLUDE "library/common/main/subroutine/dil2.asm"
INCLUDE "library/advanced/main/variable/tvt1.asm"
INCLUDE "library/6502sp/io/subroutine/do65c02.asm"
INCLUDE "library/common/main/subroutine/irq1.asm"
INCLUDE "library/advanced/main/subroutine/setvdu19-dovdu19.asm"

\ ******************************************************************************
\
\ Save I.CODE.bin
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
 SAVE "versions/6502sp/3-assembled-output/I.CODE.bin", CODE%, P%, LOAD%
