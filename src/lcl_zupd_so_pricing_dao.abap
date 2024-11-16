*"* use this source file for your ABAP unit test classes

CLASS lcl_zupd_so_pricing_dao DEFINITION
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES ZUPD_IF_SO_PRICING.

    METHODS: constructor.


  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS: c_not_found TYPE sy-subrc  VALUE 4.
ENDCLASS.


CLASS lcl_zupd_so_pricing_dao IMPLEMENTATION.

  METHOD constructor.

  ENDMETHOD.

  METHOD ZUPD_IF_SO_PRICING~fetch_auart.

    IF i_vbeln EQ '23009495'.

      e_auart = 'ZFSC'.

    ELSEIF i_vbeln EQ '23009494'.

      e_auart = 'ZIMP'.

    ELSE.

      CLEAR e_auart.

    ENDIF.

  ENDMETHOD.

  METHOD ZUPD_IF_SO_PRICING~select_labor.
    IF  i_matnr = '19DGPY'.
      e_labor = 'PY'.
    ELSE.
      CLEAR e_labor.
      RAISE EXCEPTION TYPE cx_bapi_ex
        EXPORTING
          sysubrc = c_not_found.
    ENDIF.

  ENDMETHOD.

  METHOD ZUPD_IF_SO_PRICING~select_mbew.

    IF i_vbeln EQ '23009495'.
      e_zcmw = '5777.22'.
    ELSEIF i_vbeln EQ '23999988'.
      e_zcmw = '12545.25'.
    ELSE.

      CLEAR e_zcmw.

      RAISE EXCEPTION TYPE cx_bapi_ex
        EXPORTING
          sysubrc = c_not_found.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
