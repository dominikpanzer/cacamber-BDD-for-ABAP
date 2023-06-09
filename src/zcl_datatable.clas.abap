CLASS zcl_datatable DEFINITION
  PUBLIC
  CREATE PRIVATE.

  PUBLIC SECTION.
    TYPES: BEGIN OF datatable_line_ts,
             row    TYPE int4,
             column TYPE int4,
             value  TYPE string,
           END OF datatable_line_ts.
    TYPES: datatable_tt TYPE SORTED TABLE OF datatable_line_ts WITH UNIQUE KEY row column.
    CLASS-METHODS from_string IMPORTING table_as_string  TYPE string
                              RETURNING VALUE(datatable) TYPE REF TO zcl_datatable
                              RAISING   zcx_cacamber_error.
    METHODS read_row IMPORTING rownumber   TYPE int4
                     RETURNING VALUE(line) TYPE string_table
                     RAISING   zcx_cacamber_error ##NEEDED.
    METHODS read_cell IMPORTING rownumber    TYPE int4
                                columnnumber TYPE int4
                      RETURNING VALUE(value) TYPE string
                      RAISING   zcx_cacamber_error.
    METHODS to_table IMPORTING ddic_table_type_name TYPE tabname
                     EXPORTING VALUE(table)         TYPE any.
    METHODS is_gregorian_dot_seperated IMPORTING variable      TYPE string
                                       RETURNING VALUE(result) TYPE abap_bool.
    METHODS is_time_format IMPORTING variable      TYPE string
                           RETURNING VALUE(result) TYPE abap_bool.
    METHODS format_time IMPORTING variable    TYPE string
                        RETURNING VALUE(time) TYPE string.
  PRIVATE SECTION.
    DATA datatable TYPE datatable_tt.
    METHODS parse IMPORTING table_as_string TYPE string.
ENDCLASS.



CLASS zcl_datatable IMPLEMENTATION.


  METHOD from_string.
    IF table_as_string IS INITIAL.
      RAISE EXCEPTION TYPE zcx_cacamber_error.
    ENDIF.
    datatable = NEW zcl_datatable( ).
    datatable->parse( table_as_string ).
  ENDMETHOD.


  METHOD parse.
    DATA datatable_line TYPE datatable_line_ts.
    SPLIT table_as_string AT '|' INTO TABLE DATA(raw_entries).
    LOOP AT raw_entries REFERENCE INTO DATA(raw_entry).
      IF raw_entry->* IS INITIAL.
        datatable_line-row = datatable_line-row + 1.
        datatable_line-column = 0.
        CONTINUE.
      ENDIF.
      CONDENSE raw_entry->*.
      datatable_line-column = datatable_line-column + 1.
      datatable_line-value = raw_entry->*.
      INSERT datatable_line INTO TABLE datatable.
    ENDLOOP.
  ENDMETHOD.


  METHOD read_row.
    DATA(reduced_datatable) = FILTER #( datatable WHERE row = rownumber ).
    line = VALUE #( FOR datatable_line IN reduced_datatable ( datatable_line-value ) ).

    IF line IS INITIAL.
      RAISE EXCEPTION TYPE zcx_cacamber_error.
    ENDIF.
  ENDMETHOD.


  METHOD read_cell.
    READ TABLE datatable INTO DATA(datatable_line) WITH KEY row = rownumber column = columnnumber.
    IF datatable_line IS INITIAL.
      RAISE EXCEPTION TYPE zcx_cacamber_error.
    ENDIF.
    value = datatable_line-value.
  ENDMETHOD.


  METHOD to_table.
* transforms the line-column-value datatable into a real internal table of the
* supplied tabletype
    DATA: table_data_reference TYPE REF TO data.
    DATA: structure_data_reference TYPE REF TO data.
    DATA: row_number TYPE int4 VALUE 1.
    FIELD-SYMBOLS: <table> TYPE STANDARD TABLE.
    FIELD-SYMBOLS: <line> TYPE any.
    FIELD-SYMBOLS: <cell> TYPE any.

    CREATE DATA table_data_reference TYPE (ddic_table_type_name).
    ASSIGN table_data_reference->* TO <table>.

    CREATE DATA structure_data_reference TYPE LINE OF (ddic_table_type_name).
    ASSIGN structure_data_reference->* TO <line>.

    LOOP AT datatable REFERENCE INTO DATA(datatable_line).
      IF datatable_line->row <> row_number.
        APPEND <line> TO <table>.
        row_number = datatable_line->row.
      ENDIF.
      ASSIGN COMPONENT datatable_line->column OF STRUCTURE <line> TO <cell>.
      CHECK <cell> IS ASSIGNED.

      IF is_gregorian_dot_seperated( datatable_line->value ).
        cl_abap_datfm=>conv_date_ext_to_int( EXPORTING im_datext = datatable_line->value
                                                       im_datfmdes = '1'
                                             IMPORTING ex_datint = <cell> ).
      ELSEIF is_time_format( datatable_line->value ).
        <cell> = format_time( datatable_line->value ).
      ELSE.
        <cell> = datatable_line->value.
      ENDIF.
      UNASSIGN <cell>.
    ENDLOOP.
    APPEND <line> TO <table>.

    table = <table>.
  ENDMETHOD.

  METHOD is_gregorian_dot_seperated.
    CONSTANTS ddmmyyyy_dot_seperated TYPE string VALUE '^(0[0-9]|[12][0-9]|3[01])[- \..](0[0-9]|1[012])[- \..]\d\d\d\d$'.
    result = xsdbool( matches( val = variable regex = ddmmyyyy_dot_seperated ) ).
  ENDMETHOD.

  METHOD is_time_format.
    CONSTANTS time_format_hhmmss_with_colon TYPE string VALUE '^(2[0-3]|[01]?[0-9]):([0-5]?[0-9]):([0-5]?[0-9])$'.
    result = xsdbool( matches( val = variable regex = time_format_hhmmss_with_colon ) ).
  ENDMETHOD.

  METHOD format_time.
    time = translate( val = variable  from = `:`  to = `` ).
  ENDMETHOD.
ENDCLASS.
