CLASS acceptance_tests DEFINITION FINAL FOR TESTING  INHERITING FROM zcl_cacamber
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PUBLIC SECTION.
    METHODS set_first_and_second_name IMPORTING first_name TYPE char30
                                                last_name  TYPE char30.
    METHODS: set_birthdate IMPORTING birthdate TYPE dats.
    METHODS: calculate_discount IMPORTING product TYPE string,
      eval_slayer_oldschool_discount.

  PRIVATE SECTION.
    DATA discount_calculator TYPE REF TO zcl_bdd_example.
    DATA: discount TYPE int4.
    METHODS: setup.
    METHODS: disount_on_slayer_albums FOR TESTING RAISING cx_static_check.


ENDCLASS.


CLASS acceptance_tests IMPLEMENTATION.
  METHOD setup.
    configure( pattern = '^the customers first name is (.+) and his last name is (.+)$' methodname = 'set_first_and_second_name').
    configure( pattern = '^his birthdate according to our CRM system is (.+)' methodname = 'set_birthdate').
    configure( pattern = '^the sales clerk lets the system calculate the customers discount on a (.+)$' methodname = 'calculate_discount').
    configure( pattern = '^the discount is (.+)% \\m\/$' methodname = 'eval_slayer_oldschool_discount').

    discount_calculator = NEW zcl_bdd_example( ).
  ENDMETHOD.

  METHOD disount_on_slayer_albums.
    given('the customers first name is Dominik and his last name is Panzer').
    and('his birthdate according to our CRM system is 06.06.2006').
    when('the sales clerk lets the system calculate the customers discount on a Slayer Album').
    then('the discount is 66% \m/').
  ENDMETHOD.


  METHOD set_first_and_second_name.
    discount_calculator->set_first_name( first_name ).
    discount_calculator->set_last_name( last_name ).
  ENDMETHOD.

  METHOD set_birthdate.
    discount_calculator->set_birth_date( birthdate ).
  ENDMETHOD.

  METHOD calculate_discount.
    discount = discount_calculator->calculate_discount( product ).
  ENDMETHOD.

  METHOD eval_slayer_oldschool_discount.
    cl_abap_unit_assert=>assert_equals( msg = 'Error' exp = 66 act = discount ).
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
      can_set_birth_date FOR TESTING RAISING cx_static_check,
      can_calculate_discount FOR TESTING RAISING cx_static_check.
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


  METHOD can_calculate_discount.
    DATA(discount) = discount_calculator->calculate_discount( 'Slayer Album' ).
    cl_abap_unit_assert=>assert_equals( msg = 'Error' exp = 0 act = discount ).
  ENDMETHOD.

ENDCLASS.
