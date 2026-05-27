with areas as (
    select distinct area
    from {{ ref('silver_mac_pcp') }}
)

select area,{{ dbt_utils.generate_surrogate_key(['area']) }} as area_id,
    current_timestamp as created_at
from areas