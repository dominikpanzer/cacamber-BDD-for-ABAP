CLASS acceptance_german_language DEFINITION FINAL FOR TESTING INHERITING FROM zcl_cacamber_german
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA: cacamber TYPE REF TO zcl_cacamber_german,
          sum TYPE int4.
    METHODS can_run_a_scenario FOR TESTING RAISING cx_static_check.
    METHODS setup.
ENDCLASS.


CLASS acceptance_german_language IMPLEMENTATION.

  METHOD setup.
    cacamber = NEW zcl_cacamber_german( ).
  ENDMETHOD.

  METHOD can_run_a_scenario.
    cacamber->configure( pattern = 'your name is (.+) (.+)' method_name = 'WHENYOURNAMEIS' ).

    cacamber->pruefe( 'Szenario: deutsches Szenario' &&
                      'Regel: deutsche Regel' &&
                      'Angenommen eine Variable is 0' &&
                      'Und ich addiere 1 dazu' &&
                      'Oder ich addiere noch mal 1 dazu' &&
                      'Aber dann addiere ich noch mal 1 dazu' &&
                      'Wenn ich dann die Summe berechne' &&
                      'Dann ist die Summe 3' ).

    cl_abap_unit_assert=>assert_equals( msg = 'Wrong sum' exp = 3 act = sum ).
  ENDMETHOD.

ENDCLASS.
