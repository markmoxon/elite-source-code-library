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

.hiddenColour

 SKIP 1                 \ Contains the colour to use for pixels that are hidden
                        \ in palette 0, e.g. &0F for black
                        \
                        \ See the SetPaletteForView routine for details

.visibleColour

 SKIP 1                 \ Contains the colour to use for pixels that are visible
                        \ in palette 0, e.g. &2C for cyan
                        \
                        \ See the SetPaletteForView routine for details

.paletteColour2

 SKIP 1                 \ Contains the colour to use for palette entry 2 in the
                        \ current (non-space) view
                        \
                        \ See the SetPaletteForView routine for details

.paletteColour3

 SKIP 1                 \ Contains the colour to use for palette entry 3 in the
                        \ current (non-space) view
                        \
                        \ See the SetPaletteForView routine for details

.fontStyle

 SKIP 1                 \ The font style to use when printing text:
                        \
                        \   * 1 = normal font
                        \
                        \   * 2 = highlight font
                        \
                        \   * 3 = green text on a black background (colour 3 on
                        \         background colour 0)
                        \
                        \ Style 3 is used when printing characters into 2x2
                        \ attribute blocks where printing the normal font would
                        \ result in the wrong colour text being shown

.nmiTimer

 SKIP 1                 \ A counter that gets decremented each time the NMI
                        \ interrupt is called, starting at 50 and counting down
                        \ to zero, at which point it jumps back up to 50 again
                        \ and triggers an increment of (nmiTimerHi nmiTimerLo)
                        \
                        \ On PAL system there are 50 frames per second, so this
                        \ means nmiTimer ticks down from 50 once a second, so
                        \ (nmiTimerHi nmiTimerLo) counts up in seconds
                        \
                        \ On NTSC there are 60 frames per second, so nmiTimer
                        \ counts down in 5/6 of a second, or 0.8333 seconds,
                        \ so (nmiTimerHi nmiTimerLo) counts up every 0.8333
                        \ seconds

.nmiTimerLo

 SKIP 1                 \ Low byte of a counter that's incremented by 1 every
                        \ time nmiTimer wraps
                        \
                        \ On PAL systems (nmiTimerHi nmiTimerLo) counts seconds
                        \
                        \ On NTSC it increments up every 0.8333 seconds

.nmiTimerHi

 SKIP 1                 \ High byte of a counter that's incremented by 1 every
                        \ time nmiTimer wraps
                        \
                        \ On PAL systems (nmiTimerHi nmiTimerLo) counts seconds
                        \
                        \ On NTSC it increments up every 0.8333 seconds

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

.iconBarKeyPress

 SKIP 1                 \ The button number of an icon bar button if an icon bar
                        \ button has been chosen
                        \
                        \ This gets set along with the key logger, copying the
                        \ value from iconBarChoice (the latter gets set in the
                        \ NMI handler with the icon bar button number, so
                        \ iconBarKeyPress effectively latches the value from
                        \ iconBarChoice)

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

 SKIP 1                 \ This contains the type of the current view (or, if
                        \ we are changing views, the type of the view we are
                        \ changing to)
                        \
                        \ The low nibble determines the view, as follows:
                        \
                        \   0  = &x0 = Space view
                        \   1  = &x1 = Title screen
                        \   2  = &x2 = Mission 1 briefing: rotating ship
                        \   3  = &x3 = Mission 1 briefing: ship and text
                        \   4  = &x4 = Game Over screen
                        \   5  = &x5 = Text-based mission briefing
                        \   6  = &x6 = Data on System
                        \   7  = &x7 = Inventory
                        \   8  = &x8 = Status Mode
                        \   9  = &x9 = Equip Ship
                        \   10 = &xA = Market Price
                        \   11 = &xB = Save and Load
                        \   12 = &xC = Short-range Chart
                        \   13 = &xD = Long-range Chart
                        \   14 = &xE = Unused
                        \   15 = &xF = Start screen
                        \
                        \ The high nibble contains four configuration bits, as
                        \ follows:
                        \
                        \   * Bit 4 clear = do not load the normal font
                        \     Bit 4 set   = load the normal font into patterns
                        \                   66 to 160 (or 68 to 162 for views
                        \                   &9D and &DF)
                        \
                        \   * Bit 5 clear = do not load the highlight font
                        \     Bit 5 set   = load the highlight font into
                        \                   patterns 161 to 255
                        \
                        \   * Bit 6 clear = icon bar
                        \     Bit 6 set   = no icon bar (rows 27-28 are blank)
                        \
                        \   * Bit 7 clear = dashboard (icon bar on row 20)
                        \     Bit 7 set   = no dashboard (icon bar on row 27)
                        \
                        \ The normal font is colour 1 on background colour 0
                        \ (typically white or cyan on black)
                        \
                        \ The highlight font is colour 3 on background colour 1
                        \ (typically green on white)
                        \
                        \ Most views have the same configuration every time
                        \ the view is shown, but &x0 (space view), &xB (Save and
                        \ load), &xD (Long-range Chart) and &xF (Start screen)
                        \ can have different configurations at different times
                        \
                        \ Note that view &FF is an exception, as no fonts are
                        \ loaded for this view, despite bits 4 and 5 being set
                        \ (this view represents the blank screen between the end
                        \ of the Title screen and the start of the demo scroll
                        \ text)
                        \
                        \ Also, view &BB (Save and load with the normal and
                        \ highlight fonts loaded) displays the normal font as
                        \ colour 1 on background colour 2 (white on red)
                        \
                        \ Finally, views &9D (Long-range Chart) and &DF (Start
                        \ screen) load the normal font into patterns 68 to 162,
                        \ rather than 66 to 160
                        \
                        \ The complete list of view types is therefore:
                        \
                        \   &00 = Space view
                        \         No fonts loaded, dashboard
                        \
                        \   &10 = Space view
                        \         Normal font loaded, dashboard
                        \
                        \   &01 = Title screen
                        \         No fonts loaded, dashboard
                        \
                        \   &92 = Mission 1 briefing: rotating ship
                        \         Normal font loaded, no dashboard
                        \
                        \   &93 = Mission 1 briefing: ship and text
                        \         Normal font loaded, no dashboard
                        \
                        \   &C4 = Game Over screen
                        \         No fonts loaded, no dashboard or icon bar
                        \
                        \   &95 = Text-based mission briefing
                        \         Normal font loaded, no dashboard
                        \
                        \   &96 = Data on System
                        \         Normal font loaded, no dashboard
                        \
                        \   &97 = Inventory
                        \         Normal font loaded, no dashboard
                        \
                        \   &98 = Status Mode
                        \         Normal font loaded, no dashboard
                        \
                        \   &B9 = Equip Ship
                        \         Normal and highlight fonts loaded, no
                        \         dashboard
                        \
                        \   &BA = Market Price
                        \         Normal and highlight fonts loaded, no
                        \         dashboard
                        \
                        \   &8B = Save and Load
                        \         No fonts loaded, no dashboard
                        \
                        \   &BB = Save and Load
                        \         Normal and highlight fonts loaded, special
                        \         colours for the normal font, no dashboard
                        \
                        \   &9C = Short-range Chart
                        \         Normal font loaded, no dashboard
                        \
                        \   &8D = Long-range Chart
                        \         No fonts loaded, no dashboard
                        \
                        \   &9D = Long-range Chart
                        \         Normal font loaded, no dashboard
                        \
                        \   &CF = Start screen
                        \         No fonts loaded, no dashboard or icon bar
                        \
                        \   &DF = Start screen
                        \         Normal font loaded, no dashboard or icon bar
                        \
                        \   &FF = Segue screen from Title screen to Demo
                        \         No fonts loaded, no dashboard or icon bar
                        \
                        \ In terms of fonts, then, these are the only options:
                        \
                        \   * No font is loaded
                        \
                        \   * The normal font is loaded
                        \
                        \   * The normal and highlight fonts are loaded
                        \
                        \   * The normal and highlight fonts are loaded, with
                        \     special colours for the normal font

.QQ11a

 SKIP 1                 \ Contains the old view type when changing views
                        \
                        \ When we change view, QQ11 gets set to the new view
                        \ number straight away while QQ11a stays set to the old
                        \ view type, only updating to the new view type once
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

.halfScreenHeight

 SKIP 1                 \ Half the height of the drawable part of the screen in
                        \ pixels (can be 72, 77 or 104 pixels)

.screenHeight

 SKIP 1                 \ The height of the drawable part of the screen in
                        \ pixels (can be 144, 154 or 208 pixels)

INCLUDE "library/master/main/variable/yx2m1.asm"
INCLUDE "library/advanced/main/variable/messxc.asm"

.messYC

 SKIP 1                 \ Used to specify the text row of the in-flight message
                        \ in MESS, so it can be shown at a different positions
                        \ in different views

INCLUDE "library/master/main/variable/newzp.asm"

.ASAV

 SKIP 1                 \ Temporary storage for saving the value of the A
                        \ register, used in the bank-switching routines in
                        \ bank 7

.firstFreePattern

 SKIP 1                 \ Contains the number of the first free pattern in the
                        \ pattern buffer that we can draw into next (or 0 if
                        \ there are no free patterns)
                        \
                        \ This variable is typically used to control the drawing
                        \ process - when we need to draw into a new tile when
                        \ drawing the space view, this is the number of the next
                        \ pattern to use for that tile

.pattBufferHiDiv8

 SKIP 1                 \ High byte of the address of the current pattern
                        \ buffer (&60 or &68) divided by 8

.SC2

 SKIP 2                 \ Temporary storage, typically used to store an address
                        \ when writing data to the PPU or into the buffers

.SC3

 SKIP 2                 \ Temporary storage, used to store an address in the
                        \ pattern buffers when drawing horizontal lines

.barButtons

 SKIP 2                 \ The address of the list of button numbers in the
                        \ iconBarButtons table for the current icon bar

.drawingBitplane

 SKIP 1                 \ Flipped manually by calling FlipDrawingPlane,
                        \ controls whether we are showing nametable/palette
                        \ buffer 0 or 1

.lastPattern

 SKIP 1                 \ The number of the last pattern entry to send from
                        \ pattern buffer 0 to bitplane 0 of the PPU pattern
                        \ table in the NMI handler

 SKIP 1                 \ The number of the last pattern entry to send from
                        \ pattern buffer 1 to bitplane 1 of the PPU pattern
                        \ table in the NMI handler

.clearingPattern

 SKIP 1                 \ The number of the first pattern to clear in pattern
                        \ buffer 0 when the NMI handler clears patterns
                        \
                        \ This variable is saved by the NMI handler so the
                        \ buffers can be cleared across multiple VBlanks

 SKIP 1                 \ The number of the first pattern to clear in pattern
                        \ buffer 1 when the NMI handler clears patterns
                        \
                        \ This variable is saved by the NMI handler so the
                        \ buffers can be cleared across multiple VBlanks

.clearingNameTile

 SKIP 1                 \ The number of the first tile to clear in nametable
                        \ buffer 0 when the NMI handler clears tiles, divided
                        \ by 8
                        \
                        \ This variable is saved by the NMI handler so the
                        \ buffers can be cleared across multiple VBlanks

 SKIP 1                 \ The number of the first tile to clear in nametable
                        \ buffer 1 when the NMI handler clears tiles, divided
                        \ by 8
                        \
                        \ This variable is saved by the NMI handler so the
                        \ buffers can be cleared across multiple VBlanks


.sendingNameTile

 SKIP 1                 \ The number of the most recent tile that was sent to
                        \ the PPU nametable by the NMI handler for bitplane
                        \ 0 (or the number of the first tile to send if none
                        \ have been sent), divided by 8
                        \
                        \ This variable is saved by the NMI handler so the
                        \ buffers can be cleared across multiple VBlanks

 SKIP 1                 \ The number of the most recent tile that was sent to
                        \ the PPU nametable by the NMI handler for bitplane
                        \ 1 (or the number of the first tile to send if none
                        \ have been sent), divided by 8
                        \
                        \ This variable is saved by the NMI handler so the
                        \ buffers can be cleared across multiple VBlanks

.patternCounter

 SKIP 1                 \ Counts patterns as they are written to the PPU pattern
                        \ table in the NMI handler
                        \
                        \ This variable is used internally by the
                        \ SendPatternsToPPU routine

.sendingPattern

 SKIP 1                 \ The number of the most recent pattern that was sent to
                        \ the PPU pattern table by the NMI handler for bitplane
                        \ 0 (or the number of the first pattern to send if none
                        \ have been sent)
                        \
                        \ This variable is saved by the NMI handler so the
                        \ buffers can be cleared across multiple VBlanks

 SKIP 1                 \ The number of the most recent pattern that was sent to
                        \ the PPU pattern table by the NMI handler for bitplane
                        \ 1 (or the number of the first pattern to send if none
                        \ have been sent)
                        \
                        \ This variable is saved by the NMI handler so the
                        \ buffers can be cleared across multiple VBlanks

.firstNameTile

 SKIP 1                 \ The number of the first tile for which we send
                        \ nametable data to the PPU in the NMI handler
                        \ (potentially for both bitplanes, if both are
                        \ configured to be sent)

.lastNameTile

 SKIP 1                 \ The number of the last nametable buffer entry to send
                        \ to the PPU nametable table in the NMI handler for
                        \ bitplane 0, divided by 8

 SKIP 1                 \ The number of the last nametable buffer entry to send
                        \ to the PPU nametable table in the NMI handler for
                        \ bitplane 1, divided by 8

.nameTileCounter

 SKIP 1                 \ Counts tiles as they are written to the PPU nametable
                        \ in the NMI handler
                        \
                        \ Contains the tile number divided by 8, so it counts up
                        \ 4 for every 32 tiles sent
                        \
                        \ We divide by 8 because there are 1024 entries in each
                        \ nametable, which doesn't fit into one byte, so we
                        \ divide by 8 so the maximum counter value is 128
                        \
                        \ This variable is used internally by the
                        \ SendNametableToPPU routine

.cycleCount

 SKIP 2                 \ Counts the number of CPU cycles left in the current
                        \ VBlank in the NMI handler

.firstPattern

 SKIP 1                 \ The number of the first pattern for which we send data
                        \ to the PPU in the NMI handler (potentially for both
                        \ bitplanes, if both are configured to be sent)

.barPatternCounter

 SKIP 1                 \ The number of icon bar nametable and pattern entries
                        \ that need to be sent to the PPU in the NMI handler
                        \
                        \   * 0 = send the nametable entries and the first four
                        \         patterns in the next NMI call (and update
                        \         barPatternCounter to 4 when done)
                        \
                        \   * 1-127 = counts the number of pattern bytes already
                        \             sent to the PPU, which get sent in batches
                        \             of four patterns (32 bytes), split across
                        \             multiple NMI calls, until we have send all
                        \             32 patterns and the value is 128
                        \
                        \   * 128 = do not send any tiles

.iconBarRow

 SKIP 2                 \ The row on which the icon bar appears
                        \
                        \ This is stored as an offset from the start of the
                        \ nametable buffer, so it's the number of the nametable
                        \ entry for the top-left tile of the icon bar
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

 SKIP 1                 \ A flag to control whether to send the icon bar's
                        \ patterns to the PPU, after sending the nametable
                        \ entries (this only applies if barPatternCounter = 0)
                        \
                        \   * Bit 7 set = do not send patterns
                        \
                        \   * Bit 7 clear = send patterns
                        \
                        \ This means that if barPatternCounter is set to zero
                        \ and bit 7 of skipBarPatternsPPU is set, then only the
                        \ nametable entries for the icon bar will be sent to the
                        \ PPU, but if barPatternCounter is set to zero and bit 7
                        \ of skipBarPatternsPPU is clear, both the nametable
                        \ entries and patterns will be sent

.maxNameTileToClear

 SKIP 1                 \ The tile number at which the NMI handler should stop
                        \ clearing tiles in the nametable buffers during its
                        \ clearing cycle

.asciiToPattern

 SKIP 1                 \ The number to add to an ASCII code to get the pattern
                        \ number in the PPU of the corresponding character image

.updatePaletteInNMI

 SKIP 1                 \ A flag that controls whether to send the palette data
                        \ from XX3 to the PPU during NMI:
                        \
                        \   * 0 = do not send palette data
                        \
                        \   * Non-zero = do send palette data

.patternBufferLo

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

.nameTileBuffLo

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

.nmiBitplane8

 SKIP 1                 \ Used when sending patterns to the PPU to calculate the
                        \ address offset of bitplanes 0 and 1
                        \
                        \ Gets set to nmiBitplane * 8 to given an offset of 0
                        \ for bitplane 0 and an offset of 8 for bitplane 1

.ppuPatternTableHi

 SKIP 1                 \ High byte of the address of the PPU pattern table to
                        \ which we send patterns
                        \
                        \ This is set to HI(PPU_PATT_1) in ResetScreen and
                        \ doesn't change again, so it always points to pattern
                        \ table 1 in the PPU, as that's the only pattern table
                        \ we use for storing patterns

.pattBufferAddr

 SKIP 2                 \ Address of the current pattern buffer:
                        \
                        \   * pattBuffer0 (&6000) when drawingBitplane = 0
                        \   * pattBuffer1 (&6800) when drawingBitplane = 1

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

.autoplayKeys

 SKIP 2                 \ The address of the table containing the key presses to
                        \ apply when auto-playing the demo
                        \
                        \ The address is either that of the chosen language's
                        \ autoplayKeys1 table (for the first part of the
                        \ auto-play demo, or the autoplayKeys2 table (for the
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

