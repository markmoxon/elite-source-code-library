\ ******************************************************************************
\
\       Name: ZP
\       Type: Workspace
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform
\    Address: &0000 to &00E1
ELIF _NES_VERSION
\    Address: &0000 to &00FF
ELIF _C64_VERSION
\    Address: &0000 to &00D1
ELIF _APPLE_VERSION
\    Address: &0000 to &00E2
ELIF _MASTER_VERSION
\    Address: &0000 to &00E3
ENDIF
\   Category: Workspaces
\    Summary: Lots of important variables are stored in the zero page workspace
\             as it is quicker and more space-efficient to access memory here
\
\ ******************************************************************************

 ORG &0000              \ Set the assembly address to &0000

.ZP

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Comment

 SKIP 0                 \ The start of the zero page workspace

ENDIF

IF _MASTER_VERSION \ Platform

 SKIP 2                 \ These bytes appear to be unused

INCLUDE "library/master/loader/variable/mos.asm"

ELIF _NES_VERSION OR _APPLE_VERSION

 SKIP 2                 \ These bytes appear to be unused

ELIF _C64_VERSION

 SKIP 2                 \ These two bytes control the 6510 processor port
                        \
                        \ In particular, Elite uses the 6510 port register at
                        \ location &0001 to reconfigure memory on numerous
                        \ occasions
                        \
                        \ For example, when it needs to access the memory-mapped
                        \ registers in the VIC-II video controller chip, the SID
                        \ sound chip or the two CIA I/O chips, the I/O memory is
                        \ paged in by updating location &0001, and is then paged
                        \ out again afterwards
                        \
                        \ See the SETL1 routine for more details

ENDIF

INCLUDE "library/common/main/variable/rand.asm"

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Platform

INCLUDE "library/original/main/variable/trtb_per_cent.asm"

ENDIF

INCLUDE "library/common/main/variable/t1.asm"

IF _MASTER_VERSION OR _APPLE_VERSION \ Platform

INCLUDE "library/master/main/variable/t2.asm"
INCLUDE "library/master/main/variable/t3.asm"
INCLUDE "library/master/main/variable/t4.asm"

ENDIF

INCLUDE "library/common/main/variable/sc.asm"
INCLUDE "library/common/main/variable/sch.asm"

IF _NES_VERSION

INCLUDE "library/common/main/variable/xx1.asm"
INCLUDE "library/common/main/variable/inwk.asm"
INCLUDE "library/enhanced/main/variable/newb.asm"

 SKIP 1                 \ This byte appears to be unused

ELIF _C64_VERSION OR _APPLE_VERSION

INCLUDE "library/common/main/variable/xx1.asm"
INCLUDE "library/common/main/variable/inwk.asm"
INCLUDE "library/common/main/variable/xx19.asm"
INCLUDE "library/enhanced/main/variable/newb.asm"

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

INCLUDE "library/common/main/variable/xx16.asm"
INCLUDE "library/common/main/variable/p.asm"

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

INCLUDE "library/common/main/variable/p.asm"
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
INCLUDE "library/nes/main/variable/hiddencolour.asm"
INCLUDE "library/nes/main/variable/visiblecolour.asm"
INCLUDE "library/nes/main/variable/palettecolour2.asm"
INCLUDE "library/nes/main/variable/palettecolour3.asm"
INCLUDE "library/nes/main/variable/fontstyle.asm"
INCLUDE "library/nes/main/variable/nmitimer.asm"
INCLUDE "library/nes/main/variable/nmitimerlo.asm"
INCLUDE "library/nes/main/variable/nmitimerhi.asm"
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
INCLUDE "library/common/main/variable/inf.asm"
INCLUDE "library/common/main/variable/v.asm"
INCLUDE "library/common/main/variable/xx.asm"
INCLUDE "library/common/main/variable/yy.asm"

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Platform

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

IF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Platform

INCLUDE "library/common/main/variable/alp1.asm"
INCLUDE "library/common/main/variable/alp2.asm"

ENDIF

INCLUDE "library/common/main/variable/xx15.asm"

IF NOT(_APPLE_VERSION)

INCLUDE "library/common/main/variable/x1.asm"
INCLUDE "library/common/main/variable/y1.asm"
INCLUDE "library/common/main/variable/x2.asm"
INCLUDE "library/common/main/variable/y2.asm"

ELIF _APPLE_VERSION

INCLUDE "library/apple/main/variable/ztemp0.asm"
INCLUDE "library/common/main/variable/x1.asm"
INCLUDE "library/apple/main/variable/ztemp1.asm"
INCLUDE "library/common/main/variable/y1.asm"
INCLUDE "library/apple/main/variable/ztemp2.asm"
INCLUDE "library/common/main/variable/x2.asm"
INCLUDE "library/apple/main/variable/ztemp3.asm"
INCLUDE "library/common/main/variable/y2.asm"

ENDIF

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

INCLUDE "library/nes/main/variable/iconbarkeypress.asm"

ENDIF

IF _C64_VERSION

INCLUDE "library/advanced/main/variable/thiskey.asm"

ELIF _APPLE_VERSION

INCLUDE "library/apple/main/variable/keylook.asm"
INCLUDE "library/apple/main/variable/klo.asm"
INCLUDE "library/advanced/main/variable/thiskey.asm"
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
INCLUDE "library/enhanced/main/variable/ky20.asm"

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

IF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Platform

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

IF _MASTER_VERSION \ Platform

INCLUDE "library/master/main/variable/w.asm"

ENDIF
IF NOT(_NES_VERSION)

INCLUDE "library/common/main/variable/qq11.asm"

ELIF _NES_VERSION

INCLUDE "library/nes/main/variable/qq11.asm"
INCLUDE "library/nes/main/variable/qq11a.asm"

ENDIF

INCLUDE "library/common/main/variable/zz.asm"
INCLUDE "library/common/main/variable/xx13.asm"
INCLUDE "library/common/main/variable/mcnt.asm"

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Platform

INCLUDE "library/common/main/variable/dl.asm"

ENDIF

INCLUDE "library/common/main/variable/type.asm"

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Platform

INCLUDE "library/common/main/variable/jstx.asm"
INCLUDE "library/common/main/variable/jsty.asm"

ENDIF

INCLUDE "library/common/main/variable/alpha.asm"

IF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Platform

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

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _NES_VERSION \ Platform

INCLUDE "library/common/main/variable/xx14.asm"

ELIF _MASTER_VERSION OR _APPLE_VERSION

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

ELIF _C64_VERSION

INCLUDE "library/advanced/main/variable/widget.asm"
INCLUDE "library/master/main/variable/dontclip.asm"
INCLUDE "library/master/main/variable/yx2m1.asm"
INCLUDE "library/advanced/main/variable/messxc.asm"
INCLUDE "library/master/main/variable/newzp.asm"
INCLUDE "library/common/main/variable/t.asm"
INCLUDE "library/c64/main/variable/p2.asm"
INCLUDE "library/c64/main/variable/q2.asm"
INCLUDE "library/c64/main/variable/r2.asm"
INCLUDE "library/c64/main/variable/s2.asm"
INCLUDE "library/c64/main/variable/t2.asm"

 SKIP 1                 \ This byte appears to be unused

INCLUDE "library/c64/main/variable/bddataptr1.asm"
INCLUDE "library/c64/main/variable/bddataptr2.asm"
INCLUDE "library/c64/main/variable/bddataptr3.asm"
INCLUDE "library/c64/main/variable/bddataptr4.asm"
INCLUDE "library/c64/main/variable/counter.asm"
INCLUDE "library/c64/main/variable/vibrato2.asm"
INCLUDE "library/c64/main/variable/vibrato3.asm"
INCLUDE "library/c64/main/variable/voice2lo1.asm"
INCLUDE "library/c64/main/variable/voice2hi1.asm"
INCLUDE "library/c64/main/variable/voice2lo2.asm"
INCLUDE "library/c64/main/variable/voice2hi2.asm"
INCLUDE "library/c64/main/variable/voice3lo1.asm"
INCLUDE "library/c64/main/variable/voice3hi1.asm"
INCLUDE "library/c64/main/variable/voice3lo2.asm"
INCLUDE "library/c64/main/variable/voice3hi2.asm"
INCLUDE "library/c64/main/variable/bdbuff.asm"

ELIF _APPLE_VERSION

INCLUDE "library/advanced/main/variable/widget.asm"
INCLUDE "library/master/main/variable/dontclip.asm"
INCLUDE "library/master/main/variable/yx2m1.asm"
INCLUDE "library/apple/main/variable/text.asm"
INCLUDE "library/advanced/main/variable/messxc.asm"
INCLUDE "library/master/main/variable/newzp.asm"
INCLUDE "library/common/main/variable/t.asm"
INCLUDE "library/common/main/variable/jstx.asm"
INCLUDE "library/common/main/variable/jsty.asm"
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
INCLUDE "library/nes/main/variable/halfscreenheight.asm"
INCLUDE "library/nes/main/variable/screenheight.asm"
INCLUDE "library/master/main/variable/yx2m1.asm"
INCLUDE "library/advanced/main/variable/messxc.asm"
INCLUDE "library/nes/main/variable/messyc.asm"
INCLUDE "library/master/main/variable/newzp.asm"
INCLUDE "library/nes/main/variable/storea.asm"
INCLUDE "library/nes/main/variable/firstfreepattern.asm"
INCLUDE "library/nes/main/variable/pattbufferhidiv8.asm"
INCLUDE "library/nes/main/variable/sc2.asm"
INCLUDE "library/nes/main/variable/sc3.asm"
INCLUDE "library/nes/main/variable/barbuttons.asm"
INCLUDE "library/nes/main/variable/drawingbitplane.asm"
INCLUDE "library/nes/main/variable/lastpattern.asm"
INCLUDE "library/nes/main/variable/clearingpattern.asm"
INCLUDE "library/nes/main/variable/clearingnametile.asm"
INCLUDE "library/nes/main/variable/sendingnametile.asm"
INCLUDE "library/nes/main/variable/patterncounter.asm"
INCLUDE "library/nes/main/variable/sendingpattern.asm"
INCLUDE "library/nes/main/variable/firstnametile.asm"
INCLUDE "library/nes/main/variable/lastnametile.asm"
INCLUDE "library/nes/main/variable/nametilecounter.asm"
INCLUDE "library/nes/main/variable/cyclecount.asm"
INCLUDE "library/nes/main/variable/firstpattern.asm"
INCLUDE "library/nes/main/variable/barpatterncounter.asm"
INCLUDE "library/nes/main/variable/iconbarrow.asm"
INCLUDE "library/nes/main/variable/iconbarimagehi.asm"
INCLUDE "library/nes/main/variable/skipbarpatternsppu.asm"
INCLUDE "library/nes/main/variable/maxnametiletoclear.asm"
INCLUDE "library/nes/main/variable/asciitopattern.asm"
INCLUDE "library/nes/main/variable/updatepaletteinnmi.asm"
INCLUDE "library/nes/main/variable/patternbufferlo.asm"
INCLUDE "library/nes/main/variable/nametilebufflo.asm"
INCLUDE "library/nes/main/variable/nmibitplane8.asm"
INCLUDE "library/nes/main/variable/ppupatterntablehi.asm"
INCLUDE "library/nes/main/variable/pattbufferaddr.asm"
INCLUDE "library/nes/main/variable/ppunametableaddr.asm"
INCLUDE "library/nes/main/variable/drawingplanedebug.asm"
INCLUDE "library/nes/main/variable/namebufferhi.asm"
INCLUDE "library/nes/main/variable/startupdebug.asm"
INCLUDE "library/nes/main/variable/lasttosend.asm"
INCLUDE "library/nes/main/variable/setupppuforiconbar.asm"
INCLUDE "library/nes/main/variable/showuserinterface.asm"
INCLUDE "library/nes/main/variable/joystickdelta.asm"
INCLUDE "library/nes/main/variable/addr.asm"
INCLUDE "library/nes/main/variable/dataforppu.asm"
INCLUDE "library/nes/main/variable/clearblocksize.asm"
INCLUDE "library/nes/main/variable/clearaddress.asm"
INCLUDE "library/nes/main/variable/hiddenbitplane.asm"
INCLUDE "library/nes/main/variable/nmibitplane.asm"
INCLUDE "library/nes/main/variable/ppuctrlcopy.asm"
INCLUDE "library/nes/main/variable/enablebitplanes.asm"
INCLUDE "library/nes/main/variable/currentbank.asm"
INCLUDE "library/nes/main/variable/runningsetbank.asm"
INCLUDE "library/nes/main/variable/characterend.asm"
INCLUDE "library/nes/main/variable/autoplaykeys.asm"

 SKIP 2                 \ These bytes appear to be unused

INCLUDE "library/nes/main/variable/soundaddr.asm"

ENDIF

IF _ELITE_A_6502SP_PARA

INCLUDE "library/elite-a/parasite/variable/dockedp.asm"

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 ORG &00D1              \ Set the assembly address to &00D1

INCLUDE "library/common/main/variable/t.asm"
INCLUDE "library/common/main/variable/k3.asm"
INCLUDE "library/common/main/variable/xx2.asm"
INCLUDE "library/common/main/variable/k4.asm"

ENDIF

 PRINT "ZP workspace from ", ~ZP, "to ", ~P%-1, "inclusive"

