\ ******************************************************************************
\
\       Name: SFRMIS
\       Type: Subroutine
\   Category: Tactics
\    Summary: Add an enemy missile to our local bubble of universe
\
\ ------------------------------------------------------------------------------
\
\ An enemy has fired a missile, so add the missile to our universe if there is
\ room, and if there is, make the appropriate warnings and noises.
\
IF _ELITE_A_VERSION \ Comment
\ Other entry points:
\
\   n_sound30           Make the sound of a missile being launched
\
ENDIF
\ ******************************************************************************

.SFRMIS

 LDX #MSL               \ Set X to the ship type of a missile, and call SFS1-2
 JSR SFS1-2             \ to add the missile to our universe with an AI flag
                        \ of %11111110 (AI enabled, hostile, no E.C.M.)

IF _CASSETTE_VERSION \ Label

 BCC NO1                \ The C flag will be set if the call to SFS1-2 was a
                        \ success, so if it's clear, jump to NO1 to return from
                        \ the subroutine (as NO1 contains an RTS)

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT

 BCC KYTB               \ The C flag will be set if the call to SFS1-2 was a
                        \ success, so if it's clear, jump to KYTB to return from
                        \ the subroutine (as KYTB contains an RTS)

ELIF _ELECTRON_VERSION

 BCC ECMOF-1            \ The C flag will be set if the call to SFS1-2 was a
                        \ success, so if it's clear, jump to KYTB to return from
                        \ the subroutine (as ECMOF-1 contains an RTS)

ELIF _MASTER_VERSION

IF _SNG47

 BCC yetanotherrts      \ The C flag will be set if the call to SFS1-2 was a
                        \ success, so if it's clear, jump to KYTB to return from
                        \ the subroutine (as yetanotherrts contains an RTS)

ELIF _COMPACT

 BCC TT17X-1            \ The C flag will be set if the call to SFS1-2 was a
                        \ success, so if it's clear, jump to KYTB to return from
                        \ the subroutine (as TT17X-1 contains an RTS)

ENDIF

ELIF _ELITE_A_6502SP_PARA

 BCC d_4418             \ The C flag will be set if the call to SFS1-2 was a
                        \ success, so if it's clear, jump down to d_4418 to
                        \ return from the subroutine

ENDIF

IF _6502SP_VERSION \ 6502SP: If speech is enabled on the Executive version, it will say "Incoming missile" every time the "INCOMING MISSILE,SIR" message flashes on-screen

IF _EXECUTIVE

 LDX #1                 \ Call TALK with X = 1 to say "Incoming missile" using
 JSR TALK               \ the Watford Electronics Beeb Speech Synthesiser (if
                        \ one is fitted and speech has been enabled)

ENDIF

ENDIF

 LDA #120               \ Print recursive token 120 ("INCOMING MISSILE") as an
 JSR MESS               \ in-flight message

IF _ELITE_A_VERSION

.n_sound30

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _6502SP_VERSION \ Master: The Master version has a unique missile launch sound

 LDA #48                \ Call the NOISE routine with A = 48 to make the sound
 BNE NOISE              \ of the missile being launched and return from the
                        \ subroutine using a tail call (this BNE is effectively
                        \ a JMP as A will never be zero)

ELIF _MASTER_VERSION

 LDY #solaun            \ Call the NOISE routine with Y = 8 to make the sound
 JMP NOISE              \ of the missile being launched and return from the
                        \ subroutine using a tail call

ELIF _ELITE_A_6502SP_PARA

 LDA #48                \ Call the NOISE routine with A = 48 to make the sound
 JMP NOISE              \ of the missile being launched and return from the
                        \ subroutine using a tail call

.d_4418

 RTS                    \ Return from the subroutine

ENDIF

