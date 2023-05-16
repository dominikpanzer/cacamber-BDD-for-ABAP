CLASS scaffolding_tests DEFINITION DEFERRED.
CLASS zcl_cacamber DEFINITION LOCAL FRIENDS scaffolding_tests.
CLASS scaffolding_tests DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PUBLIC SECTION.
    METHODS: whenyournameis IMPORTING first_name TYPE char30
                                      last_name  TYPE char30 ##NEEDED,
      local_method_for_test_date IMPORTING date TYPE dats ##NEEDED,
      local_method_for_test IMPORTING char30  TYPE char30
                                      integer TYPE int4
                                      packed  TYPE zde_bdd_packed ##NEEDED,
      local_method_for_test_exportin EXPORTING dummy         TYPE string
                                               another_dummy TYPE string ##NEEDED,
      local_method_for_test_table IMPORTING table_as_string TYPE string ##NEEDED.
  PROTECTED SECTION.


  PRIVATE SECTION.
    CONSTANTS exporting TYPE string VALUE 'E' ##NO_TEXT.
    DATA: cacamber TYPE REF TO zcl_cacamber.
    DATA: method_has_been_called TYPE abap_bool,
          datatable              TYPE REF TO zcl_datatable.
    METHODS: setup.
    METHODS: can_store_configuration FOR TESTING RAISING cx_static_check.
    METHODS: can_store_two_configurations FOR TESTING RAISING cx_static_check.
    METHODS: ignores_empty_pattern_config FOR TESTING RAISING cx_static_check.
    METHODS: ignores_empty_methodnme_config FOR TESTING RAISING cx_static_check.
    METHODS: matching_step_found FOR TESTING RAISING cx_static_check.
    METHODS: extract_first_string FOR TESTING RAISING cx_static_check.
    METHODS: extract_two_middle_strings FOR TESTING RAISING cx_static_check.
    METHODS: extract_string_at_end FOR TESTING RAISING cx_static_check.
    METHODS: get_method_parameter_list FOR TESTING RAISING cx_static_check.
    METHODS: added_variables_to_params_ok FOR TESTING RAISING cx_static_check.
    METHODS: added_vars_to_paras_char30 FOR TESTING RAISING cx_static_check.
    METHODS: added_vars_to_paras_dats FOR TESTING RAISING cx_static_check.
    METHODS: call_a_method_dynamically FOR TESTING RAISING cx_static_check.
    METHODS: added_vars_to_paras_int FOR TESTING RAISING cx_static_check.
    METHODS: given_calls_a_method FOR TESTING RAISING cx_static_check.
    METHODS: can_set_a_feature FOR TESTING RAISING cx_static_check.
    METHODS: can_set_a_scenario FOR TESTING RAISING cx_static_check.
    METHODS: underscore_calls_a_method FOR TESTING RAISING cx_static_check.
    METHODS: can_set_a_rule FOR TESTING RAISING cx_static_check.
    METHODS: wrong_paramter_count FOR TESTING RAISING cx_static_check.
    METHODS: no_method_for_step_found FOR TESTING RAISING cx_static_check.
    METHODS: dynamic_method_call_failed FOR TESTING RAISING cx_static_check.
    METHODS: added_vars_to_paras_neg_int FOR TESTING RAISING cx_static_check.
    METHODS: added_vars_to_paras_tims FOR TESTING RAISING cx_static_check,
      can_run_a_one_step_scenario FOR TESTING RAISING cx_static_check,
      can_split_a_string_into_steps FOR TESTING RAISING cx_static_check,
      can_extract_current_scenario FOR TESTING RAISING cx_static_check,
      can_extract_current_rule FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS scaffolding_tests IMPLEMENTATION.

  METHOD setup.
    cacamber = NEW zcl_cacamber( me ).
  ENDMETHOD.

  METHOD can_store_configuration.
    cacamber->configure( pattern = 'pattern' method_name = 'methodname' ).
    DATA(expected_configuration) = VALUE zcl_cacamber=>configuration_tt( ( pattern = 'pattern' method_name = 'METHODNAME' ) ).
    cl_abap_unit_assert=>assert_equals( msg = 'Configuration is wrong' exp = expected_configuration act = cacamber->configuration ).
  ENDMETHOD.

  METHOD can_store_two_configurations.
    cacamber->configure( pattern = 'pattern' method_name = 'methodname' ).
    cacamber->configure( pattern = 'pattern2' method_name = 'methodname2' ).

    DATA(expected_configuration) = VALUE zcl_cacamber=>configuration_tt( ( pattern = 'pattern' method_name = 'METHODNAME' )
                                                                          ( pattern = 'pattern2' method_name = 'METHODNAME2' ) ).

    cl_abap_unit_assert=>assert_equals( msg = 'Configuration is wrong' exp = expected_configuration act = cacamber->configuration ).
  ENDMETHOD.

  METHOD ignores_empty_pattern_config.
    cacamber->configure( pattern = '' method_name = 'methodname' ).

    cl_abap_unit_assert=>assert_initial( cacamber->configuration ).
  ENDMETHOD.

  METHOD ignores_empty_methodnme_config.
    cacamber->configure( pattern = 'pattern' method_name = '' ).

    cl_abap_unit_assert=>assert_initial( act = cacamber->configuration ).
  ENDMETHOD.

  METHOD matching_step_found.
    cacamber->configure( pattern = '^(.+) is not Cucumber$' method_name = 'isnotcucumber' ).

    DATA(methodname) = cacamber->match_step_to_method_name( 'Cacamber is not Cucumber' ).

    cl_abap_unit_assert=>assert_equals( msg = 'Should find a method' exp = 'ISNOTCUCUMBER' act = methodname ).
  ENDMETHOD.

  METHOD extract_first_string.
    cacamber->configure( pattern = '^(.+) is not Cucumber$' method_name = 'notrelevant' ).
    DATA(expected_variables) = VALUE string_table( ( |Cacamber| ) ).

    DATA(variables) = cacamber->extract_variables_from_step( 'Cacamber is not Cucumber' ).

    cl_abap_unit_assert=>assert_equals( msg = 'Variable not found' exp = expected_variables act = variables ).

  ENDMETHOD.

  METHOD extract_two_middle_strings.
    cacamber->configure( pattern = '^They say (.+) is not (.+) - and they are right!$' method_name = 'notrelevant' ).
    DATA(expected_variables) = VALUE string_table( ( |Cacamber| ) ( |Cucumber| ) ).

    DATA(variables) = cacamber->extract_variables_from_step( 'They say Cacamber is not Cucumber - and they are right!' ).

    cl_abap_unit_assert=>assert_equals( msg = 'Variable not found' exp = expected_variables act = variables ).

  ENDMETHOD.

  METHOD extract_string_at_end.
    cacamber->configure( pattern = '^Whats your name\? (.+)$' method_name = 'notrelevant' ).
    DATA(expected_variables) = VALUE string_table( ( |Cacamber| ) ).

    DATA(variables) = cacamber->extract_variables_from_step( 'Whats your name? Cacamber' ).

    cl_abap_unit_assert=>assert_equals( msg = 'Variable not found' exp = expected_variables act = variables ).
  ENDMETHOD.

  METHOD get_method_parameter_list.
    DATA(expected_parameters) = VALUE zcl_cacamber=>parameters_tt( ( data_type = 'CHAR30' name = 'CHAR30' )
                                                                   ( data_type = 'INT4' name = 'INTEGER' )
                                                                   ( data_type = 'ZDE_BDD_PACKED' name = 'PACKED' ) ).
    DATA(parameters) = cacamber->get_method_parameters( method_name = 'LOCAL_METHOD_FOR_TEST'
                                                        local_testclass_instance = me ).

    cl_abap_unit_assert=>assert_equals( msg = 'Parameters are wrong' exp = expected_parameters act = parameters ).
  ENDMETHOD.

  METHOD added_variables_to_params_ok.
    FIELD-SYMBOLS <first_name_matched> TYPE any.
    DATA(first_name) = |Dominik|.
    DATA(parameters) = VALUE zcl_cacamber=>parameters_tt( ( data_type = 'STRING' name = 'FIRST_NAME' ) ).
    DATA(variables) = VALUE string_table( ( first_name ) ).

    DATA(expected_matched_parameters) = VALUE abap_parmbind_tab( ( kind = exporting name = 'FIRST_NAME' value = REF #( first_name ) ) ).

    DATA(matched_parameters) = cacamber->add_variables_to_parameters( parameters = parameters variables = variables ).

    DATA(temp_first_name_matched) = matched_parameters[ name = 'FIRST_NAME' ]-value.
    ASSIGN temp_first_name_matched->* TO <first_name_matched> .

    cl_abap_unit_assert=>assert_equals( msg = 'Values dont match' exp = first_name act = <first_name_matched> ).
    cl_abap_unit_assert=>assert_equals( msg = 'Kind doesnt match' exp = exporting act = matched_parameters[ name = 'FIRST_NAME' ]-kind ).
  ENDMETHOD.

  METHOD added_vars_to_paras_char30.
    FIELD-SYMBOLS <first_name_matched> TYPE any.
    DATA first_name TYPE char30 VALUE 'Dominik'.

    DATA(parameters) = VALUE zcl_cacamber=>parameters_tt( ( data_type = 'CHAR30' name = 'FIRST_NAME' ) ).
    DATA(variables) = VALUE string_table( ( CONV #( first_name ) ) ).

    DATA(matched_parameters) = cacamber->add_variables_to_parameters( parameters = parameters variables = variables ).

    DATA(temp_first_name_matched) = matched_parameters[ name = 'FIRST_NAME' ]-value.
    ASSIGN temp_first_name_matched->* TO <first_name_matched> .

    cl_abap_unit_assert=>assert_equals( msg = 'Values dont match' exp = first_name act = <first_name_matched> ).
    cl_abap_unit_assert=>assert_equals( msg = 'Kind doesnt match' exp = exporting act = matched_parameters[ name = 'FIRST_NAME' ]-kind ).
  ENDMETHOD.


  METHOD call_a_method_dynamically.
    DATA char30 TYPE char30 VALUE 'Dominik'.
    DATA integer TYPE int4 VALUE -100.
    DATA packed TYPE zde_bdd_packed VALUE '1.1'.
    DATA(methodname) = 'LOCAL_METHOD_FOR_TEST'.

    DATA(variables) = VALUE string_table( ( CONV #( char30 ) ) ( CONV #( integer ) ) ( CONV #( packed ) ) ).
    DATA(parameters) = cacamber->get_method_parameters( method_name = 'LOCAL_METHOD_FOR_TEST'
                                                              local_testclass_instance = me ).
    DATA(matched_parameters) = cacamber->add_variables_to_parameters( parameters = parameters variables = variables ).

    TRY.
        CALL METHOD me->(methodname)
          PARAMETER-TABLE matched_parameters.
      CATCH cx_root INTO DATA(root_exception) ##NEEDED.
        cl_abap_unit_assert=>fail( ).
    ENDTRY.
  ENDMETHOD.

  METHOD added_vars_to_paras_dats.
    FIELD-SYMBOLS <date_matched> TYPE any.
    DATA date TYPE dats VALUE '20230430'.

    DATA(parameters) = VALUE zcl_cacamber=>parameters_tt( ( data_type = 'DATS' name = 'DATE' ) ).
    DATA(variables) = VALUE string_table( ( |30.04.2023| ) ).

    DATA(matched_parameters) = cacamber->add_variables_to_parameters( parameters = parameters variables = variables ).

    DATA(temp_date_matched) = matched_parameters[ name = 'DATE' ]-value.
    ASSIGN temp_date_matched->* TO <date_matched> .

    cl_abap_unit_assert=>assert_equals( msg = 'Values dont match' exp = date act = <date_matched> ).
    cl_abap_unit_assert=>assert_equals( msg = 'Kind doesnt match' exp = exporting act = matched_parameters[ name = 'DATE' ]-kind ).
  ENDMETHOD.

  METHOD added_vars_to_paras_tims.
    FIELD-SYMBOLS <time_matched> TYPE any.
    DATA time TYPE t VALUE '130001'.

    DATA(parameters) = VALUE zcl_cacamber=>parameters_tt( ( data_type = 'T' name = 'TIME' ) ).
    DATA(variables) = VALUE string_table( ( |13:00:01| ) ).

    DATA(matched_parameters) = cacamber->add_variables_to_parameters( parameters = parameters variables = variables ).

    DATA(temp_time_matched) = matched_parameters[ name = 'TIME' ]-value.
    ASSIGN temp_time_matched->* TO <time_matched> .

    cl_abap_unit_assert=>assert_equals( msg = 'Values dont match' exp = time act = <time_matched> ).
    cl_abap_unit_assert=>assert_equals( msg = 'Kind doesnt match' exp = exporting act = matched_parameters[ name = 'TIME' ]-kind ).
  ENDMETHOD.

  METHOD added_vars_to_paras_int.
    FIELD-SYMBOLS <integer_matched> TYPE any.
    DATA integer TYPE int4 VALUE '666'.

    DATA(parameters) = VALUE zcl_cacamber=>parameters_tt( ( data_type = 'INT4' name = 'INTEGER' ) ).
    DATA(variables) = VALUE string_table( ( |666| ) ).

    DATA(matched_parameters) = cacamber->add_variables_to_parameters( parameters = parameters variables = variables ).

    DATA(temp_integer_matched) = matched_parameters[ name = 'INTEGER' ]-value.
    ASSIGN temp_integer_matched->* TO <integer_matched> .

    cl_abap_unit_assert=>assert_equals( msg = 'Values dont match' exp = integer act = <integer_matched> ).
    cl_abap_unit_assert=>assert_equals( msg = 'Kind doesnt match' exp = exporting act = matched_parameters[ name = 'INTEGER' ]-kind ).
  ENDMETHOD.

  METHOD added_vars_to_paras_neg_int.
    FIELD-SYMBOLS <integer_matched> TYPE any.
    DATA integer TYPE int4 VALUE '-666'.

    DATA(parameters) = VALUE zcl_cacamber=>parameters_tt( ( data_type = 'INT4' name = 'INTEGER' ) ).
    DATA(variables) = VALUE string_table( ( |-666| ) ).

    DATA(matched_parameters) = cacamber->add_variables_to_parameters( parameters = parameters variables = variables ).

    DATA(temp_integer_matched) = matched_parameters[ name = 'INTEGER' ]-value.
    ASSIGN temp_integer_matched->* TO <integer_matched> .

    cl_abap_unit_assert=>assert_equals( msg = 'Values dont match' exp = integer act = <integer_matched> ).
    cl_abap_unit_assert=>assert_equals( msg = 'Kind doesnt match' exp = exporting act = matched_parameters[ name = 'INTEGER' ]-kind ).
  ENDMETHOD.

  METHOD given_calls_a_method.
* i don't like this test case design
    cacamber->configure( pattern = '^your name is (.+) (.+)$' method_name = 'WHENYOURNAMEIS' ).

    cacamber->given( 'your name is Marty McFly' ).

    cl_abap_unit_assert=>assert_equals( msg = 'Marker not set' exp = abap_true act = method_has_been_called ).
  ENDMETHOD.

  METHOD underscore_calls_a_method.
* i don't like this test case design
    cacamber->configure( pattern = '^List entry (.+) (.+)$' method_name = 'WHENYOURNAMEIS' ).

    cacamber->_( 'List entry Marty McFly' ).
    cacamber->_( 'List entry Ronny-James Dio' ).

    cl_abap_unit_assert=>assert_equals( msg = 'Marker not set' exp = abap_true act = method_has_been_called ).
  ENDMETHOD.

  METHOD can_set_a_feature.
    DATA feature TYPE zcl_cacamber=>feature_t VALUE 'Log in feature'.

    cacamber->feature( feature ).

    cl_abap_unit_assert=>assert_equals( msg = 'Feature hasnt been set' exp = feature act = cacamber->current_feature ).
  ENDMETHOD.

  METHOD can_set_a_scenario.
    DATA scenario TYPE zcl_cacamber=>scenario_t VALUE 'Log in is successfull'.

    cacamber->scenario( scenario ).

    cl_abap_unit_assert=>assert_equals( msg = 'Scenario hasnt been set' exp = scenario act = cacamber->current_scenario ).
  ENDMETHOD.

  METHOD can_set_a_rule.
    DATA rule TYPE zcl_cacamber=>rule_t VALUE 'firt rule of the fight club: dont talk about the fight club'.

    cacamber->rule( rule ).

    cl_abap_unit_assert=>assert_equals( msg = 'Rule hasnt been set' exp = rule act = cacamber->current_rule ).
  ENDMETHOD.

  METHOD local_method_for_test.
    " this is a dummy method for test cases of the method GET_METHOD_PARAMETER_LIST
  ENDMETHOD.

  METHOD local_method_for_test_date.
    " this is a dummy method for test cases of the method GET_METHOD_PARAMETER_LIST
  ENDMETHOD.

  METHOD local_method_for_test_exportin.
    " this is a dummy method for test cases of the method dynamic_method_call_failed.
  ENDMETHOD.

  METHOD local_method_for_test_table.
    datatable = zcl_datatable=>from_string( table_as_string ).
  ENDMETHOD.

  METHOD whenyournameis.
    " this is a dummy method for test cases of the method GET_METHOD_PARAMETER_LIST
    method_has_been_called = abap_true.
  ENDMETHOD.

  METHOD wrong_paramter_count.
    cacamber->configure( pattern = '^no parameters are here but the step-method expects some$' method_name = 'WHENYOURNAMEIS' ).

    TRY.
        cacamber->given( 'no parameters are here but the step-method expects some' ).
        cl_abap_unit_assert=>fail( ).
      CATCH zcx_cacamber_error INTO DATA(error).
        cl_abap_unit_assert=>assert_bound( error ).
    ENDTRY.
  ENDMETHOD.

  METHOD no_method_for_step_found.
    cacamber->configure( pattern = '^this is the regex$' method_name = 'WHENYOURNAMEIS' ).

    TRY.
        cacamber->given( 'but this text wont match. so no step-method will be found :-(' ).
        cl_abap_unit_assert=>fail( ).
      CATCH zcx_cacamber_error INTO DATA(error).
        cl_abap_unit_assert=>assert_bound( error ).
    ENDTRY.
  ENDMETHOD.

  METHOD dynamic_method_call_failed.
    " we catch cx_root here, because we don't want to map the exceptions of
    " the dynamic method call to our own exception. the native exception is okay
    cacamber->configure( pattern = '^this is the regex for a method with no importing parameter: (.*)$' method_name = 'local_method_for_test_exportin' ).
    TRY.
        cacamber->given( 'this is the regex for a method with no importing parameter: BOOM' ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_root INTO DATA(error).
        cl_abap_unit_assert=>assert_bound( error ).
    ENDTRY.
  ENDMETHOD.

  METHOD can_split_a_string_into_steps.
    DATA(scenario) = VALUE string_table( ( |Given thisThen that| ) ).
    DATA(steps_expected) = VALUE string_table( ( |this| ) ( |that| ) ).

    DATA(steps) = cacamber->split( strings = scenario keyword = |Given | ).
    steps = cacamber->split( strings = steps keyword = |Then | ).

    cl_abap_unit_assert=>assert_equals( msg = 'Steps do not match' exp = steps_expected act = steps ).
  ENDMETHOD.

  METHOD can_run_a_one_step_scenario.
    cacamber->configure( pattern = 'your name is (.+) (.+)' method_name = 'WHENYOURNAMEIS' ).

    cacamber->verify( 'Given your name is Marty McFly' ).

    cl_abap_unit_assert=>assert_equals( msg = 'Marker not set' exp = abap_true act = method_has_been_called ).
  ENDMETHOD.

  METHOD can_extract_current_scenario.
    DATA(steps) = VALUE string_table( ( |Scenario: The One Where I Met David Hasselhoff| ) ( |non relevant stuff| ) ).
    DATA(scenario_expected) = |The One Where I Met David Hasselhoff|.
    DATA(steps_without_scenario_exp) = VALUE string_table( ( |non relevant stuff| ) ).

    cacamber->extract_scenario_from_steps( EXPORTING steps = steps
                                                             IMPORTING scenario = DATA(scenario)
                                                                       steps_without_scenario = DATA(steps_without_scenario) ).

    cl_abap_unit_assert=>assert_equals( msg = 'Scenario hasnt been extracted' exp = scenario_expected act = scenario ).
    cl_abap_unit_assert=>assert_equals( msg = 'Scenario still in step list' exp = steps_without_scenario_exp act = steps_without_scenario ).
  ENDMETHOD.

  METHOD can_extract_current_rule.
    DATA(steps) = VALUE string_table( ( |Rule: Slow-Motion Running Only!| ) ( |non relevant stuff| ) ).
    DATA(rule_expected) = |Slow-Motion Running Only!|.
    DATA(steps_without_rule_exp) = VALUE string_table( ( |non relevant stuff| ) ).

    cacamber->extract_rule_from_steps( EXPORTING steps = steps
                                                             IMPORTING rule = DATA(rule)
                                                                       steps_without_rule = DATA(steps_without_rule) ).

    cl_abap_unit_assert=>assert_equals( msg = 'Rule hasnt been extracted' exp = rule_expected act = rule ).
    cl_abap_unit_assert=>assert_equals( msg = 'Rule still in step list' exp = steps_without_rule_exp act = steps_without_rule ).
  ENDMETHOD.

ENDCLASS.
