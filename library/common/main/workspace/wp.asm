\ ******************************************************************************
\
\       Name: WP
\       Type: Workspace
IF _CASSETTE_VERSION \ Comment
\    Address: &0D40 to &0F33
\   Category: Workspaces
\    Summary: Ship slots, variables
ELIF _ELECTRON_VERSION
\    Address: &0BE0 to &0CF3
\   Category: Workspaces
\    Summary: Ship slots, variables
ELIF _DISC_VERSION OR _ELITE_A_VERSION
\    Address: &0E00 to &0E3B
\   Category: Workspaces
\    Summary: Variables
ELIF _6502SP_VERSION
\    Address: &0D00 to &0E3B
\   Category: Workspaces
\    Summary: Variables
ELIF _MASTER_VERSION
\    Address: &0E41 to &12A9
\   Category: Workspaces
\    Summary: Ship slots, variables
ELIF _NES_VERSION
\    Address: &0300 to &05FF
\   Category: Workspaces
\    Summary: Ship slots, variables
ENDIF
\
\ ******************************************************************************

IF _CASSETTE_VERSION \ Platform

 ORG &0D40

ELIF _ELECTRON_VERSION

 ORG &0BE0

ELIF _DISC_VERSION OR _ELITE_A_VERSION

 ORG &0E00

ELIF _6502SP_VERSION

 ORG &0D00

ELIF _MASTER_VERSION

 ORG &0E41

ELIF _NES_VERSION

 ORG &0300

ENDIF

.WP

 SKIP 0                 \ The start of the WP workspace

IF _CASSETTE_VERSION \ Platform

INCLUDE "library/common/main/variable/frin.asm"
INCLUDE "library/common/main/variable/cabtmp.asm"
INCLUDE "library/common/main/variable/many.asm"
INCLUDE "library/common/main/variable/sspr.asm"
INCLUDE "library/common/main/variable/ecmp.asm"
INCLUDE "library/common/main/variable/mj.asm"
INCLUDE "library/common/main/variable/las2.asm"
INCLUDE "library/common/main/variable/msar.asm"
INCLUDE "library/common/main/variable/view.asm"
INCLUDE "library/common/main/variable/lasct.asm"
INCLUDE "library/common/main/variable/gntmp.asm"
INCLUDE "library/common/main/variable/hfx.asm"
INCLUDE "library/common/main/variable/ev.asm"
INCLUDE "library/common/main/variable/dly.asm"
INCLUDE "library/common/main/variable/de.asm"
INCLUDE "library/common/main/variable/lsx.asm"
INCLUDE "library/common/main/variable/lso.asm"
INCLUDE "library/common/main/variable/lsx2.asm"
INCLUDE "library/common/main/variable/lsy2.asm"
INCLUDE "library/common/main/variable/sy.asm"
INCLUDE "library/common/main/variable/syl.asm"
INCLUDE "library/common/main/variable/sz.asm"
INCLUDE "library/common/main/variable/szl.asm"
INCLUDE "library/common/main/variable/xsav2.asm"
INCLUDE "library/common/main/variable/ysav2.asm"
INCLUDE "library/common/main/variable/mch.asm"
INCLUDE "library/common/main/variable/fsh.asm"
INCLUDE "library/common/main/variable/ash.asm"
INCLUDE "library/common/main/variable/energy.asm"
INCLUDE "library/common/main/variable/lasx.asm"
INCLUDE "library/common/main/variable/lasy.asm"
INCLUDE "library/common/main/variable/comx.asm"
INCLUDE "library/common/main/variable/comy.asm"
INCLUDE "library/common/main/variable/qq24.asm"
INCLUDE "library/common/main/variable/qq25.asm"
INCLUDE "library/common/main/variable/qq28.asm"
INCLUDE "library/common/main/variable/qq29.asm"
INCLUDE "library/common/main/variable/gov.asm"
INCLUDE "library/common/main/variable/tek.asm"
INCLUDE "library/common/main/variable/slsp.asm"
INCLUDE "library/common/main/variable/xx24.asm"
INCLUDE "library/common/main/variable/altit.asm"
INCLUDE "library/common/main/variable/qq2.asm"
INCLUDE "library/common/main/variable/qq3.asm"
INCLUDE "library/common/main/variable/qq4.asm"
INCLUDE "library/common/main/variable/qq5.asm"
INCLUDE "library/common/main/variable/qq6.asm"
INCLUDE "library/common/main/variable/qq7.asm"
INCLUDE "library/common/main/variable/qq8.asm"
INCLUDE "library/common/main/variable/qq9.asm"
INCLUDE "library/common/main/variable/qq10.asm"
INCLUDE "library/common/main/variable/nostm.asm"

ELIF _ELECTRON_VERSION

INCLUDE "library/common/main/variable/frin.asm"
INCLUDE "library/common/main/variable/las2.asm"
INCLUDE "library/common/main/variable/many.asm"
INCLUDE "library/common/main/variable/sspr.asm"

 SKIP 2                 \ These bytes appear to be unused

INCLUDE "library/electron/main/variable/sfxpr.asm"
INCLUDE "library/electron/main/variable/sfxdu.asm"
INCLUDE "library/common/main/variable/ecmp.asm"
INCLUDE "library/common/main/variable/msar.asm"
INCLUDE "library/common/main/variable/view.asm"
INCLUDE "library/common/main/variable/lasct.asm"
INCLUDE "library/common/main/variable/gntmp.asm"
INCLUDE "library/common/main/variable/hfx.asm"
INCLUDE "library/common/main/variable/ev.asm"
INCLUDE "library/common/main/variable/dly.asm"
INCLUDE "library/common/main/variable/de.asm"
INCLUDE "library/common/main/variable/lso.asm"
INCLUDE "library/common/main/variable/lsx2.asm"
INCLUDE "library/common/main/variable/lsy2.asm"
INCLUDE "library/common/main/variable/syl.asm"
INCLUDE "library/common/main/variable/sz.asm"
INCLUDE "library/common/main/variable/szl.asm"
INCLUDE "library/common/main/variable/xsav2.asm"
INCLUDE "library/common/main/variable/ysav2.asm"
INCLUDE "library/common/main/variable/mch.asm"
INCLUDE "library/common/main/variable/fsh.asm"
INCLUDE "library/common/main/variable/ash.asm"
INCLUDE "library/common/main/variable/energy.asm"
INCLUDE "library/common/main/variable/lasx.asm"
INCLUDE "library/common/main/variable/lasy.asm"
INCLUDE "library/common/main/variable/comx.asm"
INCLUDE "library/common/main/variable/comy.asm"
INCLUDE "library/common/main/variable/qq24.asm"
INCLUDE "library/common/main/variable/qq25.asm"
INCLUDE "library/common/main/variable/qq28.asm"
INCLUDE "library/common/main/variable/qq29.asm"
INCLUDE "library/common/main/variable/gov.asm"
INCLUDE "library/common/main/variable/tek.asm"
INCLUDE "library/common/main/variable/slsp.asm"
INCLUDE "library/common/main/variable/xx24.asm"
INCLUDE "library/common/main/variable/altit.asm"
INCLUDE "library/common/main/variable/qq2.asm"
INCLUDE "library/common/main/variable/qq3.asm"
INCLUDE "library/common/main/variable/qq4.asm"
INCLUDE "library/common/main/variable/qq5.asm"
INCLUDE "library/common/main/variable/qq6.asm"
INCLUDE "library/common/main/variable/qq7.asm"
INCLUDE "library/common/main/variable/qq8.asm"
INCLUDE "library/common/main/variable/qq9.asm"
INCLUDE "library/common/main/variable/qq10.asm"

ELIF _DISC_VERSION OR _ELITE_A_VERSION

INCLUDE "library/common/main/variable/lsx.asm"
INCLUDE "library/common/main/variable/lso.asm"
INCLUDE "library/common/main/variable/lsx2.asm"
INCLUDE "library/common/main/variable/lsy2.asm"
INCLUDE "library/common/main/variable/sx.asm"
INCLUDE "library/common/main/variable/sxl.asm"
INCLUDE "library/common/main/variable/sy.asm"
INCLUDE "library/common/main/variable/syl.asm"
INCLUDE "library/common/main/variable/sz.asm"
INCLUDE "library/common/main/variable/szl.asm"
INCLUDE "library/common/main/variable/lasx.asm"
INCLUDE "library/common/main/variable/lasy.asm"
INCLUDE "library/common/main/variable/xx24.asm"
INCLUDE "library/common/main/variable/altit.asm"
INCLUDE "library/disc/main/variable/cpir.asm"

ELIF _6502SP_VERSION

INCLUDE "library/common/main/variable/lsx.asm"
INCLUDE "library/common/main/variable/lso.asm"
INCLUDE "library/common/main/variable/sx.asm"
INCLUDE "library/common/main/variable/sxl.asm"
INCLUDE "library/common/main/variable/sy.asm"
INCLUDE "library/common/main/variable/syl.asm"
INCLUDE "library/common/main/variable/sz.asm"
INCLUDE "library/common/main/variable/szl.asm"
INCLUDE "library/common/main/variable/lasx.asm"
INCLUDE "library/common/main/variable/lasy.asm"
INCLUDE "library/common/main/variable/xx24.asm"
INCLUDE "library/common/main/variable/altit.asm"
INCLUDE "library/common/main/variable/swap.asm"
INCLUDE "library/6502sp/main/variable/xp.asm"
INCLUDE "library/6502sp/main/variable/yp.asm"
INCLUDE "library/6502sp/main/variable/ys.asm"
INCLUDE "library/6502sp/main/variable/bali.asm"
INCLUDE "library/6502sp/main/variable/upo.asm"

ELIF _MASTER_VERSION

INCLUDE "library/common/main/variable/frin.asm"
INCLUDE "library/common/main/variable/many.asm"
INCLUDE "library/common/main/variable/sspr.asm"
INCLUDE "library/enhanced/main/variable/junk.asm"
INCLUDE "library/enhanced/main/variable/auto.asm"
INCLUDE "library/common/main/variable/ecmp.asm"
INCLUDE "library/common/main/variable/mj.asm"
INCLUDE "library/common/main/variable/cabtmp.asm"
INCLUDE "library/common/main/variable/las2.asm"
INCLUDE "library/common/main/variable/msar.asm"
INCLUDE "library/common/main/variable/view.asm"
INCLUDE "library/common/main/variable/lasct.asm"
INCLUDE "library/common/main/variable/gntmp.asm"
INCLUDE "library/common/main/variable/hfx.asm"
INCLUDE "library/common/main/variable/ev.asm"
INCLUDE "library/common/main/variable/dly.asm"
INCLUDE "library/common/main/variable/de.asm"
INCLUDE "library/common/main/variable/lsx2.asm"
INCLUDE "library/common/main/variable/lsy2.asm"
INCLUDE "library/common/main/variable/lso.asm"
INCLUDE "library/advanced/main/variable/buf.asm"
INCLUDE "library/common/main/variable/sx.asm"
INCLUDE "library/common/main/variable/sxl.asm"
INCLUDE "library/common/main/variable/sy.asm"
INCLUDE "library/common/main/variable/syl.asm"
INCLUDE "library/common/main/variable/sz.asm"
INCLUDE "library/common/main/variable/szl.asm"
INCLUDE "library/common/main/variable/lasx.asm"
INCLUDE "library/common/main/variable/lasy.asm"
INCLUDE "library/common/main/variable/xx24.asm"
INCLUDE "library/common/main/variable/altit.asm"
INCLUDE "library/common/main/variable/swap.asm"

.XP

 SKIP 1                 \ This byte appears to be unused

.YP

 SKIP 1                 \ This byte appears to be unused

.YS

 SKIP 1                 \ This byte appears to be unused

.BALI

 SKIP 1                 \ This byte appears to be unused

.UPO

 SKIP 1                 \ This byte appears to be unused

.boxsize

 SKIP 1                 \ This byte appears to be unused

INCLUDE "library/master/main/variable/distaway.asm"
INCLUDE "library/common/main/variable/xsav2.asm"
INCLUDE "library/common/main/variable/ysav2.asm"
INCLUDE "library/master/main/variable/nmi.asm"
INCLUDE "library/advanced/main/variable/name.asm"
INCLUDE "library/common/main/variable/tp.asm"
INCLUDE "library/common/main/variable/qq0.asm"
INCLUDE "library/common/main/variable/qq1.asm"
INCLUDE "library/common/main/variable/qq21.asm"
INCLUDE "library/common/main/variable/cash.asm"
INCLUDE "library/common/main/variable/qq14.asm"
INCLUDE "library/common/main/variable/cok.asm"
INCLUDE "library/common/main/variable/gcnt.asm"
INCLUDE "library/common/main/variable/laser.asm"

 SKIP 2                 \ These bytes appear to be unused (they were originally
                        \ used for up/down lasers, but they were dropped)

INCLUDE "library/common/main/variable/crgo.asm"
INCLUDE "library/common/main/variable/qq20.asm"
INCLUDE "library/common/main/variable/ecm.asm"
INCLUDE "library/common/main/variable/bst.asm"
INCLUDE "library/common/main/variable/bomb.asm"
INCLUDE "library/common/main/variable/engy.asm"
INCLUDE "library/common/main/variable/dkcmp.asm"
INCLUDE "library/common/main/variable/ghyp.asm"
INCLUDE "library/common/main/variable/escp.asm"

 SKIP 1                 \ This byte appears to be unused

INCLUDE "library/master/main/variable/tribble.asm"
INCLUDE "library/master/main/variable/tallyl.asm"
INCLUDE "library/common/main/variable/nomsl.asm"
INCLUDE "library/common/main/variable/fist.asm"
INCLUDE "library/common/main/variable/avl.asm"
INCLUDE "library/common/main/variable/qq26.asm"
INCLUDE "library/common/main/variable/tally.asm"
INCLUDE "library/common/main/variable/svc.asm"

 SKIP 1                 \ This byte appears to be unused

INCLUDE "library/common/main/variable/mch.asm"
INCLUDE "library/common/main/variable/comx.asm"
INCLUDE "library/common/main/variable/comy.asm"

.dialc

 SKIP 14                \ These bytes appear to be unused

INCLUDE "library/common/main/variable/qq24.asm"
INCLUDE "library/common/main/variable/qq25.asm"
INCLUDE "library/common/main/variable/qq28.asm"
INCLUDE "library/common/main/variable/qq29.asm"
INCLUDE "library/common/main/variable/gov.asm"
INCLUDE "library/common/main/variable/tek.asm"
INCLUDE "library/common/main/variable/slsp.asm"
INCLUDE "library/common/main/variable/qq2.asm"
INCLUDE "library/advanced/main/variable/safehouse.asm"
INCLUDE "library/master/main/variable/frump.asm"
INCLUDE "library/master/main/variable/jopos.asm"

ELIF _NES_VERSION

.allowInSystemJump

 SKIP 1                 \ Bits 6 and 7 record whether it is safe to perform an
                        \ in-system jump
                        \
                        \ Bits are set if, for example, hostile ships are in the
                        \ vicinity, or we are too near a station, the planet or
                        \ the sun
                        \
                        \ We can only do a jump if both bits are clear

.enableSound

 SKIP 1                 \ Controls sound effects and music in David Whittaker's
                        \ sound module
                        \
                        \   * 0 = sound is disabled
                        \
                        \   * Non-zero = sound is enabled

.effectOnSQ1

 SKIP 1                 \ Records whether a sound effect is being made on the
                        \ SQ1 channel
                        \
                        \   * 0 = no sound effect is being made on SQ1
                        \
                        \   * Non-zero = a sound effect is being made on SQ1

.effectOnSQ2

 SKIP 1                 \ Records whether a sound effect is being made on the
                        \ SQ2 channel
                        \
                        \   * 0 = no sound effect is being made on SQ2
                        \
                        \   * Non-zero = a sound effect is being made on SQ2

.effectOnNOISE

 SKIP 1                 \ Records whether a sound effect is being made on the
                        \ NOISE channel
                        \
                        \   * 0 = no sound effect is being made on NOISE
                        \
                        \   * Non-zero = a sound effect is being made on NOISE

.tuneSpeed

 SKIP 1                 \ The speed of the current tune, which can vary as the
                        \ tune plays

.tuneSpeedCopy

 SKIP 1                 \ The starting speed of the current tune, as stored in
                        \ the tune's data

.soundVibrato

 SKIP 4                 \ The four-byte seeds for adding randomised vibrato to
                        \ the current sound effect

.tuneProgress

 SKIP 1                 \ A variable for keeping track of progress while playing
                        \ the current tune, so we send data to the APU at the
                        \ correct time over multiple iterations of the MakeMusic
                        \ routine, according to the tune speed in tuneSpeed

.tuningAll

 SKIP 1                 \ The tuning value for all channels
                        \
                        \ Gets added to each note's pitch in the SQ1, SQ2 and
                        \ TRI channels

.playMusic

 SKIP 1                 \ Controls whether to keep playing the current tune:
                        \
                        \   * 0 = do not keep playing the current tune
                        \
                        \   * &FF do keep playing the current tune
                        \
                        \ The &FE note command stops the current tune and zeroes
                        \ this flag, and the only way to restart the music is
                        \ via the ChooseMusic routine
                        \
                        \ A value of zero in this flag also prevents the
                        \ EnableSound routine from having any effect

.sectionDataSQ1

 SKIP 2                 \ The address of the note data for channel SQ1 of the
                        \ the current section of the current tune
                        \
                        \ So if the current tune is tune 0 and we're playing
                        \ section 0, this would point to tune0Data_SQ1_0

.sectionListSQ1

 SKIP 2                 \ The address of the section list for channel SQ1 of
                        \ the current tune
                        \
                        \ So if the current tune is tune 0, this would point to
                        \ tune0Data_SQ1

.nextSectionSQ1

 SKIP 2                 \ The next section for the SQ1 channel of the current
                        \ tune
                        \
                        \ This is stored as the offset of the address of the
                        \ next section in the current tune for the SQ1 channel
                        \ (so this would be the offset within the tuneData0_SQ1
                        \ table for tune 0, for example)
                        \
                        \ Adding 2 moves it on to the next section of the tune

.tuningSQ1

 SKIP 1                 \ The tuning value for the SQ1 channel
                        \
                        \ Gets added to each note's pitch in the SQ1 channel

.startPauseSQ1

 SKIP 1                 \ Pause for this many iterations before starting to
                        \ process each batch of note data on channel SQ1

.pauseCountSQ1

 SKIP 1                 \ Pause for this many iterations before continuing to
                        \ process note data on channel SQ1, decrementing the
                        \ value for each paused iteration

.dutyLoopEnvSQ1

 SKIP 1                 \ The high nibble to use for SQ1_VOL, when setting the
                        \ following for the SQ1 channel:
                        \
                        \   * Bits 6-7    = duty pulse length
                        \
                        \   * Bit 5 set   = infinite play
                        \   * Bit 5 clear = one-shot play
                        \
                        \   * Bit 4 set   = constant volume
                        \   * Bit 4 clear = envelope volume

.sq1Sweep

 SKIP 1                 \ The value that we are going to send to the APU via
                        \ SQ1_SWEEP for the current tune

.pitchIndexSQ1

 SKIP 1                 \ The index of the entry within the pitch envelope to
                        \ be applied to the current tune on channel SQ1

.pitchEnvelopeSQ1

 SKIP 1                 \ The number of the pitch envelope to be applied to the
                        \ current tune on channel SQ1

.sq1LoCopy

 SKIP 1                 \ A copy of the value that we are going to send to the
                        \ APU via SQ1_LO for the current tune

.volumeIndexSQ1

 SKIP 1                 \ The index into the volume envelope data of the next
                        \ volume byte to apply to channel SQ1

.volumeRepeatSQ1

 SKIP 1                 \ The number of repeats to be applied to each byte in
                        \ the volume envelope on channel SQ1

.volumeCounterSQ1

 SKIP 1                 \ A counter for keeping track of repeated bytes from
                        \ the volume envelope on channel SQ1

.volumeEnvelopeSQ1

 SKIP 1                 \ The number of the volume envelope to be applied to the
                        \ current tune on channel SQ1

.applyVolumeSQ1

 SKIP 1                 \ A flag that determines whether to apply the volume
                        \ envelope to the SQ1 channel
                        \
                        \   * 0 = do not apply volume envelope
                        \
                        \   * &FF = apply volume envelope

.sectionDataSQ2

 SKIP 2                 \ The address of the note data for channel SQ2 of the
                        \ the current section of the current tune
                        \
                        \ So if the current tune is tune 0 and we're playing
                        \ section 0, this would point to tune0Data_SQ2_0

.sectionListSQ2

 SKIP 2                 \ The address of the section list for channel SQ2 of
                        \ the current tune
                        \
                        \ So if the current tune is tune 0, this would point to
                        \ tune0Data_SQ2

.nextSectionSQ2

 SKIP 2                 \ The next section for the SQ2 channel of the current
                        \ tune
                        \
                        \ This is stored as the offset of the address of the
                        \ next section in the current tune for the SQ2 channel
                        \ (so this would be the offset within the tuneData0_SQ2
                        \ table for tune 0, for example)
                        \
                        \ Adding 2 moves it on to the next section of the tune

.tuningSQ2

 SKIP 1                 \ The tuning value for the SQ2 channel
                        \
                        \ Gets added to each note's pitch in the SQ2 channel

.startPauseSQ2

 SKIP 1                 \ Pause for this many iterations before starting to
                        \ process each batch of note data on channel SQ2

.pauseCountSQ2

 SKIP 1                 \ Pause for this many iterations before continuing to
                        \ process note data on channel SQ2, decrementing the
                        \ value for each paused iteration

.dutyLoopEnvSQ2

 SKIP 1                 \ The high nibble to use for SQ2_VOL, when setting the
                        \ following for the SQ2 channel:
                        \
                        \   * Bits 6-7    = duty pulse length
                        \
                        \   * Bit 5 set   = infinite play
                        \   * Bit 5 clear = one-shot play
                        \
                        \   * Bit 4 set   = constant volume
                        \   * Bit 4 clear = envelope volume

.sq2Sweep

 SKIP 1                 \ The value that we are going to send to the APU via
                        \ SQ2_SWEEP for the current tune

.pitchIndexSQ2

 SKIP 1                 \ The index of the entry within the pitch envelope to
                        \ be applied to the current tune on channel SQ2

.pitchEnvelopeSQ2

 SKIP 1                 \ The number of the pitch envelope to be applied to the
                        \ current tune on channel SQ2

.sq2LoCopy

 SKIP 1                 \ A copy of the value that we are going to send to the
                        \ APU via SQ2_LO for the current tune

.volumeIndexSQ2

 SKIP 1                 \ The index into the volume envelope data of the next
                        \ volume byte to apply to channel SQ2

.volumeRepeatSQ2

 SKIP 1                 \ The number of repeats to be applied to each byte in
                        \ the volume envelope on channel SQ2

.volumeCounterSQ2

 SKIP 1                 \ A counter for keeping track of repeated bytes from
                        \ the volume envelope on channel SQ2

.volumeEnvelopeSQ2

 SKIP 1                 \ The number of the volume envelope to be applied to the
                        \ current tune on channel SQ2

.applyVolumeSQ2

 SKIP 1                 \ A flag that determines whether to apply the volume
                        \ envelope to the SQ2 channel
                        \
                        \   * 0 = do not apply volume envelope
                        \
                        \   * &FF = apply volume envelope

.sectionDataTRI

 SKIP 2                 \ The address of the note data for channel TRI of the
                        \ the current section of the current tune
                        \
                        \ So if the current tune is tune 0 and we're playing
                        \ section 0, this would point to tune0Data_TRI_0

.sectionListTRI

 SKIP 2                 \ The address of the section list for channel TRI of
                        \ the current tune
                        \
                        \ So if the current tune is tune 0, this would point to
                        \ tune0Data_TRI

.nextSectionTRI

 SKIP 2                 \ The next section for the TRI channel of the current
                        \ tune
                        \
                        \ This is stored as the offset of the address of the
                        \ next section in the current tune for the TRI channel
                        \ (so this would be the offset within the tuneData0_TRI
                        \ table for tune 0, for example)
                        \
                        \ Adding 2 moves it on to the next section of the tune

.tuningTRI

 SKIP 1                 \ The tuning value for the TRI channel
                        \
                        \ Gets added to each note's pitch in the TRI channel

.startPauseTRI

 SKIP 1                 \ Pause for this many iterations before starting to
                        \ process each batch of note data on channel TRI

.pauseCountTRI

 SKIP 1                 \ Pause for this many iterations before continuing to
                        \ process note data on channel TRI, decrementing the
                        \ value for each paused iteration

 SKIP 2                 \ These bytes appear to be unused

.pitchIndexTRI

 SKIP 1                 \ The index of the entry within the pitch envelope to
                        \ be applied to the current tune on channel TRI

.pitchEnvelopeTRI

 SKIP 1                 \ The number of the pitch envelope to be applied to the
                        \ current tune on channel TRI

.triLoCopy

 SKIP 1                 \ A copy of the value that we are going to send to the
                        \ APU via TRI_LO for the current tune

.volumeCounterTRI

 SKIP 1                 \ A counter for keeping track of repeated bytes from
                        \ the volume envelope on channel TRI


 SKIP 2                 \ These bytes appear to be unused

.volumeEnvelopeTRI

 SKIP 1                 \ The number of the volume envelope to be applied to the
                        \ current tune on channel TRI

 SKIP 1                 \ This byte appears to be unused

.sectionDataNOISE

 SKIP 2                 \ The address of the note data for channel NOISE of the
                        \ the current section of the current tune
                        \
                        \ So if the current tune is tune 0 and we're playing
                        \ section 0, this would point to tune0Data_NOISE_0

.sectionListNOISE

 SKIP 2                 \ The address of the section list for channel NOISE of
                        \ the current tune
                        \
                        \ So if the current tune is tune 0, this would point to
                        \ tune0Data_NOISE

.nextSectionNOISE

 SKIP 2                 \ The next section for the NOISE channel of the current
                        \ tune
                        \
                        \ This is stored as the offset of the address of the
                        \ next section in the current tune for the NOISE channel
                        \ (so this would be the offset within the
                        \ tuneData0_NOISE table for tune 0, for example)
                        \
                        \ Adding 2 moves it on to the next section of the tune

 SKIP 1                 \ This byte appears to be unused

.startPauseNOISE

 SKIP 1                 \ Pause for this many iterations before starting to
                        \ process each batch of note data on channel NOISE

.pauseCountNOISE

 SKIP 1                 \ Pause for this many iterations before continuing to
                        \ process note data on channel NOISE, decrementing the
                        \ value for each paused iteration

 SKIP 2                 \ These bytes appear to be unused

.pitchIndexNOISE

 SKIP 1                 \ The index of the entry within the pitch envelope to
                        \ be applied to the current tune on channel NOISE

.pitchEnvelopeNOISE

 SKIP 1                 \ The number of the pitch envelope to be applied to the
                        \ current tune on channel NOISE

.noiseLoCopy

 SKIP 1                 \ A copy of the value that we are going to send to the
                        \ APU via NOISE_LO for the current tune

.volumeIndexNOISE

 SKIP 1                 \ The index into the volume envelope data of the next
                        \ volume byte to apply to channel NOISE

.volumeRepeatNOISE

 SKIP 1                 \ The number of repeats to be applied to each byte in
                        \ the volume envelope on channel NOISE

.volumeCounterNOISE

 SKIP 1                 \ A counter for keeping track of repeated bytes from
                        \ the volume envelope on channel NOISE

.volumeEnvelopeNOISE

 SKIP 1                 \ The number of the volume envelope to be applied to the
                        \ current tune on channel NOISE

.applyVolumeNOISE

 SKIP 1                 \ A flag that determines whether to apply the volume
                        \ envelope to the NOISE channel
                        \
                        \   * 0 = do not apply volume envelope
                        \
                        \   * &FF = apply volume envelope

.sq1Volume

 SKIP 1                 \ The value that we are going to send to the APU via
                        \ SQ1_VOL for the current tune

 SKIP 1                 \ This byte appears to be unused

.sq1Lo

 SKIP 1                 \ The value that we are going to send to the APU via
                        \ SQ1_LO for the current tune

.sq1Hi

 SKIP 1                 \ The value that we are going to send to the APU via
                        \ SQ1_HI for the current tune

.sq2Volume

 SKIP 1                 \ The value that we are going to send to the APU via
                        \ SQ2_VOL for the current tune

 SKIP 1                 \ This byte appears to be unused

.sq2Lo

 SKIP 1                 \ The value that we are going to send to the APU via
                        \ SQ2_LO for the current tune

.sq2Hi

 SKIP 1                 \ The value that we are going to send to the APU via
                        \ SQ2_HI for the current tune

 SKIP 2                 \ These bytes appear to be unused

.triLo

 SKIP 1                 \ The value that we are going to send to the APU via
                        \ TRI_LO for the current tune

.triHi

 SKIP 1                 \ The value that we are going to send to the APU via
                        \ TRI_HI for the current tune

.noiseVolume

 SKIP 1                 \ The value that we are going to send to the APU via
                        \ NOISE_VOL for the current tune

 SKIP 1                 \ This byte appears to be unused

.noiseLo

 SKIP 1                 \ The value that we are going to send to the APU via
                        \ NOISE_LO for the current tune

 SKIP 1                 \ This byte appears to be unused

INCLUDE "library/common/main/variable/frin.asm"
INCLUDE "library/enhanced/main/variable/junk.asm"

.scannerNumber

 SKIP 10                \ Details of which scanner numbers are allocated to
                        \ ships on the scanner
                        \
                        \ Bytes 1 to 8 contain the following:
                        \
                        \   * &FF indicates that this scanner number (1 to 8)
                        \     is allocated to a ship so that is it shown on
                        \     the scanner (the scanner number is stored in byte
                        \     #33 of the ship's data block)
                        \
                        \   * 0 indicates that this scanner number (1 to 8) is
                        \     not yet allocated to a ship
                        \
                        \ Bytes 0 and 9 in the table are unused

.scannerColour

 SKIP 10                \ The colour of each ship number on the scanner, stored
                        \ as the sprite palette number for that ship's three
                        \ scanner sprites
                        \
                        \ Bytes 1 to 8 contain palettes for ships with non-zero
                        \ entries in the scannerNumber table (i.e. for ships on
                        \ the scanner)
                        \
                        \ Bytes 0 and 9 are unused

INCLUDE "library/enhanced/main/variable/auto.asm"
INCLUDE "library/common/main/variable/ecmp.asm"
INCLUDE "library/common/main/variable/mj.asm"
INCLUDE "library/common/main/variable/cabtmp.asm"
INCLUDE "library/common/main/variable/las2.asm"
INCLUDE "library/common/main/variable/msar.asm"
INCLUDE "library/common/main/variable/view.asm"
INCLUDE "library/common/main/variable/lasct.asm"
INCLUDE "library/common/main/variable/gntmp.asm"
INCLUDE "library/common/main/variable/hfx.asm"
INCLUDE "library/common/main/variable/ev.asm"
INCLUDE "library/common/main/variable/dly.asm"
INCLUDE "library/common/main/variable/de.asm"

.selectedSystemFlag

 SKIP 1                 \ Flags for the currently selected system
                        \
                        \   * Bit 6 is set when we can hyperspace to the
                        \     currently selected system, clear otherwise
                        \
                        \   * Bit 7 is set when there is a currently selected
                        \     system, clear otherwise (such as when we are
                        \     moving the crosshairs between systems)

INCLUDE "library/advanced/main/variable/name.asm"
INCLUDE "library/common/main/variable/svc.asm"
INCLUDE "library/common/main/variable/tp.asm"
INCLUDE "library/common/main/variable/qq0.asm"
INCLUDE "library/common/main/variable/qq1.asm"
INCLUDE "library/common/main/variable/cash.asm"
INCLUDE "library/common/main/variable/qq14.asm"
INCLUDE "library/common/main/variable/cok.asm"
INCLUDE "library/common/main/variable/gcnt.asm"
INCLUDE "library/common/main/variable/laser.asm"
INCLUDE "library/common/main/variable/crgo.asm"
INCLUDE "library/common/main/variable/qq20.asm"
INCLUDE "library/common/main/variable/ecm.asm"
INCLUDE "library/common/main/variable/bst.asm"
INCLUDE "library/common/main/variable/bomb.asm"
INCLUDE "library/common/main/variable/engy.asm"
INCLUDE "library/common/main/variable/dkcmp.asm"
INCLUDE "library/common/main/variable/ghyp.asm"
INCLUDE "library/common/main/variable/escp.asm"
INCLUDE "library/master/main/variable/tribble.asm"
INCLUDE "library/master/main/variable/tallyl.asm"
INCLUDE "library/common/main/variable/nomsl.asm"
INCLUDE "library/common/main/variable/fist.asm"
INCLUDE "library/common/main/variable/avl.asm"
INCLUDE "library/common/main/variable/qq26.asm"
INCLUDE "library/common/main/variable/tally.asm"

 SKIP 1                 \ This byte appears to be unused

INCLUDE "library/common/main/variable/qq21.asm"
INCLUDE "library/common/main/variable/nostm.asm"

.burstSpriteIndex

 SKIP 1                 \ The index into the sprite buffer of the explosion
                        \ burst sprite that is set up in DrawExplosionBurst

.unusedVariable

 SKIP 1                 \ This variable is zeroed in RES2 but is never read

.chargeDockingFee

 SKIP 1                 \ Records whether we have been charged a docking fee, so
                        \ we don't get charged twice:
                        \
                        \   * 0 = we have not been charged a docking fee
                        \
                        \   * Non-zero = we have been charged a docking fee
                        \
                        \ The docking fee is 5.0 credits

.priceDebug

 SKIP 1                 \ This is only referenced by some disabled test code in
                        \ the prx routine, where it was presumably used for
                        \ testing different equipment prices

INCLUDE "library/common/main/variable/damp.asm"
INCLUDE "library/common/main/variable/jstgy.asm"
INCLUDE "library/common/main/variable/dnoiz.asm"

.disableMusic

 SKIP 1                 \ Music on/off configuration setting
                        \
                        \   * 0 = music is on (default)
                        \
                        \   * Non-zero = sound is off

.autoPlayDemo

 SKIP 1                 \ Controls whether to play the demo automatically (which
                        \ happens after it is left idle for a while)
                        \
                        \   * Bit 7 clear = do not play the demo automatically
                        \
                        \   * Bit 7 set = play the demo automatically using
                        \                 the controller key presses in the
                        \                 autoPlayKeys table

.bitplaneFlags

 SKIP 1                 \ Flags for bitplane 0 that control the sending of data
                        \ for this bitplane to the PPU during VBlank in the NMI
                        \ handler:
                        \
                        \   * Bit 0 is ignored and is always clear
                        \
                        \   * Bit 1 is ignored and is always clear
                        \
                        \   * Bit 2 controls whether to override the number of
                        \     the last tile or pattern to send to the PPU:
                        \
                        \     * 0 = set the last tile number to lastNameTile or
                        \           the last pattern to lastPattern for this
                        \           bitplane (when sending nametable and pattern
                        \           entries respectively)
                        \
                        \     * 1 = set the last tile number to 128 (which means
                        \           tile 8 * 128 = 1024)
                        \
                        \   * Bit 3 controls the clearing of this bitplane's
                        \     buffer in the NMI handler, once it has been sent
                        \     to the PPU:
                        \
                        \     * 0 = do not clear this bitplane's buffer
                        \
                        \     * 1 = clear this bitplane's buffer once it has
                        \           been sent to the PPU
                        \
                        \   * Bit 4 lets us query whether a tile data transfer
                        \     is already in progress for this bitplane:
                        \
                        \     * 0 = we are not currently in the process of
                        \           sending tile data to the PPU for this
                        \           bitplane
                        \
                        \     * 1 = we are in the process of sending tile data
                        \           to the PPU for the this bitplane, possibly
                        \           spread across multiple VBlanks
                        \
                        \   * Bit 5 lets us query whether we have already sent
                        \     all the data to the PPU for this bitplane:
                        \
                        \     * 0 = we have not already sent all the data to the
                        \           PPU for this bitplane
                        \
                        \     * 1 = we have already sent all the data to the PPU
                        \           for this bitplane
                        \
                        \   * Bit 6 determines whether to send nametable data as
                        \     well as pattern data:
                        \
                        \     * 0 = only send pattern data for this bitplane,
                        \           and stop sending it if the other bitplane is
                        \           ready to be sent
                        \
                        \     * 1 = send both pattern and nametable data for
                        \           this bitplane
                        \
                        \   * Bit 7 determines whether we should send data to
                        \     the PPU for this bitplane:
                        \
                        \     * 0 = do not send data to the PPU
                        \
                        \     * 1 = send data to the PPU

 SKIP 1                 \ Flags for bitplane 1 (see above)

.nmiCounter

 SKIP 1                 \ A counter that increments every VBlank at the start of
                        \ the NMI handler

.screenReset

 SKIP 1                 \ Gets set to 245 when the screen is reset, but this
                        \ value is only read once (in SetupViewInNMI) and the
                        \ value is ignored, so this doesn't have any effect

INCLUDE "library/enhanced/main/variable/dtw6.asm"
INCLUDE "library/enhanced/main/variable/dtw2.asm"
INCLUDE "library/enhanced/main/variable/dtw3.asm"
INCLUDE "library/enhanced/main/variable/dtw4.asm"
INCLUDE "library/enhanced/main/variable/dtw5.asm"
INCLUDE "library/enhanced/main/variable/dtw1.asm"
INCLUDE "library/enhanced/main/variable/dtw8.asm"
INCLUDE "library/6502sp/main/variable/xp.asm"
INCLUDE "library/6502sp/main/variable/yp.asm"

.titleShip

 SKIP 0                 \ Used to store the current ship number in the title
                        \ screen

.firstBox

 SKIP 0                 \ Used to detect the first iteration of the box-drawing
                        \ loop when drawing the launch tunnel

.scrollProgress

 SKIP 1                 \ Keeps track of the progress of the demo scroll text,
                        \ starting from zero and increasing as the text scrolls
                        \ up the screen

.decimalPoint

 SKIP 1                 \ The decimal point character for the chosen language

 SKIP 2                 \ These bytes appear to be unused

INCLUDE "library/common/main/variable/las.asm"
INCLUDE "library/common/main/variable/mstg.asm"

.scrollTextSpeed

 SKIP 1                 \ Controls the speed of the scroll text in the demo

INCLUDE "library/common/main/variable/kl.asm"
INCLUDE "library/common/main/variable/ky1.asm"
INCLUDE "library/common/main/variable/ky2.asm"
INCLUDE "library/common/main/variable/ky3.asm"
INCLUDE "library/common/main/variable/ky4.asm"
INCLUDE "library/common/main/variable/ky5.asm"
INCLUDE "library/common/main/variable/ky6.asm"
INCLUDE "library/common/main/variable/ky7.asm"

.cloudSize

 SKIP 1                 \ Used to store the explosion cloud size in PTCLS

.soundByteSQ1

 SKIP 14                \ The 14 sound bytes for the sound effect being made
                        \ on channel SQ1

.soundLoSQ1

 SKIP 1                 \ The value that we are going to send to the APU via
                        \ SQ1_LO for the current sound effect

.soundHiSQ1

 SKIP 1                 \ The value that we are going to send to the APU via
                        \ SQ1_HI for the current sound effect

.soundPitCountSQ1

 SKIP 1                 \ Controls how often we send pitch data to the APU for
                        \ the sound effect on channel SQ1
                        \
                        \ Specifically, pitch data is sent every
                        \ soundPitCountSQ1 iterations

.soundPitchEnvSQ1

 SKIP 1                 \ Controls how often we apply the pitch envelope to the
                        \ sound effect on channel SQ1
                        \
                        \ Specifically, we apply the changes in the pitch
                        \ envelope every soundPitchEnvSQ1 iterations

.soundVolIndexSQ1

 SKIP 1                 \ The index into the volume envelope data of the next
                        \ volume byte to apply to the sound effect on channel
                        \ SQ1

.soundVolCountSQ1

 SKIP 1                 \ Controls how often we apply the volume envelope to the
                        \ sound effect on channel SQ1
                        \
                        \ Specifically, one entry from the volume envelope is
                        \ applied every soundVolCountSQ1 iterations

.soundByteSQ2

 SKIP 14                \ The 14 sound bytes for the sound effect being made
                        \ on channel SQ2

.soundLoSQ2

 SKIP 1                 \ The value that we are going to send to the APU via
                        \ SQ2_LO for the current sound effect

.soundHiSQ2

 SKIP 1                 \ The value that we are going to send to the APU via
                        \ SQ2_HI for the current sound effect

.soundPitCountSQ2

 SKIP 1                 \ Controls how often we send pitch data to the APU for
                        \ the sound effect on channel SQ2
                        \
                        \ Specifically, pitch data is sent every
                        \ soundPitCountSQ2 iterations

.soundPitchEnvSQ2

 SKIP 1                 \ Controls how often we apply the pitch envelope to the
                        \ sound effect on channel SQ2
                        \
                        \ Specifically, we apply the changes in the pitch
                        \ envelope every soundPitchEnvSQ2 iterations

.soundVolIndexSQ2

 SKIP 1                 \ The index into the volume envelope data of the next
                        \ volume byte to apply to the sound effect on channel
                        \ SQ2

.soundVolCountSQ2

 SKIP 1                 \ Controls how often we apply the volume envelope to the
                        \ sound effect on channel SQ2
                        \
                        \ Specifically, one entry from the volume envelope is
                        \ applied every soundVolCountSQ2 iterations

.soundByteNOISE

 SKIP 14                \ The 14 sound bytes for the sound effect being made
                        \ on channel NOISE

.soundLoNOISE

 SKIP 1                 \ The value that we are going to send to the APU via
                        \ NOISE_LO for the current sound effect

.soundHiNOISE

 SKIP 1                 \ The value that we are going to send to the APU via
                        \ NOISE_HI for the current sound effect

.soundPitCountNOISE

 SKIP 1                 \ Controls how often we send pitch data to the APU for
                        \ the sound effect on channel NOISE
                        \
                        \ Specifically, pitch data is sent every
                        \ soundPitCountNOISE iterations

.soundPitchEnvNOISE

 SKIP 1                 \ Controls how often we apply the pitch envelope to the
                        \ sound effect on channel NOISE
                        \
                        \ Specifically, we apply the changes in the pitch
                        \ envelope every soundPitchEnvNOISE iterations

.soundVolIndexNOISE

 SKIP 1                 \ The index into the volume envelope data of the next
                        \ volume byte to apply to the sound effect on channel
                        \ NOISE

.soundVolCountNOISE

 SKIP 1                 \ Controls how often we apply the volume envelope to the
                        \ sound effect on channel NOISE
                        \
                        \ Specifically, one entry from the volume envelope is
                        \ applied every soundVolCountNOISE iterations

.soundVolumeSQ1

 SKIP 2                 \ The address of the volume envelope data for the sound
                        \ effect currently being made on channel SQ1

.soundVolumeSQ2

 SKIP 2                 \ The address of the volume envelope data for the sound
                        \ effect currently being made on channel SQ2

.soundVolumeNOISE

 SKIP 2                 \ The address of the volume envelope data for the sound
                        \ effect currently being made on channel NOISE

INCLUDE "library/common/main/variable/qq19.asm"

.selectedSystem

 SKIP 6                 \ The three 16-bit seeds for the selected system, i.e.
                        \ the one we most recently snapped the crosshairs to
                        \ in a chart view

INCLUDE "library/common/main/variable/k2.asm"

.demoInProgress

 SKIP 1                 \ A flag to determine whether we are playing the demo:
                        \
                        \   * 0 = we are not playing the demo
                        \
                        \   * Non-zero = we are initialising or playing the demo
                        \
                        \   * Bit 7 set = we are initialising the demo

.newTune

 SKIP 1                 \ The number of the new tune when choosing the
                        \ background music
                        \
                        \   * Bits 0-6 = the tune number (1-4)
                        \                0 indicates no tune is selected
                        \
                        \   * Bit 7 set = we are still in the process of
                        \                 changing to this tune

IF _PAL

.pointerTimerB

 SKIP 1                 \ A timer used in the PAL version to detect the B button
                        \ being pressed twice in quick succession (a double-tap)
                        \
                        \ The MoveIconBarPointer routine sets pointerTimerB to 1
                        \ and pointerTimer to 40 when it detects a tap on the B
                        \ button
                        \
                        \ In successive calls to MoveIconBarPointer, while
                        \ pointerTimerB is non-zero, the MoveIconBarPointer
                        \ routine keeps a look-out for a second tap of the B
                        \ button, and if it detects one, it's a double-tap
                        \
                        \ When the timer in pointerTimer runs down to zero,
                        \ pointerTimerB is also zeroed, so if a second tap is
                        \ detected within 40 VBlanks, it is deemed to be a
                        \ double-tap

ENDIF

.showIconBarPointer

 SKIP 1                 \ Controls whether to show the icon bar pointer
                        \
                        \   * 0 = do not show the icon bar pointer
                        \
                        \   * &FF = show the icon bar pointer

.xIconBarPointer

 SKIP 1                 \ The x-coordinate of the icon bar pointer
                        \
                        \ Each of the 12 buttons on the bar is positioned at an
                        \ interval of 4, so the buttons have x-coordinates of
                        \ of 0, 4, 8 and so on, up to 44 for the rightmost
                        \ button
                        \
                        \ This value is multiplied by 5 to get the button's
                        \ pixel coordinate

.yIconBarPointer

 SKIP 1                 \ The y-coordinate of the icon bar pointer
                        \
                        \ This is either 148 (when the dashboard is visible) or
                        \ 204 (when there is no dashboard and the icon bar is
                        \ along the bottom of the screen)

.xPointerDelta

 SKIP 1                 \ The direction in which the icon bar pointer is moving,
                        \ expressed as a delta to add to the x-coordinate of the
                        \ pointer sprites
                        \
                        \   * 0 = pointer is not moving
                        \
                        \   * 1 = pointer is moving to the right
                        \
                        \   * -1 = pointer is moving to the left

.pointerMoveCounter

 SKIP 1                 \ The position of the icon bar pointer as it moves
                        \ between icons, counting down from 12 (at the start of
                        \ the move) to 0 (at the end of the move)

.iconBarType

 SKIP 1                 \ The type of the current icon bar:
                        \
                        \   * 0 = Docked
                        \
                        \   * 1 = Flight
                        \
                        \   * 2 = Charts
                        \
                        \   * 3 = Pause
                        \
                        \   * 4 = Title screen copyright message
                        \
                        \   * &FF = Hide the icon bar on row 27

.iconBarChoice

 SKIP 1                 \ The number of the icon bar button that's just been
                        \ selected
                        \
                        \   * 0 means no button has been selected
                        \
                        \   * A button number from the iconBarButtons table
                        \     means that button has been selected by pressing
                        \     Select on that button (or the B button has been
                        \     tapped twice)
                        \
                        \   * 80 means the Start has been pressed to pause the
                        \     game
                        \
                        \ This variable is set in the NMI handler, so the
                        \ selection is recorded in the background

 SKIP 1                 \ This byte appears to be unused

.pointerTimer

 SKIP 1                 \ A timer that counts down by 1 on each call to the
                        \ MoveIconBarPointer routine, so that a double-tap
                        \ on the B button can be interpreted as such

.pointerPressedB

 SKIP 1                 \ Controls whether the MoveIconBarPointer routine looks
                        \ for a second tap of the B button when trying to detect
                        \ a double-tap on the B button
                        \
                        \   * 0 = do not look for a second tap
                        \
                        \   * Non-zero = do look for a second tap

.nmiStoreA

 SKIP 1                 \ Temporary storage for the A register during NMI

.nmiStoreX

 SKIP 1                 \ Temporary storage for the X register during NMI

.nmiStoreY

 SKIP 1                 \ Temporary storage for the Y register during NMI

.picturePattern

 SKIP 1                 \ The number of the first free pattern where commander
                        \ and system images can be stored in the buffers

.sendDashboardToPPU

 SKIP 1                 \ A flag that controls whether we send the dashboard to
                        \ the PPU during the main loop
                        \
                        \   * 0 = do not send the dashboard
                        \
                        \   * &FF = do send the dashboard
                        \
                        \ Flips between 0 or &FF after the screen has been drawn
                        \ in the main loop, but only if drawingBitplane = 0

.boxEdge1

 SKIP 1                 \ The tile number for drawing the left edge of a box
                        \
                        \   * 0 = no box, for use in the Game Over screen
                        \
                        \   * 1 = standard box, for use in all other screens

.boxEdge2

 SKIP 1                 \ The tile number for drawing the right edge of a box
                        \
                        \   * 0 = no box, for use in the Game Over screen
                        \
                        \   * 2 = standard box, for use in all other screens

.chartToShow

 SKIP 1                 \ Controls which chart is shown when choosing the chart
                        \ button on the icon bar (as the Long-range and
                        \ Short-range Charts share the same button)
                        \
                        \   * Bit 7 clear = show Short-range Chart
                        \
                        \   * Bit 7 clear = show Long-range Chart

.previousCondition

 SKIP 1                 \ Used to store the ship's previous status condition
                        \ (i.e. docked, green, yellow or red), so we can tell
                        \ how the situation is changing

.statusCondition

 SKIP 1                 \ Used to store the ship's current status condition
                        \ (i.e. docked, green, yellow or red)

.screenFadedToBlack

 SKIP 1                 \ Records whether the screen has been faded to black
                        \
                        \   * Bit 7 clear = screen is full colour
                        \
                        \   * Bit 7 set = screen has been faded to black

 SKIP 1                 \ This byte appears to be unused

.numberOfPilots

 SKIP 1                 \ A flag to determine whether the game is configured for
                        \ one or two pilots
                        \
                        \   * 0 = one pilot (using controller 1)
                        \
                        \   * 1 = two pilots (where controller 1 controls the
                        \         weaponry and controller 2 steers the ship)
                        \
                        \ This value is toggled between 0 and 1 by the "one or
                        \ two pilots" configuration icon in the pause menu

INCLUDE "library/common/main/variable/jstx.asm"
INCLUDE "library/common/main/variable/jsty.asm"

.channelPriority

 SKIP 3                 \ The priority of the sound on the current channel
                        \ (0 to 2)

INCLUDE "library/common/main/variable/lasx.asm"
INCLUDE "library/common/main/variable/lasy.asm"

 SKIP 1                 \ This byte appears to be unused

INCLUDE "library/common/main/variable/altit.asm"
INCLUDE "library/common/main/variable/swap.asm"
INCLUDE "library/master/main/variable/distaway.asm"
INCLUDE "library/common/main/variable/xsav2.asm"
INCLUDE "library/common/main/variable/ysav2.asm"

.inputNameSize

 SKIP 1                 \ The maximum size of the name to be fetched by the
                        \ InputName routine

INCLUDE "library/common/main/variable/fsh.asm"
INCLUDE "library/common/main/variable/ash.asm"
INCLUDE "library/common/main/variable/energy.asm"
INCLUDE "library/common/main/variable/qq24.asm"
INCLUDE "library/common/main/variable/qq25.asm"
INCLUDE "library/common/main/variable/qq28.asm"
INCLUDE "library/common/main/variable/qq29.asm"

.imageSentToPPU

 SKIP 1                 \ Records when images have been sent to the PPU or
                        \ unpacked into the buffers, so we don't repeat the
                        \ process unnecessarily
                        \
                        \   * 0 = dashboard image has been sent to the PPU
                        \
                        \   * 1 = font image has been sent to the PPU
                        \
                        \   * 2 = Cobra Mk III image has been sent to the PPU
                        \         for the Equip Ship screen
                        \
                        \   * 3 = the small Elite logo has been sent to the PPU
                        \         for the Save and Load screen
                        \
                        \   * 245 = the inventory icon image has been sent to
                        \           the PPU for the Market Price screen
                        \
                        \   * %1000xxxx = the headshot image has been sent to
                        \                 the PPU for the Status Mode screen,
                        \                 where %xxxx is the headshot number
                        \                 (0-13)
                        \
                        \   * %1100xxxx = the system background image has been
                        \                 unpacked into the buffers for the Data
                        \                 on System screen, where %xxxx is the
                        \                 system image number (0-14)

INCLUDE "library/common/main/variable/gov.asm"
INCLUDE "library/common/main/variable/tek.asm"
INCLUDE "library/common/main/variable/qq2.asm"
INCLUDE "library/common/main/variable/qq3.asm"
INCLUDE "library/common/main/variable/qq4.asm"
INCLUDE "library/common/main/variable/qq5.asm"
INCLUDE "library/common/main/variable/qq6.asm"
INCLUDE "library/common/main/variable/qq7.asm"
INCLUDE "library/common/main/variable/qq8.asm"
INCLUDE "library/common/main/variable/qq9.asm"
INCLUDE "library/common/main/variable/qq10.asm"

.systemNumber

 SKIP 1                 \ The current system number, as calculated in TT111 when
                        \ finding the nearest system in the galaxy

 SKIP 1                 \ This byte appears to be unused

.systemsOnChart

 SKIP 1                 \ A counter for the number of systems drawn on the
                        \ Short-range Chart, so it gets limited to 24 systems

.spasto

 SKIP 2                 \ Contains the address of the ship blueprint of the
                        \ space station (which can be a Coriolis or Dodo)

.QQ18Lo

 SKIP 1                 \ Gets set to the low byte of the address of the text
                        \ token table used by the ex routine (QQ18)

.QQ18Hi

 SKIP 1                 \ Gets set to the high byte of the address of the text
                        \ token table used by the ex routine (QQ18)

.TKN1Lo

 SKIP 1                 \ Gets set to the low byte of the address of the text
                        \ token table used by the DETOK routine (TKN1)

.TKN1Hi

 SKIP 1                 \ Gets set to the high byte of the address of the text
                        \ token table used by the DETOK routine (TKN1)

.languageIndex

 SKIP 1                 \ The language that was chosen on the Start screen as an
                        \ index into the various lookup tables:
                        \
                        \   * 0 = English
                        \
                        \   * 1 = German
                        \
                        \   * 2 = French

.languageNumber

 SKIP 1                 \ The language that was chosen on the Start screen as a
                        \ number:
                        \
                        \   * 1 = Bit 0 set = English
                        \
                        \   * 2 = Bit 1 set = German
                        \
                        \   * 4 = Bit 2 set = French

.controller1Down

 SKIP 1                 \ A shift register for recording presses of the down
                        \ button on controller 1
                        \
                        \ The controller is scanned every NMI and the result is
                        \ right-shifted into bit 7, with a 1 indicating a button
                        \ press and a 0 indicating no button press

.controller2Down

 SKIP 1                 \ A shift register for recording presses of the down
                        \ button on controller 2
                        \
                        \ The controller is scanned every NMI and the result is
                        \ right-shifted into bit 7, with a 1 indicating a button
                        \ press and a 0 indicating no button press

.controller1Up

 SKIP 1                 \ A shift register for recording presses of the up
                        \ button on controller 1
                        \
                        \ The controller is scanned every NMI and the result is
                        \ right-shifted into bit 7, with a 1 indicating a button
                        \ press and a 0 indicating no button press

.controller2Up

 SKIP 1                 \ A shift register for recording presses of the up
                        \ button on controller 2
                        \
                        \ The controller is scanned every NMI and the result is
                        \ right-shifted into bit 7, with a 1 indicating a button
                        \ press and a 0 indicating no button press

.controller1Left

 SKIP 1                 \ A shift register for recording presses of the left
                        \ button on controller 1
                        \
                        \ The controller is scanned every NMI and the result is
                        \ right-shifted into bit 7, with a 1 indicating a button
                        \ press and a 0 indicating no button press

.controller2Left

 SKIP 1                 \ A shift register for recording presses of the left
                        \ button on controller 2
                        \
                        \ The controller is scanned every NMI and the result is
                        \ right-shifted into bit 7, with a 1 indicating a button
                        \ press and a 0 indicating no button press

.controller1Right

 SKIP 1                 \ A shift register for recording presses of the right
                        \ button on controller 1
                        \
                        \ The controller is scanned every NMI and the result is
                        \ right-shifted into bit 7, with a 1 indicating a button
                        \ press and a 0 indicating no button press

.controller2Right

 SKIP 1                 \ A shift register for recording presses of the right
                        \ button on controller 2
                        \
                        \ The controller is scanned every NMI and the result is
                        \ right-shifted into bit 7, with a 1 indicating a button
                        \ press and a 0 indicating no button press

.controller1A

 SKIP 1                 \ A shift register for recording presses of the A button
                        \ on controller 1
                        \
                        \ The controller is scanned every NMI and the result is
                        \ right-shifted into bit 7, with a 1 indicating a button
                        \ press and a 0 indicating no button press

.controller2A

 SKIP 1                 \ A shift register for recording presses of the A button
                        \ on controller 2
                        \
                        \ The controller is scanned every NMI and the result is
                        \ right-shifted into bit 7, with a 1 indicating a button
                        \ press and a 0 indicating no button press

.controller1B

 SKIP 1                 \ A shift register for recording presses of the B button
                        \ on controller 1
                        \
                        \ The controller is scanned every NMI and the result is
                        \ right-shifted into bit 7, with a 1 indicating a button
                        \ press and a 0 indicating no button press

.controller2B

 SKIP 1                 \ A shift register for recording presses of the B button
                        \ on controller 2
                        \
                        \ The controller is scanned every NMI and the result is
                        \ right-shifted into bit 7, with a 1 indicating a button
                        \ press and a 0 indicating no button press

.controller1Start

 SKIP 1                 \ A shift register for recording presses of the Start
                        \ button on controller 1
                        \
                        \ The controller is scanned every NMI and the result is
                        \ right-shifted into bit 7, with a 1 indicating a button
                        \ press and a 0 indicating no button press

.controller2Start

 SKIP 1                 \ A shift register for recording presses of the Start
                        \ button on controller 2
                        \
                        \ The controller is scanned every NMI and the result is
                        \ right-shifted into bit 7, with a 1 indicating a button
                        \ press and a 0 indicating no button press

.controller1Select

 SKIP 1                 \ A shift register for recording presses of the Select
                        \ button on controller 1
                        \
                        \ The controller is scanned every NMI and the result is
                        \ right-shifted into bit 7, with a 1 indicating a button
                        \ press and a 0 indicating no button press

.controller2Select

 SKIP 1                 \ A shift register for recording presses of the Select
                        \ button on controller 2
                        \
                        \ The controller is scanned every NMI and the result is
                        \ right-shifted into bit 7, with a 1 indicating a button
                        \ press and a 0 indicating no button press

.controller1Left03

 SKIP 1                 \ Bits 0 to 3 of the left button controller variable
                        \
                        \ In non-space views, this contains controller1Left but
                        \ shifted left by four places, so the high nibble
                        \ contains bits 0 to 3 of controller1Left, with zeroes
                        \ in the low nibble
                        \
                        \ So bit 7 is the left button state from four VBlanks
                        \ ago, bit 6 is from five VBlanks ago, and so on

.controller1Right03

 SKIP 1                 \ Bits 0 to 3 of the right button controller variable
                        \
                        \ In non-space views, this contains controller1Right but
                        \ shifted left by four places, so the high nibble
                        \ contains bits 0 to 3 of controller1Right, with zeroes
                        \ in the low nibble
                        \
                        \ So bit 7 is the right button state from four VBlanks
                        \ ago, bit 6 is from five VBlanks ago, and so on

.autoPlayKey

 SKIP 1                 \ Stores the buttons to be automatically pressed during
                        \ auto-play
                        \
                        \ The bits are as follows:
                        \
                        \   * Bit 0 = right button
                        \   * Bit 1 = left button
                        \   * Bit 2 = down button
                        \   * Bit 3 = up button
                        \   * Bit 4 = Select button
                        \   * Bit 5 = B button
                        \   * Bit 6 = A button
                        \
                        \ Bit 7 is always clear

.autoPlayRepeat

 SKIP 1                 \ Stores the number of times a step should be repeated
                        \ during auto-play

.patternBufferHi

 SKIP 1                 \ (patternBufferHi patternBufferLo) contains the address
                        \ of the pattern buffer for the pattern we are sending
                        \ to the PPU from bitplane 0 (i.e. for pattern number
                        \ sendingPattern in bitplane 0)
                        \
                        \ This variable is saved by the NMI handler so the
                        \ buffers can be cleared across multiple VBlanks

 SKIP 1                 \ (patternBufferHi patternBufferLo) contains the address
                        \ of the pattern buffer for the pattern we are sending
                        \ to the PPU from bitplane 1 (i.e. for pattern number
                        \ sendingPattern in bitplane 1)
                        \
                        \ This variable is saved by the NMI handler so the
                        \ buffers can be cleared across multiple VBlanks

.nameTileBuffHi

 SKIP 1                 \ (nameTileBuffHi nameTileBuffLo) contains the address
                        \ of the nametable buffer for the tile we are sending to
                        \ the PPU from bitplane 0 (i.e. for tile number
                        \ sendingNameTile in bitplane 0)
                        \
                        \ This variable is saved by the NMI handler so the
                        \ buffers can be cleared across multiple VBlanks

 SKIP 1                 \ (nameTileBuffHi nameTileBuffLo) contains the address
                        \ of the nametable buffer for the tile we are sending to
                        \ the PPU from bitplane 1 (i.e. for tile number
                        \ sendingNameTile in bitplane 1)
                        \
                        \ This variable is saved by the NMI handler so the
                        \ buffers can be cleared across multiple VBlanks

 SKIP 4                 \ These bytes appear to be unused

.ppuToBuffNameHi

 SKIP 1                 \ A high byte that we can add to an address in nametable
                        \ buffer 0 to get the corresponding address in the PPU
                        \ nametable

 SKIP 1                 \ A high byte that we can add to an address in nametable
                        \ buffer 1 to get the corresponding address in the PPU
                        \ nametable

INCLUDE "library/common/main/variable/sx.asm"
INCLUDE "library/common/main/variable/sy.asm"
INCLUDE "library/common/main/variable/sz.asm"
INCLUDE "library/advanced/main/variable/buf.asm"
INCLUDE "library/master/main/variable/hangflag.asm"
INCLUDE "library/common/main/variable/many.asm"
INCLUDE "library/common/main/variable/sspr.asm"

.messageLength

 SKIP 1                 \ The length of the message stored in the message buffer

.messageBuffer

 SKIP 32                \ A buffer for the in-flight message text

INCLUDE "library/common/main/variable/sxl.asm"
INCLUDE "library/common/main/variable/syl.asm"
INCLUDE "library/common/main/variable/szl.asm"
INCLUDE "library/advanced/main/variable/safehouse.asm"

.sunWidth0

 SKIP 1                 \ The half-width of the sun on pixel row 0 in the tile
                        \ row that is currently being drawn

.sunWidth1

 SKIP 1                 \ The half-width of the sun on pixel row 1 in the tile
                        \ row that is currently being drawn

.sunWidth2

 SKIP 1                 \ The half-width of the sun on pixel row 2 in the tile
                        \ row that is currently being drawn

.sunWidth3

 SKIP 1                 \ The half-width of the sun on pixel row 3 in the tile
                        \ row that is currently being drawn

.sunWidth4

 SKIP 1                 \ The half-width of the sun on pixel row 4 in the tile
                        \ row that is currently being drawn

.sunWidth5

 SKIP 1                 \ The half-width of the sun on pixel row 5 in the tile
                        \ row that is currently being drawn

.sunWidth6

 SKIP 1                 \ The half-width of the sun on pixel row 6 in the tile
                        \ row that is currently being drawn

.sunWidth7

 SKIP 1                 \ The half-width of the sun on pixel row 7 in the tile
                        \ row that is currently being drawn

.shipIsAggressive

 SKIP 1                 \ A flag to record just how aggressive the current ship
                        \ is in the TACTICS routine
                        \
                        \ Bit 7 set indicates the ship in tactics is looking
                        \ for a fight

 CLEAR BUF+32, P%       \ The following tables share space with BUF through to
 ORG BUF+32             \ K%, which we can do as the scroll text is not shown
                        \ at the same time as ships, stardust and so on

INCLUDE "library/6502sp/main/variable/x1tb.asm"
INCLUDE "library/6502sp/main/variable/y1tb.asm"
INCLUDE "library/6502sp/main/variable/x2tb.asm"

ENDIF

 PRINT "WP workspace from  ", ~WP," to ", ~P%

