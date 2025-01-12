\ ******************************************************************************
\
\       Name: UNIV
\       Type: Variable
\   Category: Universe
\    Summary: Table of pointers to the local universe's ship data blocks
\  Deep dive: The local bubble of universe
\             Ship data blocks
\
IF _NES_VERSION
\ ------------------------------------------------------------------------------
\
\ Note that in the NES version, there are four extra bytes at the end of each K%
\ block that don't form part of the core ship block, so each ship in K% contains
\ NIK% = NI% + 4 bytes, rather than NI%.
\
ENDIF
\ ******************************************************************************

.UNIV

IF NOT(_NES_VERSION)

 FOR I%, 0, NOSH

  EQUW K% + I% * NI%    \ Address of block no. I%, of size NI%, in workspace K%

 NEXT

ELIF _NES_VERSION

 FOR I%, 0, NOSH

  EQUW K% + I% * NIK%   \ Address of block no. I%, of size NIK%, in workspace K%

 NEXT

ENDIF

