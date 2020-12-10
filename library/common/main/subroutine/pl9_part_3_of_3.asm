\ ******************************************************************************
\
\       Name: PL9 (Part 3 of 3)
\       Type: Subroutine
\   Category: Drawing planets
\    Summary: Draw the planet's crater
\  Deep dive: Drawing craters
\
\ ------------------------------------------------------------------------------
\
\ Draw the planet's crater.
\
\ Arguments:
\
\   K(1 0)              The planet's radius
\
\   K3(1 0)             Pixel x-coordinate of the centre of the planet
\
\   K4(1 0)             Pixel y-coordinate of the centre of the planet
\
\   INWK                The planet's ship data block
\
\ ******************************************************************************

.PL26

 LDA INWK+20            \ Set A = roofv_z_hi

 BMI PL20               \ If A is negative, the crater is on the far side of the
                        \ planet, so return from the subroutine (as PL2
                        \ contains an RTS)

 LDX #15                \ Set X = 15, so the following call to PLS3 operates on
                        \ roofv

 JSR PLS3               \ Call PLS3 to calculate:
                        \
                        \   (Y A P) = 222 * roofv_x / z
                        \
                        \ to give the x-coordinate of the crater offset and
                        \ increment X to point to roofv_y for the next call

 CLC                    \ Calculate:
 ADC K3                 \
 STA K3                 \   K3(1 0) = (Y A) + K3(1 0)
                        \           = 222 * roofv_x / z + x-coordinate of planet
                        \             centre
                        \
                        \ starting with the high bytes

 TYA                    \ And then doing the low bytes, so now K3(1 0) contains
 ADC K3+1               \ the x-coordinate of the crater offset plus the planet
 STA K3+1               \ centre to give the x-coordinate of the crater's centre

 JSR PLS3               \ Call PLS3 to calculate:
                        \
                        \   (Y A P) = 222 * roofv_y / z
                        \
                        \ to give the y-coordinate of the crater offset

 STA P                  \ Calculate:
 LDA K4                 \
 SEC                    \   K4(1 0) = K4(1 0) - (Y A)
 SBC P                  \           = 222 * roofv_x / z - y-coordinate of planet
 STA K4                 \             centre
                        \
                        \ starting with the low bytes

 STY P                  \ And then doing the low bytes, so now K4(1 0) contains
 LDA K4+1               \ the y-coordinate of the crater offset plus the planet
 SBC P                  \ centre to give the y-coordinate of the crater's centre
 STA K4+1

 LDX #9                 \ Set X = 9, so the following call to PLS1 operates on
                        \ nosev

 JSR PLS1               \ Call PLS1 to calculate the following:
                        \
                        \   (Y A) = nosev_x / z
                        \
                        \ and increment X to point to nosev_y for the next call

 LSR A                  \ Set (XX16 K2) = (Y A) / 2
 STA K2
 STY XX16

 JSR PLS1               \ Call PLS1 to calculate the following:
                        \
                        \   (Y A) = nosev_y / z
                        \
                        \ and increment X to point to nosev_z for the next call

 LSR A                  \ Set (XX16+1 K2+1) = (Y A) / 2
 STA K2+1
 STY XX16+1

 LDX #21                \ Set X = 21, so the following call to PLS1 operates on
                        \ sidev

 JSR PLS1               \ Call PLS1 to calculate the following:
                        \
                        \   (Y A) = sidev_x / z
                        \
                        \ and increment X to point to sidev_y for the next call

 LSR A                  \ Set (XX16+2 K2+2) = (Y A) / 2
 STA K2+2
 STY XX16+2

 JSR PLS1               \ Call PLS1 to calculate the following:
                        \
                        \   (Y A) = sidev_y / z
                        \
                        \ and increment X to point to sidev_z for the next call

 LSR A                  \ Set (XX16+3 K2+3) = (Y A) / 2
 STA K2+3
 STY XX16+3

 LDA #64                \ Set TGT = 64, so we draw a full circle in the call to
 STA TGT                \ PLS22 below

IF _CASSETTE_VERSION

 LDA #0                 \ Set CNT2 = 0 as we are drawing a full circle, so we
 STA CNT2               \ don't need to apply an offset

 JMP PLS22              \ Jump to PLS22 to draw the crater, returning from the
                        \ subroutine using a tail call

ELIF _6502SP_VERSION

 STZ CNT2               \ Set CNT2 = 0 as we are drawing a full circle, so we
                        \ don't need to apply an offset

 JSR PLS22              \ Call PLS22 to draw the crater

 JMP LS2FL              \ Jump to LS2FL to send the ball line heap to the I/O
                        \ processor for drawing on-screen, returning from the
                        \ subroutine using a tail call

ENDIF

