.new_hold

 SKIP 1                 \ The amount of free space in our current ship's hold
                        \
                        \ The value is actually the amount of free space plus 1,
                        \ as this makes the maths slightly easier in the tnpr
                        \ routine
                        \
                        \ In Elite-A, hold space is taken up by both equipment
                        \ and cargo
                        \
                        \ When we buy a new ship, this is set to the relevant
                        \ value from the new_details table

