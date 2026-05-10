select
    member_id,
    first_name,
    last_name,
    gender,
    cast(date_of_birth as date) as date_of_birth,
    state,
    plan_type,
    cast(enrollment_date as date) as enrollment_date

from {{ source('raw', 'members') }}