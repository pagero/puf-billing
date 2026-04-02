# PUF Tax Data Report — France Invoice Reporting Examples (Flux 10.1)

Example files for French invoice e-reporting (Flux 10.1). These use the standard PUF Invoice format with reporting-specific extensions in `ext:UBLExtensions` for metadata like entry type, transaction type, and report period.

> **Note**: For payment reporting (Flux 10.2 / 10.4), see [puf-tax-report/examples/country-specific-examples/france/](https://github.com/pagero/puf-tax-report/tree/master/examples/country-specific-examples/france).

## Example Files

| File | Direction | Entry Type | Description |
|------|-----------|------------|-------------|
| `PUF_FR_SALES_INVOICE_TDR_CROSSBORDER_B2Bi_DRAFT.xml` | Sales (B2Bi) | INVOICE | Draft — Cross-border B2B sales invoice reporting. French seller, Italian buyer. Services invoice (S1). |
| `PUF_FR_SALES_INVOICE_TDR_POS_TRANSACTIONS_DRAFT.xml` | Sales (B2C) | RECEIPTTRANSACTION | Draft — B2C POS receipt transaction reporting. Aggregated daily transactions with TLB1 (goods) and TPS1 (services) category codes. |
| `PUF_FR_PURCHASE_INVOICE_TDR_CROSSBORDER_Bi2B_DRAFT.xml` | Purchase (Bi2B) | INVOICE | Draft — Cross-border B2B purchase invoice reporting. French buyer, German seller. ProfileID = `urn:pagero.com:puf:purchase:1.0`. |
| `PUF_France_UC43_IntraCommunitySupply_InvoiceReport.xml` | Sales (B2Bi) | INVOICE | UC43 — Intra-community goods supply from France to Germany. VAT category K with `VATEX-EU-IC`. `#BAR#B2BINT` treatment type. Buyer identified with EU VAT number (schemeID `0223`). |
| `PUF_France_UC44_DROM_GuadeloupeToGuyane_InvoiceReport.xml` | Sales (B2Bi) | INVOICE | UC44 — DROM transaction from Guadeloupe (Group 1) to French Guiana (Group 2). Demonstrates BR-FR-MAP-14 country code mapping (GP → FR, GF stays GF). VAT category G with `VATEX-EU-G`. |

## Reporting Extensions (UBLExtensions)

Invoice e-reporting uses the standard PUF Invoice format with additional metadata in `ext:UBLExtensions/ext:UBLExtension`:

| Key | Description | Values |
|-----|-------------|--------|
| `entryType` | Type of reporting entry | `INVOICE` (individual invoice), `RECEIPTTRANSACTION` (aggregated POS) |
| `transactionType` | B2B or B2C classification | `B2B`, `B2C` |
| `issuerAssignedReportId` | Issuer-assigned report identifier | Free text |
| `reportPeriodStart` | Start of reporting period | YYYY-MM-DD |
| `reportPeriodEnd` | End of reporting period | YYYY-MM-DD |
| `transmissionType` | Report transmission type | `RECTIFICATION` (only if correction) |

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
- **Party identification (BR-FR-MAP-16)**: France = SIREN (`0002`), EU = VAT number (`0223`), non-EU = country + name (`0227`), New Caledonia = RIDET (`0228`), French Polynesia = TAHITI (`0229`).
- **Country code mapping (BR-FR-MAP-14)**: Overseas territory codes (GP, MQ, RE) → `FR` in flux; Guyane (GF) and Mayotte (YT) stay as-is in Flux 10.1.
- **Currency**: For B2B, any valid currency; if not EUR, BT-6 (tax currency code) is mandatory. For B2C/transaction, must be EUR.
- **Phased rollout (G6.15)**: Header-level data from Sept 2026; line-level data + allowances/charges from Sept 2027.
