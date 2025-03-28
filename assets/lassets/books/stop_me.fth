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

: ?EVEN ( Num $num -- Bool $isEven ) 2 % 0 == ;

: ?ODD ( Num $num -- Bool $isOdd ) 2 % 0 <> ;

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
