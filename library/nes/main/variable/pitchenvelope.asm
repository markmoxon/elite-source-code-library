\ ******************************************************************************
\
\       Name: pitchEnvelope
\       Type: Variable
\   Category: Sound
\    Summary: Pitch envelope data for the game music
\
\ ******************************************************************************

.pitchEnvelope

.pitchEnvelopeLo

 EQUB LO(pitchEnvelope0)
 EQUB LO(pitchEnvelope1)
 EQUB LO(pitchEnvelope2)
 EQUB LO(pitchEnvelope3)
 EQUB LO(pitchEnvelope4)
 EQUB LO(pitchEnvelope5)
 EQUB LO(pitchEnvelope6)
 EQUB LO(pitchEnvelope7)

.pitchEnvelopeHi

 EQUB HI(pitchEnvelope0)
 EQUB HI(pitchEnvelope1)
 EQUB HI(pitchEnvelope2)
 EQUB HI(pitchEnvelope3)
 EQUB HI(pitchEnvelope4)
 EQUB HI(pitchEnvelope5)
 EQUB HI(pitchEnvelope6)
 EQUB HI(pitchEnvelope7)

.pitchEnvelope0

 EQUB &00, &80

.pitchEnvelope1

 EQUB &00, &01, &02, &01, &00, &FF, &FE, &FF
 EQUB &80

.pitchEnvelope2

 EQUB &00, &02, &00, &FE, &80

.pitchEnvelope3

 EQUB &00, &01, &00, &FF, &80

.pitchEnvelope4

 EQUB &00, &04, &00, &04, &00, &80

.pitchEnvelope5

 EQUB &00, &02, &04, &02, &00, &FE, &FC, &FE
 EQUB &80

.pitchEnvelope6

 EQUB &00, &03, &06, &03, &00, &FD, &FA, &FD
 EQUB &80

.pitchEnvelope7

 EQUB &00, &04, &08, &04, &00, &FC, &F8, &FC
 EQUB &80

