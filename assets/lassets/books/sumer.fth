: FF_MAIN ( -- )
  |<
  400 20 + .
  |<

  |<
  EMPIRE_START |<
  C_YEARS_N SUMER_RULE_YEARS |<
  SUMER_RULE_END |<
  EMPIRE_END |<
  |<
;

: SUMER_RULE_YEARS ( Empire $empire Num $years -- Empire $empire )
  VAR $years
  0 VAR $year
  BEGIN $year 1 + VAR $year
    s" Sumer year " .. s"_ .. $year .
    $year SUMER_RULE_SINGLE_YEAR
    $year $years < IF |< THEN
  $year $years < UNTIL
;

: SUMER_RULE_SINGLE_YEAR ( Empire $empire Num $year -- Empire $empire )
  ?SUMER_YEAR_DECISION IF
    CLASS_EMPIRE_GROW
  THEN
  CLASS_EMPIRE_YEAR_END
  |<
  4 SUMER_X_DOTS_WAIT
  |<
;

: ?SUMER_YEAR_DECISION ( Num $year -- Bool $success )
  VAR $year
  s" DECIDE: " .. s"_ ..
  ?ASK_NUMBER IF
    $year +
    ?EVEN IF
      true
    ELSE
      false
    THEN
  ELSE
    false
  THEN
  DUP IF
    s" Success! " .
  ELSE
    s" Failure! " .
  THEN
;

: SUMER_X_DOTS_WAIT ( Num $x -- )
  VAR $x
  BEGIN $x 1 - VAR $x
    s" . " ..
    0.25 SECONDS_WAIT
  $x 0 > UNTIL
;

: SUMER_RULE_END ( Empire $empire -- Empire $empire )
  s" Sumer rule ends. " .
  CLASS_EMPIRE_TO_STRING
;

: EMPIRE_START ( -- Empire $empire )
  CLASS_EMPIRE_NEW
  s" Empire started. " .
;

: EMPIRE_END ( Empire $empire -- )
  DROP
  s" Empire ended. " .
;

: CLASS_EMPIRE_NEW ( -- Empire $empire )
  MAP_NEW
  # age 0 MAP_SET
  # status 0 MAP_SET
  # gold 10 MAP_SET
;

: CLASS_EMPIRE_GROW ( Empire $empire -- Empire $empire )
  # status MAP_GET 1 + # status SWAP MAP_SET
;

: CLASS_EMPIRE_YEAR_END ( Empire $empire -- Empire $empire )
  # age MAP_GET 1 + # age SWAP MAP_SET
  # gold MAP_GET 10 + # gold SWAP MAP_SET
;

: CLASS_EMPIRE_TO_STRING ( Empire $empire -- Empire $empire )
  s" Age: " .. s"_ .. # age MAP_GET .
  s" Status: " .. s"_ .. # status MAP_GET _CLASS_EMPIRE_STATUS_NAME .
  s" Gold: " .. s"_ .. # gold MAP_GET .
;

: _CLASS_EMPIRE_STATUS_NAME ( Num $status -- String $name )
  VAR $status
  $status C_STATUS_JOKE <= IF
    s" What a joke. "
  ELSE  $status C_STATUS_OK <= IF
    s" Ok. "
  ELSE $status C_STATUS_WOW <= IF
    s" Wow! "
  ELSE
    s" Rotten !!! "
  THEN THEN THEN
;

: C_YEARS_N ( -- Num $years ) 5 ;

: C_STATUS_JOKE ( -- Num $threshold ) 1 ;

: C_STATUS_OK ( -- Num $threshold ) 2 ;

: C_STATUS_WOW ( -- Num $threshold ) 4 ;
