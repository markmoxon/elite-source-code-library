.dontclip

IF NOT(_C64_VERSION)

 SKIP 1                 \ This is set to 0 in the RES2 routine, but the value is
                        \ never actually read (this is left over from the
                        \ Commodore 64 version of Elite)

ELIF _C64_VERSION

 SKIP 1                 \ A flag that contols whether the LL145 routine clips
                        \ lines to the dimensions of the space view (which we
                        \ want to disable in the Short-range Chart, as there is
                        \ no dashboard and the chart needs to use the whole
                        \ screen)
                        \
                        \   * Bit 7 clear = clipping is enabled
                        \
                        \   * Bit 7 set = clipping is disabled

ENDIF

