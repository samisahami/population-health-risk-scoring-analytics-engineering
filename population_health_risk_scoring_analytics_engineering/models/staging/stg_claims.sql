select
    claim_id,
    member_id,
    claim_type,
    cast(service_date as date) as service_date,
    allowed_amount,
    paid_amount,
    admit_flag

from {{ source('raw', 'claims') }}