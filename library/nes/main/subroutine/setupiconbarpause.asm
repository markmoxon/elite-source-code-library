\ ******************************************************************************
\
\       Name: SetupIconBarPause
\       Type: Subroutine
\   Category: Icon bar
\    Summary: Set up the game options shown on the icon bar when the game is
\             paused
\
\ ******************************************************************************

.SetupIconBarPause

                        \ By default the icon bar shows all possible icons, so
                        \ now we work our way through the buttons, hiding any
                        \ icons that do not apply

 LDA JSTGY              \ If JSTGY is 0 then the game is not configured to
 BEQ pbar1              \ reverse the controller y-axis, so jump to pbar1 to
                        \ skip the following and leave the default icon showing

 LDY #2                 \ Draw four tiles over the top of the first button to
 JSR Draw4OptionTiles   \ show that the controller y-axis is reversed

.pbar1

 LDA DAMP               \ If DAMP is 0 then controller damping is disabled, so
 BEQ pbar2              \ jump to pbar2 to skip the following and leave the
                        \ default icon showing

 LDY #4                 \ Draw six tiles over the top of the second button to
 JSR Draw6OptionTiles   \ shot that controller damping is enabled

.pbar2

 LDA disableMusic       \ If bit 7 of disableMusic is clear then music is
 BPL pbar3              \ enabled, so jump to pbar3 to skip the following and
                        \ leave the default icon showing

 LDY #7                 \ Draw four tiles over the top of the third button to
 JSR Draw4OptionTiles   \ show that music is disabled

.pbar3

 LDA DNOIZ              \ If bit 7 of DNOIZ is set then sound is on, so jump to
 BMI pbar4              \ pbar4 to skip the following and leave the default icon
                        \ showing

 LDY #9                 \ Draw six tiles over the top of the fourth button to
 JSR Draw6OptionTiles   \ shot that sound is disabled

.pbar4

 LDA numberOfPilots     \ If the game is configured for two pilots, jump to
 BNE pbar5              \ pbar5 to skip the following and leave the default icon
                        \ showing

 LDY #12                \ Draw four tiles over the top of the fifth button to
 JSR Draw4OptionTiles   \ show that one pilot is configured

.pbar5

 JSR BlankButtons6To11  \ Blank from the sixth to the eleventh button on the
                        \ icon bar

                        \ Fall through into SetIconBarButtonsS to jump to
                        \ SetIconBarButtons to set the correct list of button
                        \ numbers for the icon bar

