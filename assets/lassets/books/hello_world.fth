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
