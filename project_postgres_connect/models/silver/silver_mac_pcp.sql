{{
  config(
    materialized = 'table',
    )
}}
select mac.date as collected_date,mac.amount as collected_amount,coalesce(mac.party_details,pcp.party_details) as party_details,pcp.area,pcp.sales_agent,pcp.closing_amt as last_known_closing_amt
from  {{ref('pcp')}} pcp
left join {{ref('mac')}} mac 
on mac.party_details = pcp.party_details