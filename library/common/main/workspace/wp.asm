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
ELIF _DISC_VERSION
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
ENDIF
\
\ ******************************************************************************

IF _CASSETTE_VERSION \ Platform

ORG &0D40

ELIF _ELECTRON_VERSION

ORG &0BE0

ELIF _DISC_VERSION

ORG &0E00

ELIF _6502SP_VERSION

ORG &0D00

ELIF _MASTER_VERSION

ORG &0E41

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

ELIF _DISC_VERSION

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

 SKIP 1                 \ This byte appears to be unused

INCLUDE "library/common/main/variable/altit.asm"
INCLUDE "library/common/main/variable/swap.asm"

 SKIP 6                 \ These bytes appear to be unused

INCLUDE "library/master/main/variable/sdist.asm"

 SKIP 2                 \ These bytes appear to be unused

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

INCLUDE "library/master/main/variable/trumble.asm"
INCLUDE "library/master/main/variable/tallyf.asm"
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
INCLUDE "library/master/main/variable/clcnt.asm"
INCLUDE "library/master/main/variable/adch1.asm"
INCLUDE "library/master/main/variable/adch2.asm"
INCLUDE "library/master/main/variable/adch3.asm"

ENDIF

PRINT "WP workspace from  ", ~WP," to ", ~P%

