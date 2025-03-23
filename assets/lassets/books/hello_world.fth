: FF_MAIN ( -- )
  HELLO_WORLD_A |<
  HELLO_WORLD_B |<
  HELLO_WORLD_B_1 |<
  HELLO_WORLD_C |<
  HELLO_WORLD_D |<
;

: HELLO_WORLD_A ( -- )
  HELLO_WORLD_A_LABEL .
  400 20 + .
  1 2 3 + * .
  3 2 1 + * .
  true .
  false .
  HELLO_WORLD_A_LABEL .. s"_ .. s" ends here and newline will follow " .. |<
;

: HELLO_WORLD_A_LABEL ( -- String $label ) s" !Hello, World A! " ;

: HELLO_WORLD_B ( -- )
  s" Hello, World B! " .
  0 BEGIN 1 +
    s" i: " .. s"_ .. DUP .
  DUP 5 < UNTIL DROP
;

: HELLO_WORLD_B_1 ( -- )
  s" Hello, World B_1! " .
  0 BEGIN 1 + DUP 5 < WHILE
    s" i: " .. s"_ .. DUP .
  REPEAT DROP
;

: HELLO_WORLD_C ( -- )
  s" Hello, World C! " .
  1 HWC_INPUT_NUMBER
  2 HWC_INPUT_NUMBER
  +
  s" Sum is " .. s"_ .. DUP .
  DUP ?EVEN IF
    s" Sum is even! " .
  ELSE
    s" Sum is not even! " .
  THEN
  DUP ?ODD IF
    s" Sum is odd! " .
  ELSE
    s" Sum is not odd! " .
  THEN
  DROP
  s" Fun, huh?! " .
;

: HWC_INPUT_NUMBER ( Any $label -- Num $number )
  s" % Enter number " .. s"_ .. NOP .. s": .. s"_ ..
  ?ASK_NUMBER NOT IF
    0
  THEN
   s" > Entered: " .. s"_ .. DUP .
;

: HELLO_WORLD_D ( -- )
  s" Hello, World D! " .
  22 VAR $a
  34 VAR $b
  $a $b + .
  $a $b * .
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
