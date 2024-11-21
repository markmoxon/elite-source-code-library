.TRIBVX

 SKIP 16                \ Contains the low byte of the 16-bit x-axis velocity
                        \ of each of the Trumbles
                        \
                        \ Also contains the 8-bit y-axis velocity
                        \
                        \ The 16-bit x-axis velocity for Trumble Y is stored in
                        \ (TRIBVXH+Y*2 TRIBVX+Y*2), for Y = 0 to 5
                        \
                        \ The 8-bit y-axis velocity for Trumble Y is stored in
                        \ TRIBVX + Y*2 + 1, for Y = 0 to 5

