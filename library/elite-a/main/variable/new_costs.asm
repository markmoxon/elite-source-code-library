.new_costs

 SKIP 1                 \ The price table offset for our current ship
                        \
                        \ In Elite-A the PRXS table (which contains equipment
                        \ prices) has multiple sections, for the different types
                        \ of ship we can buy, and the offset into this table for
                        \ our current ship is held here
                        \
                        \ When we buy a new ship, this is set to the relevant
                        \ value from the ship's flight characteristics table
                        \ at new_details

