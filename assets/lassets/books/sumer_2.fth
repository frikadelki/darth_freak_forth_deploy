: FF_MAIN ( -- )
  |<
  EMPIRE_START |<
  SUMER_YEARS_N SUMER_RULE_YEARS |<
  SUMER_RULE_END |<
  EMPIRE_END |<
  |<
;

: SUMER_RULE_YEARS ( Empire $empire Num $years -- Empire $empire )
  VAR $years
  0 VAR $year
  BEGIN $year 1 + VAR $year
    $year SUMER_RULE_SINGLE_YEAR
  $year $years < UNTIL
;

: SUMER_RULE_SINGLE_YEAR ( Empire $empire Num $year -- Empire $empire )
  VAR $year
  s" ! A new year dawns on our empire. " .
  CLASS_EMPIRE_TO_STRING |<

  SUMER_LAND_TRADE |<
  SUMER_FEED_DECIDE VAR $fedGrain |<
  SUMER_LAND_SOW_DECIDE VAR $sowedLand |<

  SUMER_DEFAULT_DOTS_WAIT |<

  $fedGrain SUMER_FEED_APPLY
  $sowedLand SUMER_LAND_SOW_APPLY
  CLASS_EMPIRE_YEAR_END
  |<

  SUMER_DEFAULT_DOTS_WAIT |<
;

: SUMER_RULE_END ( Empire $empire -- Empire $empire )
  s" ! Sumer rule ends. " .
  CLASS_EMPIRE_TO_STRING |<
;

: SUMER_LAND_TRADE ( Empire $empire -- Empire $empire )
  SUMER_LAND_PRICE VAR $landPrice
  s" Land is trading at " .. s"_ .. $landPrice .. s"_ ..
  s" bushels of grain per acre. " .
  BEGIN
    s" How many acres of land do you want to buy? "
    SUMER_SOLICIT_NUMBER VAR $land
    $land $landPrice * VAR $cost
    $cost CLASS_EMPIRE_GRAIN_HAS IF
      $cost CLASS_EMPIRE_GRAIN_SUB
      $land CLASS_EMPIRE_LAND_ADD
      false
    ELSE
      s" You do not have enough grain to buy that much land. " .
      true
    THEN
  UNTIL
  BEGIN
    s" How many acres of land do you want to sell? "
    SUMER_SOLICIT_NUMBER VAR $land
    $land CLASS_EMPIRE_LAND_HAS IF
      $land $landPrice * VAR $cost
      $cost CLASS_EMPIRE_GRAIN_ADD
      $land CLASS_EMPIRE_LAND_SUB
      false
    ELSE
      s" You do not have enough land to sell. " .
      true
    THEN
  UNTIL
;

: SUMER_LAND_SOW_DECIDE ( Empire $empire -- Empire $empire Num $land )
  BEGIN
    s" How many acres of land do you want to sow with grain? "
    SUMER_SOLICIT_NUMBER VAR $land
    $land CLASS_EMPIRE_LAND_HAS VAR $hasEnoughLand
    $land 1 * VAR $grainCost
    $grainCost CLASS_EMPIRE_GRAIN_HAS VAR $hasEnoughGrain
    $hasEnoughLand NOT IF
      s" You do not have that much land to sow. " .
      true
    ELSE $hasEnoughGrain NOT IF
      s" You do not have enough grain to sow that much land. " .
      true
    ELSE
      $grainCost CLASS_EMPIRE_GRAIN_SUB
      false
    THEN THEN
  UNTIL
  $land
;

: SUMER_LAND_SOW_APPLY ( Empire $empire Num $land -- Empire $empire )
  VAR $land
  SUMER_LAND_FERTILITY VAR $fertility
  $land $fertility * VAR $harvest
  $harvest CLASS_EMPIRE_GRAIN_ADD
  s" You harvested " .. s"_ .. $fertility .. s"_ .. s" bushels of grain per acre. " .
;

: SUMER_FEED_DECIDE ( Empire $empire -- Empire $empire Num $grain )
  BEGIN
    s" How many bushels of grain do you want to feed your people? "
    SUMER_SOLICIT_NUMBER VAR $grain
    $grain CLASS_EMPIRE_GRAIN_HAS IF
      $grain CLASS_EMPIRE_GRAIN_SUB
      false
    ELSE
      s" You do not have that much grain to feed your people. " .
      true
    THEN
  UNTIL
  $grain
;

: SUMER_FEED_APPLY ( Empire $empire Num $grain -- Empire $empire )
  SUMER_PERSON_RATION ~/ VAR $fedPeople
  CLASS_EMPIRE_POPULATION_GET $fedPeople - VAR $starvedPeople
  $starvedPeople 0 > IF
    $starvedPeople CLASS_EMPIRE_POPULATION_SUB
    $starvedPeople .. s"_ .. s" people starved to death. " .
  THEN
;

: SUMER_SOLICIT_NUMBER ( String $prompt -- Num $number )
  VAR $prompt
  BEGIN
    $prompt .. s"_ ..
    ?ASK_NUMBER VAR $success
    $success NOT IF
      s" Think again. " .
    THEN
  $success NOT UNTIL
;

: SUMER_DEFAULT_DOTS_WAIT ( -- ) 3 SUMER_X_DOTS_WAIT |< ;

: SUMER_X_DOTS_WAIT ( Num $x -- )
  VAR $x
  BEGIN $x 1 - VAR $x
    s" . " ..
    0.25 SECONDS_WAIT
  $x 0 > UNTIL
;

: SUMER_YEARS_N ( -- Num $years ) 5 ;

: SUMER_LAND_PRICE ( -- Num $price )
  SUMER_LAND_PRICE_MAX SUMER_LAND_PRICE_MIN - 1 + RANDOM_INT
  SUMER_LAND_PRICE_MIN +
;

: SUMER_LAND_PRICE_MIN ( -- Num $price ) 17 ;

: SUMER_LAND_PRICE_MAX ( -- Num $price ) 26 ;

: SUMER_LAND_FERTILITY ( -- Num $fertility )
  SUMER_LAND_FERTILITY_MAX SUMER_LAND_FERTILITY_MIN - 1 + RANDOM_INT
  SUMER_LAND_FERTILITY_MIN +
;

: SUMER_LAND_FERTILITY_MIN ( -- Num $fertility ) 1 ;

: SUMER_LAND_FERTILITY_MAX ( -- Num $fertility ) 3 ;

: SUMER_PERSON_RATION ( -- Num $ration ) 20 ;

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
  # population 100 MAP_SET
  # land 1000 MAP_SET
  # grain 3000 MAP_SET
;

: CLASS_EMPIRE_YEAR_END ( Empire $empire -- Empire $empire )
  # age MAP_GET VAR $oldAge
  # age $oldAge 1 + MAP_SET
;

: CLASS_EMPIRE_POPULATION_GET ( Empire $empire -- Empire $empire Num $population )
  # population MAP_GET
;

: CLASS_EMPIRE_POPULATION_ADD ( Empire $empire Num $population -- Empire $empire )
  VAR $population
  # population MAP_GET VAR $old
  # population $old $population + MAP_SET
;

: CLASS_EMPIRE_POPULATION_SUB ( Empire $empire Num $population -- Empire $empire )
  VAR $population
  # population MAP_GET VAR $old
  # population $old $population - MAP_SET
;

: CLASS_EMPIRE_LAND_GET ( Empire $empire -- Empire $empire Num $land )
  # land MAP_GET
;

: CLASS_EMPIRE_LAND_HAS ( Empire $empire Num $amount -- Empire $empire Bool $hasEnough )
  VAR $amount
  # land MAP_GET $amount >=
;

: CLASS_EMPIRE_LAND_ADD ( Empire $empire Num $amount -- Empire $empire )
  VAR $amount
  # land MAP_GET VAR $old
  # land $old $amount + MAP_SET
;

: CLASS_EMPIRE_LAND_SUB ( Empire $empire Num $amount -- Empire $empire )
  VAR $amount
  # land MAP_GET VAR $old
  # land $old $amount - MAP_SET
;

: CLASS_EMPIRE_GRAIN_GET ( Empire $empire -- Empire $empire Num $grain )
  # grain MAP_GET
;

: CLASS_EMPIRE_GRAIN_HAS ( Empire $empire Num $amount -- Empire $empire Bool $hasEnough )
  VAR $amount
  # grain MAP_GET $amount >=
;

: CLASS_EMPIRE_GRAIN_ADD ( Empire $empire Num $amount -- Empire $empire )
  VAR $amount
  # grain MAP_GET VAR $old
  # grain $old $amount + MAP_SET
;

: CLASS_EMPIRE_GRAIN_SUB ( Empire $empire Num $amount -- Empire $empire )
  VAR $amount
  # grain MAP_GET VAR $old
  # grain $old $amount - MAP_SET
;

: CLASS_EMPIRE_TO_STRING ( Empire $empire -- Empire $empire )
  s" Age: " .. s"_ .. # age MAP_GET .. s"_ .. s" years. " .
  s" Population: " .. s"_ .. # population MAP_GET .. s"_ .. s" people. " .
  s" Land: " .. s"_ .. # land MAP_GET .. s"_ .. s" acres. " .
  s" Grain: " .. s"_ .. # grain MAP_GET .. s"_ .. s" bushels. " .
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
