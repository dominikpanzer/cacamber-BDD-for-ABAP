CLASS scaffolding_tests DEFINITION DEFERRED.
CLASS zcl_cacamber DEFINITION LOCAL FRIENDS scaffolding_tests.
CLASS scaffolding_tests DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PUBLIC SECTION.
    METHODS: whenyournameis IMPORTING first_name TYPE char30
                                      last_name  TYPE char30,
      local_method_for_test_date IMPORTING date TYPE dats,
      local_method_for_test IMPORTING first_name TYPE char30
                                      last_name  TYPE char30,
      local_method_for_test_exportin EXPORTING dummy TYPE string.
  PROTECTED SECTION.


  PRIVATE SECTION.
    DATA: cacamber TYPE REF TO zcl_cacamber.
    DATA: method_has_been_called TYPE abap_bool.
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
    METHODS: can_set_a_scenario FOR TESTING RAISING cx_static_check,
      underscore_calls_a_method FOR TESTING RAISING cx_static_check,
      can_set_a_rule FOR TESTING RAISING cx_static_check,
      wrong_paramter_count FOR TESTING RAISING cx_static_check,
      no_method_for_step_found FOR TESTING RAISING cx_static_check,
      dynamic_method_call_failed FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS scaffolding_tests IMPLEMENTATION.

  METHOD setup.
    cacamber = NEW zcl_cacamber( me ).
  ENDMETHOD.

  METHOD can_store_configuration.
    cacamber->configure( pattern = 'pattern' methodname = 'methodname' ).
    DATA(expected_configuration) = VALUE zcl_cacamber=>configuration_tt( ( pattern = 'pattern' methodname = 'METHODNAME' ) ).
    cl_abap_unit_assert=>assert_equals( msg = 'Configuration is wrong' exp = expected_configuration act = cacamber->configuration ).
  ENDMETHOD.

  METHOD can_store_two_configurations.
    cacamber->configure( pattern = 'pattern' methodname = 'methodname' ).
    cacamber->configure( pattern = 'pattern2' methodname = 'methodname2' ).

    DATA(expected_configuration) = VALUE zcl_cacamber=>configuration_tt( ( pattern = 'pattern' methodname = 'METHODNAME' )
                                                                          ( pattern = 'pattern2' methodname = 'METHODNAME2' ) ).

    cl_abap_unit_assert=>assert_equals( msg = 'Configuration is wrong' exp = expected_configuration act = cacamber->configuration ).
  ENDMETHOD.

  METHOD ignores_empty_pattern_config.
    cacamber->configure( pattern = '' methodname = 'methodname' ).

    cl_abap_unit_assert=>assert_initial( cacamber->configuration ).
  ENDMETHOD.

  METHOD ignores_empty_methodnme_config.
    cacamber->configure( pattern = 'pattern' methodname = '' ).

    cl_abap_unit_assert=>assert_initial( act = cacamber->configuration ).
  ENDMETHOD.

  METHOD matching_step_found.
    cacamber->configure( pattern = '^(.+) is not Cucumber$' methodname = 'isnotcucumber' ).

    DATA(methodname) = cacamber->match_step_to_methodname( 'Cacamber is not Cucumber' ).

    cl_abap_unit_assert=>assert_equals( msg = 'Should find a method' exp = 'ISNOTCUCUMBER' act = methodname ).
  ENDMETHOD.

  METHOD extract_first_string.
    cacamber->configure( pattern = '^(.+) is not Cucumber$' methodname = 'notrelevant' ).
    DATA(expected_variables) = VALUE string_table( ( |Cacamber| ) ).

    DATA(variables) = cacamber->extract_variables_from_step( 'Cacamber is not Cucumber' ).

    cl_abap_unit_assert=>assert_equals( msg = 'Variable not found' exp = expected_variables act = variables ).

  ENDMETHOD.

  METHOD extract_two_middle_strings.
    cacamber->configure( pattern = '^They say (.+) is not (.+) - and they are right!$' methodname = 'notrelevant' ).
    DATA(expected_variables) = VALUE string_table( ( |Cacamber| ) ( |Cucumber| ) ).

    DATA(variables) = cacamber->extract_variables_from_step( 'They say Cacamber is not Cucumber - and they are right!' ).

    cl_abap_unit_assert=>assert_equals( msg = 'Variable not found' exp = expected_variables act = variables ).

  ENDMETHOD.

  METHOD extract_string_at_end.
    cacamber->configure( pattern = '^Whats your name\? (.+)$' methodname = 'notrelevant' ).
    DATA(expected_variables) = VALUE string_table( ( |Cacamber| ) ).

    DATA(variables) = cacamber->extract_variables_from_step( 'Whats your name? Cacamber' ).

    cl_abap_unit_assert=>assert_equals( msg = 'Variable not found' exp = expected_variables act = variables ).
  ENDMETHOD.

  METHOD get_method_parameter_list.
    DATA(expected_parameters) = VALUE zcl_cacamber=>parameters_tt( ( data_type = 'CHAR30' name = 'FIRST_NAME' )
                                                 ( data_type = 'CHAR30' name = 'LAST_NAME' ) ).
    DATA(parameters) = cacamber->get_method_parameters( methodname = 'LOCAL_METHOD_FOR_TEST'
                                                            local_testclass_instance = me ).

    cl_abap_unit_assert=>assert_equals( msg = 'Parameters are wrong' exp = expected_parameters act = parameters ).
  ENDMETHOD.

  METHOD added_variables_to_params_ok.
    DATA(first_name) = |Dominik|.
    DATA(last_name) = |Panzer|.
    DATA(parameters) = VALUE zcl_cacamber=>parameters_tt( ( data_type = 'STRING' name = 'FIRST_NAME' )
                                                 ( data_type = 'STRING' name = 'LAST_NAME' ) ).
    DATA(variables) = VALUE string_table( ( first_name ) ( last_name ) ).

    DATA(expected_matched_parameters) = VALUE abap_parmbind_tab( ( kind = 'E' name = 'FIRST_NAME' value = REF #( first_name ) )
                                                 ( kind = 'E' name = 'LAST_NAME' value = REF #( last_name ) ) ).

    DATA(matched_parameters) = cacamber->add_variables_to_parameters( parameters = parameters variables = variables ).

    cl_abap_unit_assert=>assert_equals( msg = 'Values dont match' exp = expected_matched_parameters[ name = 'FIRST_NAME' ]-value->* act = matched_parameters[ name = 'FIRST_NAME' ]-value->* ).
  ENDMETHOD.

  METHOD added_vars_to_paras_char30.
    DATA first_name TYPE char30 VALUE 'Dominik'.
    DATA last_name TYPE char30 VALUE 'Panzer'.

    DATA(parameters) = VALUE zcl_cacamber=>parameters_tt( ( data_type = 'CHAR30' name = 'FIRST_NAME' )
                                                ( data_type = 'CHAR30' name = 'LAST_NAME' ) ).
    DATA(variables) = VALUE string_table( ( CONV #( first_name ) ) ( CONV #( last_name ) ) ).

    DATA(expected_matched_parameters) = VALUE abap_parmbind_tab( ( kind = 'E' name = 'FIRST_NAME' value = REF #( first_name ) )
                                                 ( kind = 'E' name = 'LAST_NAME' value = REF #( last_name ) ) ).

    DATA(matched_parameters) = cacamber->add_variables_to_parameters( parameters = parameters variables = variables ).

    cl_abap_unit_assert=>assert_equals( msg = 'Values dont match' exp = expected_matched_parameters[ name = 'FIRST_NAME' ]-value->* act = matched_parameters[ name = 'FIRST_NAME' ]-value->* ).

  ENDMETHOD.

  METHOD call_a_method_dynamically.
    DATA first_name TYPE char30 VALUE 'Dominik'.
    DATA last_name TYPE char30 VALUE 'Panzer'.
    DATA(methodname) = 'LOCAL_METHOD_FOR_TEST'.

    DATA(variables) = VALUE string_table( ( CONV #( first_name ) ) ( CONV #( last_name ) ) ).

    DATA(parameters) = cacamber->get_method_parameters( methodname = 'LOCAL_METHOD_FOR_TEST'
                                                              local_testclass_instance = me ).

    DATA(matched_parameters) = cacamber->add_variables_to_parameters( parameters = parameters variables = variables ).
    TRY.
        CALL METHOD me->(methodname)
          PARAMETER-TABLE matched_parameters.
      CATCH cx_root INTO DATA(root_exception).
        cl_abap_unit_assert=>fail( ).
    ENDTRY.
  ENDMETHOD.

  METHOD added_vars_to_paras_dats.
    DATA date TYPE dats VALUE '20230430'.

    DATA(parameters) = VALUE zcl_cacamber=>parameters_tt( ( data_type = 'DATS' name = 'DATE' ) ).
    DATA(variables) = VALUE string_table( ( |30.04.2023| ) ).

    DATA(expected_matched_parameters) = VALUE abap_parmbind_tab( ( kind = 'E' name = 'DATE' value = REF #( date ) ) ).

    DATA(matched_parameters) = cacamber->add_variables_to_parameters( parameters = parameters variables = variables ).

    cl_abap_unit_assert=>assert_equals( msg = 'Values dont match' exp = expected_matched_parameters[ name = 'DATE' ]-value->* act = matched_parameters[ name = 'DATE' ]-value->* ).

  ENDMETHOD.

  METHOD added_vars_to_paras_int.
    DATA integer TYPE int4 VALUE '666'.

    DATA(parameters) = VALUE zcl_cacamber=>parameters_tt( ( data_type = 'INT4' name = 'INTEGER' ) ).
    DATA(variables) = VALUE string_table( ( |666| ) ).

    DATA(expected_matched_parameters) = VALUE abap_parmbind_tab( ( kind = 'E' name = 'INTEGER' value = REF #( integer ) ) ).

    DATA(matched_parameters) = cacamber->add_variables_to_parameters( parameters = parameters variables = variables ).

    cl_abap_unit_assert=>assert_equals( msg = 'Values dont match' exp = expected_matched_parameters[ name = 'INTEGER' ]-value->* act = matched_parameters[ name = 'INTEGER' ]-value->* ).

  ENDMETHOD.

  METHOD given_calls_a_method.
* i don't like this test case design
    cacamber->configure( pattern = '^your name is (.+) (.+)$' methodname = 'WHENYOURNAMEIS' ).

    cacamber->given( 'your name is Marty McFly' ).

    cl_abap_unit_assert=>assert_equals( msg = 'Marker not set' exp = abap_true act = method_has_been_called ).
  ENDMETHOD.

  METHOD underscore_calls_a_method.
* i don't like this test case design
    cacamber->configure( pattern = '^List entry (.+) (.+)$' methodname = 'WHENYOURNAMEIS' ).

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

  METHOD whenyournameis.
    " this is a dummy method for test cases of the method GET_METHOD_PARAMETER_LIST
    method_has_been_called = abap_true.
  ENDMETHOD.

  METHOD wrong_paramter_count.
    cacamber->configure( pattern = '^no parameters are here but the step-method expects some$' methodname = 'WHENYOURNAMEIS' ).

    TRY.
        cacamber->given( 'no parameters are here but the step-method expects some' ).
        cl_abap_unit_assert=>fail( ).
      CATCH zcx_cacamber_error INTO DATA(error).
    ENDTRY.
  ENDMETHOD.

  METHOD no_method_for_step_found.
    cacamber->configure( pattern = '^this is the regex$' methodname = 'WHENYOURNAMEIS' ).

    TRY.
        cacamber->given( 'but this text wont match. so no step-method will be found :-(' ).
        cl_abap_unit_assert=>fail( ).
      CATCH zcx_cacamber_error INTO DATA(error).
    ENDTRY.
  ENDMETHOD.

  METHOD dynamic_method_call_failed.
    " we catch cx_root here, because we don't want to map the exceptions of
    " the dynamic method call to our own exception. the native exception is okay
    cacamber->configure( pattern = '^this is the regex for a method with no importing parameter: (.*)$' methodname = 'local_method_for_test_exportin' ).
    TRY.
        cacamber->given( 'this is the regex for a method with no importing parameter: BOOM' ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_root INTO DATA(error).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
