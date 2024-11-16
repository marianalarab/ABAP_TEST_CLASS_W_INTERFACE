CLASS LCL_ZUPD_SO_PRICING DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA: lo_data_accessor     TYPE REF TO ZUPD_IF_SO_PRICING.
    DATA: lo_ZUPD_SO_PRICING TYPE REF TO ZUPD_SO_PRICING. "f_cut

    METHODS: setup.
    METHODS:
      is_CORRECT_PROCESS_true       FOR TESTING RAISING cx_static_check,
      is_CORRECT_PROCESS_false      FOR TESTING RAISING cx_static_check,
      is_CORRECT_PROCESS_false2     FOR TESTING RAISING cx_static_check,
      is_CORRECT_PROCESS_false3     FOR TESTING RAISING cx_static_check,
      is_CORRECT_PROCESS_false4     FOR TESTING RAISING cx_static_check,
      is_CORRECT_PROCESS_false5     FOR TESTING RAISING cx_static_check,
      map_so_price_date_update FOR TESTING RAISING cx_static_check,
      map_new_zcmw_value_s     FOR TESTING RAISING cx_static_check,
      map_new_zcmw_value_f     FOR TESTING RAISING cx_static_check,
      map_new_zcmw_value_ov    FOR TESTING RAISING cx_static_check,
      is_special_customer_t    FOR TESTING RAISING cx_static_check,
      is_special_customer_f    FOR TESTING RAISING cx_static_check,
      is_special_customer_zimp FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS LCL_ZUPD_SO_PRICING IMPLEMENTATION.

  METHOD setup.

    lo_data_accessor = new lcl_zupd_so_pricing_dao( ).

    lo_ZUPD_SO_PRICING = NEW ZUPD_SO_PRICING( if_data_accessor = lo_data_accessor ).

  ENDMETHOD.

  METHOD is_CORRECT_PROCESS_true.

    lo_ZUPD_SO_PRICING->is_CORRECT_PROCESS(
      EXPORTING
        i_matnr = '19DGPY'
        i_sernr = '1PY5105MCPB000225'
      RECEIVING
        e_5m    = DATA(is_5m)
    ).

    IF is_5m EQ abap_false.

      cl_abap_unit_assert=>fail( 'is_CORRECT_PROCESS_true failed' ).

    ENDIF.

  ENDMETHOD.

  METHOD is_CORRECT_PROCESS_false.

    lo_ZUPD_SO_PRICING->is_CORRECT_PROCESS(
    EXPORTING
      i_matnr = '19DGPY'
      i_sernr = '1QC5105MCPB000225'
    RECEIVING
      e_5m    = DATA(is_5m)
  ).

    IF is_5m EQ abap_true.

      cl_abap_unit_assert=>fail( 'is_CORRECT_PROCESS_false failed' ).

    ENDIF.

  ENDMETHOD.

  METHOD is_CORRECT_PROCESS_false2.

    lo_ZUPD_SO_PRICING->is_CORRECT_PROCESS(
      EXPORTING
        i_matnr = '19DGPC'
        i_sernr = '1PY5105MCPB000225'
      RECEIVING
        e_5m    = DATA(is_5m)
    ).

    IF is_5m EQ abap_true.

      cl_abap_unit_assert=>fail( 'is_CORRECT_PROCESS_false failed' ).

    ENDIF.

  ENDMETHOD.

  METHOD is_CORRECT_PROCESS_false3.

    lo_ZUPD_SO_PRICING->is_CORRECT_PROCESS(
      EXPORTING
        i_matnr = '19AGPY'
        i_sernr = '1PY5105MCPB000225'
      RECEIVING
        e_5m    = DATA(is_5m)
    ).

    IF is_5m EQ abap_true.

      cl_abap_unit_assert=>fail( 'is_CORRECT_PROCESS_false failed' ).

    ENDIF.
  ENDMETHOD.

  METHOD is_CORRECT_PROCESS_false4.
    lo_ZUPD_SO_PRICING->is_CORRECT_PROCESS(
      EXPORTING
        i_matnr = '19DGMB'
        i_sernr = '1PY5105MCPB000225'
      RECEIVING
        e_5m    = DATA(is_5m)
    ).

    IF is_5m EQ abap_true.

      cl_abap_unit_assert=>fail( 'is_CORRECT_PROCESS_true failed' ).

    ENDIF.
  ENDMETHOD.

  METHOD is_CORRECT_PROCESS_false5.

    lo_ZUPD_SO_PRICING->is_CORRECT_PROCESS(
    EXPORTING
      i_matnr = '19DGMB'
      i_sernr = '1PY5105MCPB000225'
    RECEIVING
      e_5m    = DATA(is_5m)
  ).

    IF is_5m EQ abap_true.

      cl_abap_unit_assert=>fail( 'is_CORRECT_PROCESS_true failed' ).

    ENDIF.

  ENDMETHOD.

  METHOD map_so_price_date_update.

    DATA: l_header_in TYPE bapisdh1,
          l_header_x  TYPE bapisdh1x.


    lo_ZUPD_SO_PRICING->map_so_price_date_update(
      EXPORTING
        i_header_in = l_header_in
        i_header_x  = l_header_x
      IMPORTING
        e_header_in = l_header_in
        e_header_x  = l_header_x
    ).



    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act       = l_header_in-price_date               " Data object with current value
        exp       = sy-datum                             " Data object with expected type
        msg       = 'Error caculating price date'        " Description
        level     = if_aunit_constants=>severity-medium  " Severity (TOLERABLE, CRITICAL, FATAL)
            RECEIVING
        assertion_failed = DATA(lv_assert)    " Condition was not met (and QUIT = NO)

    ).


  ENDMETHOD.


  METHOD map_new_zcmw_value_s.

    DATA: lt_cond  TYPE cmp_t_cond,
          lt_condx TYPE crmt_bapicondx_t.

    lo_ZUPD_SO_PRICING->map_new_zcmw_value(
      EXPORTING
        i_vbeln = '23009495'
      CHANGING
        t_cond  = lt_cond
        t_condx = lt_condx
    ).

    IF NOT line_exists( lt_cond[ cond_type = 'ZCMW' ] ).

      cl_abap_unit_assert=>fail( 'Error Mapping ZCMW' ).

    ENDIF.

  ENDMETHOD.

  METHOD map_new_zcmw_value_f.

    DATA: lt_cond  TYPE cmp_t_cond,
          lt_condx TYPE crmt_bapicondx_t.

    lo_ZUPD_SO_PRICING->map_new_zcmw_value(
      EXPORTING
        i_vbeln = '23999999'
      CHANGING
        t_cond  = lt_cond
        t_condx = lt_condx
    ).

    cl_abap_unit_assert=>assert_initial(
      EXPORTING
        act              = lt_cond                                  "Actual data object
        msg              = 'Error Mapping ZCMW - should be initial' "Description
        level            = if_aunit_constants=>severity-medium      " Severity (TOLERABLE, >CRITICAL<, FATAL)
      RECEIVING
        assertion_failed =  DATA(lv_assert)   " Condition was not met (and QUIT = NO)
    ).


  ENDMETHOD.

  METHOD is_special_customer_t.

    DATA(e_exp) = lo_ZUPD_SO_PRICING->is_special_customer( i_vbeln = '23009495' ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  =  e_exp   " Data object with current value
        exp                  =  abap_true   " Data object with expected type
        msg                  =  'Error getting AUART for ZFSC'   " Description
        level                = if_aunit_constants=>severity-high      " Severity (TOLERABLE, >CRITICAL<, FATAL)
    ).


  ENDMETHOD.

  METHOD is_special_customer_f.

    DATA(e_exp) = lo_ZUPD_SO_PRICING->is_special_customer( i_vbeln = '12345678' ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  =  e_exp   " Data object with current value
        exp                  =  abap_false   " Data object with expected type
        msg                  =  'Error getting AUART for ZFSC - False'   " Description
        level                = if_aunit_constants=>severity-high      " Severity (TOLERABLE, >CRITICAL<, FATAL)
    ).

  ENDMETHOD.

  METHOD is_special_customer_zimp.

    DATA(e_exp) = lo_ZUPD_SO_PRICING->is_special_customer( i_vbeln = '23009494' ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  =  e_exp   " Data object with current value
        exp                  =  abap_false   " Data object with expected type
        msg                  =  'Error getting AUART for ZFSC'   " Description
        level                = if_aunit_constants=>severity-high      " Severity (TOLERABLE, >CRITICAL<, FATAL)
    ).

  ENDMETHOD.



  METHOD map_new_zcmw_value_ov.

    DATA: lt_cond  TYPE cmp_t_cond,
          lt_condx TYPE crmt_bapicondx_t.

    lo_ZUPD_SO_PRICING->map_new_zcmw_value(
      EXPORTING
        i_vbeln = '23999988'
      CHANGING
        t_cond  = lt_cond
        t_condx = lt_condx
    ).

    IF NOT line_exists( lt_cond[ cond_type = 'ZCMW' ] ).

      cl_abap_unit_assert=>fail( 'Error Mapping ZCMW' ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
