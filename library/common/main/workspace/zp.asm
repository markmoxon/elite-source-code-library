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

INCLUDE "library/master/loader/variable/mos.asm"

ELIF _NES_VERSION

 SKIP 2                 \ These bytes appear to be unused

ENDIF

INCLUDE "library/common/main/variable/rand.asm"

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Platform

INCLUDE "library/original/main/variable/trtb_per_cent.asm"

ENDIF

INCLUDE "library/common/main/variable/t1.asm"

IF _MASTER_VERSION \ Platform

.T2

 SKIP 1                 \ This byte appears to be unused

.T3

 SKIP 1                 \ This byte appears to be unused

.T4

 SKIP 1                 \ This byte appears to be unused

ENDIF

INCLUDE "library/common/main/variable/sc.asm"
INCLUDE "library/common/main/variable/sch.asm"

IF _NES_VERSION

INCLUDE "library/common/main/variable/xx1.asm"
INCLUDE "library/common/main/variable/inwk.asm"

.L002A

 SKIP 1                 \ ???

.L002B

 SKIP 1                 \ ???

.L002C

 SKIP 1                 \ ???

INCLUDE "library/enhanced/main/variable/newb.asm"

.L002E

 SKIP 1                 \ ???

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

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

ELIF _NES_VERSION

INCLUDE "library/common/main/variable/p.asm"
INCLUDE "library/common/main/variable/xc.asm"

.L0033

 SKIP 1                 \ ???

.L0034

 SKIP 1                 \ ???

.L0035

 SKIP 1                 \ ???

.L0036

 SKIP 1                 \ ???

.L0037

 SKIP 1                 \ ???

.L0038

 SKIP 1                 \ ???

.L0039

 SKIP 1                 \ ???

.L003A

 SKIP 1                 \ ???

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

IF NOT(_NES_VERSION)

INCLUDE "library/common/main/variable/xx0.asm"
INCLUDE "library/common/main/variable/inf.asm"
INCLUDE "library/common/main/variable/v.asm"
INCLUDE "library/common/main/variable/xx.asm"
INCLUDE "library/common/main/variable/yy.asm"

ELIF _NES_VERSION

INCLUDE "library/common/main/variable/xx0.asm"

.XX19

 SKIP 0                 \ Instead of pointing XX19 to the ship heap address in
                        \ INWK(34 33), like the other versions of Elite, the NES
                        \ version points XX19 to the ship blueprint address in
                        \ INF(1 0)

INCLUDE "library/common/main/variable/inf.asm"
INCLUDE "library/common/main/variable/v.asm"
INCLUDE "library/common/main/variable/xx.asm"
INCLUDE "library/common/main/variable/yy.asm"

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Platform

INCLUDE "library/common/main/variable/sunx.asm"

ELIF _ELECTRON_VERSION

 SKIP 2                 \ These bytes are unused in this version of Elite (they
                        \ are used to store the centre axis of the sun in the
                        \ other versions)

ENDIF

INCLUDE "library/common/main/variable/beta.asm"
INCLUDE "library/common/main/variable/bet1.asm"

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

INCLUDE "library/common/main/variable/xc.asm"
INCLUDE "library/common/main/variable/yc.asm"

ENDIF

INCLUDE "library/common/main/variable/qq22.asm"
INCLUDE "library/common/main/variable/ecma.asm"

IF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Platform

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

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Platform

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

IF NOT(_NES_VERSION)

INCLUDE "library/common/main/variable/las.asm"
INCLUDE "library/common/main/variable/mstg.asm"

ELIF _NES_VERSION

.L0081

 SKIP 1                 \ ???

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

INCLUDE "library/common/main/variable/xx1.asm"
INCLUDE "library/common/main/variable/inwk.asm"
INCLUDE "library/common/main/variable/xx19.asm"

ENDIF

IF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Platform

INCLUDE "library/enhanced/main/variable/newb.asm"

ENDIF

IF _MASTER_VERSION \ Platform

INCLUDE "library/common/main/variable/dl.asm"

ENDIF

IF NOT(_NES_VERSION)

INCLUDE "library/common/main/variable/lsp.asm"
ENDIF

INCLUDE "library/common/main/variable/qq15.asm"
INCLUDE "library/common/main/variable/k5.asm"
INCLUDE "library/common/main/variable/xx18.asm"

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

INCLUDE "library/common/main/variable/qq17.asm"
INCLUDE "library/common/main/variable/qq19.asm"
INCLUDE "library/common/main/variable/k6.asm"

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Platform

INCLUDE "library/common/main/variable/alp1.asm"
INCLUDE "library/common/main/variable/alp2.asm"

ENDIF

IF _MASTER_VERSION \ Platform

INCLUDE "library/common/main/variable/k6.asm"
INCLUDE "library/common/main/variable/qq19.asm"

ELIF _NES_VERSION

INCLUDE "library/common/main/variable/k6.asm"

ENDIF

INCLUDE "library/common/main/variable/bet2.asm"
INCLUDE "library/common/main/variable/delta.asm"
INCLUDE "library/common/main/variable/delt4.asm"
INCLUDE "library/common/main/variable/u.asm"

IF _ELECTRON_VERSION \ Platform

 SKIP 16                \ These bytes appear to be unused

ENDIF

INCLUDE "library/common/main/variable/q.asm"
INCLUDE "library/common/main/variable/r.asm"
INCLUDE "library/common/main/variable/s.asm"

IF _MASTER_VERSION OR _NES_VERSION \ Platform

INCLUDE "library/common/main/variable/t.asm"

ENDIF

INCLUDE "library/common/main/variable/xsav.asm"
INCLUDE "library/common/main/variable/ysav.asm"
INCLUDE "library/common/main/variable/xx17.asm"

IF _MASTER_VERSION OR _NES_VERSION \ Platform

INCLUDE "library/master/main/variable/w.asm"

ENDIF

INCLUDE "library/common/main/variable/qq11.asm"
INCLUDE "library/common/main/variable/zz.asm"
INCLUDE "library/common/main/variable/xx13.asm"
INCLUDE "library/common/main/variable/mcnt.asm"

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

INCLUDE "library/common/main/variable/dl.asm"

ELIF _ELECTRON_VERSION

 SKIP 1                 \ This byte is unused in this version of Elite (it
                        \ is used to store the delay counter in the other
                        \ versions)

ENDIF

INCLUDE "library/common/main/variable/type.asm"

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Platform

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

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Platform

INCLUDE "library/common/main/variable/swap.asm"

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

INCLUDE "library/common/main/variable/col.asm"

ELIF _ELECTRON_VERSION

 SKIP 1                 \ This byte is unused in this version of Elite (it
                        \ is used to store colour information when drawing
                        \ pixels in the dashboard, and the Electron's dashboard
                        \ is monochrome)

ENDIF

INCLUDE "library/common/main/variable/flag.asm"
INCLUDE "library/common/main/variable/cnt.asm"
INCLUDE "library/common/main/variable/cnt2.asm"
INCLUDE "library/common/main/variable/stp.asm"
INCLUDE "library/common/main/variable/xx4.asm"
INCLUDE "library/common/main/variable/xx20.asm"

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _NES_VERSION \ Platform

INCLUDE "library/common/main/variable/xx14.asm"

ELIF _MASTER_VERSION

INCLUDE "library/master/main/variable/lsnum.asm"
INCLUDE "library/master/main/variable/lsnum2.asm"

ENDIF

INCLUDE "library/common/main/variable/rat.asm"
INCLUDE "library/common/main/variable/rat2.asm"
IF NOT(_NES_VERSION)

INCLUDE "library/common/main/variable/k2.asm"

ENDIF

IF _6502SP_VERSION \ Platform

INCLUDE "library/advanced/main/variable/widget.asm"
INCLUDE "library/advanced/main/variable/safehouse.asm"
INCLUDE "library/advanced/main/variable/messxc.asm"

ELIF _MASTER_VERSION

INCLUDE "library/advanced/main/variable/widget.asm"
INCLUDE "library/master/main/variable/dontclip.asm"
INCLUDE "library/master/main/variable/yx2m1.asm"
INCLUDE "library/advanced/main/variable/messxc.asm"
INCLUDE "library/master/main/variable/newzp.asm"
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

ELIF _ELITE_A_VERSION

INCLUDE "library/elite-a/flight/variable/finder.asm"

ELIF _NES_VERSION

INCLUDE "library/advanced/main/variable/widget.asm"

.Yx1M2

 SKIP 1                 \ ???

.Yx2M2

 SKIP 1                 \ ???

INCLUDE "library/master/main/variable/yx2m1.asm"
INCLUDE "library/advanced/main/variable/messxc.asm"

.L00B5

 SKIP 1                 \ ???

INCLUDE "library/master/main/variable/newzp.asm"

.L00B7

 SKIP 1                 \ ???

.tileNumber

 SKIP 1                 \ ???

.patternTableHi

 SKIP 1                 \ ???

.SC2

 SKIP 2                 \ ???

.L00BC

 SKIP 1                 \ ???

.L00BD

 SKIP 1                 \ ???

.L00BE

 SKIP 1                 \ ???

.L00BF

 SKIP 1                 \ ???

.L00C0

 SKIP 1                 \ ???

.L00C1

 SKIP 1                 \ ???

.L00C2

 SKIP 1                 \ ???

.L00C3

 SKIP 1                 \ ???

.L00C4

 SKIP 1                 \ ???

.L00C5

 SKIP 1                 \ ???

.L00C6

 SKIP 1                 \ ???

.L00C7

 SKIP 1                 \ ???

.L00C8

 SKIP 1                 \ ???

.L00C9

 SKIP 1                 \ ???

.L00CA

 SKIP 1                 \ ???

.L00CB

 SKIP 1                 \ ???

.L00CC

 SKIP 1                 \ ???

.L00CD

 SKIP 1                 \ ???

.L00CE

 SKIP 1                 \ ???

.L00CF

 SKIP 1                 \ ???

.L00D0

 SKIP 1                 \ ???

.L00D1

 SKIP 1                 \ ???

.L00D2

 SKIP 1                 \ ???

.L00D3

 SKIP 1                 \ ???

.addr1

 SKIP 2                 \ ???

.L00D6

 SKIP 1                 \ ???

.L00D7

 SKIP 1                 \ ???

.L00D8

 SKIP 1                 \ ???

.L00D9

 SKIP 1                 \ ???

.L00DA

 SKIP 1                 \ ???

.L00DB

 SKIP 11                \ ???

.nametableHi

 SKIP 1                 \ ???

.L00E7

 SKIP 1                 \ ???

.L00E8

 SKIP 1                 \ ???

.dashboardSwitch

 SKIP 1                 \ ???

.L00EA

 SKIP 1                 \ ???

.L00EB

 SKIP 1                 \ ???

.L00EC

 SKIP 1                 \ ???

.L00ED

 SKIP 1                 \ ???

.L00EE

 SKIP 1                 \ ???

.L00EF

 SKIP 1                 \ ???

.L00F0

 SKIP 1                 \ ???

.addr6

 SKIP 2                 \ ???

.L00F3

 SKIP 1                 \ ???

.L00F4

 SKIP 1                 \ ???

.ppuCtrlCopy

 SKIP 1                 \ ???

.L00F6

 SKIP 1                 \ ???

.currentBank

 SKIP 1                 \ ???

.L00F8

 SKIP 1                 \ ???

.L00F9

 SKIP 1                 \ ???

.addr2

 SKIP 2                 \ ???

.L00FC

 SKIP 1                 \ ???

.L00FD

 SKIP 1                 \ ???

.L00FE

 SKIP 1                 \ ???

.L00FF

 SKIP 1                 \ ???

ENDIF

IF _ELITE_A_6502SP_PARA

INCLUDE "library/elite-a/parasite/variable/dockedp.asm"

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 ORG &00D1

INCLUDE "library/common/main/variable/t.asm"
INCLUDE "library/common/main/variable/k3.asm"
INCLUDE "library/common/main/variable/xx2.asm"
INCLUDE "library/common/main/variable/k4.asm"

ENDIF

 PRINT "Zero page variables from ", ~ZP, " to ", ~P%

