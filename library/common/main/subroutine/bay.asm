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

 JSR ClearScreen_b3     \ Clear the screen by zeroing patterns 66 to 255 in
                        \ both pattern buffer, and clearing both nametable
                        \ buffers to the background tile

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

ELIF _C64_VERSION OR _APPLE_VERSION

 LDA #f8                \ Jump into the main loop at FRCE, setting the key
 JMP FRCE               \ that's "pressed" to the Status Mode key

ELIF _NES_VERSION

 LDA #3                 \ Jump into the main loop at FRCE, setting the key
 JMP FRCE               \ that's "pressed" to the Status Mode icon bar button
                        \ so we show the Status Mode screen

ELIF _DEMO_VERSION

                        \ We now show a sequence of docked screens by "pressing"
                        \ the relevant keys and showing various screens for five
                        \ seconds each

 LDA #f8                \ Call TT102 to "press" the f8 key (Status Mode) and
 JSR TT102              \ wait for five seconds (the delay has been added to
                        \ TT102)

 LDA #f7                \ Call TT102 to "press" the f7 key (Market Price) and
 JSR TT102              \ wait for five seconds (the delay has been added to
                        \ TT167)

 LDA #f6                \ Call TT102 to "press" the f6 key (Data on System) and
 JSR TT102              \ wait for five seconds (the delay has been added to
                        \ TT25, which falls through into DelayFiveSeconds)

 LDA #f3                \ Call TT102 to "press" the f3 key (Equip Ship) to start
 JSR TT102              \ the following sequence:
                        \
                        \   * Display the Equip Ship screen, buy fuel and a
                        \     missile and wait for five seconds (see EQSHP)
                        \
                        \   * Show the Buy Cargo screen and buy some random
                        \     cargo (see TT219)
                        \
                        \   * Show the Inventory screen and wait for five
                        \     seconds (see TT213 and TT210)

 LDA #f0                \ Jump into the main game loop at FRCE, setting the key
 JMP FRCE               \ "pressed" to red key f0 (so we launch from the
                        \ station)

                        \ The following code is never run, and is presumably
                        \ left over from some experiments with which screen to
                        \ show in this part of the demo

 LDA #&FF               \ Set QQ12 to &FF to indicate we are docked
 STA QQ12

 LDA #f8                \ Jump into the main loop at FRCE, setting the key
 JMP FRCE               \ that's "pressed" to red key f8 (so we show the Status
                        \ Mode screen)

ENDIF

