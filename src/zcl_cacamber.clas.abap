* regex coach https://regex101.com/
CLASS zcl_cacamber DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS: configure IMPORTING pattern    TYPE string
                                 methodname TYPE char30.
    METHODS: when IMPORTING step TYPE string.
    METHODS: given IMPORTING step TYPE string.
    METHODS: then IMPORTING step TYPE string.
    METHODS: and IMPORTING step TYPE string.
    METHODS: or IMPORTING step TYPE string.

    METHODS constructor IMPORTING testclass_instance TYPE REF TO object OPTIONAL.
    METHODS feature IMPORTING feature TYPE char255.
    METHODS scenario IMPORTING scenario TYPE char255.


  PROTECTED SECTION.
    TYPES: BEGIN OF configuration_ts,
             pattern    TYPE string,
             methodname TYPE char30,
           END OF configuration_ts.
    TYPES: configuration_tt TYPE SORTED TABLE OF configuration_ts WITH UNIQUE KEY pattern.

    TYPES: BEGIN OF parameter_ts,
             name      TYPE char30,
             data_type TYPE char30,
           END OF parameter_ts.
    TYPES: parameters_tt TYPE STANDARD TABLE OF parameter_ts WITH DEFAULT KEY.

    DATA: configuration TYPE configuration_tt.
    DATA: current_feature TYPE char255.
    DATA: current_scenario TYPE char255.

  PRIVATE SECTION.
    CLASS-DATA testclass_instance TYPE REF TO object.

    METHODS get_method_parameters IMPORTING methodname               TYPE char30
                                            local_testclass_instance TYPE REF TO object
                                  RETURNING VALUE(parameters)        TYPE parameters_tt .
    METHODS: extract_variables_from_step IMPORTING step             TYPE string
                                         RETURNING VALUE(variables) TYPE string_table,
      match_step_to_methodname IMPORTING step              TYPE string
                               RETURNING VALUE(methodname) TYPE char30,
      add_variables_to_parameters IMPORTING variables                 TYPE string_table
                                            parameters                TYPE parameters_tt
                                  RETURNING VALUE(matched_parameters) TYPE abap_parmbind_tab.
ENDCLASS.



CLASS zcl_cacamber IMPLEMENTATION.
  METHOD configure.
    CHECK pattern IS NOT INITIAL.
    CHECK methodname IS NOT INITIAL.

    configuration = VALUE #( BASE configuration (  pattern = pattern methodname = to_upper( methodname ) ) ).
  ENDMETHOD.

  METHOD match_step_to_methodname.
    LOOP AT configuration REFERENCE INTO DATA(configuration_entry).
      IF matches( val = step regex = configuration_entry->pattern ).
        methodname = configuration_entry->methodname.
        EXIT.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD extract_variables_from_step.
    LOOP AT configuration REFERENCE INTO DATA(configuration_entry).
      IF NOT matches( val = step regex = configuration_entry->pattern ).
        CONTINUE.
      ENDIF.
      FIND ALL OCCURRENCES OF REGEX configuration_entry->pattern  IN step  RESULTS DATA(findings).
      LOOP AT findings  REFERENCE INTO DATA(finding).
        LOOP AT finding->submatches REFERENCE INTO DATA(submatch).
          DATA(variable) = substring(  val = step off = submatch->offset len = submatch->length ).
          APPEND variable TO variables.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_method_parameters.
    DATA: class_description TYPE REF TO cl_abap_classdescr.
    DATA: object_description TYPE REF TO cl_abap_objectdescr.


    class_description ?= cl_abap_classdescr=>describe_by_object_ref( local_testclass_instance ).
    object_description ?= cl_abap_objectdescr=>describe_by_object_ref( local_testclass_instance ).

    READ TABLE class_description->methods REFERENCE INTO DATA(method) WITH KEY name = methodname.


    LOOP AT method->parameters REFERENCE INTO DATA(method_parameter).
      DATA(parameter_description) = object_description->get_method_parameter_type( p_method_name = methodname
                                                                                  p_parameter_name = method_parameter->name ).

      parameters = VALUE #( BASE parameters ( name = method_parameter->name data_type = parameter_description->absolute_name+6(194) ) ).
    ENDLOOP.
  ENDMETHOD.

  METHOD add_variables_to_parameters.
    CONSTANTS exporting TYPE string VALUE 'E' ##NO_TEXT.
    DATA: parameter_value TYPE REF TO data.

    LOOP AT parameters ASSIGNING FIELD-SYMBOL(<parameter>).
      CREATE DATA parameter_value TYPE (<parameter>-data_type).

      IF matches( val = variables[ sy-tabix ] regex = '^\s*(3[01]|[12][0-9]|0?[1-9])\.(1[012]|0?[1-9])\.((?:19|20)\d{2})\s*$' ).
        cl_abap_datfm=>conv_date_ext_to_int( EXPORTING im_datext = variables[ sy-tabix ]
                                                       im_datfmdes = '1'
       IMPORTING ex_datint = parameter_value->*  ).
      ELSE.
        parameter_value->* = |{ variables[ sy-tabix ] ALPHA = IN }|.
      ENDIF.
      matched_parameters = VALUE #( BASE matched_parameters ( name = <parameter>-name kind = exporting value = parameter_value ) ).
    ENDLOOP.
  ENDMETHOD.

  METHOD given.
    DATA(methodname) = match_step_to_methodname( step ).
    CHECK methodname IS NOT INITIAL.

    DATA(variables) = extract_variables_from_step( step ).
    DATA(parameters) = get_method_parameters( local_testclass_instance = me->testclass_instance methodname = methodname ).
    DATA(matched_parameters) = add_variables_to_parameters( variables = variables parameters = parameters ).
    CALL METHOD me->testclass_instance->(methodname) PARAMETER-TABLE matched_parameters.
  ENDMETHOD.

  METHOD when.
    given( step ).
  ENDMETHOD.

  METHOD and.
    given( step ).
  ENDMETHOD.

  METHOD or.
    given( step ).
  ENDMETHOD.

  METHOD then.
    given( step ).
  ENDMETHOD.

  METHOD constructor.
    me->testclass_instance = COND #( WHEN testclass_instance IS INITIAL THEN me
                                     ELSE testclass_instance ).
  ENDMETHOD.

  METHOD feature.
    current_feature = feature.
  ENDMETHOD.


  METHOD scenario.
    current_scenario = scenario.
  ENDMETHOD.

ENDCLASS.
