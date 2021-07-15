.new_min

 SKIP 1                 \ Our current ship's minimum pitch/roll rate
                        \
                        \ This is always equal to 255 - new_max, so when we buy
                        \ a new ship, the correct value is calculated rather
                        \ than being fetched from the new_details table (there
                        \ are default values for this in the new_details table,
                        \ though these are commented out)

