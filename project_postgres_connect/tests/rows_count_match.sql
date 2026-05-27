with silver_parties as (
    select count(distinct(party_details)) as silver_party_count
    from {{ ref('silver_mac_pcp') }}
),

gold_parties as (
    select count(distinct(party_id)) as gold_party_count
    from {{ ref('fact_cd') }}
)


select *
from silver_parties s
cross join gold_parties g
where s.silver_party_count != g.gold_party_count