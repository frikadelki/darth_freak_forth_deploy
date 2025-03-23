: FF_MAIN ( -- )
  |<
  400 20 + VAR $time
  s" Hello, it's " .. s"_ .. $time .. s"_ ..  s" o'clock. " .
  s" Have a good time! " .
  s" Bye. " .
;

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
