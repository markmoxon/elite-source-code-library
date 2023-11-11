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

