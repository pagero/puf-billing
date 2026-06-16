# Slovakia E-Invoicing Examples

This directory contains example PUF (Pagero Universal Format) files for Slovak domestic
B2B billing documents, grounded in the Slovak VAT Act and EN 16931.

> All party names, identifiers, IBANs and amounts are example/anonymised data.

## Example Files

| File | Document | Type code | Demonstrates |
|------|----------|-----------|--------------|
| `PUF_Slovakia_Invoice.xml` | Invoice | 380 | Full B2B invoice: standard (23%) + reduced (5%) VAT, document- and line-level allowance, payment details |
| `PUF_Slovakia_CreditNote.xml` | Credit note | 381 | Partial return referencing the original invoice (BG-3), due date in `cac:PaymentMeans` |
| `PUF_Slovakia_Invoice_VAT_Reconciliation.xml` | Invoice | 380 | EN↔SK reverse-VAT reconciliation via a BT-99 document charge (reason "Mutually defined" / code `ZZZ`) |

### PUF_Slovakia_Invoice.xml

A domestic B2B invoice from a Bratislava seller to a Košice buyer with three lines:

- Line 1 — office chairs at the **23% standard rate** with a line-level volume discount (BG-27)
- Line 2 — oak desks at the **23% standard rate**
- Line 3 — a book at the **5% reduced rate**

It also carries a document-level loyalty discount (BG-20) against the standard-rated goods.

### PUF_Slovakia_CreditNote.xml

A credit note for a partial return against `SK-2026-00042`:

- Two credited lines (chairs at 23%, books at 5%)
- `cac:BillingReference` to the preceding invoice (BT-25 / BT-26)
- `cbc:CreditNoteTypeCode` 381 and `cac:PaymentMeans/cbc:PaymentDueDate` (credit notes do **not** carry a document-level `cbc:DueDate`)

## EN vs SK VAT calculation (reconciliation)

Slovak law calculates VAT **backwards** from the VAT-inclusive total, while EN 16931
calculates **forwards** from the tax base. The two can differ by rounding, which breaks the
Peppol check that the invoice-level taxable base equals the sum of line net amounts. When that
happens, a document-level charge (BT-99) with reason "Mutually defined" / reason code `ZZZ`
bridges the difference.

`PUF_Slovakia_Invoice.xml` and `PUF_Slovakia_CreditNote.xml` are constructed so the forward and
reverse calculations agree exactly, so no reconciliation entry is required.

`PUF_Slovakia_Invoice_VAT_Reconciliation.xml` deliberately demonstrates the divergent case: the
seller's source prices are round VAT-inclusive (gross) amounts, so net = gross/1.23 rounded per
unit. Across the quantities, the line-net sum (BT-106 = 141.30) falls €0.16 short of the Slovak
gross-derived base (BT-116 = 141.46). A BT-99 document-level charge of 0.16 (BT-104 "Mutually
defined", BT-105 `ZZZ`) restores `BT-116 = SUM(BT-131) + BT-99 − BT-92`, and the reported VAT
(BT-117 = 32.54) is the Slovak reverse figure `174.00 × 23/123`.
