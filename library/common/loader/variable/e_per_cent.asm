\ ******************************************************************************
\
\       Name: E%
\       Type: Variable
\   Category: Sound
\    Summary: Sound envelope definitions
\
\ ------------------------------------------------------------------------------
\
\ This table contains the sound envelope data, which is passed to OSWORD by the
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Comment
\ FNE macro to create the four sound envelopes used in-game. Refer to chapter 30
\ of the "BBC Microcomputer User Guide" by John Coll for details of sound
\ envelopes and what all the parameters mean.
ELIF _ELECTRON_VERSION
\ FNE macro to create the four sound envelopes used in-game. Refer to chapter 22
\ of the "Electron User Guide" by Acorn Computers for details of sound envelopes
\ and what all the parameters mean.
ENDIF
\
\ The envelopes are as follows:
\
\   * Envelope 1 is the sound of our own laser firing
\
\   * Envelope 2 is the sound of lasers hitting us, or hyperspace
\
\   * Envelope 3 is the first sound in the two-part sound of us dying, or the
\     second sound in the two-part sound of us hitting or killing an enemy ship
\
\   * Envelope 4 is the sound of E.C.M. firing
\
\ ******************************************************************************

.E%

IF _CASSETTE_VERSION \ Standard: There is a subtle difference between the cassette version's laser firing sound compared to the disc and 6502SP versions (the Master has a unique sound system so is different again). Specifically, the cassette version has a slightly lower #amplitude in the envelope's attack phase, which makes the lasers noticeably quieter. The Electron laser sound, meanwhile, is also unique

 EQUB 1, 1, 0, 111, -8, 4, 1, 8, 8, -2, 0, -1, 112, 44
ELIF _ELECTRON_VERSION

 EQUB 1, 1, 0, 111, -8, 4, 1, 8, 126, 0, 0, -126, 126, 126
ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION

 EQUB 1, 1, 0, 111, -8, 4, 1, 8, 8, -2, 0, -1, 126, 44
ENDIF
 EQUB 2, 1, 14, -18, -1, 44, 32, 50, 6, 1, 0, -2, 120, 126
 EQUB 3, 1, 1, -1, -3, 17, 32, 128, 1, 0, 0, -1, 1, 1
 EQUB 4, 1, 4, -8, 44, 4, 6, 8, 22, 0, 0, -127, 126, 0

