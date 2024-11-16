class ZUPD_SO_PRICING_DAO definition
  public
  create public .

public section.

  interfaces ZUPD_IF_SO_PRICING.

  methods CONSTRUCTOR .
  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS: c_not_found TYPE sy-subrc  VALUE 4.
ENDCLASS.



CLASS ZUPD_SO_PRICING_DAO IMPLEMENTATION.


  METHOD CONSTRUCTOR.

  ENDMETHOD.


  METHOD ZUPD_IF_SO_PRICING~FETCH_AUART.

    CLEAR e_auart.

    SELECT SINGLE auart
        FROM vbak
        INTO e_auart
        WHERE vbeln EQ i_vbeln.

  ENDMETHOD.


  METHOD ZUPD_IF_SO_PRICING~SELECT_LABOR.

    SELECT SINGLE labor FROM mara INTO e_labor WHERE matnr EQ i_matnr.

    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE cx_bapi_ex
        EXPORTING
          sysubrc = c_not_found.
    ENDIF.

  ENDMETHOD.


  METHOD ZUPD_IF_SO_PRICING~SELECT_MBEW.

    SELECT SUM( m~stprs )
      INTO @DATA(lv_zcmw)
      FROM vbap AS p
      INNER JOIN mbew AS m
      ON p~matnr EQ m~matnr AND
         p~werks EQ m~bwkey
      WHERE p~vbeln EQ @i_vbeln.

    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE cx_bapi_ex
        EXPORTING
          sysubrc = c_not_found.

    ELSE.
      e_zcmw = lv_zcmw.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
