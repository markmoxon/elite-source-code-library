\ ******************************************************************************
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
\       Name: PLUT
ELIF _DISC_VERSION OR _ELITE_A_VERSION
\       Name: PU1
ENDIF
\       Type: Subroutine
\   Category: Flight
\    Summary: Flip the coordinate axes for the four different views
\  Deep dive: Flipping axes between space views
\
\ ------------------------------------------------------------------------------
\
\ This routine flips the relevant geometric axes in INWK depending on which
\ view we are looking through (front, rear, left, right).
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Comment
\ Other entry points:
\
\   PU1-1               Contains an RTS
\
ENDIF
\ ******************************************************************************

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Platform

.PLUT

 LDX VIEW               \ Load the current view into X:
                        \
                        \   0 = front
                        \   1 = rear
                        \   2 = left
                        \   3 = right

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor

 BNE PU1                \ If the current view is the front view, return from the
 RTS                    \ subroutine, as the geometry in INWK is already correct

ELIF _6502SP_VERSION OR _MASTER_VERSION

 BEQ PU2-1              \ If the current view is the front view, return from the
                        \ subroutine (PU2-1 contains an RTS), as the geometry in
                        \ INWK is already correct

ENDIF

.PU1

 DEX                    \ Decrement the view, so now:
                        \
                        \   0 = rear
                        \   1 = left
                        \   2 = right

 BNE PU2                \ If the current view is left or right, jump to PU2,
                        \ otherwise this is the rear view, so continue on

 LDA INWK+2             \ Flip the sign of x_sign
 EOR #%10000000
 STA INWK+2

 LDA INWK+8             \ Flip the sign of z_sign
 EOR #%10000000
 STA INWK+8

 LDA INWK+10            \ Flip the sign of nosev_x_hi
 EOR #%10000000
 STA INWK+10

 LDA INWK+14            \ Flip the sign of nosev_z_hi
 EOR #%10000000
 STA INWK+14

 LDA INWK+16            \ Flip the sign of roofv_x_hi
 EOR #%10000000
 STA INWK+16

 LDA INWK+20            \ Flip the sign of roofv_z_hi
 EOR #%10000000
 STA INWK+20

 LDA INWK+22            \ Flip the sign of sidev_x_hi
 EOR #%10000000
 STA INWK+22

 LDA INWK+26            \ Flip the sign of roofv_z_hi
 EOR #%10000000
 STA INWK+26

 RTS                    \ Return from the subroutine

.PU2

                        \ We enter this with X set to the view, as follows:
                        \
                        \   1 = left
                        \   2 = right

 LDA #0                 \ Set RAT2 = 0 (left view) or -1 (right view)
 CPX #2
 ROR A
 STA RAT2

 EOR #%10000000         \ Set RAT = -1 (left view) or 0 (right view)
 STA RAT

 LDA INWK               \ Swap x_lo and z_lo
 LDX INWK+6
 STA INWK+6
 STX INWK

 LDA INWK+1             \ Swap x_hi and z_hi
 LDX INWK+7
 STA INWK+7
 STX INWK+1

 LDA INWK+2             \ Swap x_sign and z_sign
 EOR RAT                \ If left view, flip sign of new z_sign
 TAX                    \ If right view, flip sign of new x_sign
 LDA INWK+8
 EOR RAT2
 STA INWK+2
 STX INWK+8

 LDY #9                 \ Swap nosev_x_lo and nosev_z_lo
 JSR PUS1               \ Swap nosev_x_hi and nosev_z_hi
                        \ If left view, flip sign of new nosev_z_hi
                        \ If right view, flip sign of new nosev_x_hi

 LDY #15                \ Swap roofv_x_lo and roofv_z_lo
 JSR PUS1               \ Swap roofv_x_hi and roofv_z_hi
                        \ If left view, flip sign of new roofv_z_hi
                        \ If right view, flip sign of new roofv_x_hi

 LDY #21                \ Swap sidev_x_lo and sidev_z_lo
                        \ Swap sidev_x_hi and sidev_z_hi
                        \ If left view, flip sign of new sidev_z_hi
                        \ If right view, flip sign of new sidev_x_hi

.PUS1

 LDA INWK,Y             \ Swap the low x and z bytes for the vector in Y:
 LDX INWK+4,Y           \
 STA INWK+4,Y           \   * For Y =  9 swap nosev_x_lo and nosev_z_lo
 STX INWK,Y             \   * For Y = 15 swap roofv_x_lo and roofv_z_lo
                        \   * For Y = 21 swap sidev_x_lo and sidev_z_lo

 LDA INWK+1,Y           \ Swap the high x and z bytes for the offset in Y:
 EOR RAT                \
 TAX                    \   * If left view, flip sign of new z-coordinate
 LDA INWK+5,Y           \   * If right view, flip sign of new x-coordinate
 EOR RAT2
 STA INWK+1,Y
 STX INWK+5,Y

                        \ Fall through into LOOK1 to return from the subroutine

