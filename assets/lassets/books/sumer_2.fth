: FF_MAIN ( -- )
  BEGIN
    |< SUMER_RUN_GAME |<
    s" Try again? " ?ASK_YES_NO
  UNTIL
;

: SUMER_RUN_GAME ( -- )
  EMPIRE_START |<
  SUMER_YEARS_N SUMER_RULE_YEARS
  SUMER_RULE_END
  |< EMPIRE_END
;

: SUMER_RULE_YEARS ( Empire $empire Num $years -- Empire $empire )
  VAR $years
  0 VAR $year
  BEGIN $year 1 + VAR $year
    $year SUMER_RULE_SINGLE_YEAR VAR $success
    $success NOT IF
      RETURN
    THEN
  $year $years < UNTIL
;

: SUMER_RULE_SINGLE_YEAR ( Empire $empire Num $year -- Empire $empire Bool $success )
  VAR $year

  s" ! " .
  s" A new year dawns on your empire. " .
  CLASS_EMPIRE_TO_STRING

  s" ? " .
  SUMER_LAND_TRADE
  s" ? " .
  SUMER_FEED_DECIDE VAR $fedGrain
  s" ? " .
  SUMER_LAND_SOW_DECIDE VAR $sowedLand

  SUMER_DEFAULT_DOTS_WAIT

  $fedGrain SUMER_FEED_APPLY VAR $impeached
  $impeached IF
    SUMER_IMPEACHMENT_MESSAGE
    false RETURN
  THEN

  $sowedLand SUMER_LAND_SOW_APPLY

  SUMER_EVENT_RATS
  SUMER_EVENT_PLAGUE
  SUMER_EVENT_NOMADS

  SUMER_EVENT_?REVOLT IF
    SUMER_REVOLT_MESSAGE
    false RETURN
  THEN

  CLASS_EMPIRE_?ALIVE NOT IF
    SUMER_EMPIRE_IN_SHAMBLES_MESSAGE
    false RETURN
  THEN

  SUMER_DEFAULT_DOTS_WAIT

  CLASS_EMPIRE_YEAR_END
  true
;

: SUMER_RULE_END ( Empire $empire -- Empire $empire )
  s" ! " .
  s" Sumer rule ends. " .
  CLASS_EMPIRE_TO_STRING
  SUMER_DEFAULT_DOTS_WAIT
  s" ! " .
  SUMER_EMPIRE_STORY_STATUS
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
    $land CLASS_EMPIRE_LAND_HAS NOT IF
      s" You do not have that much land to sow. " .
      true
    ELSE
      $land SUMER_SOW_ACRES_PER_PERSON / CLASS_EMPIRE_POPULATION_HAS NOT IF
        s" You do not have enough people to sow that much land. " .
        true
      ELSE
        $land SUMER_SOW_BUSHELS_PER_ACRE * VAR $grainCost
        $grainCost CLASS_EMPIRE_GRAIN_HAS NOT IF
          s" You do not have enough grain to sow that much land. " .
          true
        ELSE
          $grainCost CLASS_EMPIRE_GRAIN_SUB
          false
        THEN
      THEN
    THEN
  UNTIL
  $land
;

: SUMER_LAND_SOW_APPLY ( Empire $empire Num $land -- Empire $empire )
  VAR $land
  SUMER_LAND_FERTILITY VAR $fertility
  $land $fertility * VAR $harvest
  $harvest CLASS_EMPIRE_GRAIN_ADD
  s" Harvested " .. s"_ .. $fertility .. s"_ .. s" bushels of grain per acre. " .
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

: SUMER_FEED_APPLY ( Empire $empire Num $grain -- Empire $empire Bool $impeached )
  SUMER_PERSON_RATION ~/ VAR $fedPeople
  CLASS_EMPIRE_POPULATION_GET VAR $originalPopulation
  $originalPopulation $fedPeople - VAR $starvedPeople
  $starvedPeople 0 > IF
    $starvedPeople CLASS_EMPIRE_POPULATION_SUB
    $starvedPeople .. s"_ .. s" people starved to death. " .
  THEN
  $originalPopulation $starvedPeople SUMER_PEOPLE_STARVED_?IMPEACHED
;

: SUMER_EVENT_RATS ( Empire $empire -- Empire $empire )
  CLASS_EMPIRE_GRAIN_GET VAR $grain
  $grain 0 <= IF RETURN THEN
  100 RANDOM_INT 75 < NOT IF RETURN THEN
  $grain 25 RANDOM_INT * 100 ~/ 1 + VAR $grainLoss
  $grainLoss CLASS_EMPIRE_GRAIN_SUB
  s" Rats ate " .. s"_ .. $grainLoss .. s"_ .. s" bushels of grain. " .
;

: SUMER_EVENT_PLAGUE ( Empire $empire -- Empire $empire )
  CLASS_EMPIRE_POPULATION_GET VAR $population
  $population 0 <= IF RETURN THEN
  100 RANDOM_INT 15 < NOT IF RETURN THEN
  $population 2 ~/ RANDOM_INT 1 + VAR $plaguePeople
  $plaguePeople CLASS_EMPIRE_POPULATION_SUB
  s" Horrible plague struck and killed " .. s"_ .. $plaguePeople .. s"_ .. s" people. " .
;

: SUMER_EVENT_NOMADS ( Empire $empire -- Empire $empire )
  CLASS_EMPIRE_POPULATION_GET 15 RANDOM_INT * 100 ~/ 1 + VAR $nomads
  $nomads CLASS_EMPIRE_POPULATION_ADD
  $nomads .. s"_ .. s" nomads joined your empire. " .
;

: SUMER_EVENT_?REVOLT ( Empire $empire -- Empire $empire Bool $revolt )
  CLASS_EMPIRE_LAND_GET VAR $land
  $land 0 <= IF true RETURN THEN
  CLASS_EMPIRE_POPULATION_GET VAR $population
  $population 0 <= IF true RETURN THEN
  $land $population / 1 <
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

: SUMER_IMPEACHMENT_MESSAGE ( -- )
  s" Due to extreme mismanagement you have not only been impeached and " .. s"_ ..
  s" thrown out of office, but you have also been declared national fink!!!! " .
;

: SUMER_REVOLT_MESSAGE ( -- )
  s" People have risen up against you! " .
;

: SUMER_EMPIRE_IN_SHAMBLES_MESSAGE ( -- )
  s" Empire is in shambles! " .
;

: SUMER_EMPIRE_STORY_STATUS ( Empire $empire -- Empire $empire )
  CLASS_EMPIRE_POPULATION_GET VAR $population
  CLASS_EMPIRE_LAND_GET VAR $land
  CLASS_EMPIRE_GRAIN_GET VAR $grain

  $land $population / VAR $density
  $density 8 <= IF
    s" CRAMPED " ..
  ELSE $density 11 <= IF
    s" MEDIOCRE " ..
  ELSE
    s" VAST " ..
  THEN THEN

  s"_ ..

  $grain $population / VAR $grainPerPerson
  $grainPerPerson SUMER_PERSON_RATION < IF
    s" STARVING " ..
  ELSE $grainPerPerson SUMER_PERSON_RATION 1.5 * < IF
    s" SATISFIED " ..
  ELSE
    s" LUSH " ..
  THEN THEN

  s"_ ..

  s" EMPIRE " .
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

: SUMER_LAND_FERTILITY_MAX ( -- Num $fertility ) 4 ;

: SUMER_SOW_BUSHELS_PER_ACRE ( -- Num $bushels ) 1 ;

: SUMER_SOW_ACRES_PER_PERSON ( -- Num $acres ) 13 ;

: SUMER_PERSON_RATION ( -- Num $ration ) 20 ;

: SUMER_PEOPLE_STARVED_?IMPEACHED ( Num $population Num $starved -- Bool $impeached )
  VAR $starved
  100 / 25 * VAR $starvedImpeachmentThreshold
  $starved $starvedImpeachmentThreshold >=
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
  # population 100 MAP_SET
  # land 1000 MAP_SET
  # grain 3000 MAP_SET
;

: CLASS_EMPIRE_YEAR_END ( Empire $empire -- Empire $empire )
  # age MAP_GET VAR $oldAge
  # age $oldAge 1 + MAP_SET
;

: CLASS_EMPIRE_?ALIVE ( Empire $empire -- Empire $empire Bool $alive )
  # population MAP_GET 0 > NOT IF false RETURN THEN
  # land MAP_GET 0 > NOT IF false RETURN THEN
  true
;

: CLASS_EMPIRE_POPULATION_GET ( Empire $empire -- Empire $empire Num $population )
  # population MAP_GET
;

: CLASS_EMPIRE_POPULATION_HAS ( Empire $empire Num $amount -- Empire $empire Bool $hasEnough )
  VAR $amount
  # population MAP_GET $amount >=
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
