: FF_MAIN ( -- )
  _MAIN
  READ_LINE DROP
;

: _MAIN ( -- )
  |<

  s" This is The Original Series Star Trek Star Fleet training exercise. " .
  DEFAULT_DOTS_WAIT

  s" Your ship patrols the border between the Federation Space and the Klingon Empire. " .
  DEFAULT_DOTS_WAIT

  PART_1 NOT IF
    PART_1_FAILED
    RETURN
  THEN

  PART_2 VAR $mainChoice
  $mainChoice # part_2_result_rescue == IF
    s" As you approach the neutral zone, a fleet of Klingon ships uncloaks and attacks. They destroy both your ship and the Kobayashi Maru. " .
    EXERCISE_FAILED
    RETURN
  THEN
  $mainChoice # part_2_result_ignore == IF
    s" You can still hear their distress signal as you leave them to certain doom. " .
    EXERCISE_FAILED
    RETURN
  THEN

  |<
  EXERCISE_SOLVED
;

: PART_1 ( -- Bool $success )
  s" Your receive a distress signal from civilian fuel ship Kobayashi Maru. " .
  s" 1. Ignore. " .
  s" 2. Investigate. " .
  READ_CHOICE_LINE VAR $choice
  $choice s" 2 " == IF
    s" You decide to investigate the distress signal. " .
    true
  ELSE
    s" You ignore the distress signal. " .
    false
  THEN
  DEFAULT_DOTS_WAIT
;

: PART_1_FAILED ( -- )
  s" As you continue on your patrol, you keep thinking about those poor souls on board of the Kobayashi Maru. " .
  EXERCISE_FAILED
;

: PART_2 ( -- Symbol $result )
  s" As you approach, you can see that Kobayashi Maru is stranded in the neutral zone. " .
  s" 1. Ignore. " .
  s" 2. Enter the neutral zone and attempt rescue. " .
  READ_CHOICE_LINE VAR $choice
  $choice s" 2 " == IF
    s" You decide to enter the neutral zone and attempt rescue. " .
    # part_2_result_rescue
  ELSE
    s" You ignore the situation and continue on your patrol. " .
    # part_2_result_ignore
  THEN
  DEFAULT_DOTS_WAIT
;

: EXERCISE_FAILED ( -- )
  s" EXERCISE FAILED. " .
;

: EXERCISE_SOLVED ( -- )
  s" EXERCISE SOLVED. " .
;

: READ_CHOICE_LINE ( -- String $input )
  s" ~~~> " .. s"_ ..
  READ_LINE
;

: DEFAULT_DOTS_WAIT ( -- ) 3 X_DOTS_WAIT |< ;

: X_DOTS_WAIT ( Num $x -- )
  VAR $x
  BEGIN $x 1 - VAR $x
    s" . " ..
    0.25 SECONDS_WAIT
  $x 0 > UNTIL
;
