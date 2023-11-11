\ ******************************************************************************
\
\       Name: ZP
\       Type: Workspace
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Platform
\    Address: &0000 to &00B0
ELIF _NES_VERSION
\    Address: &0000 to &00FF
ENDIF
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

INCLUDE "library/nes/main/variable/iconbarkeypress.asm"

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
INCLUDE "library/nes/main/variable/halfscreenheight.asm"
INCLUDE "library/nes/main/variable/screenheight.asm"
INCLUDE "library/master/main/variable/yx2m1.asm"
INCLUDE "library/advanced/main/variable/messxc.asm"
INCLUDE "library/nes/main/variable/messyc.asm"
INCLUDE "library/master/main/variable/newzp.asm"
INCLUDE "library/nes/main/variable/asav.asm"
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

.ppuNametableAddr

 SKIP 2                 \ Address of the current PPU nametable:
                        \
                        \   * PPU_NAME_0 (&2000) when drawingBitplane = 0
                        \   * PPU_NAME_1 (&2400) when drawingBitplane = 1

.drawingPlaneDebug

 SKIP 1                 \ This variable is set to 0 whenever the drawing
                        \ bitplane changes, but it is never read, so maybe this
                        \ is part of some debug code that was left behind?

.nameBufferHi

 SKIP 1                 \ High byte of the address of the current nametable
                        \ buffer (&70 or &74)

.startupDebug

 SKIP 1                 \ This variable is set to 0 in the game's entry routine
                        \ at S%, but it is never read, so maybe this is part of
                        \ some debug code that was left behind?

.lastToSend

 SKIP 1                 \ The last tile or pattern number to send to the PPU,
                        \ potentially potentially overwritten by the flags
                        \
                        \ This variable is used internally by the NMI handler,
                        \ and is set according to bit 3 of the bitplane flags

.setupPPUForIconBar

 SKIP 1                 \ Controls whether we force the nametable and pattern
                        \ table to 0 when the PPU starts drawing the icon bar
                        \
                        \   * Bit 7 clear = do nothing when the PPU starts
                        \                   drawing the icon bar
                        \
                        \   * Bit 7 set = configure the PPU to display nametable
                        \                 0 and pattern table 0 when the PPU
                        \                 starts drawing the icon bar

.showUserInterface

 SKIP 1                 \ Bit 7 set means display the user interface (so we only
                        \ clear it for the game over screen)

.joystickDelta

 SKIP 0                 \ Used to store the amount to change the pitch and roll
                        \ rates when converting controller button presses into
                        \ joystick values

.addr

 SKIP 2                 \ Temporary storage, used in a number of places to hold
                        \ an address

.dataForPPU

 SKIP 2                 \ An address pointing to data that we send to the PPU

.clearBlockSize

 SKIP 2                 \ The size of the block of memory to clear, for example
                        \ when clearing the buffers

.clearAddress

 SKIP 2                 \ The address of a block of memory to clear, for example
                        \ when clearing the buffers

.hiddenBitplane

 SKIP 1                 \ The bitplane that is currently hidden from view in the
                        \ space view
                        \
                        \   * 0 = bitplane 0 is hidden, so:
                        \         * Colour %01 (1) is the hidden colour (black)
                        \         * Colour %10 (2) is the visible colour (cyan)
                        \
                        \   * 1 = bitplane 1 is hidden, so:
                        \         * Colour %01 (1) is the visible colour (cyan)
                        \         * Colour %10 (2) is the hidden colour (black)
                        \
                        \ Note that bitplane 0 corresponds to bit 0 of the
                        \ colour number, while bitplane 1 corresponds to bit 1
                        \ of the colour number (as this is how the NES stores
                        \ pattern data - the first block of eight bytes in each
                        \ pattern controls bit 0 of the colour, while the second
                        \ block controls bit 1)
                        \
                        \ In other words:
                        \
                        \   * Bitplane 0 = bit 0 = colour %01 = colour 1
                        \
                        \   * Bitplane 1 = bit 1 = colour %10 = colour 2

.nmiBitplane

 SKIP 1                 \ The number of the bitplane (0 or 1) that is currently
                        \ being processed in the NMI handler during VBlank

.ppuCtrlCopy

 SKIP 1                 \ Contains a copy of PPU_CTRL, so we can check the PPU
                        \ configuration without having to access the PPU

.enableBitplanes

 SKIP 1                 \ A flag to control whether two different bitplanes are
                        \ implemented when drawing the screen, so smooth vector
                        \ graphics can be shown
                        \
                        \   * 0 = bitplanes are disabled (for the Start screen)
                        \
                        \   * 1 = bitplanes are enabled (for the main game)

.currentBank

 SKIP 1                 \ Contains the number of the ROM bank (0 to 6) that is
                        \ currently paged into memory at &8000

.runningSetBank

 SKIP 1                 \ A flag that records whether we are in the process of
                        \ switching ROM banks in the SetBank routine when the
                        \ NMI handler is called
                        \
                        \   * 0 = we are not in the process of switching ROM
                        \         banks
                        \
                        \   * Non-zero = we are not in the process of switching
                        \                ROM banks
                        \
                        \ This is used to control whether the NMI handler calls
                        \ the MakeSounds routine to make the current sounds
                        \ (music and sound effects), as this can only happen if
                        \ we are not in the middle of switching ROM banks (if
                        \ we are, then MakeSounds is only called once the
                        \ bank-switching is done - see the SetBank routine for
                        \ details)

.characterEnd

 SKIP 1                 \ The number of the character beyond the end of the
                        \ printable character set for the chosen language

.autoPlayKeys

 SKIP 2                 \ The address of the table containing the key presses to
                        \ apply when auto-playing the demo
                        \
                        \ The address is either that of the chosen language's
                        \ autoPlayKeys1 table (for the first part of the
                        \ auto-play demo, or the autoPlayKeys2 table (for the
                        \ second part)

 SKIP 2                 \ These bytes appear to be unused

.soundAddr

 SKIP 2                 \ Temporary storage, used in a number of places in the
                        \ sound routines to hold an address

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

