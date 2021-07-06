.cmdr_cour

 SKIP 2                 \ The mission counter for the current special cargo
                        \ delivery destination
                        \
                        \ While doing a special cargo delivery, this counter is
                        \ halved on every visit to a station (and again if we
                        \ choose to pay a docking fee), and if it runs down to
                        \ zero, the mission is lost

