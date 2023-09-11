.TALLY

 SKIP 2                 \ Our combat rank
                        \
                        \ The combat rank is stored as the number of kills, in a
                        \ 16-bit number TALLY(1 0) - so the high byte is in
                        \ TALLY+1 and the low byte in TALLY
IF _MASTER_VERSION OR _NES_VERSION \ Comment
                        \
                        \ There is also a fractional part of the kill count,
                        \ which is stored in TALLYL
ENDIF
IF NOT(_NES_VERSION)
                        \
                        \ If the high byte in TALLY+1 is 0 then we have between
                        \ 0 and 255 kills, so our rank is Harmless, Mostly
                        \ Harmless, Poor, Average or Above Average, according to
                        \ the value of the low byte in TALLY:
                        \
                        \   Harmless        = %00000000 to %00000011 = 0 to 3
                        \   Mostly Harmless = %00000100 to %00000111 = 4 to 7
                        \   Poor            = %00001000 to %00001111 = 8 to 15
                        \   Average         = %00010000 to %00011111 = 16 to 31
                        \   Above Average   = %00100000 to %11111111 = 32 to 255
                        \
                        \ If the high byte in TALLY+1 is non-zero then we are
                        \ Competent, Dangerous, Deadly or Elite, according to
                        \ the high byte in TALLY+1:
                        \
                        \   Competent       = 1           = 256 to 511 kills
                        \   Dangerous       = 2 to 9      = 512 to 2559 kills
                        \   Deadly          = 10 to 24    = 2560 to 6399 kills
                        \   Elite           = 25 and up   = 6400 kills and up
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

