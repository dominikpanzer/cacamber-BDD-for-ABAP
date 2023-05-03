CLASS acceptance_tests DEFINITION DEFERRED.
CLASS zcl_datatable DEFINITION LOCAL FRIENDS acceptance_tests.
CLASS acceptance_tests DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      can_instantiate_via_factory FOR TESTING RAISING cx_static_check,
      fails_without_string FOR TESTING RAISING cx_static_check,
      stores_a_table_line FOR TESTING RAISING cx_static_check,
      stores_two_table_lines FOR TESTING RAISING cx_static_check,
      returns_a_line FOR TESTING RAISING cx_static_check,
      throws_when_no_line_found FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS acceptance_tests IMPLEMENTATION.
  METHOD fails_without_string.
    TRY.
        DATA(datatable) = zcl_datatable=>from_string( '' ).
        cl_abap_unit_assert=>fail( ).
      CATCH zcx_cacamber_error INTO DATA(error).
        cl_abap_unit_assert=>assert_bound( error ).
    ENDTRY.
  ENDMETHOD.

  METHOD can_instantiate_via_factory.
    DATA(datatable) = zcl_datatable=>from_string( 'test' ).
    cl_abap_unit_assert=>assert_bound( datatable ).
  ENDMETHOD.

  METHOD stores_a_table_line.
    DATA(datatable_expected) = VALUE zcl_datatable=>datatable_tt( ( row = '1' column = '1' value = 'test' )
                                        ( row = '1' column = '2' value = 'all' )
                                        ( row = '1' column = '3' value = 'the' )
                                        ( row = '1' column = '4' value = 'cases' ) ).
    DATA(datatable) = zcl_datatable=>from_string( '| test | all | the | cases |' ).

    cl_abap_unit_assert=>assert_equals( msg = 'Tables dont match' exp = datatable_expected act = datatable->datatable ).

  ENDMETHOD.

  METHOD stores_two_table_lines.
    DATA(datatable_expected) = VALUE zcl_datatable=>datatable_tt(
                                        ( row = '1' column = '1' value = 'test' )
                                        ( row = '1' column = '2' value = 'all' )
                                        ( row = '1' column = '3' value = 'the' )
                                        ( row = '1' column = '4' value = 'cases' )
                                        ( row = '2' column = '1' value = 'until' )
                                        ( row = '2' column = '2' value = 'everything' )
                                        ( row = '2' column = '3' value = 'works' )
                                        ( row = '2' column = '4' value = 'great' ) ).
    DATA(datatable) = zcl_datatable=>from_string( '| test  | all        | the   | cases |' &&
                                                  '| until | everything | works | great |' ).

    cl_abap_unit_assert=>assert_equals( msg = 'Tables dont match' exp = datatable_expected act = datatable->datatable ).
  ENDMETHOD.

  METHOD returns_a_line.
    DATA(line_expected) = VALUE string_table( ( |until| ) ( |everything| ) ( |works| ) ( |great| ) ).
    DATA(datatable) = zcl_datatable=>from_string( '| test  | all        | the   | cases |' &&
                                                  '| until | everything | works | great |' ).

    DATA(line) = datatable->read_row( 2 ).

    cl_abap_unit_assert=>assert_equals( msg = 'Line not correct' exp = line_expected act = line ).
  ENDMETHOD.

  METHOD throws_when_no_line_found.
    DATA(line_expected) = VALUE string_table( ( |until| ) ( |everything| ) ( |works| ) ( |great| ) ).
    DATA(datatable) = zcl_datatable=>from_string( '| test  | all        | the   | cases |' &&
                                                  '| until | everything | works | great |' ).
    TRY.
        DATA(line) = datatable->read_row( 666 ).
        cl_abap_unit_assert=>fail( ).
      CATCH zcx_cacamber_error INTO DATA(error).
        cl_abap_unit_assert=>assert_bound( error ).
    ENDTRY.
  ENDMETHOD.


ENDCLASS.
