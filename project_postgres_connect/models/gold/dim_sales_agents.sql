with sales_agent as (
    select distinct sales_agent  as sales_agent_name
    from {{ ref('silver_mac_pcp') }}
)

select sales_agent_name,{{ dbt_utils.generate_surrogate_key(['sales_agent_name']) }}  as sales_agent_id,
    current_timestamp as created_at
from sales_agent 

