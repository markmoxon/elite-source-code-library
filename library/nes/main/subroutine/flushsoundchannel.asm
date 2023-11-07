\ ******************************************************************************
\
\       Name: FlushSoundChannel
\       Type: Subroutine
\   Category: Sound
\    Summary: Flush a specific sound channel
\  Deep dive: Sound effects in NES Elite
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The sound channel to flush:
\
\                         * 0 = flush the SQ1 sound channel
\
\                         * 1 = flush the SQ2 sound channel
\
\                         * 2 = flush the NOISE sound channel
\
\ ******************************************************************************

.FlushSoundChannel

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA #0                 \ Set the priority for channel X to zero to stop the
 STA channelPriority,X  \ channel from making any more sounds

 LDA #26                \ Set A = 26 to pass to StartEffect below (sound effect
                        \ 26 is the sound of silence, so this flushes the sound
                        \ channel)

 BNE StartEffect_b7     \ Jump to StartEffect to start making sound effect 26
                        \ on channel X (this BNE is effectively a JMP as A is
                        \ never zero)

