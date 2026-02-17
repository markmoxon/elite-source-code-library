\ ******************************************************************************
\
\       Name: PLL1 (Part 2 of 3)
\       Type: Subroutine
\   Category: Drawing planets
\    Summary: Draw Saturn on the loading screen (draw the stars)
\  Deep dive: Drawing Saturn on the loading screen
\
\ ******************************************************************************

                        \ The following loop iterates CNT2(1 0) times, i.e. &1DD
                        \ or 477 times, and draws the background stars on the
                        \ loading screen

.PLL2

 JSR DORND              \ Set A and X to signed random numbers between -128 and
                        \ 127, say A = r3

 TAX                    \ Set X = A
                        \       = r3

 JSR SQUA2              \ Set (A P) = A * A
                        \           = r3^2

 STA ZP+1               \ Set ZP+1 = A
                        \          = r3^2 / 256

 JSR DORND              \ Set A and X to signed random numbers between -128 and
                        \ 127, say A = r4

 STA YY                 \ Set YY = r4

 JSR SQUA2              \ Set (A P) = A * A
                        \           = r4^2

 ADC ZP+1               \ Set A = A + r3^2 / 256
                        \       = r4^2 / 256 + r3^2 / 256
                        \       = (r3^2 + r4^2) / 256

 CMP #&11               \ If A < 17, jump down to PLC2 to skip to the next pixel
 BCC PLC2

 LDA YY                 \ Set A = r4

 JSR PIX                \ Draw a pixel at screen coordinate (X + 128, A + 128),
                        \ so that's at:
                        \
                        \   (r3 + 128, r4 + 128)
                        \
                        \ where:
                        \
                        \   (r3^2 + r4^2) / 256 >= 17

.PLC2

 DEC CNT2               \ Decrement the counter in CNT2 (the low byte)

 BNE PLL2               \ Loop back to PLL2 until CNT2 = 0

 DEC CNT2+1             \ Decrement the counter in CNT2+1 (the high byte)

 BNE PLL2               \ Loop back to PLL2 until CNT2+1 = 0

IF _CASSETTE_VERSION \ Other: The cassette and Electron versions contain various bits of copy protection code injected into part 2 of the Saturn-drawing routine in the loader

 LDX MHCA               \ Set the low byte of BLPTR(1 0) to the contents of MHCA
 STX BLPTR              \ (which is &CA), so we now have BLPTR(1 0) = &03CA,
                        \ which we will use in the IRQ1 handler (this has
                        \ nothing to do with drawing Saturn, it's all part of
                        \ the copy protection)

 LDX #&C6               \ Set the low byte of BLN(1 0) to &C6, so we now have
 STX BLN                \ BLN(1 0) = &03C6, which we will use in the IRQ1
                        \ handler (this has nothing to do with drawing Saturn,
                        \ it's all part of the copy protection)

ELIF _ELECTRON_VERSION

 LDX #&CA               \ This is normally part of the copy protection, but it's
 NOP                    \ been disabled in this unprotected version so this has
 STX BLPTR              \ no effect (though the crackers presumably thought they
 LDX #&C6               \ might as well still set the values just in case)
 STX BLN

ENDIF

