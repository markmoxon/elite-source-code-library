\ ******************************************************************************
\
\       Name: soundData
\       Type: Variable
\   Category: Sound
\    Summary: Sound data for the sound effects
\
\ ------------------------------------------------------------------------------
\
\ Each sound block is made up of 14 bytes, which are copied to the soundByteSQ1,
\ soundByteSQ2 or soundByteNOISE blocks (one for each channel) where they can be
\ manipulated (so counters can be updated, and so on).
\
\ The sound data block controls the sending of data to the APU during each
\ iteration of the sound effect routine (which is typically every VBlank). The
\ following documentation talks about channel SQ1, but the same logic applies to
\ the SQ2 and NOISE channels.
\
\ The list of bytes in the sound effect data block is as follows:
\
\   * Byte #0 = length of sound (in iterations)
\
\     * Ignored if the sound is an infinite loop (i.e. if byte #12 is non-zero)
\
\     * Gets decremented on each iteration
\
\   * Byte #1 = how often we send pitch data to the APU
\
\     * So we send pitch data to the APU every byte #1 iterations
\
\   * Bytes #2, #3 = the first 16-bit pitch data to send to (SQ1_HI SQ1_LO)
\
\     * Used as 16-bit storage for (soundHiSQ1 soundLoSQ1), which contains the
\       pitch data to send to the APU for this iteration
\
\     * This gets sent to the APU via (SQ1_HI SQ1_LO) to set the sound effect's
\       pitch as the effect progresses
\
\   * Bytes #4, #5 = A 16-bit value to apply to the pitch every iteration
\
\     * The pitch is only varied if enabled by byte #8 being non-zero
\
\   * Byte #6 = top nibble of the SQ1_VOL byte
\
\     * This value gets OR'd with the soundVolume to send to the APU via SQ1_VOL
\
\     * It sets the duty, loop and NES envelope settings to send to the APU
\
\   * Byte #7 = add vibrato
\
\     * Non-zero means add vibrato to the pitch on each iteration using the
\       randomised vibrato value in soundVibrato
\
\   * Byte #8 = enable/disable the pitch variation in byte #4/#5
\
\     * Non-zero means:
\
\       * Bit 7 clear = subtract byte #4/#5 from the APU pitch on each iteration
\                      (so the note frequency goes up)
\
\       * Bit 7 set = add byte #4/#5 to the APU pitch on each iteration
\                     (so the note frequency goes down)
\
\     * Zero disables the pitch variation in byte #4/#5 
\
\   * Byte #9 = number of iterations for which we send pitch data to the APU
\
\     * Ignored if the sound is an infinite loop (i.e. if byte #12 is non-zero)
\
\   * Byte #10 = number of the volume envelope to apply
\
\     * This is the number of the envelope as specified in the soundVolume table
\
\   * Byte #11 = how often we apply the volume envelope to the sound
\
\     * We apply the next entry from the volume envelope every byte #11
\       iterations
\
\   * Byte #12 = enable/disable infinite loop
\
\     * Non-zero means the sound effect loops and keeps being made, even after
\       the counter in byte #0 runs down
\
\     * Zero means the sound only runs for the number of iterations in byte #0
\
\   * Byte #13 = how often to apply the pitch variation in byte #4/#5
\
\     * If pitch variation is enabled by byte #8 being non-zero, then:
\
\       * Non-zero means only apply the pitch variation in byte #4/#5 every
\         byte #13 iterations
\
\       * Zero means apply the pitch variation every iteration
\
\ ******************************************************************************

.soundData

 EQUW soundData0
 EQUW soundData1
 EQUW soundData2
 EQUW soundData3
 EQUW soundData4
 EQUW soundData5
 EQUW soundData6
 EQUW soundData7
 EQUW soundData8
 EQUW soundData9
 EQUW soundData10
 EQUW soundData11
 EQUW soundData12
 EQUW soundData13
 EQUW soundData14
 EQUW soundData15
 EQUW soundData16
 EQUW soundData17
 EQUW soundData18
 EQUW soundData19
 EQUW soundData20
 EQUW soundData21
 EQUW soundData22
 EQUW soundData23
 EQUW soundData24
 EQUW soundData25
 EQUW soundData26
 EQUW soundData27
 EQUW soundData28
 EQUW soundData29
 EQUW soundData30
 EQUW soundData31

.soundData0

 EQUB &3C, &03, &04, &00, &02, &00, &30, &00
 EQUB &01, &0A, &00, &05, &00, &63

.soundData1

 EQUB &16, &04, &A8, &00, &04, &00, &70, &00
 EQUB &FF, &63, &0C, &02, &00, &00

.soundData2

 EQUB &19, &19, &AC, &03, &1C, &00, &30, &00
 EQUB &01, &63, &06, &02, &FF, &00

.soundData3

 EQUB &05, &63, &2C, &00, &00, &00, &70, &00
 EQUB &00, &63, &0C, &01, &00, &00

.soundData4

 EQUB &09, &63, &57, &02, &02, &00, &B0, &00
 EQUB &FF, &63, &08, &01, &00, &00

.soundData5

 EQUB &0A, &02, &18, &00, &01, &00, &30, &FF
 EQUB &FF, &0A, &0C, &01, &00, &00

.soundData6

 EQUB &0D, &02, &28, &00, &01, &00, &70, &FF
 EQUB &FF, &0A, &0C, &01, &00, &00

.soundData7

 EQUB &19, &1C, &00, &01, &06, &00, &70, &00
 EQUB &01, &63, &06, &02, &00, &00

.soundData8

 EQUB &5A, &09, &14, &00, &01, &00, &30, &00
 EQUB &FF, &63, &00, &0B, &00, &00

.soundData9

 EQUB &46, &28, &02, &00, &01, &00, &30, &00
 EQUB &FF, &00, &08, &06, &00, &03

.soundData10

 EQUB &0E, &03, &6C, &00, &21, &00, &B0, &00
 EQUB &FF, &63, &0C, &02, &00, &00

.soundData11

 EQUB &13, &0F, &08, &00, &01, &00, &30, &00
 EQUB &FF, &00, &0C, &03, &00, &02

.soundData12

 EQUB &AA, &78, &1F, &00, &01, &00, &30, &00
 EQUB &01, &00, &01, &08, &00, &0A

.soundData13

 EQUB &59, &02, &4F, &00, &29, &00, &B0, &FF
 EQUB &01, &FF, &00, &09, &00, &00

.soundData14

 EQUB &19, &05, &82, &01, &29, &00, &B0, &FF
 EQUB &FF, &FF, &08, &02, &00, &00

.soundData15

 EQUB &22, &05, &82, &01, &29, &00, &B0, &FF
 EQUB &FF, &FF, &08, &03, &00, &00

.soundData16

 EQUB &0F, &63, &B0, &00, &20, &00, &70, &00
 EQUB &FF, &63, &08, &02, &00, &00

.soundData17

 EQUB &0D, &63, &8F, &01, &31, &00, &30, &00
 EQUB &FF, &63, &10, &02, &00, &00

.soundData18

 EQUB &18, &05, &FF, &01, &31, &00, &30, &00
 EQUB &FF, &63, &10, &03, &00, &00

.soundData19

 EQUB &46, &03, &42, &03, &29, &00, &B0, &00
 EQUB &FF, &FF, &0C, &06, &00, &00

.soundData20

 EQUB &0C, &02, &57, &00, &14, &00, &B0, &00
 EQUB &FF, &63, &0C, &01, &00, &00

.soundData21

 EQUB &82, &46, &0F, &00, &01, &00, &B0, &00
 EQUB &01, &00, &01, &07, &00, &05

.soundData22

 EQUB &82, &46, &00, &00, &01, &00, &B0, &00
 EQUB &FF, &00, &01, &07, &00, &05

.soundData23

 EQUB &19, &05, &82, &01, &29, &00, &B0, &FF
 EQUB &FF, &FF, &0E, &02, &00, &00

.soundData24

 EQUB &AA, &78, &1F, &00, &01, &00, &30, &00
 EQUB &01, &00, &01, &08, &00, &0A

.soundData25

 EQUB &14, &03, &08, &00, &01, &00, &30, &00
 EQUB &FF, &FF, &00, &02, &00, &00

.soundData26

 EQUB &01, &00, &00, &00, &00, &00, &30, &00
 EQUB &00, &00, &0D, &00, &00, &00

.soundData27

 EQUB &19, &05, &82, &01, &29, &00, &B0, &FF
 EQUB &FF, &FF, &0F, &02, &00, &00

.soundData28

 EQUB &0B, &04, &42, &00, &08, &00, &B0, &00
 EQUB &01, &63, &08, &01, &00, &02

.soundData29

 EQUB &96, &1C, &00, &01, &06, &00, &70, &00
 EQUB &01, &63, &06, &02, &00, &00

.soundData30

 EQUB &96, &1C, &00, &01, &06, &00, &70, &00
 EQUB &01, &63, &06, &02, &00, &00

.soundData31

 EQUB &14, &02, &28, &00, &01, &00, &70, &FF
 EQUB &FF, &0A, &00, &02, &00, &00

