CLASS zcx_cacamber_error DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_t100_message .
    INTERFACES if_t100_dyn_msg .

    CONSTANTS:
      BEGIN OF method_not_found,
        msgid TYPE symsgid VALUE 'Z_CACAMBER',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'TEXT1',
        attr2 TYPE scx_attrname VALUE 'TEXT2',
        attr3 TYPE scx_attrname VALUE 'TEXT3',
        attr4 TYPE scx_attrname VALUE 'TEXT4',
      END OF method_not_found.
    DATA text1 TYPE string .
    DATA text2 TYPE string .
    DATA text3 TYPE string .
    DATA text4 TYPE string .

    METHODS constructor
      IMPORTING
        !textid   LIKE if_t100_message=>t100key OPTIONAL
        !previous LIKE previous OPTIONAL
        !text1    TYPE string OPTIONAL
        !text2    TYPE string OPTIONAL
        !text3    TYPE string OPTIONAL
        !text4    TYPE string OPTIONAL .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcx_cacamber_error IMPLEMENTATION.
  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.
    me->text1 = text1 .
    me->text2 = text2 .
    me->text3 = text3 .
    me->text4 = text4 .
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
