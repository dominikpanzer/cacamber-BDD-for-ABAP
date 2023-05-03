CLASS acceptance_tests DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      can_instantiate_via_factory FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS acceptance_tests IMPLEMENTATION.

  METHOD can_instantiate_via_factory.
    DATA(datatable) = zcl_datatable=>from_string( '' ).
    cl_abap_unit_assert=>assert_bound( datatable ).
  ENDMETHOD.

ENDCLASS.
