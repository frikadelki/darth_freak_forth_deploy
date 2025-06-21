: FF_MAIN ( -- )
  |<
  400 20 + .
  |<
  DO_THING_TEST
  |<
;

: DO_THING_TEST ( -- )
  BEGIN
    s" Enter something: " .. s"_ ..
    ?ASK_NUMBER NOT IF
      s" Not a number! " .
    ELSE 666 == IF
      s" 666! " .
      RETURN
    ELSE
      s" Other number! " .
    THEN THEN
  true UNTIL
;
