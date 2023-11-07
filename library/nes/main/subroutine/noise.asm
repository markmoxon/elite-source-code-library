\ ******************************************************************************
\
\       Name: NOISE
\       Type: Subroutine
\   Category: Sound
\    Summary: Make the sound effect whose number is in Y
\  Deep dive: Sound effects in NES Elite
\
\ ------------------------------------------------------------------------------
\
\ The full list of sound effects is as follows, along with the names of the
\ routines that make them:
\
\    0 = Unused                                     -
\    1 = Fuel scoop                                 MakeScoopSound
\    2 = E.C.M.                                     ECBLB2
\    3 = Short, high beep                           BEEP
\    4 = Long, low beep                             BOOP
\    5 = Trumbles in the hold sound 1, 75% chance   Main game loop (Part 5)
\    6 = Trumbles in the hold sound 2, 25% chance   Main game loop (Part 5)
\    7 = Low energy beep                            Main flight loop (Part 15)
\    8 = Energy bomb                                Main flight loop (Part 3)
\    9 = Missile launch                             FRMIS, SFRMIS
\   10 = Us making a hit or kill                    EXNO
\   11 = Us being hit by lasers                     TACTICS (Part 6)
\   12 = First launch sound                         LAUN
\   13 = Explosion/collision sound                  EXNO3
\        Ship explosion at distance z_hi < 6        EXNO2
\   14 = Ship explosion at distance z_hi >= 6       EXNO2
\   15 = Military laser firing                      Main flight loop (Part 3)
\   16 = Mining laser firing                        Main flight loop (Part 3)
\   17 = Beam laser firing                          Main flight loop (Part 3)
\   18 = Pulse laser firing                         Main flight loop (Part 3)
\   19 = Escape pod launching                       ESCAPE
\   20 = Unused                                     -
\   21 = Hyperspace                                 MakeHyperSound
\   22 = Galactic hyperspace                        Ghy
\   23 = Third launch sound                         LAUN
\        Ship explosion at distance z_hi >= 8       EXNO2
\   24 = Second launch sound                        LAUN
\   25 = Unused                                     -
\   26 = No noise                                   FlushSoundChannel
\   27 = Ship explosion at a distance of z_hi >= 16 EXNO2
\   28 = Trill noise to indicate a purchase         BuyAndSellCargo
\   29 = First mis-jump sound                       MJP
\   30 = Second mis-jump sound                      MJP
\   31 = Trumbles being killed by the sun           Main flight loop (Part 15)
\
\ Arguments:
\
\   Y                   The number of the sound effect to be made
\
\ ******************************************************************************

.NOISE

 LDA DNOIZ              \ If DNOIZ is zero then sound is disabled, so jump to
 BPL RTS8               \ RTS8 to return from the subroutine without making a
                        \ sound

 LDX soundChannel,Y     \ Set X to the channel number for sound effect Y

 CPX #3                 \ If X < 3 then this sound effect uses just the channel
 BCC nois1              \ given in X, so jump to nois1 to make the sound effect
                        \ on that channel alone

                        \ If we get here then X = 3 or 4, so we need to make the
                        \ sound effect on two channels:
                        \
                        \   * If X = 3, use sound channels 0 and 2
                        \
                        \   * If X = 4, use sound channels 1 and 2

 TYA                    \ Store the sound effect number on the stack, so we can
 PHA                    \ restore it after the call to nois1 below

 DEX                    \ Set X = X - 3, so X is now 0 or 1, which is the number
 DEX                    \ of the first channel we need to make the sound on
 DEX                    \ (i.e. the SQ1 or SQ2 channel)

 JSR nois1              \ Call nois1 to make the sound effect on channel X, so
                        \ that's the SQ1 or SQ2 channel

 PLA                    \ Restore the sound effect number from the stack into Y
 TAY

 LDX #2                 \ Set X = 2 and fall through into nois1 to make the
                        \ sound effect on the NOISE channel, which is the number
                        \ of the second channel we need to make the sound on

.nois1

 LDA effectOnSQ1,X      \ If the status flag for channel X is zero, then there
 BEQ nois2              \ is no sound being made on this channel at the moment,
                        \ so jump to nois2 to make the sound

 LDA soundPriority,Y    \ Otherwise set A to the priority of the sound effect we
                        \ want to make

 CMP channelPriority,X  \ If A is less than the priority of the sound currently
 BCC RTS8               \ being made on channel X, then we mustn't interrupt it
                        \ with our lower-priority sound, so return from the
                        \ subroutine without making the new sound

.nois2

                        \ If we get here then we are cleared to make our new
                        \ sound Y on channel X

 LDA soundPriority,Y    \ Set the priority of the sound on channel X to that of
 STA channelPriority,X  \ our new sound, as we are about to make it

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 TYA                    \ Set A to the sound number in Y so we can pass it to
                        \ the StartEffect routine

                        \ Fall through into StartEffect_b7 to start making sound
                        \ effect A on channel X

