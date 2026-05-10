SELECT
    member_id,
    first_name,
    last_name,
    state,
    plan_type,

    total_claims,
    total_paid_amount,
    inpatient_admits,
    chronic_condition_count,
    condition_risk_score,
    outreach_attempts,
    successful_outreach,

    case 
        when successful_outreach > 0 then 'Engaged'
        else 'Not Engaged'
    end as engagement_status,

    case 
        when condition_risk_score >= 6
        or inpatient_admits >= 2
        or total_paid_amount >= 10000
            then 'High'
        when condition_risk_score between 3 and 5
        or inpatient_admits = 1
        or total_paid_amount between 5000 and 9999
            then 'Medium'
        else 'Low'
        end as population_risk_tier

from {{ ref('int_member_risk_profile') }}
