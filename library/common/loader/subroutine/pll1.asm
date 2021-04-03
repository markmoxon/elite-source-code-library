\ ******************************************************************************
\
\       Name: PLL1
\       Type: Subroutine
\   Category: Drawing planets
\    Summary: Draw Saturn on the loading screen
\
\ ------------------------------------------------------------------------------
\
\ Part 1 (PLL1) x 1280 - planet
\
\   * Draw pixels at (x, y) where:
\
\     r1 = random number from 0 to 255
\     r2 = random number from 0 to 255
\     (r1^2 + r1^2) < 128^2
\
\     y = r2, squished into 64 to 191 by negation
\
\     x = SQRT(128^2 - (r1^2 + r1^2)) / 2
\
\ Part 2 (PLL2) x 477 - stars
\
\   * Draw pixels at (x, y) where:
\
\     y = random number from 0 to 255
\     y = random number from 0 to 255
\     (x^2 + y^2) div 256 > 17
\
\ Part 3 (PLL3) x 1280 - rings
\
\   * Draw pixels at (x, y) where:
\
\     r5 = random number from 0 to 255
\     r6 = random number from 0 to 255
\     r7 = r5, squashed into -32 to 31
\
\     32 <= (r5^2 + r6^2 + r7^2) / 256 <= 79
\     Draw 50% fewer pixels when (r6^2 + r7^2) / 256 <= 16
\
\     x = r5 + r7
\     y = r5
\
\ Draws pixels within the diagonal band of horizontal width 64, from top-left to
\ bottom-right of the screen.
\
\ ******************************************************************************

.PLL1

IF _CASSETTE_VERSION \ Comment

                        \ The following loop iterates CNT(1 0) times, i.e. &500
                        \ or 1280 times, and draws the planet part of the
                        \ loading screen's Saturn

ELIF _6502SP_VERSION OR _DISC_VERSION OR _MASTER_VERSION

                        \ The following loop iterates CNT(1 0) times, i.e. &300
                        \ or 768 times, and draws the planet part of the
                        \ loading screen's Saturn

ENDIF

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_VERSION \ Master: For most versions, the loading screen's Saturn is drawn randomly, so the dots are different every time the game loads. However, the Master version always draws exactly the same pixels for the Saturn, as the random number generator gets seeded to the same value every time

 LDA VIA+&44            \ Read the 6522 System VIA T1C-L timer 1 low-order
 STA RAND+1             \ counter (SHEILA &44), which increments 1000 times a
                        \ second so this will be pretty random, and store it in
                        \ RAND+1 among the hard-coded random seeds in RAND

ELIF _MASTER_VERSION

 STA RAND+1             \ Store A in RAND+1 among the hard-coded random seeds
                        \ in RAND. We set A to %00001111 before calling the PLL1
                        \ routine, so this sets the random number generator so
                        \ that it always generates the same numbers every time,
                        \ which is probably not what was intended (other
                        \ versions read the 6522 System VIA timer to use as a
                        \ seed, which is random). As a result, if you look at
                        \ the Saturn on the Master loading screen, it is always
                        \ exactly the same, every time you run the game

ENDIF

 JSR DORND              \ Set A and X to random numbers, say A = r1

 JSR SQUA2              \ Set (A P) = A * A
                        \           = r1^2

 STA ZP+1               \ Set ZP(1 0) = (A P)
 LDA P                  \             = r1^2
 STA ZP

IF _DISC_VERSION \ Other: Group A: The disc version contains various bits of copy protection code injected into the Saturn-drawing routine in the loader. In the original versions of Elite, the only self-modifying code is in the copy protection, though later versions do use this technique in the main game code

 LDA #LO(OSBmod)        \ As part of the copy protection, the JSR OSB
 STA OSBjsr+1           \ instruction at OSBjsr gets modified to point to OSBmod
                        \ instead of OSB, and this is where we modify the low
                        \ byte of the destination address

ENDIF

 JSR DORND              \ Set A and X to random numbers, say A = r2

 STA YY                 \ Set YY = A
                        \        = r2

 JSR SQUA2              \ Set (A P) = A * A
                        \           = r2^2

 TAX                    \ Set (X P) = (A P)
                        \           = r2^2

 LDA P                  \ Set (A ZP) = (X P) + ZP(1 0)
 ADC ZP                 \
 STA ZP                 \ first adding the low bytes

 TXA                    \ And then adding the high bytes
 ADC ZP+1

 BCS PLC1               \ If the addition overflowed, jump down to PLC1 to skip
                        \ to the next pixel

 STA ZP+1               \ Set ZP(1 0) = (A ZP)
                        \             = r1^2 + r2^2

 LDA #1                 \ Set ZP(1 0) = &4001 - ZP(1 0) - (1 - C)
 SBC ZP                 \             = 128^2 - ZP(1 0)
 STA ZP                 \
                        \ (as the C flag is clear), first subtracting the low
                        \ bytes

 LDA #&40               \ And then subtracting the high bytes
 SBC ZP+1
 STA ZP+1

 BCC PLC1               \ If the subtraction underflowed, jump down to PLC1 to
                        \ skip to the next pixel

                        \ If we get here, then both calculations fitted into
                        \ 16 bits, and we have:
                        \
                        \   ZP(1 0) = 128^2 - (r1^2 + r2^2)
                        \
                        \ where ZP(1 0) >= 0

 JSR ROOT               \ Set ZP = SQRT(ZP(1 0))

 LDA ZP                 \ Set X = ZP >> 1
 LSR A                  \       = SQRT(128^2 - (a^2 + b^2)) / 2
 TAX

 LDA YY                 \ Set A = YY
                        \       = r2

 CMP #128               \ If YY >= 128, set the C flag (so the C flag is now set
                        \ to bit 7 of A)

 ROR A                  \ Rotate A and set the sign bit to the C flag, so bits
                        \ 6 and 7 are now the same, i.e. A is a random number in
                        \ one of these ranges:
                        \
                        \   %00000000 - %00111111  = 0 to 63    (r2 = 0 - 127)
                        \   %11000000 - %11111111  = 192 to 255 (r2 = 128 - 255)
                        \
                        \ The PIX routine flips bit 7 of A before drawing, and
                        \ that makes -A in these ranges:
                        \
                        \   %10000000 - %10111111  = 128-191
                        \   %01000000 - %01111111  = 64-127
                        \
                        \ so that's in the range 64 to 191

 JSR PIX                \ Draw a pixel at screen coordinate (X, -A), i.e. at
                        \
                        \   (ZP / 2, -A)
                        \
                        \ where ZP = SQRT(128^2 - (r1^2 + r2^2))
                        \
                        \ So this is the same as plotting at (x, y) where:
                        \
                        \   r1 = random number from 0 to 255
                        \   r1 = random number from 0 to 255
                        \   (r1^2 + r1^2) < 128^2
                        \
                        \   y = r2, squished into 64 to 191 by negation
                        \
                        \   x = SQRT(128^2 - (r1^2 + r1^2)) / 2
                        \
                        \ which is what we want

.PLC1

 DEC CNT                \ Decrement the counter in CNT (the low byte)

 BNE PLL1               \ Loop back to PLL1 until CNT = 0

 DEC CNT+1              \ Decrement the counter in CNT+1 (the high byte)

 BNE PLL1               \ Loop back to PLL1 until CNT+1 = 0

IF _CASSETTE_VERSION \ Other: Group B: The cassette version contains various bits of copy protection code injected into the Saturn-drawing routine in the loader

 LDX #&C2               \ Set the low byte of EXCN(1 0) to &C2, so we now have
 STX EXCN               \ EXCN(1 0) = &03C2, which we will use in the IRQ1
                        \ handler (this has nothing to do with drawing Saturn,
                        \ it's all part of the copy protection)

ENDIF

                        \ The following loop iterates CNT2(1 0) times, i.e. &1DD
                        \ or 477 times, and draws the background stars on the
                        \ loading screen

.PLL2

 JSR DORND              \ Set A and X to random numbers, say A = r3

 TAX                    \ Set X = A
                        \       = r3

 JSR SQUA2              \ Set (A P) = A * A
                        \           = r3^2

 STA ZP+1               \ Set ZP+1 = A
                        \          = r3^2 / 256

 JSR DORND              \ Set A and X to random numbers, say A = r4

 STA YY                 \ Set YY = r4

 JSR SQUA2              \ Set (A P) = A * A
                        \           = r4^2

 ADC ZP+1               \ Set A = A + r3^2 / 256
                        \       = r4^2 / 256 + r3^2 / 256
                        \       = (r3^2 + r4^2) / 256

 CMP #&11               \ If A < 17, jump down to PLC2 to skip to the next pixel
 BCC PLC2

 LDA YY                 \ Set A = r4

 JSR PIX                \ Draw a pixel at screen coordinate (X, -A), i.e. at
                        \ (r3, -r4), where (r3^2 + r4^2) / 256 >= 17
                        \
                        \ Negating a random number from 0 to 255 still gives a
                        \ random number from 0 to 255, so this is the same as
                        \ plotting at (x, y) where:
                        \
                        \   x = random number from 0 to 255
                        \   y = random number from 0 to 255
                        \   (x^2 + y^2) div 256 >= 17
                        \
                        \ which is what we want

.PLC2

 DEC CNT2               \ Decrement the counter in CNT2 (the low byte)

 BNE PLL2               \ Loop back to PLL2 until CNT2 = 0

 DEC CNT2+1             \ Decrement the counter in CNT2+1 (the high byte)

 BNE PLL2               \ Loop back to PLL2 until CNT2+1 = 0

IF _CASSETTE_VERSION \ Other: See group B

 LDX MHCA               \ Set the low byte of BLPTR(1 0) to the contents of MHCA
 STX BLPTR              \ (which is &CA), so we now have BLPTR(1 0) = &03CA,
                        \ which we will use in the IRQ1 handler (this has
                        \ nothing to do with drawing Saturn, it's all part of
                        \ the copy protection)

 LDX #&C6               \ Set the low byte of BLN(1 0) to &C6, so we now have
 STX BLN                \ BLN(1 0) = &03C6, which we will use in the IRQ1
                        \ handler (this has nothing to do with drawing Saturn,
                        \ it's all part of the copy protection)

ENDIF

IF _CASSETTE_VERSION \ Comment

                        \ The following loop iterates CNT3(1 0) times, i.e. &500
                        \ or 1280 times, and draws the rings around the loading
                        \ screen's Saturn

ELIF _6502SP_VERSION OR _DISC_VERSION OR _MASTER_VERSION

                        \ The following loop iterates CNT3(1 0) times, i.e. &333
                        \ or 819 times, and draws the rings around the loading
                        \ screen's Saturn

ENDIF

.PLL3

 JSR DORND              \ Set A and X to random numbers, say A = r5

 STA ZP                 \ Set ZP = r5

 JSR SQUA2              \ Set (A P) = A * A
                        \           = r5^2

 STA ZP+1               \ Set ZP+1 = A
                        \          = r5^2 / 256

IF _DISC_VERSION \ Other: See group A

 LDA #HI(OSBmod)        \ As part of the copy protection, the JSR OSB
 STA OSBjsr+2           \ instruction at OSBjsr gets modified to point to OSBmod
                        \ instead of OSB, and this is where we modify the high
                        \ byte of the destination address

ENDIF

 JSR DORND              \ Set A and X to random numbers, say A = r6

 STA YY                 \ Set YY = r6

 JSR SQUA2              \ Set (A P) = A * A
                        \           = r6^2

 STA T                  \ Set T = A
                        \       = r6^2 / 256

 ADC ZP+1               \ Set ZP+1 = A + r5^2 / 256
 STA ZP+1               \          = r6^2 / 256 + r5^2 / 256
                        \          = (r5^2 + r6^2) / 256

 LDA ZP                 \ Set A = ZP
                        \       = r5

 CMP #128               \ If A >= 128, set the C flag (so the C flag is now set
                        \ to bit 7 of ZP, i.e. bit 7 of A)

 ROR A                  \ Rotate A and set the sign bit to the C flag, so bits
                        \ 6 and 7 are now the same

 CMP #128               \ If A >= 128, set the C flag (so again, the C flag is
                        \ set to bit 7 of A)

 ROR A                  \ Rotate A and set the sign bit to the C flag, so bits
                        \ 5-7 are now the same, i.e. A is a random number in one
                        \ of these ranges:
                        \
                        \   %00000000 - %00011111  = 0-31
                        \   %11100000 - %11111111  = 224-255
                        \
                        \ In terms of signed 8-bit integers, this is a random
                        \ number from -32 to 31. Let's call it r7

 ADC YY                 \ Set X = A + YY
 TAX                    \       = r7 + r6

 JSR SQUA2              \ Set (A P) = r7 * r7

 TAY                    \ Set Y = A
                        \       = r7 * r7 / 256

 ADC ZP+1               \ Set A = A + ZP+1
                        \       = r7^2 / 256 + (r5^2 + r6^2) / 256
                        \       = (r5^2 + r6^2 + r7^2) / 256

 BCS PLC3               \ If the addition overflowed, jump down to PLC3 to skip
                        \ to the next pixel

 CMP #80                \ If A >= 80, jump down to PLC3 to skip to the next
 BCS PLC3               \ pixel

 CMP #32                \ If A < 32, jump down to PLC3 to skip to the next pixel
 BCC PLC3

 TYA                    \ Set A = Y + T
 ADC T                  \       = r7^2 / 256 + r6^2 / 256
                        \       = (r6^2 + r7^2) / 256

 CMP #16                \ If A > 16, skip to PL1 to plot the pixel
 BCS PL1

 LDA ZP                 \ If ZP is positive (50% chance), jump down to PLC3 to
 BPL PLC3               \ skip to the next pixel

.PL1

 LDA YY                 \ Set A = YY
                        \       = r6

 JSR PIX                \ Draw a pixel at screen coordinate (X, -A), where:
                        \
                        \   X = (random -32 to 31) + r6
                        \   A = r6
                        \
                        \ Negating a random number from 0 to 255 still gives a
                        \ random number from 0 to 255, so this is the same as
                        \ plotting at (x, y) where:
                        \
                        \   r5 = random number from 0 to 255
                        \   r6 = random number from 0 to 255
                        \   r7 = r5, squashed into -32 to 31
                        \
                        \   x = r5 + r7
                        \   y = r5
                        \
                        \   32 <= (r5^2 + r6^2 + r7^2) / 256 <= 79
                        \   Draw 50% fewer pixels when (r6^2 + r7^2) / 256 <= 16
                        \
                        \ which is what we want

.PLC3

 DEC CNT3               \ Decrement the counter in CNT3 (the low byte)

 BNE PLL3               \ Loop back to PLL3 until CNT3 = 0

 DEC CNT3+1             \ Decrement the counter in CNT3+1 (the high byte)

 BNE PLL3               \ Loop back to PLL3 until CNT3+1 = 0

IF _DISC_VERSION \ Other: See group A

 LDA #&00               \ Set ZP(1 0) = &6300
 STA ZP
 LDA #&63
 STA ZP+1

 LDA #&62               \ Set P(1 0) = &2A62
 STA P
 LDA #&2A
 STA P+1

 LDX #8                 \ Call MVPG with X = 8 to copy 8 pages of memory from
 JSR MVPG               \ the address in P(1 0) to the address in ZP(1 0)

ENDIF

