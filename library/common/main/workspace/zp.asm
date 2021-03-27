\ ******************************************************************************
\
\       Name: ZP
\       Type: Workspace
\    Address: &0000 to &00B0
\   Category: Workspaces
\    Summary: Lots of important variables are stored in the zero page workspace
\             as it is quicker and more space-efficient to access memory here
\
\ ******************************************************************************

ORG &0000

.ZP

 SKIP 0                 \ The start of the zero page workspace

IF _MASTER_VERSION \ Platform

 SKIP 2                 \ These bytes appear to be unused

ENDIF

INCLUDE "library/common/main/variable/rand.asm"

IF _CASSETTE_VERSION OR _DISC_VERSION \ Platform

INCLUDE "library/original/main/variable/trtb_per_cent.asm"

ENDIF

INCLUDE "library/common/main/variable/t1.asm"

IF _MASTER_VERSION \ Platform

 SKIP 3                 \ These bytes appear to be unused

ENDIF

INCLUDE "library/common/main/variable/sc.asm"
INCLUDE "library/common/main/variable/sch.asm"

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Platform

INCLUDE "library/common/main/variable/xx16.asm"
INCLUDE "library/common/main/variable/p.asm"

ELIF _MASTER_VERSION

INCLUDE "library/common/main/variable/p.asm"

 SKIP 1                 \ This byte appears to be unused

INCLUDE "library/common/main/variable/xc.asm"
INCLUDE "library/common/main/variable/col.asm"
INCLUDE "library/common/main/variable/yc.asm"
INCLUDE "library/common/main/variable/qq17.asm"
INCLUDE "library/common/main/variable/k3.asm"
INCLUDE "library/common/main/variable/xx2.asm"
INCLUDE "library/common/main/variable/k4.asm"
INCLUDE "library/common/main/variable/xx16.asm"

ENDIF

IF _6502SP_VERSION \ Platform

INCLUDE "library/6502sp/main/variable/needkey.asm"

ENDIF

INCLUDE "library/common/main/variable/xx0.asm"
INCLUDE "library/common/main/variable/inf.asm"
INCLUDE "library/common/main/variable/v.asm"
INCLUDE "library/common/main/variable/xx.asm"
INCLUDE "library/common/main/variable/yy.asm"
INCLUDE "library/common/main/variable/sunx.asm"
INCLUDE "library/common/main/variable/beta.asm"
INCLUDE "library/common/main/variable/bet1.asm"

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Platform

INCLUDE "library/common/main/variable/xc.asm"
INCLUDE "library/common/main/variable/yc.asm"

ENDIF

INCLUDE "library/common/main/variable/qq22.asm"
INCLUDE "library/common/main/variable/ecma.asm"

IF _6502SP_VERSION OR _DISC_VERSION OR _MASTER_VERSION \ Platform

INCLUDE "library/common/main/variable/alp1.asm"
INCLUDE "library/common/main/variable/alp2.asm"

ENDIF

INCLUDE "library/common/main/variable/xx15.asm"
INCLUDE "library/common/main/variable/x1.asm"
INCLUDE "library/common/main/variable/y1.asm"
INCLUDE "library/common/main/variable/x2.asm"
INCLUDE "library/common/main/variable/y2.asm"

 SKIP 2                 \ The last two bytes of the XX15 block

INCLUDE "library/common/main/variable/xx12.asm"
INCLUDE "library/common/main/variable/k.asm"

IF _CASSETTE_VERSION \ Platform

INCLUDE "library/common/main/variable/kl.asm"
INCLUDE "library/common/main/variable/ky1.asm"
INCLUDE "library/common/main/variable/ky2.asm"
INCLUDE "library/common/main/variable/ky3.asm"
INCLUDE "library/common/main/variable/ky4.asm"
INCLUDE "library/common/main/variable/ky5.asm"
INCLUDE "library/common/main/variable/ky6.asm"
INCLUDE "library/common/main/variable/ky7.asm"
INCLUDE "library/common/main/variable/ky12.asm"
INCLUDE "library/common/main/variable/ky13.asm"
INCLUDE "library/common/main/variable/ky14.asm"
INCLUDE "library/common/main/variable/ky15.asm"
INCLUDE "library/common/main/variable/ky16.asm"
INCLUDE "library/common/main/variable/ky17.asm"
INCLUDE "library/common/main/variable/ky18.asm"
INCLUDE "library/common/main/variable/ky19.asm"

ENDIF

INCLUDE "library/common/main/variable/las.asm"
INCLUDE "library/common/main/variable/mstg.asm"

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Platform

INCLUDE "library/common/main/variable/xx1.asm"
INCLUDE "library/common/main/variable/inwk.asm"
INCLUDE "library/common/main/variable/xx19.asm"

ENDIF

IF _6502SP_VERSION OR _DISC_VERSION \ Platform

INCLUDE "library/enhanced/main/variable/newb.asm"

ENDIF

IF _MASTER_VERSION \ Platform

INCLUDE "library/common/main/variable/dl.asm"

ENDIF

INCLUDE "library/common/main/variable/lsp.asm"
INCLUDE "library/common/main/variable/qq15.asm"
INCLUDE "library/common/main/variable/k5.asm"
INCLUDE "library/common/main/variable/xx18.asm"

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Platform

INCLUDE "library/common/main/variable/qq17.asm"
INCLUDE "library/common/main/variable/qq19.asm"
INCLUDE "library/common/main/variable/k6.asm"

ENDIF

IF _CASSETTE_VERSION \ Platform

INCLUDE "library/common/main/variable/alp1.asm"
INCLUDE "library/common/main/variable/alp2.asm"

ENDIF

IF _MASTER_VERSION \ Platform

INCLUDE "library/common/main/variable/k6.asm"
INCLUDE "library/common/main/variable/qq19.asm"

ENDIF

INCLUDE "library/common/main/variable/bet2.asm"
INCLUDE "library/common/main/variable/delta.asm"
INCLUDE "library/common/main/variable/delt4.asm"
INCLUDE "library/common/main/variable/u.asm"
INCLUDE "library/common/main/variable/q.asm"
INCLUDE "library/common/main/variable/r.asm"
INCLUDE "library/common/main/variable/s.asm"

IF _MASTER_VERSION \ Platform

INCLUDE "library/common/main/variable/t.asm"

ENDIF

INCLUDE "library/common/main/variable/xsav.asm"
INCLUDE "library/common/main/variable/ysav.asm"
INCLUDE "library/common/main/variable/xx17.asm"

IF _MASTER_VERSION \ Platform

INCLUDE "library/master/main/variable/w.asm"

ENDIF

INCLUDE "library/common/main/variable/qq11.asm"
INCLUDE "library/common/main/variable/zz.asm"
INCLUDE "library/common/main/variable/xx13.asm"
INCLUDE "library/common/main/variable/mcnt.asm"

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Platform

INCLUDE "library/common/main/variable/dl.asm"

ENDIF

INCLUDE "library/common/main/variable/type.asm"

IF _CASSETTE_VERSION \ Platform

INCLUDE "library/common/main/variable/jstx.asm"
INCLUDE "library/common/main/variable/jsty.asm"

ENDIF

INCLUDE "library/common/main/variable/alpha.asm"

IF _6502SP_VERSION \ Platform

INCLUDE "library/6502sp/main/variable/pbup.asm"
INCLUDE "library/6502sp/main/variable/hbup.asm"
INCLUDE "library/6502sp/main/variable/lbup.asm"

ENDIF

INCLUDE "library/common/main/variable/qq12.asm"
INCLUDE "library/common/main/variable/tgt.asm"

IF _CASSETTE_VERSION OR _DISC_VERSION \ Platform

INCLUDE "library/common/main/variable/swap.asm"

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Platform

INCLUDE "library/common/main/variable/col.asm"

ENDIF

INCLUDE "library/common/main/variable/flag.asm"
INCLUDE "library/common/main/variable/cnt.asm"
INCLUDE "library/common/main/variable/cnt2.asm"
INCLUDE "library/common/main/variable/stp.asm"
INCLUDE "library/common/main/variable/xx4.asm"
INCLUDE "library/common/main/variable/xx20.asm"
INCLUDE "library/common/main/variable/xx14.asm"
INCLUDE "library/common/main/variable/rat.asm"
INCLUDE "library/common/main/variable/rat2.asm"
INCLUDE "library/common/main/variable/k2.asm"

IF _6502SP_VERSION \ Platform

INCLUDE "library/advanced/main/variable/widget.asm"
INCLUDE "library/advanced/main/variable/safehouse.asm"
INCLUDE "library/advanced/main/variable/messxc.asm"

ELIF _MASTER_VERSION

INCLUDE "library/advanced/main/variable/widget.asm"
INCLUDE "library/master/main/variable/xmax.asm"
INCLUDE "library/master/main/variable/ymax.asm"
INCLUDE "library/advanced/main/variable/messxc.asm"
INCLUDE "library/master/main/variable/deltx.asm"
INCLUDE "library/common/main/variable/xx1.asm"
INCLUDE "library/common/main/variable/inwk.asm"
INCLUDE "library/common/main/variable/xx19.asm"
INCLUDE "library/enhanced/main/variable/newb.asm"
INCLUDE "library/common/main/variable/jstx.asm"
INCLUDE "library/common/main/variable/jsty.asm"
INCLUDE "library/common/main/variable/kl.asm"
INCLUDE "library/common/main/variable/ky17.asm"
INCLUDE "library/common/main/variable/ky14.asm"
INCLUDE "library/common/main/variable/ky15.asm"
INCLUDE "library/enhanced/main/variable/ky20.asm"
INCLUDE "library/common/main/variable/ky7.asm"
INCLUDE "library/common/main/variable/ky5.asm"
INCLUDE "library/common/main/variable/ky18.asm"
INCLUDE "library/common/main/variable/ky6.asm"
INCLUDE "library/common/main/variable/ky19.asm"
INCLUDE "library/common/main/variable/ky12.asm"
INCLUDE "library/common/main/variable/ky2.asm"
INCLUDE "library/common/main/variable/ky16.asm"
INCLUDE "library/common/main/variable/ky3.asm"
INCLUDE "library/common/main/variable/ky4.asm"
INCLUDE "library/common/main/variable/ky1.asm"
INCLUDE "library/common/main/variable/ky13.asm"
INCLUDE "library/common/main/variable/lsx.asm"
INCLUDE "library/common/main/variable/fsh.asm"
INCLUDE "library/common/main/variable/ash.asm"
INCLUDE "library/common/main/variable/energy.asm"
INCLUDE "library/common/main/variable/qq3.asm"
INCLUDE "library/common/main/variable/qq4.asm"
INCLUDE "library/common/main/variable/qq5.asm"
INCLUDE "library/common/main/variable/qq6.asm"
INCLUDE "library/common/main/variable/qq7.asm"
INCLUDE "library/common/main/variable/qq8.asm"
INCLUDE "library/common/main/variable/qq9.asm"
INCLUDE "library/common/main/variable/qq10.asm"
INCLUDE "library/common/main/variable/nostm.asm"

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION

ORG &00D1

INCLUDE "library/common/main/variable/t.asm"
INCLUDE "library/common/main/variable/k3.asm"
INCLUDE "library/common/main/variable/xx2.asm"
INCLUDE "library/common/main/variable/k4.asm"

ENDIF

PRINT "Zero page variables from ", ~ZP, " to ", ~P%

