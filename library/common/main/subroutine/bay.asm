\ ******************************************************************************
\
\       Name: BAY
\       Type: Subroutine
\   Category: Status
\    Summary: Go to the docking bay (i.e. show the Status Mode screen)
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

 LDA #&FF               \ Set QQ12 = &FF (the docked flag) to indicate that we
 STA QQ12               \ are docked

IF _CASSETTE_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _6502SP_VERSION OR _MASTER_VERSION \ Comment

 LDA #f8                \ Jump into the main loop at FRCE, setting the key
 JMP FRCE               \ that's "pressed" to red key f8 (so we show the Status
                        \ Mode screen)

ELIF _ELECTRON_VERSION

 LDA #func9             \ Jump into the main loop at FRCE, setting the key
 JMP FRCE               \ that's "pressed" to FUNC-9 (so we show the Status
                        \ Mode screen)

ENDIF

