\ ******************************************************************************
\
\       Name: StopSounds
\       Type: Subroutine
\   Category: Sound
\    Summary: Stop all sounds (music and sound effects)
\
\ ******************************************************************************

.StopSounds

 LDA #0                 \ Set enableSound = 0 to disable all sounds (music and
 STA enableSound        \ sound effects)

 STA effectOnSQ1        \ Set effectOnSQ1 = 0 to indicate the SQ1 channel is
                        \ clear of sound effects

 STA effectOnSQ2        \ Set effectOnSQ2 = 0 to indicate the SQ2 channel is
                        \ clear of sound effects

 STA effectOnNOISE      \ Set effectOnNOISE = 0 to indicate the NOISE channel is
                        \ clear of sound effects

 TAX                    \ We now clear the 16 bytes at sq1Volume, so set X = 0
                        \ to act as an index in the following loop

.stop1

 STA sq1Volume,X        \ Zero the X-th byte of sq1Volume

 INX                    \ Increment the index counter

 CPX #16                \ Loop back until we have cleared all 16 bytes
 BNE stop1

 STA TRI_LINEAR         \ Zero the linear counter for the TRI channel, which
                        \ configures it as follows:
                        \
                        \   * Bit 7 clear = do not reload the linear counter
                        \
                        \   * Bits 0-6    = counter reload value of 0
                        \
                        \ So this silences the TRI channel

 LDA #%00110000         \ Set the volume of the SQ1, SQ2 and NOISE channels to
 STA SQ1_VOL            \ zero as follows:
 STA SQ2_VOL            \
 STA NOISE_VOL          \   * Bits 6-7    = duty pulse length is 3
                        \   * Bit 5 set   = infinite play
                        \   * Bit 4 set   = constant volume
                        \   * Bits 0-3    = volume is 0

 LDA #%00001111         \ Enable the sound channels by writing to the sound
 STA SND_CHN            \ status register in SND_CHN as follows:
                        \
                        \   Bit 4 clear = disable the DMC channel
                        \   Bit 3 set   = enable the NOISE channel
                        \   Bit 2 set   = enable the TRI channel
                        \   Bit 1 set   = enable the SQ2 channel
                        \   Bit 0 set   = enable the SQ1 channel

 RTS                    \ Return from the subroutine

