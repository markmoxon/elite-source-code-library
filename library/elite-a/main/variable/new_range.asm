.new_range

 SKIP 1                 \ Our current ship's hyperspace range (i.e. the size of
                        \ the fuel tank)
                        \
                        \ The range is stored as the number of light years
                        \ multiplied by 10, so a value of 1 represents 0.1 light
                        \ years, while 70 represents 7.0 light years
                        \
                        \ When we buy a new ship, this is set to the relevant
                        \ value from the ship's flight characteristics table
                        \ at new_details

