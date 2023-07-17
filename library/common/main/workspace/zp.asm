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

 SKIP 1                 \ Normally INWK+33 (ship heap lo), reused in NES ???

.L002B

 SKIP 1                 \ Normally INWK+34 (ship heap hi), reused in NES ???

.L002C

 SKIP 1                 \ INWK+35 energy level

INCLUDE "library/enhanced/main/variable/newb.asm"

.L002E

 SKIP 1                 \ Unused ??? INWK+37

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

.hiddenColour

 SKIP 1                 \ Contains the colour to use for pixels that are hidden
                        \ in palette 0, e.g. &0F for black
                        \
                        \ See the SetPaletteForPhase routine for details

.visibleColour

 SKIP 1                 \ Contains the colour to use for pixels that are visible
                        \ in palette 0, e.g. &2C for cyan
                        \
                        \ See the SetPaletteForPhase routine for details

.paletteColour2

 SKIP 1                 \ Contains the colour to use for palette entry 2 in the
                        \ current (non-space) view
                        \
                        \ See the SetPaletteForPhase routine for details

.paletteColour3

 SKIP 1                 \ Contains the colour to use for palette entry 3 in the
                        \ current (non-space) view
                        \
                        \ See the SetPaletteForPhase routine for details

.fontBitPlane

 SKIP 1                 \ When printing a character in CHPR, this defines which
                        \ bit planes to draw from the font images in fontImage,
                        \ as each character in the font contains two separate
                        \ characters
                        \
                        \   * %01 = draw bit plane 1 (monochrome)
                        \
                        \   * %10 = draw bit plane 2 (monochrome)
                        \
                        \   * %11 = draw both bit planes (four-colour)

.nmiTimer

 SKIP 1                 \ A counter that gets decremented each time the NMI
                        \ interrupt is called, starting at 50 and counting down
                        \ to zero, at which point it jumps back up to 50 again
                        \ and triggers and increment of (nmiTimerHi nmiTimerLo)

.nmiTimerLo

 SKIP 1                 \ Low byte of a counter that's incremented by 1 every
                        \ time nmiTimer wraps

.nmiTimerHi

 SKIP 1                 \ High byte of a counter that's incremented by 1 every
                        \ time nmiTimer wraps

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

IF _MASTER_VERSION \ Platform

INCLUDE "library/master/main/variable/w.asm"

ENDIF
IF NOT(_NES_VERSION)

INCLUDE "library/common/main/variable/qq11.asm"

ELIF _NES_VERSION

.QQ11

 SKIP 1                 \ The number of the current view:
                        \
                        \   0   = Space view, Title screen
                        \   1   = Loading ship on Title screen
                        \   &10 = ???
                        \   &8B = ???
                        \   &8D = ???
                        \   &92 = ???
                        \   &93 = ???
                        \   &95 = Trumble mission screen
                        \   &96 = Data on System (TT25, TRADEMODE)
                        \   &97 = Inventory
                        \   &98 = Status Mode
                        \   &9C = Short-range Chart
                        \   &9D = Long-range Chart
                        \   &B9 = Equip Ship
                        \   &BA = Market Prices/Buy Cargo/Sell Cargo
                        \   &BB = Save and load
                        \   &C4 = ???
                        \   &CF = ???
                        \   &DF = Start screen
                        \   &FF = ???
                        \
                        \   * Bit 6 clear = there is an icon bar? (0 to &BF)
                        \     Bit 6 set   = there is no icon bar? (&C0 and up)
                        \
                        \   * Bit 7 clear = icon bar on row 20 (dashboard)
                        \     Bit 7 set   = icon bar on row 27 (no dashboard)
                        \
                        \ STA: 0, &8B, &97, &9D, &BB, &DF, &FF
                        \ TT66: 0, &8D, &93, &95, &9C, &BB, &C4, &CF
                        \ ChangeViewRow0: &96, &97, &98, &B9, &BA
                        \ subm_B39D: 0, 1, &10, &92

.QQ11a

 SKIP 1                 \ Can be 0, &FF or QQ11
                        \
                        \ When we change view, QQ11 gets set to the new view
                        \ number straight away while QQ11a stays set to the old
                        \ view number, only updating to the new view number once
                        \ the new view has appeared

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

.Yx1M2

 SKIP 1                 \ Height of screen for text-based views ???

.Yx2M2

 SKIP 1                 \ Contains 2 x Yx1M2 ???

INCLUDE "library/master/main/variable/yx2m1.asm"
INCLUDE "library/advanced/main/variable/messxc.asm"

.L00B5

 SKIP 1                 \ ???

INCLUDE "library/master/main/variable/newzp.asm"

.ASAV

 SKIP 1                 \ Temporary storage for saving the value of the A
                        \ register, used in the bank-switching routines in
                        \ bank 7

.tileNumber

 SKIP 1                 \ Contains the current tile number to draw into ???

.pattBufferHiDiv8

 SKIP 1                 \ High byte of the address of the current pattern
                        \ buffer (&60 or &68) divided by 8

.SC2

 SKIP 2                 \ Typically contains an address that's used alongside
                        \ SC(1 0)???

.SC3

 SKIP 2                 \ Typically contains an address that's used alongside
                        \ SC(1 0)???

.L00BE

 SKIP 1                 \ ???

.L00BF

 SKIP 1                 \ ???

.drawingPhase

 SKIP 1                 \ Flipped manually by calling ChangeDrawingPhase,
                        \ controls whether we are showing nametable/palette
                        \ buffer 0 or 1 (and which tile number is chosen from
                        \ the following)

.tileNumber0

 SKIP 1                 \ A tile number, for phase 0

 SKIP 1                 \ A tile number, for phase 1

.tileNumber1

 SKIP 1                 \ A tile number, for phase 0

 SKIP 1                 \ A tile number, for phase 1

.tileNumber2

 SKIP 1                 \ A tile number, for phase 0

 SKIP 1                 \ A tile number, for phase 1

.tileNumber3

 SKIP 1                 \ A tile number, for phase 0

 SKIP 1                 \ A tile number, for phase 1

.L00C9

 SKIP 1                 \ ???

.tileNumber4

 SKIP 1                 \ A tile number, for phase 0

 SKIP 1                 \ A tile number, for phase 1

.L00CC

 SKIP 1                 \ ???

.phaseL00CD

 SKIP 1                 \ ??? Phase 0

 SKIP 1                 \ ??? Phase 1

.L00CF

 SKIP 1                 \ ???

.cycleCount

 SKIP 2                 \ Counts the number of CPU cycles spent in the NMI
                        \ handler

.L00D2

 SKIP 1                 \ ???

.barPatternCounter

 SKIP 1                 \ The number of icon bar nametable and pattern entries
                        \ that need to be sent to the PPU in the NMI handler
                        \
                        \   * 0 = send the nametable entries and the first four
                        \         tile pattern in the next NMI call (and update
                        \         barPatternCounter to 4 when done)
                        \
                        \   * 1-127 = counts the number of pattern bytes already
                        \             sent to the PPU, which get sent in batches
                        \             of four patterns (32 bytes), split across
                        \             multiple NMI calls, until we have send all
                        \             32 tile patterns and the value is 128
                        \             
                        \   * 128 = do not send any tiles

.iconBarOffset

 SKIP 2                 \ The offset from the start of the nametable buffer of
                        \ the icon bar (i.e. the number of the nametable entry
                        \ for the top-left tile of the icon bar)
                        \
                        \ This can have two values:
                        \
                        \   * 20*32 = icon bar is on row 20 (just above the
                        \             dashboard)
                        \
                        \   * 27*32 = icon bar is on tow 27 (at the bottom of
                        \             the screen, where there is no dashboard)

.iconBarImageHi

 SKIP 1                 \ Contains the high byte of the address of the image
                        \ data for the current icon bar, i.e. HI(iconBarImage0)
                        \ through to HI(iconBarImage4)

.skipBarPatternsPPU

 SKIP 1                 \ A flag to control whether to send the icon bar's tile
                        \ patterns to the PPU, after sending the nametable
                        \ entries (this only applies if barPatternCounter = 0)
                        \
                        \   * Bit 7 set = do not send tile patterns
                        \
                        \   * Bit 7 clear = send tile patterns
                        \
                        \ This means that if barPatternCounter is set to zero
                        \ and bit 7 of skipBarPatternsPPU is set, then only the
                        \ nametable entries for the icon bar will be sent to the
                        \ PPU, but if barPatternCounter is set to zero and bit 7
                        \ of skipBarPatternsPPU is clear, both the nametable
                        \ entries and tile patterns will be sent

.L00D8

 SKIP 1                 \ ???

.L00D9

 SKIP 1                 \ ???

.updatePaletteInNMI

 SKIP 1                 \ A flag that controls whether to send the palette data
                        \ from XX3 to the PPU during NMI:
                        \
                        \   * 0 = do not send palette data
                        \
                        \   * Non-zero = do send palette data

.phaseL00DB

 SKIP 1                 \ ??? Phase 0

 SKIP 1                 \ ??? Phase 1

.phaseL00DD

 SKIP 1                 \ ??? Phase 0

 SKIP 1                 \ ??? Phase 1

.pallettePhasex8

 SKIP 1                 \ Set to 0 or palettePhase * 8 (i.e. 0 or %0001) ???

.L00E0

 SKIP 1                 \ ???

.pattBufferAddr

 SKIP 2                 \ Address of the current pattern buffer:
                        \
                        \   * &6000 when drawingPhase = 0
                        \   * &6800 when drawingPhase = 1

.ppuNametableAddr

 SKIP 2                 \ Address of the current PPU nametable:
                        \
                        \   * &2000 when drawingPhase = 0
                        \   * &2400 when drawingPhase = 1

.drawingPhaseDebug

 SKIP 1                 \ Set to 0 when drawing phase changes, never read ???

.nameBufferHi

 SKIP 1                 \ High byte of the address of the current nametable
                        \ buffer (&70 or &74)

.startupDebug

 SKIP 1                 \ Set to 0 in S%, never used again ???

.temp1

 SKIP 1                 \ Temporary variable, used in bank 7 ???

.setupPPUForIconBar

 SKIP 1                 \ Bit 7 set means we set nametable 0 and palette table 0
                        \ when the PPU starts drawing the icon bar

.showUserInterface

 SKIP 1                 \ Bit 7 set means display the user interface (so we only
                        \ clear it for the game over screen) 

.addr4

 SKIP 2                 \ An address within the PPU to be poked to ???

.dataForPPU

 SKIP 2                 \ An address pointing to data that we send to the PPU

.addr7

 SKIP 2                 \ ???

.addr6

 SKIP 2                 \ ???

.palettePhase

 SKIP 1                 \ 0 or 1, flips every NMI, controls palette switching
                        \ for space view in NMI routine ???

.otherPhase

 SKIP 1                 \ 0 or 1, flipped in subm_CB42 ???

.ppuCtrlCopy

 SKIP 1                 \ Contains a copy of PPU_CTRL

.L00F6

 SKIP 1                 \ ???

.currentBank

 SKIP 1                 \ Contains the number of the ROM bank (0 to 6) that is
                        \ currently paged into memory at &8000

.runningSetBank

 SKIP 1                 \ Set to &FF if we are inside the SetBank routine when
                        \ the NMI interrupts, 0 otherwise

.L00F9

 SKIP 1                 \ ???

.addr2

 SKIP 2                 \ An address within the PPU to be poked to ???

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

