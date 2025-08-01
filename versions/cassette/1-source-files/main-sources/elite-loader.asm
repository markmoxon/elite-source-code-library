\ ******************************************************************************
\
\ BBC MICRO CASSETTE ELITE GAME LOADER SOURCE
\
\ BBC Micro cassette Elite was written by Ian Bell and David Braben and is
\ copyright Acornsoft 1984
\
\ The code in this file is identical to the source discs released on Ian Bell's
\ personal website at http://www.elitehomepage.org/ (it's just been reformatted
\ to be more readable)
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
\ This source file contains the game loader for BBC Micro cassette Elite.
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * ELITE.unprot.bin
\
\ after reading in the following files:
\
\   * DIALS.bin
\   * P.ELITE.bin
\   * P.A-SOFT.bin
\   * P.(C)ASFT.bin
\   * WORDS9.bin
\   * PYTHON.bin
\
\ ******************************************************************************

 INCLUDE "versions/cassette/1-source-files/main-sources/elite-build-options.asm"

 _CASSETTE_VERSION      = (_VERSION = 1)
 _DISC_VERSION          = (_VERSION = 2)
 _6502SP_VERSION        = (_VERSION = 3)
 _MASTER_VERSION        = (_VERSION = 4)
 _ELECTRON_VERSION      = (_VERSION = 5)
 _ELITE_A_VERSION       = (_VERSION = 6)
 _NES_VERSION           = (_VERSION = 7)
 _C64_VERSION           = (_VERSION = 8)
 _APPLE_VERSION         = (_VERSION = 9)
 _SOURCE_DISC           = (_VARIANT = 1)
 _TEXT_SOURCES          = (_VARIANT = 2)
 _STH_CASSETTE          = (_VARIANT = 3)

 GUARD &6000            \ Guard against assembling over screen memory

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

 DISC = _DISC           \ Set to TRUE to load the code above DFS and relocate
                        \ down, so we can load the cassette version from disc,
                        \ or set to FALSE to load the code as if it were from a
                        \ cassette

 PROT = _PROT           \ Set to TRUE to enable the tape protection code, or set
                        \ to FALSE to disable the code (for TRUE, the file must
                        \ be saved to tape with the block data corrupted, so you
                        \ probably want to leave this as FALSE)

IF DISC

 CODE% = &1100          \ CODE% is set to the assembly address of the loader
                        \ code file that we assemble in this file ("ELITE"),
                        \ which is at the lowest DFS page value of &1100 for the
                        \ version that loads from disc

 LOAD% = &1100          \ LOAD% is the load address of the main game code file
                        \ ("ELTcode" for loading from disc, "ELITEcode" for
                        \ loading from tape)

 L% = &1128             \ L% points to the start of the actual game code from
                        \ elite-source.asm, after the &28 bytes of header code
                        \ that are inserted by elite-bcfs.asm

ELSE

 CODE% = &0E00          \ CODE% is set to the assembly address of the loader
                        \ code file that we assemble in this file ("ELITE"),
                        \ which is at the standard &0E00 address for the version
                        \ that loads from cassette

 LOAD% = &0F1F          \ LOAD% is the load address of the main game code file
                        \ ("ELTcode" for loading from disc, "ELITEcode" for
                        \ loading from tape)

 L% = &0F47             \ L% points to the start of the actual game code from
                        \ elite-source.asm, after the &28 bytes of header code
                        \ that are inserted by elite-bcfs.asm

ENDIF

 LEN1 = 15              \ Size of the BEGIN% routine that gets pushed onto the
                        \ stack and executed there

 LEN2 = 18              \ Size of the MVDL routine that gets pushed onto the
                        \ stack and executed there

 LEN = LEN1 + LEN2      \ Total number of bytes that get pushed on the stack for
                        \ execution there (33)

 VSCAN = 57-1           \ Defines the split position in the split-screen mode

 LE% = &0B00            \ LE% is the address to which the code from UU% onwards
                        \ is copied in part 3. It contains:
                        \
                        \   * ENTRY2, the entry point for the second block of
                        \     loader code
                        \
                        \   * IRQ1, the interrupt routine for the split-screen
                        \     mode
                        \
                        \   * BLOCK, which by this point has already been put
                        \     on the stack by this point
                        \
                        \   * The variables used by the above

 NETV = &0224           \ The NETV vector that we intercept as part of the copy
                        \ protection

 IRQ1V = &0204          \ The IRQ1V vector that we intercept to implement the
                        \ split-screen mode

 OSPRNT = &0234         \ The address for the OSPRNT vector

 C% = &0F40             \ C% is set to the location that the main game code gets
                        \ moved to after it is loaded

 S% = C%                \ S% points to the entry point for the main game code

IF _SOURCE_DISC

 D% = &563A             \ D% is set to the address of the byte after the end of
                        \ the code, i.e. the byte after checksum0 at XX21

ELIF _TEXT_SOURCES

 D% = &5638             \ D% is set to the address of the byte after the end of
                        \ the code, i.e. the byte after checksum0 at XX21

ELIF _STH_CASSETTE

 D% = &563A             \ D% is set to the address of the byte after the end of
                        \ the code, i.e. the byte after checksum0 at XX21

ENDIF

 LC% = &6000 - C%       \ LC% is set to the maximum size of the main game code
                        \ (as the code starts at C% and screen memory starts
                        \ at &6000)

 N% = 67                \ N% is set to the number of bytes in the VDU table, so
                        \ we can loop through them in part 2 below

 SVN = &7FFD            \ SVN is where we store the "saving in progress" flag,
                        \ and it matches the location in elite-source.asm

 VEC = &7FFE            \ VEC is where we store the original value of the IRQ1
                        \ vector, and it matches the value in elite-source.asm

 VIA = &FE00            \ Memory-mapped space for accessing internal hardware,
                        \ such as the video ULA, 6845 CRTC and 6522 VIAs (also
                        \ known as SHEILA)

 OSWRCH = &FFEE         \ The address for the OSWRCH routine

 OSBYTE = &FFF4         \ The address for the OSBYTE routine

 OSWORD = &FFF1         \ The address for the OSWORD routine

INCLUDE "library/original/loader/workspace/zp.asm"

\ ******************************************************************************
\
\ ELITE LOADER
\
\ ******************************************************************************

 ORG CODE%              \ Set the assembly address to CODE%

INCLUDE "library/cassette/loader/subroutine/elite_loader_part_1_of_6.asm"
INCLUDE "library/common/loader/variable/b_per_cent.asm"
INCLUDE "library/common/loader/variable/e_per_cent.asm"
INCLUDE "library/original/loader/subroutine/swine.asm"
INCLUDE "library/common/loader/subroutine/osb.asm"
INCLUDE "library/original/loader/variable/authors_names.asm"
INCLUDE "library/original/loader/variable/oscliv.asm"
INCLUDE "library/original/loader/variable/david9.asm"
INCLUDE "library/original/loader/variable/david23.asm"
INCLUDE "library/original/loader/subroutine/doprot1.asm"
INCLUDE "library/original/loader/variable/mhca.asm"
INCLUDE "library/original/loader/subroutine/david7.asm"
INCLUDE "library/common/loader/macro/fne.asm"
INCLUDE "library/cassette/loader/subroutine/elite_loader_part_2_of_6.asm"
INCLUDE "library/cassette/loader/subroutine/elite_loader_part_3_of_6.asm"
INCLUDE "library/cassette/loader/subroutine/elite_loader_part_4_of_6.asm"
INCLUDE "library/common/loader/subroutine/pll1_part_1_of_3.asm"
INCLUDE "library/common/loader/subroutine/pll1_part_2_of_3.asm"
INCLUDE "library/common/loader/subroutine/pll1_part_3_of_3.asm"
INCLUDE "library/common/loader/subroutine/dornd.asm"
INCLUDE "library/common/loader/subroutine/squa2.asm"
INCLUDE "library/common/loader/subroutine/pix.asm"
INCLUDE "library/common/loader/variable/twos.asm"
INCLUDE "library/common/loader/variable/cnt.asm"
INCLUDE "library/common/loader/variable/cnt2.asm"
INCLUDE "library/common/loader/variable/cnt3.asm"
INCLUDE "library/common/loader/subroutine/root.asm"
INCLUDE "library/cassette/loader/subroutine/begin_per_cent.asm"
INCLUDE "library/cassette/loader/subroutine/domove.asm"
INCLUDE "library/cassette/loader/workspace/uu_per_cent.asm"
INCLUDE "library/cassette/loader/variable/checkbyt.asm"
INCLUDE "library/cassette/loader/variable/mainsum.asm"
INCLUDE "library/cassette/loader/variable/foolv.asm"
INCLUDE "library/cassette/loader/variable/checkv.asm"
INCLUDE "library/cassette/loader/variable/block1.asm"
INCLUDE "library/cassette/loader/variable/block2.asm"
INCLUDE "library/cassette/loader/subroutine/tt26.asm"
INCLUDE "library/cassette/loader/subroutine/osprint.asm"
INCLUDE "library/cassette/loader/subroutine/command.asm"
INCLUDE "library/cassette/loader/variable/mess1.asm"
INCLUDE "library/cassette/loader/subroutine/elite_loader_part_5_of_6.asm"
INCLUDE "library/cassette/loader/variable/m2.asm"
INCLUDE "library/cassette/loader/subroutine/irq1.asm"
INCLUDE "library/cassette/loader/variable/block.asm"
INCLUDE "library/cassette/loader/subroutine/elite_loader_part_6_of_6.asm"
INCLUDE "library/cassette/loader/subroutine/checker.asm"
INCLUDE "library/cassette/loader/variable/xc.asm"
INCLUDE "library/cassette/loader/variable/yc.asm"

\ ******************************************************************************
\
\ Save ELITE.unprot.bin
\
\ ******************************************************************************

 COPYBLOCK LE%, P%, UU%         \ Copy the block that we assembled at LE% to
                                \ UU%, which is where it will actually run

 PRINT "Addresses for the scramble routines in elite-checksum.py"
 PRINT "BLOCK_offset = ", ~(BLOCK - LE%) + (UU% - CODE%)
 PRINT "ENDBLOCK_offset = ", ~(ENDBLOCK - LE%) + (UU% - CODE%)
 PRINT "MAINSUM_offset = ", ~(MAINSUM - LE%) + (UU% - CODE%)
 PRINT "TUT_offset = ", ~(TUT - LE%) + (UU% - CODE%)
 PRINT "CHECKbyt_offset = ", ~(CHECKbyt - LE%) + (UU% - CODE%)
 PRINT "CODE_offset = ", ~(OSB - CODE%)
 PRINT "UU% = ", ~UU%
 PRINT "Q% = ", ~Q%
 PRINT "OSB = ", ~OSB

 PRINT "Memory usage: ", ~LE%, " - ", ~P%
 PRINT "Stack: ",LEN + ENDBLOCK - BLOCK

 PRINT "S. ELITE ", ~CODE%, " ", ~UU% + (P% - LE%), " ", ~run, " ", ~CODE%
 SAVE "versions/cassette/3-assembled-output/ELITE.unprot.bin", CODE%, UU% + (P% - LE%), run, CODE%
