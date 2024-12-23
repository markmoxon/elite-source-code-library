\ ******************************************************************************
\
\       Name: BDENTRY
\       Type: Subroutine
\   Category: Sound
\    Summary: Start playing a new tune as background music
\  Deep dive: Music in Commodore 64 Elite
\
\ ******************************************************************************

.BDENTRY

 LDA #0                 \ Set BDBUFF = 0 to reset the current music data byte in
 STA BDBUFF             \ BDBUFF

 STA counter            \ Set counter = 0 to reset the rest counter

 STA vibrato2           \ Set vibrato2 = 0 to reset the vibrato counter for
                        \ voice 2

 STA vibrato3           \ Set vibrato3 = 0 to reset the vibrato counter for
                        \ voice 3

                        \ We now zero all the SID registers from &01 to &18 to
                        \ reset the sound chip (though it doesn't zero the first
                        \ byte at &00, for some reason)

 LDX #&18               \ Set a byte counter in X

.BDloop2

 STA SID,X              \ Zero the X-th byte of the SID registers

 DEX                    \ Decrement the counter in X

 BNE BDloop2            \ Loop back until we have zeroed all the registers from
                        \ &01 to &18

IF _GMA_RELEASE

 LDA value5             \ Set A to the low byte of value5, which is set to the
                        \ address before the start of the tune that is
                        \ configured to play for docking

ELIF _SOURCE_DISK

 LDA #LO(musicstart)    \ Set A to the low byte of musicstart, which is the
                        \ address before the start of the docking music

ENDIF

 STA BDdataptr1         \ Set BDdataptr1 to the low byte of the music to play

 STA BDdataptr3         \ Set BDdataptr3 to the low byte of the music to play

IF _GMA_RELEASE

 LDA value5+1           \ Set A to the high byte of value5, which is set to the
                        \ address before the start of the tune that is
                        \ configured to play for docking

ELIF _SOURCE_DISK

 LDA #HI(musicstart)    \ Set A to the high byte of musicstart, which is the
                        \ address before the start of the docking music

ENDIF

 STA BDdataptr2         \ Set BDdataptr2 to the high byte of the music to play,
                        \ so BDdataptr1(1 0) is the address of the music to play
                        \ (as BDdataptr2 = BDdataptr1 + 1)

 STA BDdataptr4         \ Set BDdataptr4 to the high byte of the music to play,
                        \ so BDdataptr3(1 0) is the address of the music to play
                        \ (as BDdataptr4 = BDdataptr3 + 1)

 LDA #%00001111         \ Set SID register &18 to control the sound as follows:
 STA SID+&18            \
                        \   * Bits 0-3: set the volume to 15 (maximum)
                        \
                        \   * Bit 4 clear: disable the low-pass filter
                        \
                        \   * Bit 5 clear: disable the bandpass filter
                        \
                        \   * Bit 6 clear: disable the high-pass filter
                        \
                        \   * Bit 7 clear: enable voice 3

\SEI                    \ This instruction is commented out in the original
                        \ source

 RTS                    \ Return from the subroutine

\point IRQ to start     \ These instructions are commented out in the original
\                       \ source
\LDA  #LO(BDirqhere)
\STA  &0314
\LDA  #HI(BDirqhere)
\STA  &0315
\
\CLI
\
\BRK
\
\re enter monitor!

