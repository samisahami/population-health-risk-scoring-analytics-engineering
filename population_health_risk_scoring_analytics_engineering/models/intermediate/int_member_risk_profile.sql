with member_claims as (

    select
        member_id,
        count(claim_id) as total_claims,
        sum(paid_amount) as total_paid_amount,
        sum(case when admit_flag = 1 then 1 else 0 end) as inpatient_admits

    from {{ ref('stg_claims') }}

    group by member_id

),

member_conditions as (

    select
        member_id,
        count(condition_name) as chronic_condition_count,

        sum(
            case
                when risk_level = 'High' then 3
                when risk_level = 'Medium' then 2
                else 1
            end
        ) as condition_risk_score

    from {{ ref('stg_conditions') }}

    group by member_id

),

member_interactions as (

    select
        member_id,

        count(interaction_id) as outreach_attempts,

        sum(
            case
                when interaction_status = 'Successful'
                then 1
                else 0
            end
        ) as successful_outreach

    from {{ ref('stg_interactions') }}

    group by member_id

)

select

    m.member_id,
    m.first_name,
    m.last_name,
    m.state,
    m.plan_type,

    coalesce(c.total_claims, 0) as total_claims,
    coalesce(c.total_paid_amount, 0) as total_paid_amount,
    coalesce(c.inpatient_admits, 0) as inpatient_admits,

    coalesce(cond.chronic_condition_count, 0) as chronic_condition_count,
    coalesce(cond.condition_risk_score, 0) as condition_risk_score,

    coalesce(i.outreach_attempts, 0) as outreach_attempts,
    coalesce(i.successful_outreach, 0) as successful_outreach

from {{ ref('stg_members') }} m

left join member_claims c
    on m.member_id = c.member_id

left join member_conditions cond
    on m.member_id = cond.member_id

left join member_interactions i
    on m.member_id = i.member_id