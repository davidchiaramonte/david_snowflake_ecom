view: users_dt {
  # Or, you could make this view a derived table, like this:
  derived_table: {
    sql: SELECT * FROM users ;;
   }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  }
