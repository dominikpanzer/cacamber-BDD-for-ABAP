CLASS acceptance_german_language DEFINITION FINAL FOR TESTING INHERITING FROM zcl_cacamber_german
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA: cacamber TYPE REF TO zcl_cacamber_german,
          sum      TYPE int4.
    METHODS can_run_a_scenario FOR TESTING RAISING cx_static_check.
    METHODS setup.
ENDCLASS.


CLASS acceptance_german_language IMPLEMENTATION.

  METHOD setup.
    cacamber = NEW zcl_cacamber_german( ).
    cacamber->configure( pattern = '^eine Variable ist (.+)$' method_name = 'set_initial_value' ).
    cacamber->configure( pattern = '^ich addiere (.+) dazu$' method_name = 'add_value' ).
    cacamber->configure( pattern = '^ich addiere noch mal (.+) dazu$' method_name = 'add_value' ).
    cacamber->configure( pattern = '^dann addiere ich noch mal (.+) dazu$' method_name = 'add_value' ).
    cacamber->configure( pattern = '^ich dann die Summe verdopple$' method_name = 'calculate' ).
    cacamber->configure( pattern = '^ist das Ergebnis (.*) und Szenario und Regel sind gesetzt$' method_name = 'verfiy' ).
  ENDMETHOD.

  METHOD can_run_a_scenario.
    cacamber->pruefe( 'Szenario: deutsches Szenario' &&
                      'Regel: deutsche Regel' &&
                      'Angenommen eine Variable ist 0' &&
                      'Und ich addiere 1 dazu' &&
                      'Oder ich addiere noch mal 1 dazu' &&
                      'Aber dann addiere ich noch mal 1 dazu' &&
                      'Wenn ich dann die Summe verdopple' &&
                      'Dann ist das Ergebnis 6 und Szenario und Regel sind gesetzt' ).
  ENDMETHOD.

ENDCLASS.
