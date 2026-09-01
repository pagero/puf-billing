# PUF Tax Data Report — France Invoice Reporting Examples (Flux 10.1)

Example files for French invoice e-reporting (Flux 10.1). These use the standard PUF Invoice format with reporting-specific extensions in `ext:UBLExtensions` for metadata like entry type, transaction type, and report period.

> **Note**: For payment reporting (Flux 10.2 / 10.4), see [puf-tax-report/examples/country-specific-examples/france/](https://github.com/pagero/puf-tax-report/tree/master/examples/country-specific-examples/france).

## Example Files

| File | Direction | Entry Type | Description |
|------|-----------|------------|-------------|
| `PUF_FR_SALES_INVOICE_TDR_CROSSBORDER_B2Bi_DRAFT.xml` | Sales (B2Bi) | INVOICE | Draft — Cross-border B2B sales invoice reporting. French seller, Italian buyer. Services invoice (S1). |
| `PUF_FR_SALES_INVOICE_TDR_POS_TRANSACTIONS_DRAFT.xml` | Sales (B2C) | RECEIPTTRANSACTION | Draft — B2C POS receipt transaction reporting. Aggregated daily transactions with TLB1 (goods) and TPS1 (services) category codes. |
| `PUF_FR_PURCHASE_INVOICE_TDR_CROSSBORDER_Bi2B_DRAFT.xml` | Purchase (Bi2B) | INVOICE | Draft — Cross-border B2B purchase invoice reporting. French buyer, German (EU) seller. ProfileID = `urn:pagero.com:puf:purchase:1.0`. Seller identified with EU VAT (schemeID `0223`). |
| `PUF_FR_PURCHASE_INVOICE_TDR_CROSSBORDER_NonEU_Seller_DualCurrency_DRAFT.xml` | Purchase (Bi2B) | INVOICE | Draft — Cross-border B2B purchase invoice reporting with a **non-EU seller** (Mexico), invoicing in its own currency. Demonstrates BR-FR-MAP-16 party identification for a non-EU party (schemeID `0227`, value passed through as-is) together with dual currency: BT-5 `DocumentCurrencyCode` = MXN, BT-6 `TaxCurrencyCode` = EUR (mandatory since BT-5 isn't EUR). VAT/monetary amounts reported in both MXN (document currency) and EUR (tax currency) via `TaxSubtotalExtension`/`LegalMonetaryTotalExtension`. Validated end-to-end through `PUF_as_TDR_Ext_to_Int.xslt` → `FE_e-reporting_France_Int_to_Ext.xsl` → `ereporting.xsd` + the AIFE-PPF Flux10 Schematron. |
| `PUF_FR_PURCHASE_INVOICE_TDR_CROSSBORDER_Bi2B_DRAFT - REPLACE_PERIOD.xml` | Purchase (Bi2B) | INVOICE | Draft — REPLACE_PERIOD (Rectification/RE) scenario for the cross-border B2B purchase report. `transmissionType = REPLACE_PERIOD` with `taxReportId` (id of the replacing report) and `referencedReportId` (id of the aggregated report being replaced). Report period (`reportPeriodStart`/`reportPeriodEnd`) MUST match the report being replaced, and all documents belonging to that period must be resent. |
| `PUF_FR_PURCHASE_INVOICE_TDR_CROSSBORDER_Bi2B_DRAFT - ADD.xml` | Purchase (Bi2B) | INVOICE | Draft — ADD (Complémentaire/CO) scenario: adds a new document to a period whose aggregated report is already Approved. `transmissionType = ADD` with `referencedReportId` set to the **aggregatedId** of the Approved report (same reference style as REPLACE_PERIOD). Everything already reported for the period carries over automatically — only the new document is sent. |
| `PUF_FR_PURCHASE_INVOICE_TDR_CROSSBORDER_Bi2B_DRAFT - EDIT.xml` | Purchase (Bi2B) | INVOICE | Draft — EDIT (Modification/MO) scenario: corrects one specific document already reported and Approved for the period. `transmissionType = EDIT` with `referencedReportId` set to the **exact `taxReportId`** of the specific previously sent document being corrected (NOT an aggregatedId — see ADD/REPLACE_PERIOD). Corrects the base `PUF_FR_PURCHASE_INVOICE_TDR_CROSSBORDER_Bi2B_DRAFT.xml` (taxReportId `The id for the report`): only the corrected document is sent, every other already-reported document is unaffected. |
| `PUF_France_UC43_IntraCommunitySupply_InvoiceReport.xml` | Sales (B2Bi) | INVOICE | UC43 — Intra-community goods supply from France to Germany. VAT category K with `VATEX-EU-IC`. `#BAR#B2BINT` treatment type. Buyer identified with EU VAT number (schemeID `0223`). |
| `PUF_France_UC44_DROM_GuadeloupeToGuyane_InvoiceReport.xml` | Sales (B2Bi) | INVOICE | UC44 — DROM transaction from Guadeloupe (Group 1) to French Guiana (Group 2). Demonstrates BR-FR-MAP-14 country code mapping (GP → FR, GF stays GF). VAT category G with `VATEX-EU-G`. |
| `PUF_France_UC42_TaxFree_Scenario1_TransactionReport.xml` | Sales (B2C) | RECEIPTTRANSACTION | UC42 scenario 1 — tax-free (détaxe) sale corrected after BVE customs validation (XP Z12-014 §3.2.41.1). Two counter-entries: TLB1 reversal (negative net and VAT) and TNT1 re-entry (positive net, VAT 0), aggregated over 50 refunds. Reported in the period the refund occurs as a forward correction (`transmissionType = IN`), not a rectification. |

## Reporting Extensions (UBLExtensions)

Invoice e-reporting uses the standard PUF Invoice format with additional metadata in `ext:UBLExtensions/ext:UBLExtension`:

| Key | Description | Values |
|-----|-------------|--------|
| `entryType` | Type of reporting entry | `INVOICE` (individual invoice), `RECEIPTTRANSACTION` (aggregated POS) |
| `transactionType` | B2B or B2C classification | `B2B`, `B2C` |
| `issuerAssignedReportId` | Issuer-assigned report identifier | Free text |
| `reportPeriodStart` | Start of reporting period | YYYY-MM-DD |
| `reportPeriodEnd` | End of reporting period | YYYY-MM-DD |
| `transmissionType` | Report transmission type | `ADD`, `EDIT`, `REPLACE_PERIOD` (only if not a plain initial submission; `RECTIFICATION` is a legacy alias still accepted for `REPLACE_PERIOD`) |
| `taxReportId` | Identifier of the (re-)report — maps to `taxReport/taxReportId` | Free text (set on ADD/EDIT/REPLACE_PERIOD) |
| `referencedReportId` | Reference to the report/document being corrected. For `ADD`/`REPLACE_PERIOD`, the aggregatedId of the Approved aggregated report. For `EDIT`, the exact `taxReportId` of the specific previously sent document being corrected | Free text (set on ADD/EDIT/REPLACE_PERIOD) |

## Classification via ProfileID

| ProfileID | Classification |
|-----------|---------------|
| `urn:pagero.com:puf:billing:1.0` | Sales invoice reporting (INCOME) |
| `urn:pagero.com:puf:purchase:1.0` | Purchase invoice reporting (EXPENSE) |

## Line-Level Category Codes (TT-81)

For B2C and transaction reporting, each invoice line may include a category code via `RestrictedInformation`:

| Code | Description |
|------|-------------|
| `TLB1` | Supplies of goods subject to VAT |
| `TPS1` | Supplies of services subject to VAT |
| `TNT1` | Supplies of goods and services not subject to VAT in France |
| `TMA1` | Transactions giving rise to application of the VAT margin scheme |

## Key Concepts

- **Flux 10.1**: Invoice-level e-reporting for international B2B sales, international B2B acquisitions (excl. goods imports), and B2C transactions.
- **BAR treatment type**: `#BAR#B2BINT` signals international B2B e-reporting (BR-FR-20).
- **Party identification (BR-FR-MAP-16)**: the seller/buyer legal registration identifier is carried in `cac:PartyLegalEntity/cbc:CompanyID` with a `@schemeID` from the AFNOR-approved list below. The **value is the party's own registration identifier, passed through as-is** — no special value construction (e.g. country + name) is required. Provide an approved `@schemeID` and the mapping carries it through to the report. All of the approved AFNOR schemes are allowed in PUF:

  | schemeID | Party identifier | Typical use |
  |----------|------------------|-------------|
  | `0002` | SIREN | French company (9 digits) |
  | `0009` | SIRET | French establishment (14 digits) |
  | `0088` | GLN | GS1 Global Location Number |
  | `0223` | Intra-community VAT number | EU party |
  | `0226` | French natural person id | Individual (B2C) |
  | `0227` | Non-EU identifier | Party established outside the EU |
  | `0228` | RIDET | New Caledonia |
  | `0229` | TAHITI | French Polynesia |
  | `0231` | Single-taxable-company id | French VAT group / single taxable person |
  | `0238` | PDP matricule | Accredited platform (PA/PDP) |

- **Country code mapping (BR-FR-MAP-14)**: Overseas territory codes (GP, MQ, RE) → `FR` in flux; Guyane (GF) and Mayotte (YT) stay as-is in Flux 10.1.
- **Currency**: For B2B, any valid currency; if not EUR, BT-6 (tax currency code) is mandatory. For B2C/transaction, must be EUR.
- **Phased rollout (G6.15)**: Header-level data from Sept 2026; line-level data + allowances/charges from Sept 2027.
- **Correcting an already-Approved period**: all three correction types below require the referenced report/document to be Approved, and require `reportPeriodStart`/`reportPeriodEnd` to match the period being corrected. `RECTIFICATION` is a legacy alias still accepted for `REPLACE_PERIOD`, but these examples use the canonical `REPLACE_PERIOD` value.

  | Type | Use it to | What carries over |
  |------|-----------|--------------------|
  | `ADD` (Complémentaire/CO) | Add a document not in the original submission | Everything already reported, plus the new document |
  | `EDIT` (Modification/MO) | Correct one specific document already reported | Everything already reported, with that document replaced |
  | `REPLACE_PERIOD` (Rectification/RE) | Replace the whole period | Nothing — full corrected data set required |

  `referencedReportId` differs by type: `ADD` and `REPLACE_PERIOD` reference the **aggregatedId** of the Approved aggregated report; `EDIT` references the **exact `taxReportId`** of the specific previously sent document being corrected, not an aggregatedId.
