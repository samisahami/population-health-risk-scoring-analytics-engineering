select
    member_id,
    condition_name,
    risk_level,
    cast(diagnosis_date as date) as diagnosis_date

from {{ source('raw', 'conditions') }}