: FF_MAIN ( -- )
  |<
  400 20 + .
  |<
  BEGIN
    N_DOTS_RANDOM X_DOTS_WAIT |<
  AGAIN
;

: X_DOTS_WAIT ( Num $x -- )
  VAR $x
  BEGIN $x 1 - VAR $x
    s" . " ..
    0.25 SECONDS_WAIT
  $x 0 > UNTIL
;

: N_DOTS_RANDOM ( -- Num $n ) 10 RANDOM_INT 1 + ;
