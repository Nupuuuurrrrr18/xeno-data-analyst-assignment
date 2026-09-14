-- Xeno Data Analyst Internship — Investigation SQL
-- Scope: merchant 501, October 2026, campaign communications (type '2').

-- 1. Naive starting count
SELECT COUNT(*) AS naive_count
FROM communication_log
WHERE merchant_id = 501
  AND communication_type = '2'
  AND sent_time >= '2026-10-01'
  AND sent_time < '2026-11-01';

-- 2. Campaign-level counts in scope
SELECT
    communication_id,
    COUNT(*) AS send_attempts
FROM communication_log
WHERE merchant_id = 501
  AND communication_type = '2'
  AND sent_time >= '2026-10-01'
  AND sent_time < '2026-11-01'
GROUP BY communication_id
ORDER BY communication_id;

-- 3. Inspect campaign eligibility
SELECT
    id,
    parent_id,
    creation_status,
    processing_status
FROM campaign
WHERE merchant_id = 501
ORDER BY id;

-- 4. Inspect the pending campaign
SELECT *
FROM communication_log
WHERE communication_id = 9004
ORDER BY id;

-- 5. Inspect the first retry family
SELECT *
FROM communication_log
WHERE communication_id IN (9001, 9002, 9003)
ORDER BY communication_id, id;

-- 6. Inspect the second retry family
SELECT *
FROM communication_log
WHERE communication_id IN (9201, 9202)
ORDER BY communication_id, id;

-- 7. Inspect the standalone campaign where the same customer appears twice
SELECT *
FROM communication_log
WHERE communication_id = 9101
ORDER BY id;

-- 8. Map each campaign to its root campaign
WITH RECURSIVE campaign_roots AS (
    SELECT id AS campaign_id, id AS root_id
    FROM campaign
    WHERE parent_id IS NULL

    UNION ALL

    SELECT c.id AS campaign_id, cr.root_id
    FROM campaign c
    JOIN campaign_roots cr
      ON c.parent_id = cr.campaign_id
)
SELECT campaign_id, root_id
FROM campaign_roots
ORDER BY campaign_id;
