CLASS zcl_datatable DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS: from_string IMPORTING table_as_string  TYPE string
                               RETURNING VALUE(datatable) TYPE REF TO zcl_datatable.
    METHODS: constructor IMPORTING table_as_string TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_datatable IMPLEMENTATION.

  METHOD from_string.
    datatable = NEW zcl_datatable( table_as_string ).
  ENDMETHOD.

  METHOD constructor.

  ENDMETHOD.

ENDCLASS.
