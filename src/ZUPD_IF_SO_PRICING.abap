INTERFACE zsdbr_if_btp_5m_pune
  PUBLIC .
  METHODS select_labor
    IMPORTING i_matnr        TYPE mara-matnr
    RETURNING VALUE(e_labor) TYPE mara-labor
    RAISING   cx_bapi_ex.

  METHODS select_mbew
    IMPORTING i_vbeln       TYPE vbak-vbeln
    RETURNING VALUE(e_zcmw) TYPE stprs
    RAISING   cx_bapi_ex.

  METHODS fetch_auart
    IMPORTING i_vbeln        TYPE vbak-vbeln
    RETURNING VALUE(e_auart) TYPE vbak-auart.

ENDINTERFACE.
