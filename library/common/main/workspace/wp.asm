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
\    Address: &0E00 to &0FD2
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
ELIF _C64_VERSION
\    Address: &0580 to &6FB
\   Category: Workspaces
\    Summary: Variables
ELIF _APPLE_VERSION
\    Address: &0400 to &0715
\   Category: Workspaces
\    Summary: Variables
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

ELIF _C64_VERSION

 ORG &0580

ELIF _APPLE_VERSION

 ORG &0400

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
INCLUDE "library/master/main/variable/xp.asm"
INCLUDE "library/master/main/variable/yp.asm"
INCLUDE "library/master/main/variable/ys.asm"
INCLUDE "library/master/main/variable/bali.asm"
INCLUDE "library/master/main/variable/upo.asm"
INCLUDE "library/master/main/variable/boxsize.asm"
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

ELIF _C64_VERSION

INCLUDE "library/common/main/variable/lsx.asm"
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
INCLUDE "library/master/main/variable/xp.asm"
INCLUDE "library/master/main/variable/yp.asm"
INCLUDE "library/master/main/variable/ys.asm"
INCLUDE "library/master/main/variable/bali.asm"
INCLUDE "library/master/main/variable/upo.asm"
INCLUDE "library/master/main/variable/boxsize.asm"
INCLUDE "library/master/main/variable/distaway.asm"

ELIF _APPLE_VERSION

INCLUDE "library/common/main/variable/lsx2.asm"
INCLUDE "library/common/main/variable/lsy2.asm"
INCLUDE "library/common/main/variable/lso.asm"
INCLUDE "library/common/main/variable/sx.asm"
INCLUDE "library/common/main/variable/sxl.asm"
INCLUDE "library/common/main/variable/sy.asm"
INCLUDE "library/common/main/variable/syl.asm"
INCLUDE "library/common/main/variable/sz.asm"
INCLUDE "library/common/main/variable/szl.asm"

ELIF _NES_VERSION

INCLUDE "library/nes/main/variable/allowinsystemjump.asm"
INCLUDE "library/nes/main/variable/enablesound.asm"
INCLUDE "library/nes/main/variable/effectonsq1.asm"
INCLUDE "library/nes/main/variable/effectonsq2.asm"
INCLUDE "library/nes/main/variable/effectonnoise.asm"
INCLUDE "library/nes/main/variable/tunespeed.asm"
INCLUDE "library/nes/main/variable/tunespeedcopy.asm"
INCLUDE "library/nes/main/variable/soundvibrato.asm"
INCLUDE "library/nes/main/variable/tuneprogress.asm"
INCLUDE "library/nes/main/variable/tuningall.asm"
INCLUDE "library/nes/main/variable/playmusic.asm"
INCLUDE "library/nes/main/variable/sectiondatasq1.asm"
INCLUDE "library/nes/main/variable/sectionlistsq1.asm"
INCLUDE "library/nes/main/variable/nextsectionsq1.asm"
INCLUDE "library/nes/main/variable/tuningsq1.asm"
INCLUDE "library/nes/main/variable/startpausesq1.asm"
INCLUDE "library/nes/main/variable/pausecountsq1.asm"
INCLUDE "library/nes/main/variable/dutyloopenvsq1.asm"
INCLUDE "library/nes/main/variable/sq1sweep.asm"
INCLUDE "library/nes/main/variable/pitchindexsq1.asm"
INCLUDE "library/nes/main/variable/pitchenvelopesq1.asm"
INCLUDE "library/nes/main/variable/sq1locopy.asm"
INCLUDE "library/nes/main/variable/volumeindexsq1.asm"
INCLUDE "library/nes/main/variable/volumerepeatsq1.asm"
INCLUDE "library/nes/main/variable/volumecountersq1.asm"
INCLUDE "library/nes/main/variable/volumeenvelopesq1.asm"
INCLUDE "library/nes/main/variable/applyvolumesq1.asm"
INCLUDE "library/nes/main/variable/sectiondatasq2.asm"
INCLUDE "library/nes/main/variable/sectionlistsq2.asm"
INCLUDE "library/nes/main/variable/nextsectionsq2.asm"
INCLUDE "library/nes/main/variable/tuningsq2.asm"
INCLUDE "library/nes/main/variable/startpausesq2.asm"
INCLUDE "library/nes/main/variable/pausecountsq2.asm"
INCLUDE "library/nes/main/variable/dutyloopenvsq2.asm"
INCLUDE "library/nes/main/variable/sq2sweep.asm"
INCLUDE "library/nes/main/variable/pitchindexsq2.asm"
INCLUDE "library/nes/main/variable/pitchenvelopesq2.asm"
INCLUDE "library/nes/main/variable/sq2locopy.asm"
INCLUDE "library/nes/main/variable/volumeindexsq2.asm"
INCLUDE "library/nes/main/variable/volumerepeatsq2.asm"
INCLUDE "library/nes/main/variable/volumecountersq2.asm"
INCLUDE "library/nes/main/variable/volumeenvelopesq2.asm"
INCLUDE "library/nes/main/variable/applyvolumesq2.asm"
INCLUDE "library/nes/main/variable/sectiondatatri.asm"
INCLUDE "library/nes/main/variable/sectionlisttri.asm"
INCLUDE "library/nes/main/variable/nextsectiontri.asm"
INCLUDE "library/nes/main/variable/tuningtri.asm"
INCLUDE "library/nes/main/variable/startpausetri.asm"
INCLUDE "library/nes/main/variable/pausecounttri.asm"

 SKIP 2                 \ These bytes appear to be unused

INCLUDE "library/nes/main/variable/pitchindextri.asm"
INCLUDE "library/nes/main/variable/pitchenvelopetri.asm"
INCLUDE "library/nes/main/variable/trilocopy.asm"
INCLUDE "library/nes/main/variable/volumecountertri.asm"

 SKIP 2                 \ These bytes appear to be unused

INCLUDE "library/nes/main/variable/volumeenvelopetri.asm"

 SKIP 1                 \ This byte appears to be unused

INCLUDE "library/nes/main/variable/sectiondatanoise.asm"
INCLUDE "library/nes/main/variable/sectionlistnoise.asm"
INCLUDE "library/nes/main/variable/nextsectionnoise.asm"

 SKIP 1                 \ This byte appears to be unused

INCLUDE "library/nes/main/variable/startpausenoise.asm"
INCLUDE "library/nes/main/variable/pausecountnoise.asm"

 SKIP 2                 \ These bytes appear to be unused

INCLUDE "library/nes/main/variable/pitchindexnoise.asm"
INCLUDE "library/nes/main/variable/pitchenvelopenoise.asm"
INCLUDE "library/nes/main/variable/noiselocopy.asm"
INCLUDE "library/nes/main/variable/volumeindexnoise.asm"
INCLUDE "library/nes/main/variable/volumerepeatnoise.asm"
INCLUDE "library/nes/main/variable/volumecounternoise.asm"
INCLUDE "library/nes/main/variable/volumeenvelopenoise.asm"
INCLUDE "library/nes/main/variable/applyvolumenoise.asm"

INCLUDE "library/nes/main/variable/sq1volume.asm"

 SKIP 1                 \ This byte appears to be unused

INCLUDE "library/nes/main/variable/sq1lo.asm"
INCLUDE "library/nes/main/variable/sq1hi.asm"
INCLUDE "library/nes/main/variable/sq2volume.asm"

 SKIP 1                 \ This byte appears to be unused

INCLUDE "library/nes/main/variable/sq2lo.asm"
INCLUDE "library/nes/main/variable/sq2hi.asm"

 SKIP 2                 \ These bytes appear to be unused

INCLUDE "library/nes/main/variable/trilo.asm"
INCLUDE "library/nes/main/variable/trihi.asm"
INCLUDE "library/nes/main/variable/noisevolume.asm"

 SKIP 1                 \ This byte appears to be unused

INCLUDE "library/nes/main/variable/noiselo.asm"

 SKIP 1                 \ This byte appears to be unused

INCLUDE "library/common/main/variable/frin.asm"
INCLUDE "library/enhanced/main/variable/junk.asm"
INCLUDE "library/nes/main/variable/scannernumber.asm"
INCLUDE "library/nes/main/variable/scannercolour.asm"
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
INCLUDE "library/nes/main/variable/selectedsystemflag.asm"
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
INCLUDE "library/nes/main/variable/burstspriteindex.asm"
INCLUDE "library/nes/main/variable/unusedvariable.asm"
INCLUDE "library/nes/main/variable/chargedockingfee.asm"
INCLUDE "library/nes/main/variable/pricedebug.asm"
INCLUDE "library/common/main/variable/damp.asm"
INCLUDE "library/common/main/variable/jstgy.asm"
INCLUDE "library/common/main/variable/dnoiz.asm"
INCLUDE "library/nes/main/variable/disablemusic.asm"
INCLUDE "library/nes/main/variable/autoplaydemo.asm"
INCLUDE "library/nes/main/variable/bitplaneflags.asm"
INCLUDE "library/nes/main/variable/nmicounter.asm"
INCLUDE "library/nes/main/variable/screenreset.asm"
INCLUDE "library/enhanced/main/variable/dtw6.asm"
INCLUDE "library/enhanced/main/variable/dtw2.asm"
INCLUDE "library/enhanced/main/variable/dtw3.asm"
INCLUDE "library/enhanced/main/variable/dtw4.asm"
INCLUDE "library/enhanced/main/variable/dtw5.asm"
INCLUDE "library/enhanced/main/variable/dtw1.asm"
INCLUDE "library/enhanced/main/variable/dtw8.asm"
INCLUDE "library/6502sp/main/variable/xp.asm"
INCLUDE "library/6502sp/main/variable/yp.asm"
INCLUDE "library/nes/main/variable/titleship.asm"
INCLUDE "library/nes/main/variable/firstbox.asm"
INCLUDE "library/nes/main/variable/scrollprogress.asm"
INCLUDE "library/nes/main/variable/decimalpoint.asm"

 SKIP 2                 \ These bytes appear to be unused

INCLUDE "library/common/main/variable/las.asm"
INCLUDE "library/common/main/variable/mstg.asm"
INCLUDE "library/nes/main/variable/scrolltextspeed.asm"
INCLUDE "library/common/main/variable/kl.asm"
INCLUDE "library/common/main/variable/ky1.asm"
INCLUDE "library/common/main/variable/ky2.asm"
INCLUDE "library/common/main/variable/ky3.asm"
INCLUDE "library/common/main/variable/ky4.asm"
INCLUDE "library/common/main/variable/ky5.asm"
INCLUDE "library/common/main/variable/ky6.asm"
INCLUDE "library/common/main/variable/ky7.asm"
INCLUDE "library/nes/main/variable/cloudsize.asm"
INCLUDE "library/nes/main/variable/soundbytesq1.asm"
INCLUDE "library/nes/main/variable/soundlosq1.asm"
INCLUDE "library/nes/main/variable/soundhisq1.asm"
INCLUDE "library/nes/main/variable/soundpitcountsq1.asm"
INCLUDE "library/nes/main/variable/soundpitchenvsq1.asm"
INCLUDE "library/nes/main/variable/soundvolindexsq1.asm"
INCLUDE "library/nes/main/variable/soundvolcountsq1.asm"
INCLUDE "library/nes/main/variable/soundbytesq2.asm"
INCLUDE "library/nes/main/variable/soundlosq2.asm"
INCLUDE "library/nes/main/variable/soundhisq2.asm"
INCLUDE "library/nes/main/variable/soundpitcountsq2.asm"
INCLUDE "library/nes/main/variable/soundpitchenvsq2.asm"
INCLUDE "library/nes/main/variable/soundvolindexsq2.asm"
INCLUDE "library/nes/main/variable/soundvolcountsq2.asm"
INCLUDE "library/nes/main/variable/soundbytenoise.asm"
INCLUDE "library/nes/main/variable/soundlonoise.asm"
INCLUDE "library/nes/main/variable/soundhinoise.asm"
INCLUDE "library/nes/main/variable/soundpitcountnoise.asm"
INCLUDE "library/nes/main/variable/soundpitchenvnoise.asm"
INCLUDE "library/nes/main/variable/soundvolindexnoise.asm"
INCLUDE "library/nes/main/variable/soundvolcountnoise.asm"
INCLUDE "library/nes/main/variable/soundvolumesq1.asm"
INCLUDE "library/nes/main/variable/soundvolumesq2.asm"
INCLUDE "library/nes/main/variable/soundvolumenoise.asm"
INCLUDE "library/common/main/variable/qq19.asm"
INCLUDE "library/nes/main/variable/selectedsystem.asm"
INCLUDE "library/common/main/variable/k2.asm"
INCLUDE "library/nes/main/variable/demoinprogress.asm"
INCLUDE "library/nes/main/variable/newtune.asm"

IF _PAL

INCLUDE "library/nes/main/variable/pointertimerb.asm"

ENDIF

INCLUDE "library/nes/main/variable/showiconbarpointer.asm"
INCLUDE "library/nes/main/variable/xiconbarpointer.asm"
INCLUDE "library/nes/main/variable/yiconbarpointer.asm"
INCLUDE "library/nes/main/variable/xpointerdelta.asm"
INCLUDE "library/nes/main/variable/pointermovecounter.asm"
INCLUDE "library/nes/main/variable/iconbartype.asm"
INCLUDE "library/nes/main/variable/iconbarchoice.asm"

 SKIP 1                 \ This byte appears to be unused

INCLUDE "library/nes/main/variable/pointertimer.asm"
INCLUDE "library/nes/main/variable/pointerpressedb.asm"
INCLUDE "library/nes/main/variable/nmistorea.asm"
INCLUDE "library/nes/main/variable/nmistorex.asm"
INCLUDE "library/nes/main/variable/nmistorey.asm"
INCLUDE "library/nes/main/variable/picturepattern.asm"
INCLUDE "library/nes/main/variable/senddashboardtoppu.asm"
INCLUDE "library/nes/main/variable/boxedge1.asm"
INCLUDE "library/nes/main/variable/boxedge2.asm"
INCLUDE "library/nes/main/variable/charttoshow.asm"
INCLUDE "library/nes/main/variable/previouscondition.asm"
INCLUDE "library/nes/main/variable/statuscondition.asm"
INCLUDE "library/nes/main/variable/screenfadedtoblack.asm"

 SKIP 1                 \ This byte appears to be unused

INCLUDE "library/nes/main/variable/numberofpilots.asm"
INCLUDE "library/common/main/variable/jstx.asm"
INCLUDE "library/common/main/variable/jsty.asm"
INCLUDE "library/nes/main/variable/channelpriority.asm"
INCLUDE "library/common/main/variable/lasx.asm"
INCLUDE "library/common/main/variable/lasy.asm"

 SKIP 1                 \ This byte appears to be unused

INCLUDE "library/common/main/variable/altit.asm"
INCLUDE "library/common/main/variable/swap.asm"
INCLUDE "library/master/main/variable/distaway.asm"
INCLUDE "library/common/main/variable/xsav2.asm"
INCLUDE "library/common/main/variable/ysav2.asm"
INCLUDE "library/nes/main/variable/inputnamesize.asm"
INCLUDE "library/common/main/variable/fsh.asm"
INCLUDE "library/common/main/variable/ash.asm"
INCLUDE "library/common/main/variable/energy.asm"
INCLUDE "library/common/main/variable/qq24.asm"
INCLUDE "library/common/main/variable/qq25.asm"
INCLUDE "library/common/main/variable/qq28.asm"
INCLUDE "library/common/main/variable/qq29.asm"
INCLUDE "library/nes/main/variable/imagesenttoppu.asm"
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
INCLUDE "library/nes/main/variable/systemnumber.asm"

 SKIP 1                 \ This byte appears to be unused

INCLUDE "library/nes/main/variable/systemsonchart.asm"
INCLUDE "library/advanced/main/variable/spasto.asm"
INCLUDE "library/nes/main/variable/qq18lo.asm"
INCLUDE "library/nes/main/variable/qq18hi.asm"
INCLUDE "library/nes/main/variable/tkn1lo.asm"
INCLUDE "library/nes/main/variable/tkn1hi.asm"
INCLUDE "library/nes/main/variable/languageindex.asm"
INCLUDE "library/nes/main/variable/languagenumber.asm"
INCLUDE "library/nes/main/variable/controller1down.asm"
INCLUDE "library/nes/main/variable/controller2down.asm"
INCLUDE "library/nes/main/variable/controller1up.asm"
INCLUDE "library/nes/main/variable/controller2up.asm"
INCLUDE "library/nes/main/variable/controller1left.asm"
INCLUDE "library/nes/main/variable/controller2left.asm"
INCLUDE "library/nes/main/variable/controller1right.asm"
INCLUDE "library/nes/main/variable/controller2right.asm"
INCLUDE "library/nes/main/variable/controller1a.asm"
INCLUDE "library/nes/main/variable/controller2a.asm"
INCLUDE "library/nes/main/variable/controller1b.asm"
INCLUDE "library/nes/main/variable/controller2b.asm"
INCLUDE "library/nes/main/variable/controller1start.asm"
INCLUDE "library/nes/main/variable/controller2start.asm"
INCLUDE "library/nes/main/variable/controller1select.asm"
INCLUDE "library/nes/main/variable/controller2select.asm"
INCLUDE "library/nes/main/variable/controller1left03.asm"
INCLUDE "library/nes/main/variable/controller1right03.asm"
INCLUDE "library/nes/main/variable/autoplaykey.asm"
INCLUDE "library/nes/main/variable/autoplayrepeat.asm"
INCLUDE "library/nes/main/variable/patternbufferhi.asm"
INCLUDE "library/nes/main/variable/nametilebuffhi.asm"

 SKIP 4                 \ These bytes appear to be unused

INCLUDE "library/nes/main/variable/pputobuffnamehi.asm"
INCLUDE "library/common/main/variable/sx.asm"
INCLUDE "library/common/main/variable/sy.asm"
INCLUDE "library/common/main/variable/sz.asm"
INCLUDE "library/advanced/main/variable/buf.asm"
INCLUDE "library/master/main/variable/hangflag.asm"
INCLUDE "library/common/main/variable/many.asm"
INCLUDE "library/common/main/variable/sspr.asm"
INCLUDE "library/nes/main/variable/messagelength.asm"
INCLUDE "library/nes/main/variable/messagebuffer.asm"
INCLUDE "library/common/main/variable/sxl.asm"
INCLUDE "library/common/main/variable/syl.asm"
INCLUDE "library/common/main/variable/szl.asm"
INCLUDE "library/advanced/main/variable/safehouse.asm"
INCLUDE "library/nes/main/variable/sunwidth0.asm"
INCLUDE "library/nes/main/variable/sunwidth1.asm"
INCLUDE "library/nes/main/variable/sunwidth2.asm"
INCLUDE "library/nes/main/variable/sunwidth3.asm"
INCLUDE "library/nes/main/variable/sunwidth4.asm"
INCLUDE "library/nes/main/variable/sunwidth5.asm"
INCLUDE "library/nes/main/variable/sunwidth6.asm"
INCLUDE "library/nes/main/variable/sunwidth7.asm"
INCLUDE "library/nes/main/variable/shipisaggressive.asm"

 CLEAR BUF+32, P%       \ The following tables share space with BUF through to
 ORG BUF+32             \ K%, which we can do as the scroll text is not shown
                        \ at the same time as ships, stardust and so on

INCLUDE "library/6502sp/main/variable/x1tb.asm"
INCLUDE "library/6502sp/main/variable/y1tb.asm"
INCLUDE "library/6502sp/main/variable/x2tb.asm"

ENDIF

 PRINT "WP workspace from ", ~WP, "to ", ~P%-1, "inclusive"

