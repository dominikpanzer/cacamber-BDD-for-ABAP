CLASS zcl_cacamber_german DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor IMPORTING test_class_instance TYPE REF TO object OPTIONAL.
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
    METHODS get_current_feature RETURNING VALUE(current_feature) TYPE zcl_cacamber=>feature_t.
    METHODS get_current_scenario RETURNING VALUE(current_scenario) TYPE zcl_cacamber=>scenario_t.
    METHODS get_current_rule RETURNING VALUE(current_rule) TYPE zcl_cacamber=>rule_t.
  PROTECTED SECTION.

    DATA cacamber TYPE REF TO zcl_cacamber.
  PRIVATE SECTION.

ENDCLASS.

CLASS zcl_cacamber_german IMPLEMENTATION.

  METHOD constructor.
    DATA(german_scenario) = |Szenario|.
    DATA(german_rule) = |Regel|.
    DATA(german_keywords) = VALUE string_table( ( |Angenommen | ) ( |Wenn | ) ( |Dann | ) ( |Oder | ) ( |Und | ) ( |Aber | ) ).
    cacamber = NEW zcl_cacamber( test_class_instance = test_class_instance
                                 keywords_for_verify =  german_keywords
                                 scenario_keyword_for_verify = german_scenario
                                 rule_keyword_for_verify = german_rule ).

  ENDMETHOD.

  METHOD aber.
    cacamber->given( step ).
  ENDMETHOD.

  METHOD angenommen.
    cacamber->given( step ).
  ENDMETHOD.

  METHOD beispiel.
    cacamber->scenario( example ).
  ENDMETHOD.

  METHOD configure.
    cacamber->configure( pattern = pattern method_name = method_name ).
  ENDMETHOD.

  METHOD dann.
    cacamber->given( step ).
  ENDMETHOD.

  METHOD funktion.
    cacamber->feature( feature ).
  ENDMETHOD.

  METHOD oder.
    cacamber->given( step ).
  ENDMETHOD.

  METHOD pruefe.
    cacamber->verify( scenario ).
  ENDMETHOD.

  METHOD regel.
    cacamber->rule( rule ).
  ENDMETHOD.

  METHOD szenario.
    cacamber->scenario( scenario ).
  ENDMETHOD.

  METHOD und.
    cacamber->given( step ).
  ENDMETHOD.

  METHOD wenn.
    cacamber->given( step ).
  ENDMETHOD.

  METHOD _.
    cacamber->given( step ).
  ENDMETHOD.

  METHOD get_current_feature.
    current_feature = cacamber->get_current_feature(  ).
  ENDMETHOD.

  METHOD get_current_rule.
    current_rule = cacamber->get_current_rule(  ).
  ENDMETHOD.

  METHOD get_current_scenario.
    current_scenario = cacamber->get_current_scenario(  ).
  ENDMETHOD.

ENDCLASS.
