select
    interaction_id,
    member_id,
    interaction_type,
    interaction_status,
    cast(interaction_date as date) as interaction_date

from {{ source('raw', 'interactions') }}