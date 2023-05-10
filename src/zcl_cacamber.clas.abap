CLASS zcl_cacamber DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: feature_t TYPE c LENGTH 255.
    TYPES: scenario_t TYPE c LENGTH 255.
    TYPES: rule_t TYPE c LENGTH 255.

    METHODS: configure IMPORTING pattern     TYPE string
                                 method_name TYPE char30.
    METHODS: when IMPORTING step TYPE string
                  RAISING   zcx_cacamber_error.
    METHODS: given IMPORTING step TYPE string
                   RAISING   zcx_cacamber_error.
    METHODS: then IMPORTING step TYPE string
                  RAISING   zcx_cacamber_error.
    METHODS: and IMPORTING step TYPE string
                 RAISING   zcx_cacamber_error.
    METHODS: or IMPORTING step TYPE string
                RAISING   zcx_cacamber_error.
    METHODS: but IMPORTING step TYPE string
                 RAISING   zcx_cacamber_error.
    METHODS: _ IMPORTING step TYPE string
               RAISING   zcx_cacamber_error.
    METHODS constructor IMPORTING test_class_instance TYPE REF TO object OPTIONAL.
    METHODS feature IMPORTING feature TYPE feature_t.
    METHODS scenario IMPORTING scenario TYPE scenario_t.
    METHODS example IMPORTING example TYPE scenario_t.
    METHODS rule IMPORTING rule TYPE rule_t.

    METHODS run
      IMPORTING
        scenario TYPE string.


  PROTECTED SECTION.
    TYPES: BEGIN OF configuration_ts,
             pattern     TYPE string,
             method_name TYPE char30,
           END OF configuration_ts.
    TYPES: configuration_tt TYPE SORTED TABLE OF configuration_ts WITH UNIQUE KEY pattern.

    TYPES: BEGIN OF parameter_ts,
             name      TYPE char30,
             data_type TYPE char30,
           END OF parameter_ts.
    TYPES: parameters_tt TYPE STANDARD TABLE OF parameter_ts WITH DEFAULT KEY.


    TYPES: BEGIN OF match_ts,
             offset      TYPE int4,
             method_name TYPE char30,
             variables   TYPE string_table,
           END OF match_ts.
    TYPES: matches_tt TYPE STANDARD TABLE OF match_ts WITH DEFAULT KEY.

    DATA: configuration TYPE configuration_tt.
    DATA: current_feature TYPE feature_t.
    DATA: current_scenario TYPE scenario_t.
    DATA: current_rule TYPE rule_t.

  PRIVATE SECTION.
    CLASS-DATA test_class_instance TYPE REF TO object.

    METHODS get_method_parameters IMPORTING method_name              TYPE char30
                                            local_testclass_instance TYPE REF TO object
                                  RETURNING VALUE(parameters)        TYPE parameters_tt
                                  RAISING   zcx_cacamber_error .
    METHODS: extract_variables_from_step IMPORTING step             TYPE string
                                         RETURNING VALUE(variables) TYPE string_table,
      match_step_to_method_name IMPORTING step               TYPE string
                                RETURNING VALUE(method_name) TYPE char30,
      add_variables_to_parameters IMPORTING variables                 TYPE string_table
                                            parameters                TYPE parameters_tt
                                  RETURNING VALUE(matched_parameters) TYPE abap_parmbind_tab,
      paramaters_dont_match_variable IMPORTING parameters    TYPE zcl_cacamber=>parameters_tt
                                               variables     TYPE string_table
                                     RETURNING VALUE(result) TYPE abap_bool,
      is_gregorian_dot_seperated IMPORTING variable      TYPE string
                                 RETURNING VALUE(result) TYPE abap_bool,
      is_time_format IMPORTING variable      TYPE string
                     RETURNING VALUE(result) TYPE abap_bool,
      format_time IMPORTING variable    TYPE string
                  RETURNING VALUE(time) TYPE string,
      convertion_exit_inbound IMPORTING variable                 TYPE string
                              RETURNING VALUE(variable_internal) TYPE string,
      get_method_by_method_name IMPORTING method_name               TYPE char30
                                          class_description         TYPE REF TO cl_abap_classdescr
                                RETURNING VALUE(method_description) TYPE REF TO abap_methdescr,
      get_matches_for
        IMPORTING scenario       TYPE string
        RETURNING VALUE(matches) TYPE matches_tt.
ENDCLASS.



CLASS zcl_cacamber IMPLEMENTATION.
  METHOD configure.
    CHECK pattern IS NOT INITIAL.
    CHECK method_name IS NOT INITIAL.

    configuration = VALUE #( BASE configuration (  pattern = pattern method_name = to_upper( method_name ) ) ).
  ENDMETHOD.

  METHOD match_step_to_method_name.
    LOOP AT configuration REFERENCE INTO DATA(configuration_entry).
      IF matches( val = step regex = configuration_entry->pattern ).
        method_name = configuration_entry->method_name.
        EXIT.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD extract_variables_from_step.
    LOOP AT configuration REFERENCE INTO DATA(configuration_entry).
      IF NOT matches( val = step regex = configuration_entry->pattern ).
        CONTINUE.
      ENDIF.
      FIND ALL OCCURRENCES OF REGEX configuration_entry->pattern IN step RESULTS DATA(findings).
      LOOP AT findings REFERENCE INTO DATA(finding).
        LOOP AT finding->submatches REFERENCE INTO DATA(submatch).
          DATA(variable) = substring( val = step off = submatch->offset len = submatch->length ).
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
    DATA(method) = get_method_by_method_name( method_name = method_name class_description = class_description ).
    IF method IS INITIAL.
      RAISE EXCEPTION TYPE zcx_cacamber_error.
    ENDIF.
    LOOP AT method->parameters REFERENCE INTO DATA(method_parameter).
      DATA(parameter_description) = object_description->get_method_parameter_type( p_method_name = method_name
                                                                                  p_parameter_name = method_parameter->name ).
      parameters = VALUE #( BASE parameters ( name = method_parameter->name data_type = parameter_description->absolute_name+6(194) ) ).
    ENDLOOP.
  ENDMETHOD.

  METHOD get_method_by_method_name.
    READ TABLE class_description->methods REFERENCE INTO method_description  WITH KEY name = method_name.
  ENDMETHOD.



  METHOD add_variables_to_parameters.
    CONSTANTS exporting TYPE string VALUE 'E' ##NO_TEXT.
    DATA: parameter_value TYPE REF TO data.

    LOOP AT parameters ASSIGNING FIELD-SYMBOL(<parameter>).
      CREATE DATA parameter_value TYPE (<parameter>-data_type).
      IF is_gregorian_dot_seperated( variables[ sy-tabix ] ).
        cl_abap_datfm=>conv_date_ext_to_int( EXPORTING im_datext = variables[ sy-tabix ]
                                                       im_datfmdes = '1'
                                             IMPORTING ex_datint = parameter_value->* ).
      ELSEIF is_time_format( variables[ sy-tabix ] ).
        parameter_value->* = format_time( variables[ sy-tabix ] ).
      ELSE.
        parameter_value->* = convertion_exit_inbound( variables[ sy-tabix ] ).
      ENDIF.
      matched_parameters = VALUE #( BASE matched_parameters ( name = <parameter>-name kind = exporting value = parameter_value ) ).
    ENDLOOP.
  ENDMETHOD.

  METHOD convertion_exit_inbound.
    variable_internal = |{ variable ALPHA = IN }|.
  ENDMETHOD.

  METHOD format_time.
    time = translate( val = variable  from = `:`  to = `` ).
  ENDMETHOD.

  METHOD is_time_format.
    CONSTANTS time_format_hhmmss_with_colon TYPE string VALUE '^(2[0-3]|[01]?[0-9]):([0-5]?[0-9]):([0-5]?[0-9])$'.
    result = xsdbool( matches( val = variable regex = time_format_hhmmss_with_colon ) ).
  ENDMETHOD.

  METHOD is_gregorian_dot_seperated.
    CONSTANTS ddmmyyyy_dot_seperated TYPE string VALUE '^(0[0-9]|[12][0-9]|3[01])[- \..](0[0-9]|1[012])[- \..]\d\d\d\d$'.
    result = xsdbool( matches( val = variable regex = ddmmyyyy_dot_seperated ) ).
  ENDMETHOD.

  METHOD given.
    DATA(method_name) = match_step_to_method_name( step ).
    DATA(variables) = extract_variables_from_step( step ).
    DATA(parameters) = get_method_parameters( local_testclass_instance = me->test_class_instance method_name = method_name ).
    IF paramaters_dont_match_variable( parameters = parameters variables = variables ).
      RAISE EXCEPTION TYPE zcx_cacamber_error.
    ENDIF.
    DATA(matched_parameters) = add_variables_to_parameters( variables = variables parameters = parameters ).
    CALL METHOD me->test_class_instance->(method_name) PARAMETER-TABLE matched_parameters.
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

  METHOD example.
    scenario( example ).
  ENDMETHOD.

  METHOD but.
    given( step ).
  ENDMETHOD.

  METHOD _.
    given( step ).
  ENDMETHOD.

  METHOD constructor.
* A test class is not allowed to have mandatory constructor parameters
* but the parameter is needed for the test for ZCL_CACAMBE to inject
* a self-reference of the local test class
* it's a tradeoff
    me->test_class_instance = COND #( WHEN test_class_instance IS INITIAL THEN me
                                     ELSE test_class_instance ).
  ENDMETHOD.

  METHOD feature.
    current_feature = feature.
  ENDMETHOD.

  METHOD scenario.
    current_scenario = scenario.
  ENDMETHOD.

  METHOD rule.
    current_rule = rule.
  ENDMETHOD.

  METHOD paramaters_dont_match_variable.
    result = xsdbool( lines( variables ) <> lines( parameters ) ).
  ENDMETHOD.


  METHOD get_matches_for.
    DATA: variables TYPE string_table.

    LOOP AT configuration REFERENCE INTO DATA(configuration_entry).
      DATA(offset) = find( val = scenario regex = configuration_entry->pattern ).
      CHECK sy-subrc = 0.
      FIND ALL OCCURRENCES OF REGEX configuration_entry->pattern IN scenario RESULTS DATA(findings).
      LOOP AT findings REFERENCE INTO DATA(finding).
        CLEAR variables.
        LOOP AT finding->submatches REFERENCE INTO DATA(submatch).
          DATA(variable) = substring( val = scenario off = submatch->offset len = submatch->length ).
          APPEND variable TO variables.
        ENDLOOP.
      ENDLOOP.
      matches = VALUE #( BASE matches ( offset = offset method_name = configuration_entry->method_name variables = variables ) ).
    ENDLOOP.
    SORT matches BY offset ASCENDING.
  ENDMETHOD.

  METHOD run.
    DATA(matches) = get_matches_for( scenario ).
    LOOP AT matches REFERENCE INTO DATA(match).
      DATA(parameters) = get_method_parameters( local_testclass_instance = me->test_class_instance method_name = match->method_name ).
      IF paramaters_dont_match_variable( parameters = parameters variables = match->variables ).
        RAISE EXCEPTION TYPE zcx_cacamber_error.
      ENDIF.
      DATA(matched_parameters) = add_variables_to_parameters( variables = match->variables parameters = parameters ).
      CALL METHOD me->test_class_instance->(match->method_name) PARAMETER-TABLE matched_parameters.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
