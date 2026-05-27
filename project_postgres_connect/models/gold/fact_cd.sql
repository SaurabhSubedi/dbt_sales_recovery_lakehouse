with visits as (
select * 
from 
(
select *,
row_number() over(partition by party_details order by date desc ) as rank
from {{ ref('silver_cd') }}
)aab
where rank = 1
)
, 

pcp_ac as (
    select * 
    from {{ ref('silver_mac_pcp') }}
)
,
obt  as (
select pcp_ac.*,visits.date as last_visit_date,visits.agent_name as last_visited_agent_email,
  visits.stock_sb_750,
  visits.stock_sb_375,
  visits.stock_sb_180,
  visits.stock_sr_750,
  visits.stock_sr_375,
  visits.stock_sr_180,
  visits.stock_rara_750,
  visits.stock_rara_375,
  visits.stock_rara_180
from pcp_ac 
left join visits on pcp_ac.party_details = visits.party_details
)

{% set 
  obt_cols = 
    [
    "obt.collected_date",
    "obt.collected_amount",
    "obt.last_known_closing_amt",
    "obt.last_visit_date",
    "obt.stock_sb_750",
    "obt.stock_sb_375",
    "obt.stock_sb_180",
    "obt.stock_sr_750",
    "obt.stock_sr_375",
    "obt.stock_sr_180",
    "obt.stock_rara_750",
    "obt.stock_rara_375",
    "obt.stock_rara_180"
]
%}

select 
p.party_id,
a.area_id,
sa.sales_agent_id,
ca.col_agent_id,
{% for item in obt_cols %}
{{item}}
{% if not loop.last %}
,
{% endif %}
{% endfor %}
from obt
left join {{ ref('dim_areas') }} a  on a.area = obt.area
left join {{ ref('dim_collection_agents') }} ca on ca.email = obt.last_visited_agent_email
left join {{ ref('dim_parties') }} p on p.party_name = obt.party_details
left join {{ ref('dim_sales_agents') }} sa on sa.sales_agent_name = obt.sales_agent