select * 
from {{ source('source_tbl', 'actual_collection') }}
limit 5