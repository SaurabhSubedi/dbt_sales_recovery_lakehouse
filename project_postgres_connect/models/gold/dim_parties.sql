with parties as (
    select distinct(party_details) as party_name
    from {{ ref('silver_mac_pcp') }}

)

select party_name,{{ dbt_utils.generate_surrogate_key(['party_name']) }} as party_id ,
    current_timestamp as created_at
from parties