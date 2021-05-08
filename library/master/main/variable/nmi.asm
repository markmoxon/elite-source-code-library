IF _COMPACT

.NMI

 SKIP 1                 \ Used to store the ID of the current owner of the NMI
                        \ workspace in the NMICLAIM routine, so we can hand it
                        \ back to them in the NMIRELEASE routine once we are
                        \ done using it

ENDIF

