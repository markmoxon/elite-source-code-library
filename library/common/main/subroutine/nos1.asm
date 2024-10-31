\ ******************************************************************************
\
\       Name: NOS1
\       Type: Subroutine
\   Category: Sound
\    Summary: Prepare a sound block
\
\ ------------------------------------------------------------------------------
\
\ Copy four sound bytes from SFX into XX16, interspersing them with null bytes,
\ with Y indicating the sound number to copy (from the values in the sound
\ table at SFX). So, for example, if we call this routine with A = 40 (long,
\ low beep), the following bytes will be set in XX16 to XX16+7:
\
\   &13 &00 &F4 &00 &0C &00 &08 &00
\
\ This block will be passed to OSWORD 7 to make the sound, which expects the
\ four sound attributes as 16-bit big-endian values - in other words, with the
\ low byte first. So the above block would pass the values &0013, &00F4, &000C
\ and &0008 to the SOUND statement when used with OSWORD 7, or:
\
\   SOUND &13, &F4, &0C, &08
\
\ as the high bytes are always zero.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The sound number to copy from SFX to XX16, which is
\                       always a multiple of 8
\
\ ******************************************************************************

.NOS1

IF _ELECTRON_VERSION \ Platform

 STA XX16+8             \ Store the sound number in XX16+8, so we can retrieve
                        \ it in the NO3 routine

ENDIF

 LSR A                  \ Divide A by 2, and also clear the C flag, as bit 0 of
                        \ A is always zero (as A is a multiple of 8)

 ADC #3                 \ Set Y = A + 3, so Y now points to the last byte of
 TAY                    \ four within the block of four-byte values

 LDX #7                 \ We want to copy four bytes, spread out into an 8-byte
                        \ block, so set a counter in Y to cover 8 bytes

.NOL1

 LDA #0                 \ Set the X-th byte of XX16 to 0
 STA XX16,X

 DEX                    \ Decrement the destination byte pointer

 LDA SFX,Y              \ Set the X-th byte of XX16 to the value from SFX+Y
 STA XX16,X

 DEY                    \ Decrement the source byte pointer again

 DEX                    \ Decrement the destination byte pointer again

 BPL NOL1               \ Loop back for the next source byte

IF NOT(_ELITE_A_6502SP_PARA)

                        \ Fall through into KYTB to return from the subroutine,
                        \ as the first byte of KYTB is an RTS

ELIF _ELITE_A_6502SP_PARA

 RTS                    \ Return from the subroutine

ENDIF

