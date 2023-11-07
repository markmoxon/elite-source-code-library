\ ******************************************************************************
\
\       Name: StartEffectOnNOISE
\       Type: Subroutine
\   Category: Sound
\    Summary: Make a sound effect on the NOISE channel
\  Deep dive: Sound effects in NES Elite
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The number of the sound effect to make
\
\ ******************************************************************************

.StartEffectOnNOISE

 ASL A                  \ Set Y = A * 2
 TAY                    \
                        \ So we can use Y as an index into the soundData table,
                        \ which contains addresses of two bytes each

 LDA #0                 \ Set effectOnNOISE = 0 to disable sound generation on
 STA effectOnNOISE      \ the NOISE channel while we set up the sound effect (as
                        \ a value of 0 denotes that a sound effect is not being
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
                        \ that we now copy to soundByteNOISE, so we can do
                        \ things like update the counters and store the current
                        \ pitch as we make the sound effect

 LDY #13                \ Set a byte counter in Y for copying all 14 bytes

.meft1

 LDA (soundAddr),Y      \ Copy the Y-th byte of sound data for this sound effect
 STA soundByteNOISE,Y   \ to the Y-th byte of soundByteNOISE

 DEY                    \ Decrement the loop counter

 BPL meft1              \ Loop back until we have copied all 14 bytes

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA soundByteNOISE+11  \ Set soundVolCountNOISE = soundByteNOISE+11
 STA soundVolCountNOISE \
                        \ This initialises the counter in soundVolCountNOISE
                        \ with the value of byte #11, so it can be used to
                        \ control how often we apply the volume envelope to the
                        \ sound effect on channel NOISE

 LDA soundByteNOISE+13  \ Set soundPitchEnvNOISE = soundByteNOISE+13
 STA soundPitchEnvNOISE \
                        \ This initialises the counter in soundPitchEnvNOISE
                        \ with the value of byte #13, so it can be used to
                        \ control how often we apply the pitch envelope to the
                        \ sound effect on channel NOISE

 LDA soundByteNOISE+1   \ Set soundPitCountNOISE = soundByteNOISE+1
 STA soundPitCountNOISE \
                        \ This initialises the counter in soundPitCountNOISE
                        \ with the value of byte #1, so it can be used to
                        \ control how often we send pitch data to the APU for
                        \ the sound effect on channel NOISE

 LDA soundByteNOISE+10  \ Set Y = soundByteNOISE+10 * 2
 ASL A                  \
 TAY                    \ So we can use Y as an index into the soundVolume
                        \ table to fetch byte #10, as the table contains
                        \ addresses of two bytes each

 LDA soundVolume,Y      \ Set soundVolumeNOISE(1 0) to the address of the volume
 STA soundVolumeNOISE   \ envelope for this sound effect, as specified in
 STA soundAddr          \ byte #10 of the sound effect's data
 LDA soundVolume+1,Y    \
 STA soundVolumeNOISE+1 \ This also sets soundAddr(1 0) to the same address
 STA soundAddr+1

 LDY #0                 \ Set Y = 0 so we can use indirect addressing below (we
                        \ do not change the value of Y, this is just so we can
                        \ implement the non-existent LDA (soundAddr) instruction
                        \ by using LDA (soundAddr),Y instead)

 STY soundVolIndexNOISE \ Set soundVolIndexNOISE = 0, so we start processing the
                        \ volume envelope from the first byte

 LDA (soundAddr),Y      \ Take the first byte from the volume envelope for this
 ORA soundByteNOISE+6   \ sound effect, OR it with the sound effect's byte #6,
 STA NOISE_VOL          \ and send the result to the APU via NOISE_VOL
                        \
                        \ Data bytes in the volume envelope data only use the
                        \ low nibble (the high nibble is only used to mark the
                        \ end of the data), and the sound effect's byte #6 only
                        \ uses the high nibble, so this sets the low nibble of
                        \ the APU byte to the volume level from the data, and
                        \ the high nibble of the APU byte to the configuration
                        \ in byte #6 (which sets the duty pulse, looping and
                        \ constant flags for the volume)

 LDA #0                 \ This instruction would send 0 to the APU via
 STA NOISE_VOL+1        \ NOISE_SWEEP to disable the sweep unit and stop the
                        \ pitch from changing, but the NOISE channel doesn't
                        \ have a sweep unit, so this has no effect and is
                        \ presumably left over from the same code for the SQ1
                        \ and SQ2 channels

 LDA soundByteNOISE+2   \ Set (0 soundLoNOISE) to the 8-bit value in byte #2 of
 AND #&0F               \ the sound data, which at this point contains the first
 STA soundLoNOISE       \ pitch value to send to the APU via (NOISE_HI NOISE_LO)
 STA NOISE_LO           \ 
 LDA #0                 \ We ignore byte #3 as the NOISE channel only has an
 STA NOISE_HI           \ 8-bit pitch range
                        \
                        \ We will be using soundLoNOISE to store the pitch byte
                        \ to send to the APU as we keep making the sound effect,
                        \ so this just kicks off the process with the initial
                        \ pitch value

 INC effectOnNOISE      \ Increment effectOnNOISE to 1 to denote that a sound
                        \ effect is now being generated on the NOISE channel, so
                        \ successive calls to MakeSoundOnNOISE will now make the
                        \ sound effect

 RTS                    \ Return from the subroutine

