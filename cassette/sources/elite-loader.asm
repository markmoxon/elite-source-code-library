\ ******************************************************************************
\
\ ELITE LOADER SOURCE
\
\ Elite was written by Ian Bell and David Braben and is copyright Acornsoft 1984
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
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * output/ELITE.unprot.bin
\
\ after reading in the following files:
\
\   * binaries/DIALS.bin
\   * binaries/P.ELITE.bin
\   * binaries/P.A-SOFT.bin
\   * binaries/P.(C)ASFT.bin
\   * output/WORDS9.bin
\   * output/PYTHON.bin
\
\ ******************************************************************************

\ ******************************************************************************
\
\ Terminology used in this commentary
\ ===================================
\
\ There's a lot to explain in Elite, and some of it is pretty challenging stuff.
\ Before getting stuck in, it's probably wise to take a brief look at some of
\ the terminology I've used in this commentary.
\
\ Let's start with some general terms.
\
\   * Given a number X, ~X is the number with all the bits inverted
\
\   * Given a number A, |A| is the absolute of that number - i.e. the number
\     with no sign, or just the magnitude of the number
\
\   * Given a multi-byte number, (S R) say, the absolute would be written |S R|
\     (see below for more on multi-byte numbers and terminology)
\
\   * Coordinates are shown as (x, y), both on the screen and in space, so the
\     centre of the space view is at screen coordinate (128, 96), while our
\     trusty Cobra Mk III is at space coordinates (0, 0, 0)
\
\   * Vectors and matrices are enclosed in square brackets, like this:
\
\       [ 1   0   0 ]        [ x ]
\       [ 0   1   0 ]   or   [ y ]
\       [ 0   0  -1 ]        [ z ]
\
\     We might sometimes write a column vector as [x y z] instead, just to save
\     space, but it means the same thing as the vertical version
\
\ We also need some terminology for multi-byte numbers, but that needs its own
\ section, particularly as Elite has quite a few variations on this theme.
\
\ Multi-byte numbers
\ ------------------
\ Not surprisingly, Elite deals with some pretty big numbers. For example, the
\ cash reserves are stored as big-endian 32-bit numbers, space coordinates are
\ stored as 24-bit sign-magnitude little-endian numbers, and the joystick gives
\ us two's complement signed 16-bit numbers. When you only have the 8-bit bytes
\ of 6502 assembly language to play with, things can get confusing, and quickly.
\
\ First, let's recap some basic definitions, so we're all on the same page.
\
\   * Big-endian numbers store their most significant bytes first, then the
\     least significant bytes. This is how humans tend to write numbers.
\
\   * Little-endian numbers store the least significant bytes first then the
\     most significant ones. The 6502 stores its addresses in little-endian
\     format, as do the EQUD and EQUW operatives, for example.
\
\   * Sign-magnitude numbers store their sign in their highest bit, and the
\     rest of the number contains the magnitude of the number (i.e. the number
\     without the sign). You can change the sign of a sign-magnitude number by
\     simply flipping the highest bit (bit 7 in an 8-bit sign-magnitude number,
\     bit 15 in a 16-bit sign-magnitude number, and so on). See below for more
\     on sign-magnitude numbers.
\
\   * Two's complement numbers, meanwhile, are the mainstay of 6502 assembly
\     language, and instructions like ADC and SBC are designed to work with both
\     negative and positive two's complement numbers without us having to worry
\     about a thing. They also have a sign bit in the highest bit, but negative
\     numbers have their bits flipped compared to positive numbers. To flip the
\     sign of a number in two's complement, you flip all the bits and add 1.
\
\ Elite uses a smorgasbord of all these types, and it can get pretty confusing.
\ Given this, let's agree on some terminology to make it easier to talk about
\ multi-byte numbers and how they are stored in memory.
\
\ If we have three bytes called x_sign, x_hi and x_lo, which contain a 24-bit
\ sign-magnitude number, with the highest byte in x_sign and the lowest in x_lo,
\ then we can refer to their 32-bit number like this:
\
\   (x_sign x_hi x_lo)
\
\ In this terminology, the most significant byte is always written first,
\ irrespective of how the bytes are stored in memory. So, we can talk about
\ 16-bit numbers made up of registers:
\
\   (X Y)
\
\ So here X is the high byte and Y the low byte. Or here's a 24-bit number made
\ up of a mix of registers and memory locations:
\
\   (A S S+1)
\
\ Again, the most significant byte is on the left, so that's the accumulator A,
\ then the next most significant is in memory location S, and the least
\ significant byte is in S+1.
\
\ Or we can even talk about numbers made up of registers, memory locations and
\ constants, like this 24-bit number:
\
\   (A P 0)
\
\ or this constant, which stores 590 in a 32-bit number:
\
\   (2 78)
\
\ Just remember that in every case, the high byte is on the left, and the low
\ byte is on the right.
\
\ When talking about numbers in sequential memory locations, we can use another
\ shorthand. Consider this little-endian number:
\
\   (K+3 K+2 K+1 K)
\
\ where a 32-bit little-endian number is stored in memory locations K (low byte)
\ through to K+3 (high byte). We can also refer to this number like this:
\
\   K(3 2 1 0)
\
\ Or a big-endian number stored in XX15 through XX15+3 would be:
\
\   XX15(0 1 2 3)
\
\ where XX15 is the most significant byte and XX15+3 the least significant. We
\ could also refer to the little-endian 16-bit number stored in the X-th byte
\ of the block at XX3 with:
\
\   XX3+X(1 0)
\
\ To take this even further, if we want to add another significant byte to the
\ 32-bit number K(3 2 1 0) to make a five-byte, 40-bit number - an overflow byte
\ in a memory location called S, say - then we might talk about:
\
\   K(S 3 2 1 0)
\
\ or even something like this:
\
\   XX15(4 0 1 2 3)
\
\ which is a five-byte number stored with the highest byte in XX15+4, then the
\ next most significant in XX15, then XX15+1 and XX15+2, through to the lowest
\ byte in XX15+3. And yes, Elite does store one of its numbers like this - see
\ the BPRNT routine for the gory details.
\
\ With this terminology, it might help to think of the digits listed in the
\ brackets as being written down in the same order that we would write them
\ down as humans. The point of this terminology is to make it easier for people
\ to read, after all.
\
\ Sign-magnitude numbers
\ ----------------------
\ Many (but not all) of Elite's multi-byte numbers are stored as sign-magnitude
\ numbers.
\
\ For example the x, y and z coordinates in bytes #0-8 of the ship data block in
\ INWK and K% (which contain a ship's coordinates in space) are stored as 24-bit
\ sign-magnitude numbers, where the sign of the number is stored in bit 7 of the
\ sign byte, and the other 23 bits contain the magnitude of the number without
\ any sign (i.e. the absolute value, |x|, |y| or |z|). So an x value of &123456
\ would be stored like this:
\
\      x_sign          x_hi          x_lo
\   +     &12           &34           &56
\   0 0010010      00110100      01010110
\
\ while -&123456 is identical, just with bit 7 of the x_sign byte set:
\
\      x_sign          x_hi          x_lo
\   -     &12           &34           &56
\   1 0010010      00110100      01010110
\
\ There are also sign-magnitude numbers where the sign byte is only ever used
\ for storing the sign bit, and bits 0-6 are ignored, and there are others where
\ we only ever care about the top byte (a planet's distance, for example, is
\ determined by the value of x_sign, y_sign and z_sign, for example). But they
\ all work in exactly the same way.
\
\ ******************************************************************************

INCLUDE "cassette/sources/elite-header.h.asm"

_CASSETTE_VERSION       = TRUE AND (_VERSION = 1)
_DISC_VERSION           = TRUE AND (_VERSION = 2)
_6502SP_VERSION         = TRUE AND (_VERSION = 3)

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

DISC = TRUE             \ Set to TRUE to load the code above DFS and relocate
                        \ down, so we can load the cassette version from disc

PROT = FALSE            \ Set to TRUE to enable the tape protection code

LOAD% = &1100           \ LOAD% is the load address of the main game code file
                        \ ("ELTcode" for loading from disc, "ELITEcode" for
                        \ loading from tape)

C% = &0F40              \ C% is set to the location that the main game code gets
                        \ moved to after it is loaded

S% = C%                 \ S% points to the entry point for the main game code

L% = LOAD% + &28        \ L% points to the start of the actual game code from
                        \ elite-source.asm, after the &28 bytes of header code
                        \ that are inserted by elite-bcfs.asm

D% = &563A              \ D% is set to the size of the main game code

LC% = &6000 - C%        \ LC% is set to the maximum size of the main game code
                        \ (as the code starts at C% and screen memory starts
                        \ at &6000)

N% = 67                 \ N% is set to the number of bytes in the VDU table, so
                        \ we can loop through them in part 2 below

SVN = &7FFD             \ SVN is where we store the "saving in progress" flag,
                        \ and it matches the location in elite-source.asm

VEC = &7FFE             \ VEC is where we store the original value of the IRQ1
                        \ vector, and it matches the value in elite-source.asm

LEN1 = 15               \ Size of the BEGIN% routine that gets pushed onto the
                        \ stack and executed there

LEN2 = 18               \ Size of the MVDL routine that gets pushed onto the
                        \ stack and executed there

LEN = LEN1 + LEN2       \ Total number of bytes that get pushed on the stack for
                        \ execution there (33)

LE% = &0B00             \ LE% is the address to which the code from UU% onwards
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

IF DISC
 CODE% = &E00+&300      \ CODE% is set to the assembly address of the loader
                        \ code file that we assemble in this file ("ELITE")
ELSE
 CODE% = &E00
ENDIF

NETV = &224             \ MOS vectors that we want to intercept
IRQ1V = &204

OSWRCH = &FFEE          \ The address for the OSWRCH routine
OSBYTE = &FFF4          \ The address for the OSBYTE routine
OSWORD = &FFF1          \ The address for the OSWORD routine

OSPRNT = &234           \ The address for the OSPRNT vector

VIA = &FE40             \ Memory-mapped space for accessing the 6845 CRTC

USVIA = VIA             \ Memory-mapped space for accessing the 6845 CRTC

VSCAN = 57-1            \ Defines the split position in the split-screen mode

TRTB% = &04             \ TRTB%(1 0) points to the keyboard translation table

ZP = &70                \ Temporary storage, used all over the place

P = &72                 \ Temporary storage, used all over the place

Q = &73                 \ Temporary storage, used all over the place

YY = &74                \ Temporary storage, used when drawing Saturn

T = &75                 \ Temporary storage, used all over the place

SC = &76                \ Used to store the screen address while plotting pixels

BLPTR = &78             \ Gets set to &03CA as part of the obfuscation code

V219 = &7A              \ Gets set to &0218 as part of the obfuscation code

K3 = &80                \ Temporary storage, used for preserving the A register

BLCNT = &81             \ Stores the tape loader block count as part of the copy
                        \ protection code in IRQ1

BLN = &83               \ Gets set to &03C6 as part of the obfuscation code

EXCN = &85              \ Gets set to &03C2 as part of the obfuscation code

INCLUDE "library/cassette/loader/subroutine_elite_loader_part_1_of_6.asm"
INCLUDE "library/common/loader/variable_b_per_cent.asm"
INCLUDE "library/common/loader/variable_e_per_cent.asm"
INCLUDE "library/cassette/loader/subroutine_swine.asm"
INCLUDE "library/cassette/loader/subroutine_osb.asm"
INCLUDE "library/cassette/loader/variable_authors_names.asm"
INCLUDE "library/cassette/loader/variable_oscliv.asm"
INCLUDE "library/cassette/loader/variable_david9.asm"
INCLUDE "library/cassette/loader/variable_david23.asm"
INCLUDE "library/cassette/loader/subroutine_doprot1.asm"
INCLUDE "library/cassette/loader/variable_mhca.asm"
INCLUDE "library/cassette/loader/subroutine_david7.asm"
INCLUDE "library/common/loader/macro_fne.asm"
INCLUDE "library/cassette/loader/subroutine_elite_loader_part_2_of_6.asm"
INCLUDE "library/cassette/loader/subroutine_elite_loader_part_3_of_6.asm"
INCLUDE "library/cassette/loader/subroutine_elite_loader_part_4_of_6.asm"
INCLUDE "library/common/loader/subroutine_pll1.asm"
INCLUDE "library/common/loader/subroutine_dornd.asm"
INCLUDE "library/common/loader/subroutine_squa2.asm"
INCLUDE "library/common/loader/subroutine_pix.asm"
INCLUDE "library/common/loader/variable_twos.asm"
INCLUDE "library/common/loader/variable_cnt.asm"
INCLUDE "library/common/loader/variable_cnt2.asm"
INCLUDE "library/common/loader/variable_cnt3.asm"
INCLUDE "library/common/loader/subroutine_root.asm"
INCLUDE "library/cassette/loader/subroutine_begin_per_cent.asm"
INCLUDE "library/cassette/loader/subroutine_domove.asm"
INCLUDE "library/cassette/loader/workspace_uu_per_cent.asm"
INCLUDE "library/cassette/loader/variable_checkbyt.asm"
INCLUDE "library/cassette/loader/variable_mainsum.asm"
INCLUDE "library/cassette/loader/variable_foolv.asm"
INCLUDE "library/cassette/loader/variable_checkv.asm"
INCLUDE "library/cassette/loader/variable_block1.asm"
INCLUDE "library/cassette/loader/variable_block2.asm"
INCLUDE "library/cassette/loader/subroutine_tt26.asm"
INCLUDE "library/cassette/loader/subroutine_osprint.asm"
INCLUDE "library/cassette/loader/subroutine_command.asm"
INCLUDE "library/cassette/loader/variable_mess1.asm"
INCLUDE "library/cassette/loader/subroutine_elite_loader_part_5_of_6.asm"
INCLUDE "library/cassette/loader/variable_m2.asm"
INCLUDE "library/cassette/loader/subroutine_irq1.asm"
INCLUDE "library/cassette/loader/variable_block.asm"
INCLUDE "library/cassette/loader/subroutine_elite_loader_part_6_of_6.asm"
INCLUDE "library/cassette/loader/subroutine_checker.asm"
INCLUDE "library/cassette/loader/variable_xc.asm"
INCLUDE "library/cassette/loader/variable_yc.asm"

\ ******************************************************************************
\
\ Save output/ELITE.unprot.bin
\
\ ******************************************************************************

COPYBLOCK LE%, P%, UU%  \ Copy the block that we assembled at LE% to UU%, which
                        \ is where it will actually run

PRINT "BLOCK offset = ", ~(BLOCK - LE%) + (UU% - CODE%)
PRINT "ENDBLOCK offset = ",~(ENDBLOCK - LE%) + (UU% - CODE%)
PRINT "MAINSUM offset = ",~(MAINSUM - LE%) + (UU% - CODE%)
PRINT "TUT offset = ",~(TUT - LE%) + (UU% - CODE%)
PRINT "UU% = ",~UU%," Q% = ",~Q%, " OSB = ",~OSB

PRINT "Memory usage: ", ~LE%, " - ",~P%
PRINT "Stack: ",LEN + ENDBLOCK - BLOCK

PRINT "S. ELITE ", ~CODE%, " ", ~UU% + (P% - LE%), " ", ~run, " ", ~CODE%
SAVE "cassette/output/ELITE.unprot.bin", CODE%, UU% + (P% - LE%), run, CODE%
