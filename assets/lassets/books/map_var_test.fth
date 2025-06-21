: FF_MAIN ( -- )
  s" Hello " . |<

  MAP_NEW

  # name s" John Doe " MAP_SET
  # age 0 MAP_SET
  USER_MAP_PRINT |<

  # age 10 MAP_SET
  USER_MAP_PRINT |<

  # age MAP_GET VAR $age
  # age $age 12 + MAP_SET
  USER_MAP_PRINT |<

  s" Change age to: " .. s"_ ..
  ?ASK_NUMBER NOT IF 666 THEN VAR $age
  # age $age MAP_SET
  USER_MAP_PRINT |<

  DROP

  s" Bye " . |<
;

: USER_MAP_PRINT ( Map $user -- Map $user )
  # name MAP_GET .
  # age MAP_GET .
;
