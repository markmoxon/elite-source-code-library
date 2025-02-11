.TALLY

 SKIP 2                 \ Our combat rank
                        \
                        \ The combat rank is stored as the number of kills, in a
                        \ 16-bit number TALLY(1 0) - so the high byte is in
                        \ TALLY+1 and the low byte in TALLY
IF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION \ Comment
                        \
                        \ There is also a fractional part of the kill count,
                        \ which is stored in TALLYL
ENDIF
IF NOT(_NES_VERSION)
                        \
                        \ If the high byte in TALLY+1 is 0 then we have between
                        \ 0 and 255 kills, so our rank is Harmless, Mostly
                        \ Harmless, Poor, Average Above Average or Competent,
                        \ according to the value of the low byte in TALLY:
                        \
                        \   Harmless         %00000000 to %00000111 = 0 to 7
                        \   Mostly Harmless  %00001000 to %00001111 = 8 to 15
                        \   Poor             %00010000 to %00011111 = 16 to 31
                        \   Average          %00100000 to %00111111 = 32 to 63
                        \   Above Average    %01000000 to %01111111 = 64 to 127
                        \   Competent        %10000000 to %11111111 = 128 to 255
                        \
                        \ Note that the Competent range also covers kill counts
                        \ from 256 to 511, as follows
                        \
                        \ If the high byte in TALLY+1 is non-zero then we are
                        \ Competent, Dangerous, Deadly or Elite, according to
                        \ the value of TALLY(1 0):
                        \
                        \   Competent   (1 0) to (1 255)   = 256 to 511 kills
                        \   Dangerous   (2 0) to (9 255)   = 512 to 2559 kills
                        \   Deadly      (10 0) to (24 255) = 2560 to 6399 kills
                        \   Elite       (25 0) and up      = 6400 kills and up
                        \
                        \ You can see the rating calculation in the STATUS
                        \ subroutine
ELIF _NES_VERSION
                        \
                        \ The NES version calculates the combat rank differently
                        \ to the other versions of Elite. The combat status is
                        \ given by the number of kills in TALLY(1 0), as
                        \ follows:
                        \
                        \   * Harmless        when TALLY(1 0) = 0 or 1
                        \   * Mostly Harmless when TALLY(1 0) = 2 to 7
                        \   * Poor            when TALLY(1 0) = 8 to 23
                        \   * Average         when TALLY(1 0) = 24 to 43
                        \   * Above Average   when TALLY(1 0) = 44 to 129
                        \   * Competent       when TALLY(1 0) = 130 to 511
                        \   * Dangerous       when TALLY(1 0) = 512 to 2559
                        \   * Deadly          when TALLY(1 0) = 2560 to 6399
                        \   * Elite           when TALLY(1 0) = 6400 or more
                        \
                        \ You can see the rating calculation in the
                        \ PrintCombatRank subroutine
ENDIF

