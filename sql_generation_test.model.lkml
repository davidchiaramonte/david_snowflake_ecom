connection: "thelook_snowflake"

# include all the views
include: "/views/*.view"

datagroup: druid_test_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: druid_test_default_datagroup

explore: order_items {}

explore: users {}

explore: campaign_overview {
  cancel_grouping_fields: [campaign_overview.campaign_uid, campaign_overview.impressions]
}
