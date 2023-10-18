\ ******************************************************************************
\
\       Name: StartEffectOnSQ1
\       Type: Subroutine
\   Category: Sound
\    Summary: Make a sound effect on the SQ1 channel
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The number of the sound effect to make
\
\ ******************************************************************************

.StartEffectOnSQ1

 ASL A                  \ Set Y = A * 2
 TAY                    \
                        \ So we can use Y as an index into the soundData table,
                        \ which contains addresses of two bytes each

 LDA #0                 \ Set effectOnSQ1 = 0 to disable sound generation on the
 STA effectOnSQ1        \ SQ1 channel while we set up the sound effect (as a
                        \ value of 0 denotes that a sound effect is not being
                        \ made on this channel, so none of the sound generation
                        \ routines will do anything)
                        \
                        \ We enable sound generation below once we have finished
                        \ setting up the sound effect

 LDA soundData,Y        \ Set soundAddr(1 0) to the address for this sound
 STA soundAddr          \ effect from the soundData table, so soundAddr(1 0)
 LDA soundData+1,Y      \ points to soundData0 for the sound data for sound
 STA soundAddr+1        \ effect 0, or to soundData1 for the sound data for
                        \ sound effect 1, and so on

                        \ There are 14 bytes of sound data for each sound effect
                        \ that we now copy to soundByteSQ1, so we can do things
                        \ like update the counters and store the current pitch
                        \ as we make the sound effect

 LDY #13                \ Set a byte counter in Y for copying all 14 bytes

.mefz1

 LDA (soundAddr),Y      \ Copy the Y-th byte of sound data for this sound effect
 STA soundByteSQ1,Y     \ to the Y-th byte of soundByteSQ1

 DEY                    \ Decrement the loop counter

 BPL mefz1              \ Loop back until we have copied all 14 bytes

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA soundByteSQ1+11    \ Set soundVolCountSQ1 = soundByteSQ1+11
 STA soundVolCountSQ1   \
                        \ This initialises the counter in soundVolCountSQ1
                        \ with the value of byte #11, so it can be used to
                        \ control how often we apply the volume envelope to the
                        \ sound effect on channel SQ1

 LDA soundByteSQ1+13    \ Set soundPitchEnvSQ1 = soundByteSQ1+13
 STA soundPitchEnvSQ1   \
                        \ This initialises the counter in soundPitchEnvSQ1
                        \ with the value of byte #13, so it can be used to
                        \ control how often we apply the pitch envelope to the
                        \ sound effect on channel SQ1

 LDA soundByteSQ1+1     \ Set soundPitCountSQ1 = soundByteSQ1+1
 STA soundPitCountSQ1   \
                        \ This initialises the counter in soundPitCountSQ1
                        \ with the value of byte #1, so it can be used to
                        \ control how often we send pitch data to the APU for
                        \ the sound effect on channel SQ1

 LDA soundByteSQ1+10    \ Set Y = soundByteSQ1+10 * 2
 ASL A                  \
 TAY                    \ So we can use Y as an index into the soundVolume
                        \ table to fetch byte #10, as the table contains
                        \ addresses of two bytes each

 LDA soundVolume,Y      \ Set soundVolumeSQ1(1 0) to the address of the volume
 STA soundVolumeSQ1     \ envelope for this sound effect, as specified in
 STA soundAddr          \ byte #10 of the sound effect's data
 LDA soundVolume+1,Y    \
 STA soundVolumeSQ1+1   \ This also sets soundAddr(1 0) to the same address
 STA soundAddr+1

 LDY #0                 \ Set Y = 0 so we can use indirect addressing below (we
                        \ do not change the value of Y, this is just so we can
                        \ implement the non-existent LDA (soundAddr) instruction
                        \ by using LDA (soundAddr),Y instead)

 STY soundVolIndexSQ1   \ Set soundVolIndexSQ1 = 0, so we start processing the
                        \ volume envelope from the first byte

 LDA (soundAddr),Y      \ Take the first byte from the volume envelope for this
 ORA soundByteSQ1+6     \ sound effect, OR it with the sound effect's byte #6,
 STA SQ1_VOL            \ and send the result to the APU via SQ1_VOL
                        \
                        \ Data bytes in the volume envelope data only use the
                        \ low nibble (the high nibble is only used to mark the
                        \ end of the data), and the sound effect's byte #6 only
                        \ uses the high nibble, so this sets the low nibble of
                        \ the APU byte to the volume level from the data, and
                        \ the high nibble of the APU byte to the configuration
                        \ in byte #6 (which sets the duty pulse, looping and
                        \ constant flags for the volume)

 LDA #0                 \ Send 0 to the APU via SQ1_SWEEP to disable the sweep
 STA SQ1_SWEEP          \ unit and stop the pitch from changing

 LDA soundByteSQ1+2     \ Set (soundHiSQ1 soundLoSQ1) to the 16-bit value in
 STA soundLoSQ1         \ bytes #2 and #3 of the sound data, which at this point
 STA SQ1_LO             \ contains the first pitch value to send to the APU via
 LDA soundByteSQ1+3     \ (SQ1_HI SQ1_LO)
 STA soundHiSQ1         \
 STA SQ1_HI             \ We will be using these bytes to store the pitch bytes
                        \ to send to the APU as we keep making the sound effect,
                        \ so this just kicks off the process with the initial
                        \ pitch value

 INC effectOnSQ1        \ Increment effectOnSQ1 to 1 to denote that a sound
                        \ effect is now being generated on the SQ1 channel, so
                        \ successive calls to MakeSoundOnSQ1 will now make the
                        \ sound effect

 RTS                    \ Return from the subroutine

