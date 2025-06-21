: ?ASK_YES_NO ( String $prompt -- Bool $answer )
  .. s"_ .. READ_LINE VAR $answer
  $answer s" yes " == IF
    true RETURN
  THEN
  $answer s" y " == IF
    true RETURN
  THEN
  $answer s" true " == IF
    true RETURN
  THEN
  $answer s" t " == IF
    true RETURN
  THEN
  $answer s" 1 " == IF
    true RETURN
  THEN
  false
;

: WAIT_ANY_LINE ( -- )
  s" Enter any line to continue... " .. READ_LINE DROP
;

: ?EVEN ( Num $num -- Bool $isEven ) 2 % 0 == ;

: ?ODD ( Num $num -- Bool $isOdd ) 2 % 0 <> ;
