view: users_dt2 {
  # Or, you could make this view a derived table, like this:
  derived_table: {
    sql: SELECT * FROM ${users_dt.SQL_TABLE_NAME} ;;
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }
}
