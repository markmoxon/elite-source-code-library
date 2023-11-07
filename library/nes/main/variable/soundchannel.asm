\ ******************************************************************************
\
\       Name: soundChannel
\       Type: Variable
\   Category: Sound
\    Summary: The sound channels used by each sound effect
\  Deep dive: Sound effects in NES Elite
\
\ ------------------------------------------------------------------------------
\
\ The sound channels used by each sound are defined as follows:
\
\   * If soundChannel = 0, use the SQ1 sound channel
\
\   * If soundChannel = 1, use the SQ2 sound channel
\
\   * If soundChannel = 2, use the NOISE sound channel
\
\   * If soundChannel = 3, use the SQ1 and NOISE sound channels
\
\   * If soundChannel = 4, use the SQ2 and NOISE sound channels
\
\ ******************************************************************************

.soundChannel

 EQUB 2                 \ Sound  0
 EQUB 1                 \ Sound  1
 EQUB 1                 \ Sound  2
 EQUB 1                 \ Sound  3
 EQUB 1                 \ Sound  4
 EQUB 0                 \ Sound  5
 EQUB 0                 \ Sound  6
 EQUB 1                 \ Sound  7
 EQUB 2                 \ Sound  8
 EQUB 2                 \ Sound  9
 EQUB 2                 \ Sound 10
 EQUB 2                 \ Sound 11
 EQUB 3                 \ Sound 12
 EQUB 2                 \ Sound 13
 EQUB 2                 \ Sound 14
 EQUB 0                 \ Sound 15
 EQUB 0                 \ Sound 16
 EQUB 0                 \ Sound 17
 EQUB 0                 \ Sound 18
 EQUB 0                 \ Sound 19
 EQUB 2                 \ Sound 20
 EQUB 3                 \ Sound 21
 EQUB 3                 \ Sound 22
 EQUB 2                 \ Sound 23
 EQUB 1                 \ Sound 24
 EQUB 2                 \ Sound 25
 EQUB 0                 \ Sound 26
 EQUB 2                 \ Sound 27
 EQUB 0                 \ Sound 28
 EQUB 1                 \ Sound 29
 EQUB 0                 \ Sound 30
 EQUB 0                 \ Sound 31

