\ ******************************************************************************
\
\       Name: PZW
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Fetch the current dashboard colours, to support flashing
\
\ ------------------------------------------------------------------------------
\
\ Set A and X to the colours we should use for indicators showing dangerous and
\ safe values respectively. This enables us to implement flashing indicators,
\ which is one of the game's configurable options.
\
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment
\ If flashing is enabled, the colour returned in A (dangerous values) will be
\ red for 8 iterations of the main loop, and yellow/white for the next 8, before
\ going back to red. If we always use PZW to decide which colours we should use
\ when updating indicators, flashing colours will be automatically taken care of
\ for us.
\
\ The values returned are &F0 for yellow/white and &0F for red. These are mode 5
\ bytes that contain 4 pixels, with the colour of each pixel given in two bits,
\ the high bit from the first nibble (bits 4-7) and the low bit from the second
\ nibble (bits 0-3). So in &F0 each pixel is %10, or colour 2 (yellow or white,
\ depending on the dashboard palette), while in &0F each pixel is %01, or colour
\ 1 (red).
ELIF _6502SP_VERSION OR _MASTER_VERSION
\ If flashing is enabled, the colour returned in A (dangerous values) will be
\ red for 8 iterations of the main loop, and green for the next 8, before
\ going back to red. If we always use PZW to decide which colours we should use
\ when updating indicators, flashing colours will be automatically taken care of
\ for us.
\
\ The values returned are #GREEN2 for green and #RED2 for red. These are mode 2
\ bytes that contain 2 pixels, with the colour of each pixel given in four bits.
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   The colour to use for indicators with dangerous values
\
\   X                   The colour to use for indicators with safe values
\
\ ******************************************************************************

.PZW

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Screen

 LDX #&F0               \ Set X to dashboard colour 2 (yellow/white)

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDX #STRIPE            \ Set X to the dashboard stripe colour, which is stripe
                        \ 5-1 (magenta/red)

ENDIF

IF NOT(_ELITE_A_DOCKED)

 LDA MCNT               \ A will be non-zero for 8 out of every 16 main loop
 AND #%00001000         \ counts, when bit 4 is set, so this is what we use to
                        \ flash the "danger" colour

 AND FLH                \ A will be zeroed if flashing colours are disabled

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA \ Screen

 BEQ P%+4               \ If A is zero, skip to the LDA instruction below

 TXA                    \ Otherwise flashing colours are enabled and it's the
                        \ main loop iteration where we flash them, so set A to
                        \ colour 2 (yellow/white) and use the BIT trick below to
                        \ return from the subroutine

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A9 &0F, or BIT &0FA9, which does nothing apart
                        \ from affect the flags

 LDA #&0F               \ Set A to dashboard colour 1 (red)

ELIF _6502SP_VERSION OR _MASTER_VERSION

 BEQ P%+5               \ If A is zero, skip the next two instructions

 LDA #GREEN2            \ Otherwise flashing colours are enabled and it's the
 RTS                    \ main loop iteration where we flash them, so set A to
                        \ dashboard colour 2 (green) and return from the
                        \ subroutine

 LDA #RED2              \ Set A to dashboard colour 1 (red)

ENDIF

IF _ELITE_A_DOCKED

 LDA #&0F               \ Set A to dashboard colour 1 (red)

ENDIF

 RTS                    \ Return from the subroutine

