-- Xeno Data Analyst Internship — Final Reconciliation
-- Returns Finance's target_base for merchant 501, October 2026.

WITH RECURSIVE campaign_roots AS (
    SELECT id AS campaign_id, id AS root_id
    FROM campaign
    WHERE parent_id IS NULL

    UNION ALL

    SELECT c.id AS campaign_id, cr.root_id
    FROM campaign c
    JOIN campaign_roots cr
      ON c.parent_id = cr.campaign_id
),
eligible_campaigns AS (
    SELECT id
    FROM campaign
    WHERE merchant_id = 501
      AND creation_status IN ('approved', 'aborted', 'resumed', 'stopped')
      AND processing_status = 'processed'
),
scoped_logs AS (
    SELECT
        l.id,
        l.customer_id,
        l.communication_id,
        cr.root_id
    FROM communication_log l
    JOIN eligible_campaigns ec
      ON l.communication_id = ec.id
    JOIN campaign_roots cr
      ON l.communication_id = cr.campaign_id
    WHERE l.merchant_id = 501
      AND l.communication_type = '2'
      AND l.sent_time >= '2026-10-01'
      AND l.sent_time < '2026-11-01'
),
root_types AS (
    SELECT
        roots.root_id,
        CASE
            WHEN EXISTS (
                SELECT 1
                FROM campaign child
                WHERE child.parent_id = roots.root_id
            )
            THEN 'retry_family'
            ELSE 'standalone'
        END AS root_type
    FROM (SELECT DISTINCT root_id FROM campaign_roots) roots
),
root_summary AS (
    SELECT
        sl.root_id,
        rt.root_type,
        COUNT(*) AS send_attempts,
        COUNT(DISTINCT sl.customer_id) AS distinct_customers
    FROM scoped_logs sl
    JOIN root_types rt
      ON sl.root_id = rt.root_id
    GROUP BY sl.root_id, rt.root_type
)
SELECT
    SUM(
        CASE
            WHEN root_type = 'retry_family' THEN distinct_customers
            ELSE send_attempts
        END
    ) AS target_base
FROM root_summary;
