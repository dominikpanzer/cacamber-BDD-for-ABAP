CLASS zcl_cacamber_german DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor.
    METHODS: configure IMPORTING pattern     TYPE string
                                 method_name TYPE char30.
    METHODS: wenn IMPORTING step TYPE string
                  RAISING   zcx_cacamber_error.
    METHODS: angenommen IMPORTING step TYPE string
                        RAISING   zcx_cacamber_error.
    METHODS: dann IMPORTING step TYPE string
                  RAISING   zcx_cacamber_error.
    METHODS: und IMPORTING step TYPE string
                 RAISING   zcx_cacamber_error.
    METHODS: oder IMPORTING step TYPE string
                  RAISING   zcx_cacamber_error.
    METHODS: aber IMPORTING step TYPE string
                  RAISING   zcx_cacamber_error.
    METHODS: _ IMPORTING step TYPE string
               RAISING   zcx_cacamber_error.
    METHODS funktion IMPORTING feature TYPE zcl_cacamber=>feature_t.
    METHODS szenario IMPORTING scenario TYPE zcl_cacamber=>scenario_t.
    METHODS beispiel IMPORTING example TYPE zcl_cacamber=>scenario_t.
    METHODS regel IMPORTING rule TYPE zcl_cacamber=>rule_t.
    METHODS pruefe IMPORTING scenario TYPE string.
  PRIVATE SECTION.
    DATA cacamber TYPE REF TO zcl_cacamber.
ENDCLASS.



CLASS zcl_cacamber_german IMPLEMENTATION.

  METHOD constructor.
    DATA(german_keywords) = VALUE string_table( ( |Angenommen| ) ( |Wenn| ) ( |Dann| ) ( |Oder| ) ( |Und| ) ( |Aber| ) ).
    DATA(german_scenario) = |Szenario|.
    DATA(german_rule) = |Regel|.
    cacamber = NEW zcl_cacamber( keywords_for_verfiy =  german_keywords
                                 scenario_keyword_for_verify = german_scenario
                                 rule_keyword_for_verify = german_rule ).

  ENDMETHOD.
  METHOD aber.

  ENDMETHOD.

  METHOD angenommen.

  ENDMETHOD.

  METHOD beispiel.

  ENDMETHOD.

  METHOD configure.

  ENDMETHOD.

  METHOD dann.

  ENDMETHOD.

  METHOD funktion.

  ENDMETHOD.

  METHOD oder.

  ENDMETHOD.

  METHOD pruefe.

  ENDMETHOD.

  METHOD regel.

  ENDMETHOD.

  METHOD szenario.

  ENDMETHOD.

  METHOD und.

  ENDMETHOD.

  METHOD wenn.

  ENDMETHOD.

  METHOD _.

  ENDMETHOD.

ENDCLASS.
