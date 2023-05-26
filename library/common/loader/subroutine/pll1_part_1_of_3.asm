\ ******************************************************************************
\
\       Name: PLL1 (Part 1 of 3)
\       Type: Subroutine
\   Category: Drawing planets
\    Summary: Draw Saturn on the loading screen (draw the planet)
\  Deep dive: Drawing Saturn on the loading screen
\
\ ******************************************************************************

.PLL1

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Comment

                        \ The following loop iterates CNT(1 0) times, i.e. &500
                        \ or 1280 times, and draws the planet part of the
                        \ loading screen's Saturn

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION

                        \ The following loop iterates CNT(1 0) times, i.e. &300
                        \ or 768 times, and draws the planet part of the
                        \ loading screen's Saturn

ENDIF

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Master: For most versions, the loading screen's Saturn is drawn randomly, so the dots are different every time the game loads. However, the Master version always draws exactly the same pixels for the Saturn, as the random number generator gets seeded to the same value every time

 LDA VIA+&44            \ Read the 6522 System VIA T1C-L timer 1 low-order
 STA RAND+1             \ counter (SHEILA &44), which decrements one million
                        \ times a second and will therefore be pretty random,
                        \ and store it in location RAND+1, which is among the
                        \ main game code's random seeds in RAND (so this seeds
                        \ the random number generator)

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

IF _DISC_VERSION \ Other: The disc version contains various bits of copy protection code injected into the Saturn-drawing routine in the loader. In the original versions of Elite, the only self-modifying code is in the copy protection, though later versions do use this technique in the main game code

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
                        \   r2 = random number from 0 to 255
                        \   (r1^2 + r2^2) < 128^2
                        \
                        \   y = r2, squished into 64 to 191 by negation
                        \
                        \   x = SQRT(128^2 - (r1^2 + r2^2)) / 2
                        \
                        \ which is what we want

.PLC1

 DEC CNT                \ Decrement the counter in CNT (the low byte)

 BNE PLL1               \ Loop back to PLL1 until CNT = 0

 DEC CNT+1              \ Decrement the counter in CNT+1 (the high byte)

 BNE PLL1               \ Loop back to PLL1 until CNT+1 = 0

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Other: Group A: The cassette and Electron versions contain various bits of copy protection code injected into part 1 of the Saturn-drawing routine in the loader

 LDX #&C2               \ Set the low byte of EXCN(1 0) to &C2, so we now have
 STX EXCN               \ EXCN(1 0) = &03C2, which we will use in the IRQ1
                        \ handler (this has nothing to do with drawing Saturn,
                        \ it's all part of the copy protection)

ENDIF

IF _ELECTRON_VERSION \ Other: See group A

 LDX #&60               \ This is normally part of the copy protection, but it's
 STX &0087              \ been disabled in this unprotected version so this has
                        \ no effect (though the crackers presumably thought they
                        \ might as well still set the value just in case)

ENDIF

