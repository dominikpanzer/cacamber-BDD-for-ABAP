CLASS zcl_bdd_example DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS set_first_name
      IMPORTING
        first_name TYPE char30.
    METHODS: set_last_name IMPORTING last_name TYPE char30,
      set_birth_date IMPORTING birth_date TYPE dats.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA first_name TYPE char30.
    DATA last_name TYPE char30.
    DATA birth_date TYPE dats.
ENDCLASS.



CLASS ZCL_BDD_EXAMPLE IMPLEMENTATION.


  METHOD set_first_name.
    me->first_name = first_name.
  ENDMETHOD.


  METHOD set_last_name.
    me->last_name = last_name.
  ENDMETHOD.


  METHOD set_birth_date.
    me->birth_date = birth_date.
  ENDMETHOD.
ENDCLASS.
