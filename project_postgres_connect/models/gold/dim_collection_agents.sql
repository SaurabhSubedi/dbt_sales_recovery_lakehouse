with col_agents as (
    select distinct agent_name 
    from {{ ref('silver_cd') }}
)

select 
case agent_name 
 WHEN 'madhucaa.meo@gmail.com'      THEN 'Madhu'
    WHEN 'panday.achyut@gmail.com'     THEN 'Achyut'
    WHEN 'baralsuraj707@gmail.com'     THEN 'Suraj'
    WHEN 'yubrajsitaula4@gmail.com'    THEN 'Yubraj'
    WHEN 'anishkhadka046@gmail.com'    THEN 'Anish'
    ELSE 'Unknown'
END AS agent_name,
agent_name as email,
    current_timestamp as created_at,
{{ dbt_utils.generate_surrogate_key(['agent_name']) }} as col_agent_id 
from col_agents