\ ******************************************************************************
\
\ ELECTRON ELITE LOADER SOURCE
\
\ Electron Elite was written by Ian Bell and David Braben and is copyright
\ Acornsoft 1984
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
\   * output/ELITEDA.bin
\
\ ******************************************************************************

INCLUDE "versions/electron/sources/elite-header.h.asm"

_CASSETTE_VERSION       = (_VERSION = 1)
_DISC_VERSION           = (_VERSION = 2)
_6502SP_VERSION         = (_VERSION = 3)
_MASTER_VERSION         = (_VERSION = 4)
_ELECTRON_VERSION       = (_VERSION = 5)

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

N% = 17                 \ N% is set to the number of bytes in the VDU table, so
                        \ we can loop through them in part 2 below

LE% = &0B00             \ LE% is the address to which the code from UU% onwards
                        \ is copied in part 3

C% = &0D00              \ C% is set to the location that the main game code gets
                        \ moved to after it is loaded

L% = &2000              \ L% is the load address of the main game code file

S% = C%                 \ S% points to the entry point for the main game code

USERV = &0200           \ The address for the user vector
BRKV = &0202            \ The address for the break vector
IRQ1V = &0204           \ The address for the interrupt vector
WRCHV = &020E           \ The address for the write character vector
RDCHV = &0210           \ The address for the read character vector
KEYV = &0228            \ The address for the keyboard vector

OSWRCH = &FFEE          \ The address for the OSWRCH routine
OSBYTE = &FFF4          \ The address for the OSBYTE routine
OSWORD = &FFF1          \ The address for the OSWORD routine
OSCLI = &FFF7           \ The address for the OSCLI routine

VIA = &FE00             \ Memory-mapped space for accessing internal hardware,
                        \ such as the video ULA, 6845 CRTC and 6522 VIAs (also
                        \ known as SHEILA)

INCLUDE "library/cassette/loader/workspace/zp.asm"

\ ******************************************************************************
\
\ ELITE LOADER
\
\ ******************************************************************************

CODE% = &4400
LOAD% = &4400

ORG CODE%

INCLUDE "library/electron/loader/subroutine/elite_loader_part_1_of_5.asm"
INCLUDE "library/common/loader/variable/b_per_cent.asm"
INCLUDE "library/common/loader/variable/e_per_cent.asm"
INCLUDE "library/cassette/loader/subroutine/swine.asm"
INCLUDE "library/common/loader/subroutine/osb.asm"
INCLUDE "library/cassette/loader/variable/authors_names.asm"
INCLUDE "library/cassette/loader/variable/oscliv.asm"
INCLUDE "library/cassette/loader/variable/david9.asm"
INCLUDE "library/cassette/loader/variable/david23.asm"
INCLUDE "library/cassette/loader/subroutine/doprot1.asm"
INCLUDE "library/cassette/loader/variable/mhca.asm"
INCLUDE "library/cassette/loader/subroutine/david7.asm"
INCLUDE "library/common/loader/macro/fne.asm"
INCLUDE "library/electron/loader/subroutine/elite_loader_part_2_of_5.asm"
INCLUDE "library/electron/loader/subroutine/elite_loader_part_3_of_5.asm"
INCLUDE "library/electron/loader/subroutine/elite_loader_part_4_of_5.asm"
INCLUDE "library/common/loader/subroutine/pll1.asm"
INCLUDE "library/common/loader/subroutine/dornd.asm"
INCLUDE "library/common/loader/subroutine/squa2.asm"
INCLUDE "library/common/loader/subroutine/pix.asm"
INCLUDE "library/common/loader/variable/twos.asm"
INCLUDE "library/common/loader/variable/cnt.asm"
INCLUDE "library/common/loader/variable/cnt2.asm"
INCLUDE "library/common/loader/variable/cnt3.asm"
INCLUDE "library/common/loader/subroutine/root.asm"
INCLUDE "library/electron/loader/subroutine/crunchit.asm"
INCLUDE "library/electron/loader/subroutine/begin_per_cent.asm"
INCLUDE "library/electron/loader/workspace/uu_per_cent.asm"
INCLUDE "library/electron/loader/subroutine/elite_loader_part_5_of_5.asm"
INCLUDE "library/electron/loader/variable/mess1.asm"

 SKIP 13                \ These bytes appear to be unused

\ ******************************************************************************
\
\ Save output/ELITE.unprot.bin
\
\ ******************************************************************************

COPYBLOCK LE%, P%, UU%  \ Copy the block that we assembled at LE% to UU%, which
                        \ is where it will actually run

PRINT "S.ELITEDA ", ~CODE%, " ", ~UU% + (P% - LE%), " ", ~run, " ", ~CODE%
SAVE "versions/electron/output/ELITEDA.bin", CODE%, UU% + (P% - LE%), run, CODE%
