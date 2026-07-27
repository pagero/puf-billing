# UAE E-Invoicing Examples

This directory contains example PUF invoice files demonstrating the United Arab Emirates e-invoicing implementation for the Peppol PINT BIS Billing AE specification.

## Overview

UAE e-invoicing is mandated through the Federal Tax Authority (FTA) and transmitted via the Peppol network using the PINT BIS Billing AE 1.0.4 profile. These examples demonstrate key UAE requirements including:

- Invoice Transaction Type Code (BTAE-02) — 8-character flag string signalling the UAE business context
- UAE Tax Registration Number (TRN) — 15-digit identifier starting with `1` and ending with `03`
- Peppol Participant Identifier — the 10-digit TIN (first 10 digits of the TRN) under scheme `0235`
- Legal registration identifiers — Trade License, Emirates ID, Passport (scheme codes `AE:TL`, `AE:EID`, `AE:PASSPORT`)
- Emirate codes for country subdivision (`AUH`, `DXB`, `SHJ`, `UAQ`, `FUJ`, `AJM`, `RAK`)
- Item type declaration via `cac:CommodityClassification/cbc:CommodityCode` (`G`, `S`, `B`) with HS classification and SAC codes
- UAE-specific supply scenarios: exports, Free Trade Zone, disclosed agent, deemed supply, profit margin scheme

> Each XML file opens with a header comment describing the use case, the scenario, the key fields and the governing rule references, so an example can be read on its own without this README. The sections below give the same information in summary form for scanning and comparison.

---

## Example Files

### 1. PUF_AE_Invoice.xml

**Standard Tax Invoice**

Demonstrates:

- Standard UAE tax invoice with 5% VAT (category `S`)
- BTAE-02 = `00000000` (no special transaction context)
- Seller TRN and trade license with Legal Registration Authority (LRA)
- HS classification for goods (BTAE-13 = `G`)
- UAE IBAN and BIC in PayeeFinancialAccount

**Key Features:**

- Document type: `380`, BTAE-02 `00000000`
- Seller: Acme Trading LLC (Dubai, DXB) — trade license `AE:TL`, LRA `Department of Economic Development - Dubai`
- Buyer: Burj Holdings PJSC (Abu Dhabi, AUH) — trade license `AE:TL`, LRA `Abu Dhabi Department of Economic Development`
- 10 × AED 100.00 industrial pumps at 5% VAT; gross price with 0.00 discount (ibr-126-ae)

---

### 2. PUF_AE_CreditNote.xml

**Standard Credit Note**

Demonstrates:

- UAE credit note with reason code `DL8.61.1.D` (goods returned)
- Mandatory BillingReference to the original invoice
- BTAE-03 credit note reason code carried in `puf:BillingReferenceExtension/puf:Code`
- BTAE-02 = `00000000`

**Key Features:**

- Document type: `381`, BTAE-02 `00000000`
- BTAE-03 credit note reason code carried in `puf:BillingReferenceExtension/puf:Code`
- BillingReference to `INV-AE-2026-00001` with original issue date
- 2 units returned; 5% VAT at line level

---

### 3. PUF_AE_Invoice_ContinuousSupply.xml

**Continuous Supply Invoice**

Demonstrates:

- Continuous supply flag in BTAE-02 position 5 (`00001000`)
- Mandatory invoicing period (`cac:InvoicePeriod`) covering the supply window
- Contract document reference linking to the master agreement
- Service item type with SAC code (BTAE-17)

**Key Features:**

- Document type: `380`, BTAE-02 `00001000`
- InvoicePeriod: April 2026 (monthly advisory retainer)
- ContractDocumentReference: MSA-2025-ACME-BURJ-007
- Item type `S` (Services), SAC code `9983.11` (Management consulting services)

---

### 4. PUF_AE_Invoice_ECommerce.xml

**E-Commerce Invoice**

Demonstrates:

- E-Commerce flag in BTAE-02 position 7 (`00000010`)
- Mandatory `cac:Delivery` block with `DeliveryLocation/Address` and `DeliveryParty` (ibr-142-ae)
- Order reference from the web platform
- Standard 5% VAT

**Key Features:**

- Document type: `380`, BTAE-02 `00000010`
- Delivery to Marina Walk, Dubai (DXB) — same emirate as seller
- OrderReference: `WEB-ORD-2026-04-9837`
- 3 × AED 140.00 wireless headphones, HS code `8518.30.20`

---

### 5. PUF_AE_Invoice_ReverseCharge.xml

**Domestic Reverse Charge Invoice**

Demonstrates:

- VAT category `AE` (reverse charge) — buyer accounts for VAT
- Buyer VAT identifier mandatory (ibr-103-ae)
- VAT amount = 0 at document and line level (ibr-162-ae)
- BTAE-09 Nature Code on `cac:CommodityClassification/cbc:NatureCode`
- GS1 GTIN identifier mandatory on reverse-charge lines (`schemeID="0160"`, ibr-174-ae)

**Key Features:**

- Document type: `380`, BTAE-02 `00000000`
- 25 × AED 200.00 smartphones; category `AE`, rate `5.00`, TaxAmount `0.00`
- NatureCode `DL8.48.8.2` — UAE Goods/Services subject to RCM code list
- StandardItemIdentification GTIN `06291041500001`

---

### 6. PUF_AE_Invoice_SummaryInvoice.xml

**Summary Invoice**

Demonstrates:

- Summary invoice flag in BTAE-02 position 4 (`00010000`)
- Mandatory invoicing period as the consolidation window (ibr-138-ae)
- Multiple service lines with SAC codes
- Banking sector scenario

**Key Features:**

- Document type: `380`, BTAE-02 `00010000`
- InvoicePeriod: April 2026 (monthly fee consolidation)
- Line 1: Monthly account maintenance fee, SAC `9971.13`
- Line 2: 15 × international wire transfer fees, SAC `9971.19`

---

### 7. PUF_AE_Invoice_MarginScheme.xml

**Profit Margin Scheme Invoice**

Demonstrates:

- Profit Margin Scheme flag in BTAE-02 position 3 (`00100000`)
- VAT category `N` with rate `5.00` — statutory rate present even though TaxAmount = 0
- VAT assessed on the supplier's profit margin and settled directly with the FTA
- Used vehicle resale scenario

**Key Features:**

- Document type: `380`, BTAE-02 `00100000`
- Category `N`, Percent `5.00`, TaxAmount `0.00` (VAT not charged on the invoice)
- 1 × 2022 Toyota Camry at AED 45,000.00; HS code `8703.23.10`
- VIN reference in item description

---

### 8. PUF_AE_Invoice_DeemedSupply.xml

**Deemed Supply Invoice**

Demonstrates:

- Deemed Supply flag in BTAE-02 position 2 (`01000000`)
- Fixed FTA dummy buyer endpoint `9900000097` (scheme `0235`)
- FTA placeholder TRN `100000000099903` (15 digits, starts with `1`, ends with `03`)
- `PrepaidAmount` = `TaxInclusiveAmount` and `PayableAmount` = `0.00` (free-of-charge supply)
- `DueDate` omitted — no payment obligation

**Key Features:**

- Document type: `380`, BTAE-02 `01000000`
- Buyer: FTA Deemed Supply Recipient (dummy endpoint and TRN)
- 5 × AED 100.00 promotional gift hampers at 5% VAT; HS code `2106.90.99`
- PrepaidAmount `525.00` = TaxInclusiveAmount; PayableAmount `0.00`

---

### 9. PUF_AE_Invoice_Exports.xml

**Export Supply Invoice**

Demonstrates:

- Exports flag in BTAE-02 position 8 (`00000001`)
- Non-UAE buyer using the predefined non-Peppol placeholder endpoint `9900000099`
- Mandatory `cac:Delivery` block with non-AE delivery country (ibr-152-ae)
- `cac:DeliveryTerms/cbc:ID` carrying Incoterms code (BTAE-22)
- Zero-rated supply (category `Z`, rate `0.00`)

**Key Features:**

- Document type: `380`, BTAE-02 `00000001`
- Buyer: Gulf Beauty Retail W.L.L. (Kuwait, KW) — no Peppol registration, uses placeholder `9900000099`
- Delivery to Salmiya, Kuwait (KW); Incoterms `FOB`
- 500 × AED 30.00 skincare sets; HS code `3304.99.00`

---

### 10. PUF_AE_Invoice_FreeTradeZone.xml

**Free Trade Zone Supply Invoice**

Demonstrates:

- FTZ flag in BTAE-02 position 1 (`10000000`)
- Beneficiary ID (BTAE-01) in `puf:RestrictedInformationParty` with `Key = 'Beneficiary'`
- FTZ beneficiary TRN (distinct from the accounting buyer)
- JAFZA Free Zone scenario

**Key Features:**

- Document type: `380`, BTAE-02 `10000000`
- Beneficiary: JAFZA End-User FZE — TRN carried in RestrictedInformationParty, not AccountingCustomerParty
- In the PINT AE target output, the Beneficiary maps to `cac:BuyerCustomerParty`

---

### 11. PUF_AE_Invoice_DisclosedAgent.xml

**Disclosed Agent Invoice**

Demonstrates:

- Disclosed Agent flag in BTAE-02 position 6 (`00000100`)
- Principle ID (BTAE-14) in `puf:RestrictedInformationParty` with `Key = 'Principle'`
- Principle TRN must differ from the seller's TRN
- Agent billing on behalf of a principal

**Key Features:**

- Document type: `380`, BTAE-02 `00000100`
- Principle: National Insurance Co. PJSC — TRN carried in RestrictedInformationParty
- In the PINT AE target output, the Principle maps to `cac:SellerSupplierParty`

---

### 12. PUF_AE_Invoice_Foreign_Currency.xml

**Foreign Currency Invoice (USD)**

Demonstrates:

- `DocumentCurrencyCode = USD` with `TaxCurrencyCode = AED` (ibr-140-ae)
- Mandatory `cac:TaxExchangeRate` with `CalculationRate` and `MathematicOperatorCode = Multiply`
- Dual document-level TaxTotal: first in USD (IBT-110), second in AED (IBT-111)
- Line-level second TaxTotal in AED (BTAE-08, ibr-104-ae)
- `puf:TaxSubtotalExtension/puf:TaxCurrencyTaxAmount` for per-category AED tax (IBT-190)
- `puf:LegalMonetaryTotalExtension/puf:TaxCurrencyTaxInclusiveAmount` for total AED (BTAE-20)
- `puf:LineExtension/puf:TaxCurrencyTaxInclusiveLineExtensionAmount` for line AED total (BTAE-10, ibr-194-ae)

**Key Features:**

- Document type: `380`, BTAE-02 `00000000`; DocumentCurrencyCode `USD`, TaxCurrencyCode `AED`
- Exchange rate: 1 USD = 3.6725 AED (CBU mid-market)
- All invoice amounts in USD; VAT and totals also expressed in AED via PUF extensions

---

### 13. PUF_AE_SelfBilling_Invoice.xml

**Self-Billed Invoice**

Demonstrates:

- `puf:SelfBilled = true` document-level extension
- Type code `380` retained in PUF (UAE does not use a separate PUF self-billing type code)
- Buyer issues the invoice on behalf of the supplier
- Scrap metal recycling — weighed at buyer's gate

**Key Features:**

- Document type: `380`, BTAE-02 `00000000`; `puf:SelfBilled = true`
- Supplier: Al Awir Scrap Suppliers LLC (Dubai); Buyer (invoicing party): Emirates Steel Recycling LLC (Sharjah)
- 7 tonnes of mixed ferrous scrap at AED 500.00/tonne; HS code `7204.49.00`
- In the PINT BIS Self-Billing AE target, the transformation automatically applies type code `389` and `urn:peppol:pint:selfbilling-1@ae-1` CustomizationID

---

### 14. PUF_AE_Invoice_AdvancePayment.xml

**Advance Payment — Final Invoice**

Demonstrates:

- Advance-payment handling per UAE Guidelines V1.1, Appendix 5: the advance is invoiced as a normal Tax Invoice (`380`) and the final invoice is likewise a Tax Invoice covering only the outstanding balance — there is no dedicated prepayment type code
- `cac:BillingReference` to the preceding advance-payment invoice (IBT-25 preceding invoice number, IBT-26 preceding invoice issue date)
- Advance reference also restated in a document note (BT-22 / IBT-022)
- `cbc:PrepaidAmount` deliberately omitted — the final invoice already reflects only the remaining balance, so no further advance adjustment is applied
- BTAE-02 = `00000000` (no special transaction context; there is no advance/prepayment flag)

**Key Features:**

- Document type: `380`, BTAE-02 `00000000`
- Contract AED 10,000.00 + 5% VAT; an advance of AED 1,000.00 + VAT was invoiced earlier as `ADV-001` (2026-05-01)
- This final invoice bills the remaining AED 9,000.00 net + AED 450.00 VAT; PayableAmount AED 9,450.00
- BillingReference → `ADV-001`; HS code `7309.00.00` (steel storage tank)

> **Retention:** UAE Guidelines V1.1, Appendix 5 also clarifies retention. Businesses may issue an Electronic Invoice for the amount payable after adjusting for the retained amount, then a separate Electronic Invoice for the retained amount once the buyer becomes liable to release it. Each is a standard Tax Invoice (`380`) and follows the same structure as this example, with the retained portion simply billed on the later invoice.

---

### 15. PUF_AE_Invoice_NaturalPerson.xml

**Natural Person Seller (Passport Identification)**

Demonstrates:

- A seller who is a natural person rather than a company
- Legal registration identifier is a passport number (`AE:PASSPORT`) instead of a trade license
- Passport issuing country code (BTAE-18) required in place of the authority name (BTAE-12)
- A natural person can still be VAT-registered as a sole practitioner and carry a TRN

**Key Features:**

- Document type: `380`, BTAE-02 `00000000`
- Seller: Jane Doe (Dubai, DXB) — passport `P12345678` with `@schemeID="AE:PASSPORT"`
- BTAE-18 passport issuing country `GB` on `cac:PartyIdentification` with `@schemeID="AE:PASSPORT_COUNTRY"` (ibr-012-ae)
- 10 hours of consulting at AED 200.00/hour; item type `S`, SAC `9983.11`

> **Which supplementary field applies:** when the legal registration identifier type (BTAE-15) is `AE:TL`, `AE:EID` or `AE:CD`, the authority name (BTAE-12) is required. When it is `AE:PASSPORT`, the passport issuing country (BTAE-18) is required instead. Compare this example with `PUF_AE_Invoice.xml`.

---

## UAE-Specific Requirements Reference

### BTAE-02 Invoice Transaction Type Code

Eight-character flag string in `cbc:InvoiceTypeCode/@name` (or `cbc:CreditNoteTypeCode/@name`). Each position maps to a specific UAE business context:

| Position | Flag | BTAE-02 value | Scenario |
|----------|------|---------------|----------|
| 1 | FTZ | `1XXXXXXX` | Free Trade Zone supply |
| 2 | Deemed Supply | `X1XXXXXX` | Supply made without consideration (gifts/samples above threshold) |
| 3 | Profit Margin Scheme | `XX1XXXXX` | Sale under Article 43 — VAT on margin, not full price |
| 4 | Summary Invoice | `XXX1XXXX` | Consolidated invoice covering a period |
| 5 | Continuous Supply | `XXXX1XXX` | Instalment invoice under a continuing supply arrangement |
| 6 | Disclosed Agent | `XXXXX1XX` | Agent invoices on behalf of a disclosed principal |
| 7 | E-Commerce | `XXXXXX1X` | Supply through an electronic commerce platform |
| 8 | Exports | `XXXXXXX1` | Zero-rated export of goods or services outside the UAE |

### VAT Categories

| Code | Description | Rate | Notes |
|------|-------------|------|-------|
| `S` | Standard rated | 5.00% | Exact 5.00 required |
| `Z` | Zero rated | 0.00% | Used for exports |
| `E` | Exempt from VAT | 0.00% | Exemption reason code mandatory |
| `O` | Not subject to VAT | 0.00% | Outside scope |
| `AE` | Reverse charge | 5.00% | Buyer TRN mandatory; line VAT = 0; NatureCode and GTIN required |
| `N` | Standard rate additional VAT | 5.00% | Used for Profit Margin Scheme; rate present; TaxAmount = 0; BTAE-02 position 3 must be set |

### Item Type and Classification

| Scenario | `cbc:CommodityCode` | Classification required | Code |
|----------|---------------------|------------------------|------|
| Physical goods | `G` | HS (`@listID = 'HS'`) | e.g. `8413.70.10` |
| Services | `S` | SAC (`cac:AdditionalItemIdentification/@schemeID = 'SAC'`) | e.g. `9983.11` |
| Mixed | `B` | Both HS and SAC | — |

> **Service lines carry no HS code.** The PINT AE syntax table shows `cbc:ItemClassificationCode` as 1..1 inside `cac:CommodityClassification`, but the schematron only requires it when the item type is `G` or `B` (`ibr-184-ae`), and `ibr-188-ae` constrains the scheme only when a classification is present. A pure service line therefore contains `cbc:CommodityCode` alone — verified end-to-end against PINT AE 1.0.4. HS classifies goods; putting a placeholder HS code on a service would misreport the supply.

### Fixed Placeholder Endpoints

| Scenario | Buyer EndpointID (scheme `0235`) |
|----------|----------------------------------|
| Deemed Supply | `9900000097` |
| Export to non-Peppol buyer | `9900000099` |

### Participant Identifier (EndpointID)

The seller and buyer `cbc:EndpointID` is the Peppol Participant Identifier issued by the FTA: the **10-digit TIN** under scheme `0235`. The TIN is the first 10 digits of the 15-character TRN — the full TRN must **not** be used as the endpoint.

| Party | TRN (`cac:PartyTaxScheme/cbc:CompanyID`) | EndpointID (scheme `0235`) |
|-------|------------------------------------------|----------------------------|
| Seller (Acme Trading LLC) | `100000000000003` | `1000000000` |
| Buyer (Burj Holdings PJSC) | `100000010001003` | `1000000100` |

The PUF-008 scheme code `AE:TIN` is used on `cac:PartyIdentification/cbc:ID`, not on `cbc:EndpointID`.

### TRN Format

UAE Tax Registration Numbers must be exactly 15 digits, start with `1`, and end with `03`. The FTA dummy TRN used for Deemed Supply is `100000000099903`.

---

## Validation

All examples validate against:

- PUF UBL 2.1 XSD schemas
- PUF-UBL.sch Schematron rules
- Peppol PINT BIS Billing AE 1.0.3 (PINT-UBL-validation-preprocessed + PINT-jurisdiction-aligned-rules)
- Peppol PINT BIS Self-Billing AE 1.0.3 (for `PUF_AE_SelfBilling_Invoice.xml`)

## References

- [PUF Code Lists — UAE Invoice Type Codes](https://pagero.github.io/puf-code-lists/#_invoice_type_codes_united_arab_emirates)
- [PUF Code Lists — UAE Invoice Transaction Type Code](https://pagero.github.io/puf-code-lists/#_invoice_transaction_type_code_united_arab_emirates)
- [PUF Code Lists — UAE Identification Schemes](https://pagero.github.io/puf-code-lists/#_identification_scheme_united_arab_emirates)
- PUF Billing Specification — UAE section
- Peppol PINT BIS Billing AE 1.0.4 specification
