class ZUPD_SO_PRICING definition
  public
  final
  create public .

public section.

  data LO_DATA_ACCESSOR type ref to ZUPD_IF_SO_PRICING .

  methods CONSTRUCTOR
    importing
      !IF_DATA_ACCESSOR type ref to ZUPD_IF_SO_PRICING optional .
  methods is_CORRECT_PROCESS
    importing
      !I_MATNR type ZORDERS-ORDERING_CODE
      !I_SERNR type ZORDERS-PROD_SERIAL_NUM
    returning
      value(E_cp) type SYST-FTYPE .
  methods MAP_SO_PRICE_DATE_UPDATE
    importing
      !I_HEADER_IN type BAPISDH1
      !I_HEADER_X type BAPISDH1X
    exporting
      !E_HEADER_IN type BAPISDH1
      !E_HEADER_X type BAPISDH1X .
  methods MAP_NEW_ZCMW_VALUE
    importing
      !I_VBELN type VBAK-VBELN
    changing
      !T_COND type CMP_T_COND
      !T_CONDX type CRMT_BAPICONDX_T .
  methods IS_SPECIAL_CUSTOMER
    importing
      !I_VBELN type VBAK-VBELN
    returning
      value(E_ZFSC) type SYST-FTYPE .
  PROTECTED SECTION.



  PRIVATE SECTION.
    DATA: gv_matnr TYPE zorders-ordering_code,
          gv_sernr TYPE zorders-prod_serial_num,
          gv_is_CORRECT_PROCESS TYPE c.


    CONSTANTS: c_py   TYPE mara-labor           VALUE 'PY',
               c_zcmw TYPE bapicond-cond_type   VALUE 'ZCMW',
               c_usd  TYPE bapicond-currency    VALUE 'USD',
               c_upd  TYPE bapicondx-updateflag VALUE 'U',
               c_item TYPE bapicond-itm_number  VALUE '10',
               c_zsfc TYPE auart                VALUE 'ZFSC'.

ENDCLASS.



CLASS ZUPD_SO_PRICING IMPLEMENTATION.


  METHOD constructor.

    IF if_data_accessor IS INITIAL.
      lo_data_accessor = NEW ZUPD_SO_PRICING_DAO( ).
    ELSE.
      lo_data_accessor = if_data_accessor.
    ENDIF.

    CLEAR: gv_matnr, gv_sernr, gv_is_CORRECT_PROCESS.

  ENDMETHOD.


  METHOD is_CORRECT_PROCESS.

    IF gv_matnr EQ i_matnr AND gv_sernr EQ i_sernr.

      e_cp = gv_is_CORRECT_PROCESS.
      EXIT.

    ENDIF.

    CLEAR e_cp.
    IF  i_sernr CS c_py AND i_matnr CS c_py.
      TRY.
          DATA(e_labor) = lo_data_accessor->select_labor( i_matnr = CONV #( i_matnr ) ).
        CATCH cx_bapi_ex.
      ENDTRY.

      IF e_labor EQ c_py.
        e_cp = abap_true.
      ENDIF.

      gv_matnr = i_matnr.
      gv_sernr = i_sernr.
      gv_is_CORRECT_PROCESS = c_cp.

    ENDIF.

  ENDMETHOD.


  METHOD is_special_customer.

    CLEAR e_zfsc.
    DATA(l_auart) = lo_data_accessor->fetch_auart( i_vbeln = i_vbeln ).

    IF l_auart EQ c_zsfc.
      e_zfsc = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD map_new_zcmw_value.

    TRY.
        DATA(l_zcmw) = lo_data_accessor->select_mbew( i_vbeln = i_vbeln ).
      CATCH cx_bapi_ex.    "
        EXIT.
    ENDTRY.

    APPEND VALUE #( itm_number = c_item
                    cond_type  = c_zcmw
                    cond_value = l_zcmw
                    currency   = c_usd
                    ) TO t_cond.

    APPEND VALUE #( itm_number = c_item 
                    cond_type  = abap_true
                    updateflag = abap_true
                    cond_value = abap_true
                    currency   = abap_true
                    ) TO t_condx.


  ENDMETHOD.


  METHOD map_so_price_date_update.

    e_header_in = i_header_in.
    e_header_in-price_date = sy-datum.

    e_header_x = i_header_x.

    e_header_x-updateflag = c_upd. "UPDATE
    e_header_x-price_date = abap_true.

  ENDMETHOD.
ENDCLASS.



