CLASS acceptance_tests DEFINITION DEFERRED.
CLASS zcl_datatable DEFINITION LOCAL FRIENDS acceptance_tests.
CLASS acceptance_tests DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS: can_instantiate_via_factory FOR TESTING RAISING cx_static_check.
    METHODS: fails_without_string FOR TESTING RAISING cx_static_check.
    METHODS: stores_a_table_line FOR TESTING RAISING cx_static_check.
    METHODS: stores_two_table_lines FOR TESTING RAISING cx_static_check.
    METHODS: returns_a_line FOR TESTING RAISING cx_static_check.
    METHODS: throws_when_no_line_found FOR TESTING RAISING cx_static_check.
    METHODS: returns_a_cell FOR TESTING RAISING cx_static_check.
    METHODS: throw_when_no_cell_found FOR TESTING RAISING cx_static_check.
    METHODS: transforms_to_internal_table FOR TESTING RAISING cx_static_check.
    METHODS: stores_with_blank_cell FOR TESTING RAISING cx_static_check.
    METHODS: throws_when_transformat_fails FOR TESTING RAISING cx_static_check.
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
                                        ( row = '2' column = '4' value = 'fine' ) ).
    DATA(datatable) = zcl_datatable=>from_string( '| test  | all        | the   | cases |' &&
                                                  '| until | everything | works | fine |' ).

    cl_abap_unit_assert=>assert_equals( msg = 'Tables dont match' exp = datatable_expected act = datatable->datatable ).
  ENDMETHOD.

  METHOD stores_with_blank_cell.
    DATA(datatable_expected) = VALUE zcl_datatable=>datatable_tt(
                                        ( row = '1' column = '1' value = 'test' )
                                        ( row = '1' column = '2' value = '' )
                                        ( row = '1' column = '3' value = 'the' )
                                        ( row = '1' column = '4' value = 'cases' )
                                        ( row = '2' column = '1' value = '' )
                                        ( row = '2' column = '2' value = 'everything' )
                                        ( row = '2' column = '3' value = 'works' )
                                        ( row = '2' column = '4' value = 'fine' ) ).
    DATA(datatable) = zcl_datatable=>from_string( '| test  |            | the   | cases |' &&
                                                  '|       | everything | works | fine |' ).

    cl_abap_unit_assert=>assert_equals( msg = 'Tables dont match' exp = datatable_expected act = datatable->datatable ).
  ENDMETHOD.

  METHOD returns_a_line.
    DATA(line_expected) = VALUE string_table( ( |until| ) ( |everything| ) ( |works| ) ( |fine| ) ).
    DATA(datatable) = zcl_datatable=>from_string( '| test  | all        | the   | cases |' &&
                                                  '| until | everything | works | fine |' ).

    DATA(line) = datatable->read_row( 2 ).

    cl_abap_unit_assert=>assert_equals( msg = 'Line not correct' exp = line_expected act = line ).
  ENDMETHOD.

  METHOD throws_when_no_line_found.
    DATA(datatable) = zcl_datatable=>from_string( '| test  | all        | the   | cases |' &&
                                                  '| until | everything | works | fine |' ).
    TRY.
        DATA(line) = datatable->read_row( 666 ).
        cl_abap_unit_assert=>fail( ).
      CATCH zcx_cacamber_error INTO DATA(error).
        cl_abap_unit_assert=>assert_bound( error ).
    ENDTRY.
  ENDMETHOD.

  METHOD returns_a_cell.
    DATA(cell_expected) = |fine|.
    DATA(datatable) = zcl_datatable=>from_string( '| test  | all        | the   | cases |' &&
                                                  '| until | everything | works | fine |' ).

    DATA(cell) = datatable->read_cell( rownumber = 2 columnnumber = 4 ).

    cl_abap_unit_assert=>assert_equals( msg = 'Cell value not correct' exp = cell_expected act = cell ).
  ENDMETHOD.

  METHOD throw_when_no_cell_found.
    DATA(datatable) = zcl_datatable=>from_string( '| test  | all        | the   | cases |' &&
                                                  '| until | everything | works | fine |' ).

    TRY.
        DATA(cell) = datatable->read_cell( rownumber = 666 columnnumber = 666 ) ##NEEDED.
        cl_abap_unit_assert=>fail( ).
      CATCH zcx_cacamber_error INTO DATA(error).
        cl_abap_unit_assert=>assert_bound( error ).
    ENDTRY.
  ENDMETHOD.


  METHOD transforms_to_internal_table.
    DATA internal_table  TYPE ztt_bdd_demo.
    DATA(internal_table_expected) = VALUE ztt_bdd_demo( (  birthdate = '17.07.1952' first_name = 'David' last_name = 'Hasselhoff' age = 0 )
                                                        (  birthdate = '30.07.1947' first_name = 'Arnold' last_name = 'Schwarzenegger' age = 100 ) ).

    DATA(datatable) = zcl_datatable=>from_string( '| 17.07.1952 | David | Hasselhoff      |     |' &&
                                                  '| 30.07.1947 | Arnold | Schwarzenegger | 100 |' ).

    datatable->to_table( EXPORTING ddic_table_type_name = 'ZTT_BDD_DEMO'
                         IMPORTING table = internal_table ).

    cl_abap_unit_assert=>assert_equals( msg = 'Tables dont match' exp = internal_table_expected act = internal_table ).
  ENDMETHOD.

  METHOD throws_when_transformat_fails.
* DDIC Type doesnt exist.
    DATA internal_table  TYPE ztt_bdd_demo.
    DATA: root_exception TYPE REF TO cx_root ##NEEDED.

    DATA(datatable) = zcl_datatable=>from_string( '| 17.07.1952 | David | Hasselhoff      |     |' &&
                                                  '| 30.07.1947 | Arnold | Schwarzenegger | 100 |' ).
    TRY.
        datatable->to_table( EXPORTING ddic_table_type_name = 'ZTT_DOESNT_EXIST'
                             IMPORTING table = internal_table ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_root INTO root_exception.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
