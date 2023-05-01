CLASS acceptance_tests DEFINITION FINAL FOR TESTING  INHERITING FROM zcl_cacamber
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PUBLIC SECTION.
    METHODS set_first_and_second_name IMPORTING first_name TYPE char30
                                                last_name  TYPE char30.

  PRIVATE SECTION.
    DATA discount_calculator TYPE REF TO zcl_bdd_example.
    METHODS: setup.
    METHODS: disount_on_slayer_albums FOR TESTING RAISING cx_static_check.


ENDCLASS.


CLASS acceptance_tests IMPLEMENTATION.
  METHOD setup.
    configure( pattern = '^the customers first name is (.+) and his last name is (.+)$' methodname = 'set_first_and_second_name').
    configure( pattern = '^his birthdate according to our CRM system is (.+)' methodname = 'get_birthdate').
    configure( pattern = '^I let the system calculate his personal discount on (.+)$' methodname = 'calculate_discount').
    configure( pattern = '^the discount is (.+)% \m/$' methodname = 'validate_discountrate').

    discount_calculator = NEW zcl_bdd_example( ).
  ENDMETHOD.

  METHOD disount_on_slayer_albums.
    given('the customers first name is Dominik and his last name is Panzer').
    and('his birthdate according to our CRM system is 06.06.2006').
    when('I let the system calculate his personal discount on slayer albums').
    then('the discount is 66% \m/').
  ENDMETHOD.


  METHOD set_first_and_second_name.
    discount_calculator->set_first_name( first_name ).
    discount_calculator->set_last_name( last_name ).
  ENDMETHOD.

ENDCLASS.


CLASS scuffolding_tests DEFINITION DEFERRED.
CLASS zcl_bdd_example DEFINITION LOCAL FRIENDS scuffolding_tests.
CLASS scuffolding_tests DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA discount_calculator TYPE REF TO zcl_bdd_example.
    METHODS: setup.
    METHODS: can_set_first_name FOR TESTING RAISING cx_static_check,
      can_set_last_name FOR TESTING RAISING cx_static_check,
      can_set_birth_date FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS scuffolding_tests IMPLEMENTATION.
  METHOD setup.
    discount_calculator = NEW zcl_bdd_example( ).
  ENDMETHOD.

  METHOD can_set_first_name.
    discount_calculator->set_first_name( 'test' ).
    cl_abap_unit_assert=>assert_equals( msg = 'Error' exp = 'test' act = discount_calculator->first_name ).
  ENDMETHOD.

  METHOD can_set_last_name.
    discount_calculator->set_last_name( 'test' ).
    cl_abap_unit_assert=>assert_equals( msg = 'Error' exp = 'test' act = discount_calculator->last_name ).
  ENDMETHOD.

  METHOD can_set_birth_date.
    discount_calculator->set_birth_date( '20000101' ).
    cl_abap_unit_assert=>assert_equals( msg = 'Error' exp = '20000101' act = discount_calculator->birth_date ).
  ENDMETHOD.


ENDCLASS.
