# Xeno Data Analyst Internship — Take-Home Assignment

## Objective
Reconcile Finance's `target_base = 22` for merchant 501 for all Diwali campaigns in October 2026.

## Approach
The analysis starts from the 30 October 2026 campaign send attempts and applies the reporting rules from the supplied data dictionary:

1. Exclude campaigns whose creation workflow has not cleared.
2. Collapse retry chains into one underlying communication per distinct customer.
3. Treat standalone campaigns as individual send events, even when the same customer appears more than once.

## Result
The reconciled `target_base` is **22**, matching Finance.

See `reconciliation_bridge.md` for the step-by-step bridge and `sql/final_reconciliation.sql` for the final query.
