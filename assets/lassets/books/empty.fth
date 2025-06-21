: FF_MAIN ( -- )
  |<
  400 20 + VAR $time
  s" Hello, it's " .. s"_ .. $time .. s"_ ..  s" o'clock. " .
  s" Have a good time! " .
  s" Bye. " .
;
