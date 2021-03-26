\ ******************************************************************************
\
\       Name: SFX
\       Type: Variable
\   Category: Sound
\    Summary: Sound data
\
\ ------------------------------------------------------------------------------
\
\ Sound data. To make a sound, the NOS1 routine copies the four relevant sound
\ bytes to XX16, and NO3 then makes the sound. The sound numbers are shown in
\ the table, and are always multiples of 8. Generally, sounds are made by
\ calling the NOISE routine with the sound number in A.
\
\ These bytes are passed to OSWORD 7, and are the equivalents to the parameters
\ passed to the SOUND keyword in BASIC. The parameters therefore have these
\ meanings:
\
\   channel/flush, amplitude (or envelope number if 1-4), pitch, duration
\
\ For the channel/flush parameter, the first byte is the channel while the
\ second is the flush control (where a flush control of 0 queues the sound,
\ while a flush control of 1 makes the sound instantly). When written in
\ hexadecimal, the first figure gives the flush control, while the second is
\ the channel (so &13 indicates flush control = 1 and channel = 3).
\
\ So when we call NOISE with A = 40 to make a long, low beep, then this is
\ effectively what the NOISE routine does:
\
\   SOUND &13, &F4, &0C, &08
\
\ which makes a sound with flush control 1 on channel 3, and with amplitude &F4
\ (-12), pitch &0C (2) and duration &08 (8). Meanwhile, to make the hyperspace
\ sound, the NOISE routine does this:
\
\   SOUND &10, &02, &60, &10
\
\ which makes a sound with flush control 1 on channel 0, using envelope 2,
\ and with pitch &60 (96) and duration &10 (16). The four sound envelopes (1-4)
\ are set up by the loading process.
\
\ ******************************************************************************

.SFX

 EQUB &12,&01,&00,&10   \ 0  - Lasers fired by us
 EQUB &12,&02,&2C,&08   \ 8  - We're being hit by lasers
 EQUB &11,&03,&F0,&18   \ 16 - We died 1 / We made a hit or kill 2
 EQUB &10,&F1,&07,&1A   \ 24 - We died 2 / We made a hit or kill 1
 EQUB &03,&F1,&BC,&01   \ 32 - Short, high beep
 EQUB &13,&F4,&0C,&08   \ 40 - Long, low beep
 EQUB &10,&F1,&06,&0C   \ 48 - Missile launched / Ship launched from station
 EQUB &10,&02,&60,&10   \ 56 - Hyperspace drive engaged
 EQUB &13,&04,&C2,&FF   \ 64 - E.C.M. on
 EQUB &13,&00,&00,&00   \ 72 - E.C.M. off

