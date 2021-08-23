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
\ been reformatted, and the label names have been changed to be consistent with
\ the sources for the original BBC Micro disc version on which it is based)
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
\   * 3-assembled-output/2.H.bin
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
_ELITE_A_SHIPS_R        = FALSE
_ELITE_A_SHIPS_S        = FALSE
_ELITE_A_SHIPS_T        = FALSE
_ELITE_A_SHIPS_U        = FALSE
_ELITE_A_SHIPS_V        = FALSE
_ELITE_A_SHIPS_W        = FALSE
_ELITE_A_ENCYCLOPEDIA   = FALSE
_ELITE_A_6502SP_IO      = TRUE
_ELITE_A_6502SP_PARA    = FALSE
_RELEASED               = (_RELEASE = 1)
_SOURCE_DISC            = (_RELEASE = 2)
_BUG_FIX                = (_RELEASE = 3)

GUARD &6000             \ Guard against assembling over screen memory

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

X = 128                 \ The centre x-coordinate of the 256 x 192 space view
Y = 96                  \ The centre y-coordinate of the 256 x 192 space view

tube_brk = &0016        \ The location of the Tube host code's break handler

BRKV = &0202            \ The break vector that we intercept to enable us to
                        \ handle and display system errors

WRCHV = &020E           \ The WRCHV vector that we intercept with our custom
                        \ text printing routine

LASCT = &0346           \ The laser pulse count for the current laser, matching
                        \ the address in the main game code

HFX = &0348             \ A flag that toggles the hyperspace colour effect,
                        \ matching the address in the main game code

ESCP = &0386            \ The flag that determines whether we have an escape pod
                        \ fitted, matching the address in the main game code

VIA = &FE00             \ Memory-mapped space for accessing internal hardware,
                        \ such as the video ULA, 6845 CRTC and 6522 VIAs (also
                        \ known as SHEILA)

tube_r1s = &FEE0        \ The Tube's memory-mapped FIFO 1 status register
tube_r1d = &FEE1        \ The Tube's memory-mapped FIFO 1 data register
tube_r2s = &FEE2        \ The Tube's memory-mapped FIFO 2 status register
tube_r2d = &FEE3        \ The Tube's memory-mapped FIFO 2 data register
tube_r3s = &FEE4        \ The Tube's memory-mapped FIFO 3 status register
tube_r3d = &FEE5        \ The Tube's memory-mapped FIFO 3 data register
tube_r4s = &FEE6        \ The Tube's memory-mapped FIFO 4 status register
tube_r4d = &FEE7        \ The Tube's memory-mapped FIFO 4 data register

rawrch = &FFBC          \ The address of the MOS's VDU character output routine

OSBYTE = &FFF4          \ The address for the OSBYTE routine
OSCLI = &FFF7           \ The address for the OSCLI routine

INCLUDE "library/elite-a/io/workspace/zp.asm"

\ ******************************************************************************
\
\ ELITE I/O PROCESSOR
\
\ ******************************************************************************

CODE% = &1200
LOAD% = &1200

ORG CODE%

INCLUDE "library/elite-a/io/subroutine/tube_elite.asm"
INCLUDE "library/elite-a/io/variable/tube_run.asm"
INCLUDE "library/elite-a/io/subroutine/tube_get.asm"
INCLUDE "library/elite-a/io/subroutine/tube_put.asm"
INCLUDE "library/elite-a/io/subroutine/tube_func.asm"
INCLUDE "library/elite-a/io/variable/tube_table.asm"
INCLUDE "library/elite-a/io/subroutine/chpr.asm"
INCLUDE "library/elite-a/io/subroutine/tube_wrch.asm"
INCLUDE "library/elite-a/io/subroutine/wrch_font.asm"
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
INCLUDE "library/elite-a/io/subroutine/clr_scrn.asm"
INCLUDE "library/common/main/subroutine/zes1.asm"
INCLUDE "library/common/main/subroutine/zes2.asm"
INCLUDE "library/common/main/subroutine/clyns.asm"
INCLUDE "library/original/main/subroutine/lyn.asm"
INCLUDE "library/elite-a/io/subroutine/sync_in.asm"
INCLUDE "library/common/main/subroutine/wscan.asm"
INCLUDE "library/common/main/subroutine/dilx.asm"
INCLUDE "library/common/main/subroutine/dil2.asm"
INCLUDE "library/elite-a/io/subroutine/msbar.asm"
INCLUDE "library/elite-a/io/subroutine/scan_fire.asm"
INCLUDE "library/elite-a/io/subroutine/write_fe4e.asm"
INCLUDE "library/elite-a/io/subroutine/scan_xin.asm"
INCLUDE "library/common/main/subroutine/dks4.asm"
INCLUDE "library/elite-a/io/subroutine/scan_10in.asm"
INCLUDE "library/common/main/subroutine/rdkey.asm"
INCLUDE "library/elite-a/io/subroutine/get_key.asm"
INCLUDE "library/elite-a/io/subroutine/write_pod.asm"
INCLUDE "library/elite-a/io/subroutine/draw_blob.asm"
INCLUDE "library/common/main/subroutine/cpix2.asm"
INCLUDE "library/elite-a/io/subroutine/draw_tail.asm"
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
INCLUDE "library/elite-a/io/subroutine/scan_y.asm"
INCLUDE "library/elite-a/io/subroutine/write_0346.asm"
INCLUDE "library/elite-a/io/subroutine/read_0346.asm"
INCLUDE "library/elite-a/io/subroutine/hanger.asm"
INCLUDE "library/elite-a/io/subroutine/ha2.asm"
INCLUDE "library/enhanced/main/subroutine/has2.asm"
INCLUDE "library/enhanced/main/subroutine/has3.asm"
INCLUDE "library/elite-a/io/subroutine/printer.asm"
INCLUDE "library/elite-a/io/subroutine/print_tone.asm"
INCLUDE "library/elite-a/io/subroutine/print_esc.asm"
INCLUDE "library/elite-a/io/subroutine/print_wrch.asm"
INCLUDE "library/elite-a/io/subroutine/print_safe.asm"

\ ******************************************************************************
\
\ Save 3-assembled-output/2.H.bin
\
\ ******************************************************************************

PRINT "S.2.H ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
SAVE "versions/elite-a/3-assembled-output/2.H.bin", CODE%, P%, LOAD%