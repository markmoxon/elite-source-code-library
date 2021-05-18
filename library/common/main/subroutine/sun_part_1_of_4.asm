\ ******************************************************************************
\
\       Name: SUN (Part 1 of 4)
\       Type: Subroutine
\   Category: Drawing suns
\    Summary: Draw the sun: Set up all the variables needed
\  Deep dive: Drawing the sun
\
\ ------------------------------------------------------------------------------
\
\ Draw a new sun with radius K at pixel coordinate (K3, K4), removing the old
\ sun if there is one. This routine is used to draw the sun, as well as the
\ star systems on the Short-range Chart.
\
\ The first part sets up all the variables needed to draw the new sun.
\
\ Arguments:
\
\   K                   The new sun's radius
\
\   K3(1 0)             Pixel x-coordinate of the centre of the new sun
\
\   K4(1 0)             Pixel y-coordinate of the centre of the new sun
\
\   SUNX(1 0)           The x-coordinate of the vertical centre axis of the old
\                       sun (the one currently on-screen)
\
\ Other entry points:
\
\   RTS2                Contains an RTS
\
\ ******************************************************************************

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _MASTER_VERSION \ Platform

 JMP WPLS               \ Jump to WPLS to remove the old sun from the screen. We
                        \ only get here via the BCS just after the SUN entry
                        \ point below, when there is no new sun to draw

ENDIF

.PLF3

                        \ This is called from below to negate X and set A to
                        \ &FF, for when the new sun's centre is off the bottom
                        \ of the screen (so we don't need to draw its bottom
                        \ half)

 TXA                    \ Negate X using two's complement, so X = ~X + 1
 EOR #%11111111         \
 CLC                    \ We do this because X is negative at this point, as it
 ADC #1                 \ is calculated as 191 - the y-coordinate of the sun's
 TAX                    \ centre, and the centre is off the bottom of the
                        \ screen, past 191. So we negate it to make it positive

.PLF17

                        \ This is called from below to set A to &FF, for when
                        \ the new sun's centre is right on the bottom of the
                        \ screen (so we don't need to draw its bottom half)

 LDA #&FF               \ Set A = &FF

IF _CASSETTE_VERSION \ Minor

 JMP PLF5               \ Jump to PLF5

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION

 BNE PLF5               \ Jump to PLF5 (this BNE is effectively a JMP as A is
                        \ never zero)

ENDIF

.SUN

IF _MASTER_VERSION \ Screen

 LDA #RED               \ Switch to colour 2, which is red in the space view
 STA COL

ENDIF

 LDA #1                 \ Set LSX = 1 to indicate the sun line heap is about to
 STA LSX                \ be filled up

 JSR CHKON              \ Call CHKON to check whether any part of the new sun's
                        \ circle appears on-screen, and of it does, set P(2 1)
                        \ to the maximum y-coordinate of the new sun on-screen

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _MASTER_VERSION \ Platform

 BCS PLF3-3             \ If CHKON set the C flag then the new sun's circle does
                        \ not appear on-screen, so jump to WPLS (via the JMP at
                        \ the top of this routine) to remove the sun from the
                        \ screen, returning from the subroutine using a tail
                        \ call

ENDIF

 LDA #0                 \ Set A = 0

 LDX K                  \ Set X = K = radius of the new sun

 CPX #96                \ If X >= 96, set the C flag and rotate it into bit 0
 ROL A                  \ of A, otherwise rotate a 0 into bit 0

 CPX #40                \ If X >= 40, set the C flag and rotate it into bit 0
 ROL A                  \ of A, otherwise rotate a 0 into bit 0

 CPX #16                \ If X >= 16, set the C flag and rotate it into bit 0
 ROL A                  \ of A, otherwise rotate a 0 into bit 0

                        \ By now, A contains the following:
                        \
                        \   * If radius is 96-255 then A = %111 = 7
                        \
                        \   * If radius is 40-95  then A = %11  = 3
                        \
                        \   * If radius is 16-39  then A = %1   = 1
                        \
                        \   * If radius is 0-15   then A = %0   = 0
                        \
                        \ The value of A determines the size of the new sun's
                        \ ragged fringes - the bigger the sun, the bigger the
                        \ fringes

.PLF18

 STA CNT                \ Store the fringe size in CNT

                        \ We now calculate the highest pixel y-coordinate of the
                        \ new sun, given that P(2 1) contains the 16-bit maximum
                        \ y-coordinate of the new sun on-screen

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Master: Group A: In the Master version, the screen size is not hard-coded, but is stored in a dedicated location, an approach that was presumably inherited from the non-BBC versions of the game

 LDA #2*Y-1             \ #Y is the y-coordinate of the centre of the space
                        \ view, so this sets Y to the y-coordinate of the bottom
                        \ of the space view, i.e. 191

ELIF _MASTER_VERSION

 LDA YMAX               \ Set Y to the y-coordinate of the bottom of the space
                        \ view, i.e. 191

ENDIF

 LDX P+2                \ If P+2 is non-zero, the maximum y-coordinate is off
 BNE PLF2               \ the bottom of the screen, so skip to PLF2 with A = 191

 CMP P+1                \ If A < P+1, the maximum y-coordinate is underneath the
 BCC PLF2               \ the dashboard, so skip to PLF2 with A = 191

 LDA P+1                \ Set A = P+1, the low byte of the maximum y-coordinate
                        \ of the sun on-screen

 BNE PLF2               \ If A is non-zero, skip to PLF2 as it contains the
                        \ value we are after

 LDA #1                 \ Otherwise set A = 1, the top line of the screen

.PLF2

 STA TGT                \ Set TGT to A, the maximum y-coordinate of the sun on
                        \ screen

                        \ We now calculate the number of lines we need to draw
                        \ and the direction in which we need to draw them, both
                        \ from the centre of the new sun

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Master: See group A

 LDA #2*Y-1             \ Set (A X) = y-coordinate of bottom of screen - K4(1 0)
 SEC                    \
 SBC K4                 \ Starting with the low bytes
 TAX

ELIF _MASTER_VERSION

 LDA YMAX               \ Set (A X) = y-coordinate of bottom of screen - K4(1 0)
 SEC                    \
 SBC K4                 \ Starting with the low bytes
 TAX

ENDIF

 LDA #0                 \ And then doing the high bytes, so (A X) now contains
 SBC K4+1               \ the number of lines between the centre of the sun and
                        \ the bottom of the screen. If it is positive then the
                        \ centre of the sun is above the bottom of the screen,
                        \ if it is negative then the centre of the sun is below
                        \ the bottom of the screen

 BMI PLF3               \ If A < 0, then this means the new sun's centre is off
                        \ the bottom of the screen, so jump up to PLF3 to negate
                        \ the height in X (so it becomes positive), set A to &FF
                        \ and jump down to PLF5

 BNE PLF4               \ If A > 0, then the new sun's centre is at least a full
                        \ screen above the bottom of the space view, so jump
                        \ down to PLF4 to set X = radius and A = 0

 INX                    \ Set the flags depending on the value of X
 DEX

 BEQ PLF17              \ If X = 0 (we already know A = 0 by this point) then
                        \ jump up to PLF17 to set A to &FF before jumping down
                        \ to PLF5

 CPX K                  \ If X < the radius in K, jump down to PLF5, so if
 BCC PLF5               \ X >= the radius in K, we set X = radius and A = 0

.PLF4

 LDX K                  \ Set X to the radius

 LDA #0                 \ Set A = 0

.PLF5

 STX V                  \ Store the height in V

 STA V+1                \ Store the direction in V+1

 LDA K                  \ Set (A P) = K * K
 JSR SQUA2

 STA K2+1               \ Set K2(1 0) = (A P) = K * K
 LDA P
 STA K2

                        \ By the time we get here, the variables should be set
                        \ up as shown in the header for part 3 below

