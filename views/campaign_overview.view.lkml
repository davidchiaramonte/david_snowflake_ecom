view: campaign_overview {
  derived_table: {
    sql:
    select campaign_uid, impressions ...
    LIMIT {{ number_per_page._parameter_value }}
    OFFSET {{ number_per_page._parameter_value | times: page._parameter_value | minus: number_per_page._parameter_value }} ;;
  }

  parameter: page {
    type: number
  }

  parameter: number_per_page {
    type: number
  }

  dimension: campaign_uid {
    type: string
    primary_key: yes
  }

  dimension: impressions {
    type: number
  }
}
