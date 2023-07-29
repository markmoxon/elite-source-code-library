\ ******************************************************************************
\
\       Name: BAY
\       Type: Subroutine
\   Category: Status
IF NOT(_ELITE_A_ENCYCLOPEDIA)
\    Summary: Go to the docking bay (i.e. show the Status Mode screen)
ELIF _ELITE_A_ENCYCLOPEDIA
\    Summary: Go to the docking bay (i.e. show the Encyclopedia screen)
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ We end up here after the start-up process (load commander etc.), as well as
\ after a successful save, an escape pod launch, a successful docking, the end
\ of a cargo sell, and various errors (such as not having enough cash, entering
\ too many items when buying, trying to fit an item to your ship when you
\ already have it, running out of cargo space, and so on).
\
\ ******************************************************************************

.BAY

IF _NES_VERSION

 JSR ClearScreen_b3     \ ???

ENDIF

 LDA #&FF               \ Set QQ12 = &FF (the docked flag) to indicate that we
 STA QQ12               \ are docked

IF _CASSETTE_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _6502SP_VERSION OR _MASTER_VERSION \ Comment

 LDA #f8                \ Jump into the main loop at FRCE, setting the key
 JMP FRCE               \ that's "pressed" to red key f8 (so we show the Status
                        \ Mode screen)

ELIF _ELECTRON_VERSION

 LDA #func9             \ Jump into the main loop at FRCE, setting the key
 JMP FRCE               \ that's "pressed" to FUNC-9 (so we show the Status
                        \ Mode screen)

ELIF _ELITE_A_ENCYCLOPEDIA

 LDA #f3                \ Jump into the main loop at FRCE, setting the key
 JMP FRCE               \ that's "pressed" to red key f3 (so we show the
                        \ Encyclopedia screen)

ELIF _NES_VERSION

 LDA #3                 \ Jump into the main loop at FRCE, setting the key
 JMP FRCE               \ that's "pressed" to show the Status Mode screen ???

ENDIF

