\ ******************************************************************************
\
\       Name: BRIEF2
\       Type: Subroutine
\   Category: Missions
\    Summary: Start mission 2
\  Deep dive: The Thargoid Plans mission
\
\ ******************************************************************************

.BRIEF2

 LDA TP                 \ Set bit 2 of TP to indicate mission 2 is in progress
 ORA #%00000100         \ but plans have not yet been picked up
 STA TP

IF NOT(_NES_VERSION)

 LDA #11                \ Set A = 11 so the call to BRP prints extended token 11
                        \ (the initial contact at the start of mission 2, asking
                        \ us to head for Ceerdi for a mission briefing)

                        \ Fall through into BRP to print the extended token in A
                        \ and show the Status Mode screen

ELIF _NES_VERSION

 LDA #11                \ Print extended token 11, which is the initial contact
 JSR DETOK_b2           \ at the start of mission 2, asking us to head for
                        \ Ceerdi for a mission briefing

 JSR UpdateView         \ Update the view

 JMP BAY                \ Jump to BAY to go to the docking bay (i.e. show the
                        \ Status Mode screen) and return from the subroutine
                        \ using a tail call

ENDIF

