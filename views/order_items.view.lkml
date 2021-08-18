view: order_items {
  sql_table_name: "PUBLIC"."ORDER_ITEMS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."DELIVERED_AT" ;;
  }

  parameter: aggregation {
    view_label: "Date Aggregation Filter"
    label: "Date Granularity"
    description: "Use as a filter to adjust the granularity of the 'dynamic' date fields."
    type: string
    allowed_value: { value: "Date" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    allowed_value: { value: "Year" }
    default_value: "Date"
  }

  dimension_group: actual_arrival_port_departed_on_utc {
    # PRESENTATION
    view_label: "Shipment Timeline UTC Actual"
    label: "Arrival Port Departed On"
    description: "From Final Wet Port (chronologically last ocean port), if none, Customs Unloading (node tag)"

    # DEFINITION
    type: time
    timeframes: [
      day_of_week,
      day_of_month,
      month_name,
      time,
      date,
      week,
      month,
      quarter,
      year,
      week_of_year
    ]
    sql: ${TABLE}."DELIVERED_AT" ;;
    convert_tz: no
  }

  dimension: dynamic_actual_arrival_port_departed_on_utc {
    type: date
     view_label: "Shipment Timeline UTC Actual"
    label: "Dynamic Arrival Port Departed On"
    description: "To be used in conjunction with 'Date Granularity' filter. From Final Wet Port (chronologically last ocean port), if none, Customs Unloading (node tag)"
    sql:
      CASE
        WHEN {% parameter aggregation %} = 'Date' THEN ${actual_arrival_port_departed_on_utc_date}
        WHEN {% parameter aggregation %} = 'Week' THEN ${actual_arrival_port_departed_on_utc_week}
        WHEN {% parameter aggregation %} = 'Month' THEN ${actual_arrival_port_departed_on_utc_month}
        WHEN {% parameter aggregation %} = 'Year' THEN to_char(${actual_arrival_port_departed_on_utc_year})
      END ;;
      convert_tz: no
  }

  dimension: dynamic_actual_with_month {
    type: date
    view_label: "Shipment Timeline UTC Actual"
    label: "Dynamic Arrival Port Departed On"
    description: "To be used in conjunction with 'Date Granularity' filter. From Final Wet Port (chronologically last ocean port), if none, Customs Unloading (node tag)"
    sql:
      CASE
        WHEN {% parameter aggregation %} = 'Date' THEN ${actual_arrival_port_departed_on_utc_date}
        WHEN {% parameter aggregation %} = 'Week' THEN ${actual_arrival_port_departed_on_utc_week}
        WHEN {% parameter aggregation %} = 'Month' THEN (TO_CHAR(DATE_TRUNC('month', order_items."DELIVERED_AT" ), 'YYYY-MM-DD'))
        WHEN {% parameter aggregation %} = 'Year' THEN to_char(${actual_arrival_port_departed_on_utc_year})
      END ;;
    convert_tz: no
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."INVENTORY_ITEM_ID" ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."RETURNED_AT" ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}."SALE_PRICE" ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      second,
      year
    ]
    sql: cast(${TABLE}."SHIPPED_AT" as TIMESTAMP_NTZ(9)) ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."USER_ID" ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.first_name,
      users.last_name,
      users.id,
      inventory_items.id,
      inventory_items.product_name
    ]
  }
}
