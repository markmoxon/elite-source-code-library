.TALLYF

 SKIP 1                 \ Combat rank fraction
                        \
                        \ Contains the fraction part of the kill count, which
                        \ together with the integer in TALLY(1 0) determines our
                        \ combat rank. The fraction is stored as the numerator
                        \ of a fraction with a denominator of 256, so a TALLYF
                        \ of 128 would represent 0.5 (i.e. 128 / 256)

