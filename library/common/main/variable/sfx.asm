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
IF _ELECTRON_VERSION \ Comment
\ The Electron has an additional layer of sound data for each of the game's
\ sounds - priority and minimum duration. Because the Electron only has one
\ tone channel and one noise channel, it prioritises each sound. If a sound
\ is already playing and a sound of a higher priority needs to be made, the new
\ sound will take over; if, however, the new sound is of a lower priority, it
\ gets discarded and doesn't get made.
\
\ This system works alongside the miniumum duration value; after the minimum
\ duration, the priority system is ignored, so once a high priority sound has
\ sounded for its minimum duration, then even if that high priority sound is
\ still being made, a lower priority sound can come along and take precedence.
\
\ To put it another way, high priority sounds take control of the sound output
\ and lower priority sounds don't get a look-in, but only for the minimum
\ duration of the higher priority sound.
\
ENDIF
\ ******************************************************************************

.SFX

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Electron: The sound effects on the Electron are noticeably different to the other versions, as it has different sound hardware that only supports one sound channel rather than three

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

ELIF _ELECTRON_VERSION

 EQUB &11,&01,&00,&03   \ 0  - Lasers fired by us
 EQUB &11,&02,&2C,&04   \ 8  - We're being hit by lasers
 EQUB &11,&03,&F0,&06   \ 16 - We made a hit or kill 2
 EQUB &10,&F1,&04,&05   \ 24 - We died / We made a hit or kill 1
 EQUB &01,&F1,&BC,&01   \ 32 - Short, high beep
 EQUB &11,&F4,&0C,&08   \ 40 - Long, low beep
 EQUB &10,&F1,&04,&06   \ 48 - Missile launched / Ship launched from station
 EQUB &10,&02,&60,&10   \ 56 - Hyperspace drive engaged
 EQUB &11,&04,&C2,&FF   \ 64 - E.C.M. on
 EQUB &11,&00,&00,&00   \ 72 - E.C.M. off

ENDIF

IF _ELECTRON_VERSION \ Electron: In the Electron version, each of the game's sounds is allocated a priority and a minimum duration

.SFX2

 EQUB &70               \ 0  - Priority 112, minimum duration 0
 EQUB &24               \ 8  - Priority  36, minimum duration 4
 EQUB &56               \ 16 - Priority  86, minimum duration 6
 EQUB &56               \ 24 - Priority  86, minimum duration 6
 EQUB &42               \ 32 - Priority  66, minimum duration 2
 EQUB &28               \ 40 - Priority  40, minimum duration 8
 EQUB &C8               \ 48 - Priority 200, minimum duration 8
 EQUB &D0               \ 56 - Priority 208, minimum duration 0
 EQUB &F0               \ 64 - Priority 240, minimum duration 0
 EQUB &E0               \ 72 - Priority 224, minimum duration 0

ENDIF

