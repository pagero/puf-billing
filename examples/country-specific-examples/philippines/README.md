# Philippines PUF Examples

Synthetic PUF Billing examples for invoices issued from a Computerized Accounting
System (CAS) to the BIR Electronic Invoicing System (EIS), based on the BIR EIS e-invoice
JSON File Format v2.1 (2026-07-30, CAS sheet revised 2026-09-26). Reviewed 2026-10-16.
All parties, numbers and amounts are illustrative, not live taxpayer registrations or
bank details.

## Examples

| File | Scenario | Document type (@name) | Net / VAT / Payable (PHP) |
|---|---|---|---|
| [PUF_Philippines_Invoice.xml](PUF_Philippines_Invoice.xml) | VATable sale of goods with a line discount and a document-level regular discount | 380 (01) | 4200.00 / 504.00 / 4704.00 |
| [PUF_Philippines_Invoice_Withholding.xml](PUF_Philippines_Invoice_Withholding.xml) | VATable services; the buyer withholds creditable income tax (`INC`) | 380 (01) | 50000.00 / 6000.00 / 55000.00 |
| [PUF_Philippines_Invoice_Exempt.xml](PUF_Philippines_Invoice_Exempt.xml) | VAT-exempt sale of agricultural food products in their original state | 380 (01) | 24000.00 / 0.00 / 24000.00 |
| [PUF_Philippines_Invoice_Export.xml](PUF_Philippines_Invoice_Export.xml) | Zero-rated export to a buyer not registered with the BIR, with airway bill, bill of lading and delivery address | 380 (01) | 500000.00 / 0.00 / 500000.00 |
| [PUF_Philippines_CreditNote.xml](PUF_Philippines_CreditNote.xml) | Credit note for goods returned from PH-2026-000101, reason `05` (Return) | 381 (03) | 480.00 / 57.60 / 537.60 |
| [PUF_Philippines_Corrective_Invoice.xml](PUF_Philippines_Corrective_Invoice.xml) | Corrective invoice for one filing cabinet delivered in addition to PH-2026-000101, reason `03` (Addition/reduction) | 384 (01) | 500.00 / 60.00 / 560.00 |

## Input Conventions

- The `name` attribute of the type code carries the BIR document type: `01` Invoice,
  `03` Credit Note. A corrective invoice (384) is an invoice and carries `01`.
- There is no debit note example. The BIR no longer lists the debit note as a document
  type. An increase to an issued invoice is a new invoice that refers to it, sent as a
  corrective invoice; a decrease is a credit note.
- Each example carries one VAT category. Split a source document with VATable,
  zero-rated and exempt sales into separate invoices with their own numbers.
- The line sales amount before discounts (quantity x unit price) is in the
  `LineExtension` extension; `cbc:LineExtensionAmount` is the amount after line discounts.
- Seller and buyer TINs are 9 digits without the branch code, which goes in the branch
  code (`GEN:UnitCode`, 5 digits, `00000` for the head office). A buyer not registered
  with the BIR uses TIN `000000000`.
- `cbc:PayableAmount` is the amount the buyer pays after withholding.
- The credit note and the corrective invoice are corrections. Both refer to the original
  by invoice number, issue date, reason code and the 24-character BIR e-invoice unique ID
  returned in the PUF Clearance Notification.
- Not covered: local sales of Registered Business Enterprises, foreign-currency
  invoices and CRM/POS documents.

## Source Basis

| Claim | Value in the examples | Authority | Locator |
|---|---|---|---|
| Document types | 01 Invoice and 03 Credit Memo / Credit Note; Debit Memo / Debit Note removed | BIR EIS e-invoice JSON File Format v2.1 (CAS sheet revised 2026-09-26) | CAS sheet, No. 4 Document Type; Revision History, version 2.1 ("Removed DM/DN") |
| Increase to an issued invoice | A new invoice that refers to the original (the corrective invoice), so no debit note example | RMC No. 098-2026 | Section IV.8 |
| Invoice for added sales | Flagged as a correction with reason 03 and the unique ID of the original | BIR EIS e-invoice JSON File Format v2.1 | Correction annex, hidden in v2.1, code 03 procedure (A) |
| Credit note is a correction | The credit note refers to the invoice it reduces | RMC No. 098-2026 | Sections II.2 and IV.8 |
| Correction reason and reference | Codes 03 (Addition/reduction) and 05 (Return), 24-character unique ID of the corrected invoice | BIR EIS e-invoice JSON File Format v2.1 | CAS sheet, No. 3, 6, 7 and 8; Correction Scenarios sheet, hidden in v2.1 (every credit memo is sent as a correction) |
| Seller type | 0 VAT registered (1 Non-VAT registered and 2 Registered Business Enterprise also allowed) | Same | CAS sheet, No. 12 |
| Branch code and TIN | 5-digit branch code, 9-digit TIN, `000000000` for an unregistered buyer | Same | CAS sheet, No. 10, 11 and 17 |
| Item description | Provided on every line | Same | CAS sheet, No. 29 |
| Transport documents | Airway bill and bill of lading number and date, for exporters | Same | CAS sheet, No. 24 to 27 |
| PTU number | Seller's Permit To Use number | Same | CAS sheet, No. 54 |
| VAT rate | 12% | National Internal Revenue Code, as amended | Sections 106(A) and 108(A) |
| Zero-rated export | 0% on the sale and shipment of goods abroad | Same | Section 106(A)(2)(a) |
| VAT exemption | Agricultural food products in their original state | Same | Section 109(A) |
| Creditable withholding tax | Shown as a separate item on the invoice; the 2% rate is illustrative | RR No. 6-2026 | Section 2, item 22 of RR No. 7-2024 Section 6(B) |

Sources:

- [BIR EIS Certification Portal, Downloads](https://eis-cert.bir.gov.ph/#/downloads):
  EIS e-invoice JSON File Format v2.1 and API Development Guide v2.3, first published
  2026-10-13 (post 1330) and re-published 2026-10-15 with the revised CAS sheet (post 1331).
- [Revenue Memorandum Circular No. 098-2026](https://bir-cdn.bir.gov.ph/BIR/pdf/RMC%20No.%2098-2026%20redacted.pdf),
  issued 2026-09-22.
- [National Internal Revenue Code](https://www.bir.gov.ph/tax-code), BIR consolidated text.
- [Revenue Regulations No. 6-2026](https://bir-cdn.bir.gov.ph/BIR/pdf/RR%20No.%206-2026.pdf).

## Validation

Checked 2026-10-16: every file passes the PUF XSD and the PUF Schematron. The BIR
document type, transaction classification, withholding and totals derived from each
example match the scenario above, and the amounts reconcile under the field definitions
in the JSON File Format v2.1.
