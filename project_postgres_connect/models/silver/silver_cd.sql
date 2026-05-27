{{
      config(
        materialized = 'incremental',
        unique_key = 'id'
        )
}}

SELECT
    date,
    agent_name,
    party_details,
    non_ageing_outlet,
    id,
    address,
    collection,
    collection_type,
    closing_balance,
    remarks,

    {% set stock_types = ['sb', 'sr', 'rara'] %}
    {% set sizes = ['750', '375', '180'] %}

    {% for stock in stock_types %}
        {% for i in [1, 2, 3] %}
            {% set size = sizes[i - 1] %}
            CASE 
                WHEN array_length(stock_{{ stock }}_arr, 1) = 3 THEN stock_{{ stock }}_arr[{{ i }}]
                ELSE '9999'
            END AS stock_{{ stock }}_{{ size }}
            {% if not (loop.last and stock == stock_types[-1]) %},{% endif %}
        {% endfor %}
    {% endfor %}

FROM (
    SELECT
        date,
        agent_name,
        party_details,
        non_ageing_outlet,
        id,
        address,
        collection,
        collection_type,
        closing_balance,
        remarks,

        {% for stock in stock_types %}
            string_to_array(stock_{{ stock }}, '-') AS stock_{{ stock }}_arr
            {% if not loop.last %},{% endif %}
        {% endfor %}

    FROM {{ ref('cd') }}
    {% if is_incremental() %}
      WHERE date > (SELECT MAX(date) FROM {{ this }})
    {% endif %}
) t