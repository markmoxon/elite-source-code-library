.firstFreePattern

 SKIP 1                 \ Contains the number of the first free pattern in the
                        \ pattern buffer that we can draw into next (or 0 if
                        \ there are no free patterns)
                        \
                        \ This variable is typically used to control the drawing
                        \ process - when we need to draw into a new tile when
                        \ drawing the space view, this is the number of the next
                        \ pattern to use for that tile

