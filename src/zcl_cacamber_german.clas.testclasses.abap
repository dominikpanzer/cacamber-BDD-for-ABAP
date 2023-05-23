CLASS acceptance_german_language DEFINITION FINAL FOR TESTING INHERITING FROM zcl_cacamber_german
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PUBLIC SECTION.
    DATA counter TYPE int4.
    METHODS set_initial_value IMPORTING value TYPE int4.
    METHODS add_value IMPORTING value TYPE int4.
    METHODS calculate.
    METHODS verfiy IMPORTING expected_value TYPE int4.


  PRIVATE SECTION.
    DATA: cacamber_under_test TYPE REF TO zcl_cacamber_german,
          sum                 TYPE int4.
    METHODS can_run_a_scenario_via_verfiy FOR TESTING RAISING cx_static_check.
    METHODS can_run_a_scenario_via_calls FOR TESTING RAISING cx_static_check.
    METHODS setup.
ENDCLASS.


CLASS acceptance_german_language IMPLEMENTATION.

  METHOD setup.
    cacamber_under_test = NEW zcl_cacamber_german( me ).
    cacamber_under_test->funktion( 'a Feature' ).
    cacamber_under_test->configure( pattern = '^a variable has the value (.+)$' method_name = 'set_initial_value' ).
    cacamber_under_test->configure( pattern = '^I increase it by (.+)$' method_name = 'add_value' ).
    cacamber_under_test->configure( pattern = '^I add (.+) to it again$' method_name = 'add_value' ).
    cacamber_under_test->configure( pattern = '^then I add (.+) once more$' method_name = 'add_value' ).
    cacamber_under_test->configure( pattern = '^I double it$' method_name = 'calculate' ).
    cacamber_under_test->configure( pattern = '^the value is (.+) and feature and scenario have values.$' method_name = 'verfiy' ).
  ENDMETHOD.

  METHOD set_initial_value.
    counter = value.
  ENDMETHOD.

  METHOD add_value.
    counter = counter + value.
  ENDMETHOD.

  METHOD calculate.
    counter = counter * 2.
  ENDMETHOD.

  METHOD verfiy.
    cl_abap_unit_assert=>assert_equals( msg = 'Counter value is wrong' exp = expected_value act = counter ).
    cl_abap_unit_assert=>assert_not_initial( cacamber_under_test->get_current_feature( ) ).
    cl_abap_unit_assert=>assert_not_initial( cacamber_under_test->get_current_scenario(  ) ).
  ENDMETHOD.

  METHOD can_run_a_scenario_via_verfiy.
    cacamber_under_test->pruefe( 'Szenario: A Scenario' && "Scenario
                                 'Angenommen a variable has the value 0' && "Given
                                 'Und I increase it by 1' && "And
                                 'Oder I add 1 to it again' && "Or
                                 'Aber then I add 1 once more' && "But
                                 'Wenn I double it' && "when
                                 'Dann the value is 6 and feature and scenario have values.' ). "then
  ENDMETHOD.

  METHOD can_run_a_scenario_via_calls.
    cacamber_under_test->szenario( 'A Scenario' ). " Scenario
    cacamber_under_test->angenommen( 'a variable has the value 0' ). "Given
    cacamber_under_test->und( 'I increase it by 1' ). "And
    cacamber_under_test->oder( 'I add 1 to it again' ). "Or
    cacamber_under_test->aber( 'then I add 1 once more' ). "But
    cacamber_under_test->wenn( 'I double it' ). "When
    cacamber_under_test->dann( 'the value is 6 and feature and scenario have values.' ). "then
  ENDMETHOD.

ENDCLASS.
