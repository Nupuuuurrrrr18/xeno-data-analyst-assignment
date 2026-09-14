# Reconciliation Bridge

**Scope:** Merchant 501, October 2026, `communication_type = '2'`.

| Step | Description | Result | Adjustment | Reason |
|---|---|---:|---:|---|
| 0 | Naive count of October 2026 campaign sends | 30 | — | Starting point |
| 1 | Exclude campaign 9004 | 26 | -4 | `approval_awaiting` campaign is not eligible for official reporting |
| 2 | Collapse retry family 9001 → 9002 → 9003 | 23 | -3 | 13 attempts represent 10 underlying customer communications |
| 3 | Collapse retry family 9201 → 9202 | 22 | -1 | 6 attempts represent 5 underlying customer communications |
| **Final** | **Reconciled `target_base`** | **22** | | **Matches Finance** |

## Important discovery

A simple `COUNT(DISTINCT customer_id)` is not sufficient. Campaign 9101 is standalone and contains two legitimate sends to customer C20 on different dates. Both events count, so this campaign contributes 7 events rather than 6 distinct customers.

This is why the final SQL treats retry families and standalone campaigns differently.
