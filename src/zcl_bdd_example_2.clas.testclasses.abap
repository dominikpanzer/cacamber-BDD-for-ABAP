CLASS acceptance_discount_calculatio DEFINITION FINAL FOR TESTING INHERITING FROM zcl_cacamber
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PUBLIC SECTION.
    METHODS set_first_and_second_name IMPORTING first_name TYPE char30
                                                last_name  TYPE char30.
    METHODS: set_birthdate IMPORTING birthdate TYPE dats.
    METHODS: process_shopping_cart IMPORTING shopping_cart_raw TYPE string.
    METHODS: calculate_discount IMPORTING product TYPE string.
    METHODS: evaluate_applied_discount IMPORTING expected TYPE int4.

  PRIVATE SECTION.
    DATA discount_calculator TYPE REF TO zcl_bdd_example_2.
    DATA: discount TYPE int4.
    DATA: shopping_cart TYPE REF TO zcl_datatable.
    METHODS: setup.
    METHODS: discount_on_slayer_albums FOR TESTING RAISING cx_static_check.
    METHODS: no_discount_on_shopping_cart FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS acceptance_discount_calculatio IMPLEMENTATION.
  METHOD setup.
    feature( 'Discount Calcuation' ).
    configure( pattern = '^the customers first name is (.+) and his last name is (.+)$' method_name = 'set_first_and_second_name' ).
    configure( pattern = '^his birthdate according to our CRM system is (.+)' method_name = 'set_birthdate' ).
    configure( pattern = '^the sales clerk lets the system calculate the customers discount on the (.+)$' method_name = 'calculate_discount' ).
    configure( pattern = '^the discount is (.+)% \\m\/$' method_name = 'evaluate_applied_discount' ).
    configure( pattern = '^in his shopping cart are the following items:(.*)$' method_name = 'process_shopping_cart' ).

    discount_calculator = NEW zcl_bdd_example_2( ).
  ENDMETHOD.

  METHOD discount_on_slayer_albums.
    verify( 'Scenario: Discount on Slayer Albums for VIP Slayer fans (exclusive contract with BMG)' &&
            'Given the customers first name is Dominik and his last name is Panzer' &&
            'And his birthdate according to our CRM system is 06.06.2006' &&
            'When the sales clerk lets the system calculate the customers discount on the Slayer Album' &&
            'Then the discount is 66% \m/' ).
  ENDMETHOD.

  METHOD no_discount_on_shopping_cart.
    verify( 'Scenario: Customer is not eligable for a discount on the shopping cart' &&
            'Given the customers first name is Dominik and his last name is Panzer' &&
            'And his birthdate according to our CRM system is 06.06.2006' &&
            'And in his shopping cart are the following items:' &&
            '| 1 | Scooter - Hyper Hyper |' &&
            '| 1 | Scooter - How Much Is The Fish |' &&
            '| 1 | Scooter - Maria (I like it loud) |' &&
            'When the sales clerk lets the system calculate the customers discount on the shopping cart'  &&
            'Then the discount is 0% \m/' ).
  ENDMETHOD.


  METHOD set_first_and_second_name.
    discount_calculator->set_first_name( first_name ).
    discount_calculator->set_last_name( last_name ).
  ENDMETHOD.

  METHOD set_birthdate.
    discount_calculator->set_birth_date( birthdate ).
  ENDMETHOD.

  METHOD calculate_discount.
    IF product = 'Slayer Album'.
      discount = discount_calculator->calculate_discount( product ).
    ELSEIF product = 'shopping cart'.
      discount = REDUCE #( INIT discount_sum = 0
                           FOR n = 1 UNTIL n = 3
                           NEXT discount_sum = discount + discount_calculator->calculate_discount( shopping_cart->read_cell( rownumber = n columnnumber = 2 ) ) ).
    ENDIF.
  ENDMETHOD.

  METHOD evaluate_applied_discount.
    cl_abap_unit_assert=>assert_equals( msg = |{ get_current_feature( ) }: { get_current_scenario( ) }| exp = expected act = discount ).
  ENDMETHOD.

  METHOD process_shopping_cart.
    shopping_cart = zcl_datatable=>from_string( shopping_cart_raw ).
  ENDMETHOD.

ENDCLASS.


CLASS scuffolding_discount_calculati DEFINITION DEFERRED.
CLASS zcl_bdd_example_2 DEFINITION LOCAL FRIENDS scuffolding_discount_calculati.
CLASS scuffolding_discount_calculati DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA discount_calculator TYPE REF TO zcl_bdd_example_2.
    METHODS: setup.
    METHODS: can_set_first_name FOR TESTING RAISING cx_static_check.
    METHODS: can_set_last_name FOR TESTING RAISING cx_static_check.
    METHODS: can_set_birth_date FOR TESTING RAISING cx_static_check.
    METHODS: can_calculate_discount FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS scuffolding_discount_calculati IMPLEMENTATION.
  METHOD setup.
    discount_calculator = NEW zcl_bdd_example_2( ).
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
    cl_abap_unit_assert=>assert_equals( exp = 0 act = discount ).
  ENDMETHOD.

ENDCLASS.
