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

: ?ASK_NUMBER ( -- ?Num $number Bool $success ) BIN_USER_INPUT_ASK_FOR_NUMBER ;

: .. ( Any $in -- ) BIN_STDOUT_STACK_TOP_PRINT ;

: . ( Any $in -- ) BIN_STDOUT_STACK_TOP_PRINTLN ;

: |< ( -- ) BIN_STDOUT_EXT_NEWLINE ;

: s"_ ( -- String $space ) BIN_STACK_EXT_PUSH_SPACE ;

: s": ( -- String $colon ) BIN_STACK_EXT_PUSH_COLON ;

: NOP ( -- ) ;

: DUP ( Any $in -- Any $copy0 Any $copy1 ) BIN_STACK_DUP ;

: DROP ( Any $in -- ) BIN_STACK_DROP ;

: SWAP ( Any $a Any $b -- Any $b Any $a ) BIN_STACK_SWAP ;
