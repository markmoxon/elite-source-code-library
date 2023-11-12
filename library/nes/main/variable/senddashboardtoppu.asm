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

