\ ******************************************************************************
\
\       Name: PLL1 (Part 3 of 3)
\       Type: Subroutine
\   Category: Drawing planets
\    Summary: Draw Saturn on the loading screen (draw the rings)
\  Deep dive: Drawing Saturn on the loading screen
\
\ ******************************************************************************

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Comment

                        \ The following loop iterates CNT3(1 0) times, i.e. &500
                        \ or 1280 times, and draws the rings around the loading
                        \ screen's Saturn

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION

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

 ADC YY                 \ Set A = A + YY
                        \       = r7 + r6

 TAX                    \ Set X = A
                        \       = r6 + r7

 JSR SQUA2              \ Set (A P) = A * A
                        \           = (r6 + r7)^2

 TAY                    \ Set Y = A
                        \       = (r6 + r7)^2 / 256

 ADC ZP+1               \ Set A = A + ZP+1
                        \       = (r6 + r7)^2 / 256 + (r5^2 + r6^2) / 256
                        \       = ((r6 + r7)^2 + r5^2 + r6^2) / 256

 BCS PLC3               \ If the addition overflowed, jump down to PLC3 to skip
                        \ to the next pixel

 CMP #80                \ If A >= 80, jump down to PLC3 to skip to the next
 BCS PLC3               \ pixel

 CMP #32                \ If A < 32, jump down to PLC3 to skip to the next pixel
 BCC PLC3

 TYA                    \ Set A = Y + T
 ADC T                  \       = (r6 + r7)^2 / 256 + r6^2 / 256
                        \       = ((r6 + r7)^2 + r6^2) / 256

 CMP #16                \ If A >= 16, skip to PL1 to plot the pixel
 BCS PL1

 LDA ZP                 \ If ZP is positive (i.e. r5 < 128), jump down to PLC3
 BPL PLC3               \ to skip to the next pixel

.PL1

                        \ If we get here then the following is true:
                        \
                        \   32 <= ((r6 + r7)^2 + r5^2 + r6^2) / 256 < 80
                        \
                        \ and either this is true:
                        \
                        \   ((r6 + r7)^2 + r6^2) / 256 >= 16
                        \
                        \ or both these are true:
                        \
                        \   ((r6 + r7)^2 + r6^2) / 256 < 16
                        \   r5 >= 128

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
                        \   x = r6 + r7
                        \   y = r6
                        \
                        \   32 <= ((r6 + r7)^2 + r5^2 + r6^2) / 256 < 80
                        \
                        \   Either: ((r6 + r7)^2 + r6^2) / 256 >= 16
                        \
                        \   Or:     ((r6 + r7)^2 + r6^2) / 256 <  16
                        \           r5 >= 128
                        \
                        \ which is what we want

.PLC3

 DEC CNT3               \ Decrement the counter in CNT3 (the low byte)

 BNE PLL3               \ Loop back to PLL3 until CNT3 = 0

 DEC CNT3+1             \ Decrement the counter in CNT3+1 (the high byte)

 BNE PLL3               \ Loop back to PLL3 until CNT3+1 = 0

IF _DISC_VERSION \ Other: See group A

                        \ The following code is not required, as we copy the
                        \ title images to their correct places on-screen when
                        \ we return from the subroutine, overwriting the copy
                        \ that we do here

 LDA #&00               \ Set ZP(1 0) = &6300
 STA ZP
 LDA #&63
 STA ZP+1

 LDA #LO(ELITE)         \ Set P(1 0) = ELITE
 STA P
 LDA #HI(ELITE)
 STA P+1

 LDX #8                 \ Call MVPG with X = 8 to copy 8 pages of memory from
 JSR MVPG               \ ELITE to &6300

ELIF _ELITE_A_VERSION

                        \ The following code is not required, as we copy the
                        \ title images to their correct places on-screen when
                        \ we return from the subroutine, overwriting the copy
                        \ that we do here

 LDA #&00               \ Set ZP(1 0) = &6300
 STA ZP
 LDA #&63
 STA ZP+1

 LDA #&62               \ Set P(1 0) = &2A62
 STA P
 LDA #&2A
 STA P+1

 LDX #8                 \ Call MVPG with X = 8 to copy 8 pages of memory from
 JSR MVPG               \ &2A62 to &6300

ENDIF

