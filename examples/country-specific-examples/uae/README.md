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
- Out-of-scope (type `480`), exempt and zero-rated supplies, and document level allowances and charges in each VAT category
- Predefined buyer endpoints and the identifiers that replace a Participant Identifier

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
- Predefined buyer endpoint `9900000097` (scheme `0235`), always used for a deemed supply (UAE Electronic Invoicing Guidelines V1.1, p.25)
- Illustrative buyer TRN `100000000099903` (15 digits, starts with `1`, ends with `03`). ibr-135-ae requires a buyer TIN or TRN, and no official placeholder TRN is published
- `PrepaidAmount` = `TaxInclusiveAmount` and `PayableAmount` = `0.00` (free-of-charge supply)
- `DueDate` omitted — no payment obligation

**Key Features:**

- Document type: `380`, BTAE-02 `01000000`
- Buyer: Example Gift Recipient LLC (predefined endpoint, illustrative TRN)
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
- Customs reference number (BTAE-21) as an export declaration: `cac:AdditionalDocumentReference/cbc:ID` with `schemeID="ED"`
- Zero-rated supply (category `Z`, rate `0.00`)

**Key Features:**

- Document type: `380`, BTAE-02 `00000001`
- Buyer: Gulf Beauty Retail W.L.L. (Kuwait, KW) — no Peppol registration, uses placeholder `9900000099`
- Delivery to Salmiya, Kuwait (KW); Incoterms `FOB`; export declaration `EXP010101234`
- 500 × AED 30.00 skincare sets; HS code `3304.99.00`

---

### 10. PUF_AE_Invoice_FreeTradeZone.xml

**Free Trade Zone Supply Invoice**

Demonstrates:

- FTZ flag in BTAE-02 position 1 (`10000000`)
- Beneficiary ID (BTAE-01) in `puf:RestrictedInformationParty` with `Key = 'Beneficiary'`
- FTZ beneficiary TRN on `cac:PartyIdentification/cbc:ID` with `@schemeID = 'AE:TRN'` (distinct from the accounting buyer)
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
- Principle TRN on `cac:PartyIdentification/cbc:ID` with `@schemeID = 'AE:TRN'`, and it must differ from the seller's TRN
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

### 16. PUF_AE_Invoice_BuyerPassport.xml

**Natural Person Buyer (Passport Identification)**

Demonstrates:

- A buyer who is a natural person, identified by a passport (`AE:PASSPORT`) instead of a trade license
- Buyer passport issuing country (BTAE-19) on `cac:PartyIdentification` with `@schemeID="AE:PASSPORT_COUNTRY"` (ibr-010-ae)
- The target reports the passport with `@schemeAgencyID="PAS"` and the issuing country as `@schemeAgencyName`

**Key Features:**

- Document type: `380`, BTAE-02 `00000000`
- Buyer: John Doe, a VAT-registered sole trader (Abu Dhabi, AUH) — passport `Z1234567` issued by `IN`, TRN `100000020002003`
- 4 × AED 750.00 executive desks at 5% VAT; HS code `9403.30.00`

---

### 17. PUF_AE_Invoice_SellerTIN.xml

**Seller Tax Identification Number (TIN)**

Demonstrates:

- Seller tax registration identifier (IBT-032): the 10-digit TIN on `cac:PartyIdentification/cbc:ID` with `@schemeID="AE:TIN"`, next to the TRN
- The target reports the TIN in a second `cac:PartyTaxScheme` with tax scheme `TAX` (ibr-148-ae, ibr-178-ae)
- A TIN sent as a `cac:PartyTaxScheme` is never reported as IBT-032: next to a TRN it is dropped, and on its own it is reported as the VAT identifier and fails ibr-132-ae

**Key Features:**

- Document type: `380`, BTAE-02 `00000000`
- Seller: Acme Trading LLC — TRN `100000000000003`, TIN `1000000000` (the first 10 digits of the TRN)
- 2 × AED 2,500.00 industrial air compressors at 5% VAT; HS code `8414.80.11`

> A seller that is not registered for VAT has no TRN. It sends the same `AE:TIN`, which is then the mandatory seller identifier (ibr-177-ae; UAE Electronic Invoicing Guidelines V2.0, 18.1.1).

---

### 18. PUF_AE_Invoice_BuyerWithoutParticipantID.xml

**Buyer Without a Participant Identifier (Predefined Endpoint 9900000098)**

Demonstrates:

- Predefined buyer endpoint `9900000098` (scheme `0235`) for a UAE buyer that has not yet implemented Electronic Invoicing and has no Participant Identifier (Guidelines V2.0, 10.2.2)
- Buyer TIN (`AE:TIN`) reported as the buyer identifier IBT-046 under scheme `0235`, which ibr-135-ae requires on this endpoint together with or instead of the TRN (Guidelines V2.0, 18.2.2)
- The document is reported to the FTA and not delivered over Peppol, so the supplier also issues a regular tax invoice, for example a PDF

**Key Features:**

- Document type: `380`, BTAE-02 `00000000`
- Buyer: Falcon Engineering LLC (Sharjah, SHJ) — TRN `100000030003003`, TIN `1000000300`, no Participant Identifier
- 10 × AED 100.00 industrial pumps at 5% VAT

---

### 19. PUF_AE_Invoice_ReverseCharge_AllowanceCharge.xml

**Reverse Charge with Document Level Allowance and Charge**

Demonstrates:

- Document level allowance (BG-20) and charge (BG-21) in VAT category `AE`
- The allowance and the charge carry rate `0.00` (aligned-ibrp-ae-06, aligned-ibrp-ae-07), while the line and the VAT breakdown carry `5.00`
- Allowance expressed as a percentage of a base amount (ibr-131-ae)

**Key Features:**

- Document type: `380`, BTAE-02 `00000000`
- 50 × AED 900.00 tablet computers; NatureCode `DL8.48.8.2` (Electronic devices), GTIN `06291041500022`
- 2% volume rebate of AED 900.00 (reason `95`) and AED 450.00 insured freight (reason `FC`); AE taxable amount AED 44,550.00, VAT AED 0.00

---

### 20. PUF_AE_Invoice_Exempt.xml

**Exempt Supply with Document Level Allowance and Charge**

Demonstrates:

- Exempt supply (category `E`) with exemption reason code `DL8.46.1` (Certain financial services, [PUF-013](https://pagero.github.io/puf-code-lists/#_tax_exemption_codes_in_united_arab_emirates))
- Document level allowance and charge in category `E`: rate `0.00` (aligned-ibrp-e-06, aligned-ibrp-e-07), their own exemption reason code, and an allowance or charge reason code (ibr-168-ae, ibr-169-ae)
- No rate on the exempt line or in the exempt VAT breakdown, and no line VAT amount (BTAE-08) on the exempt line (ibr-163-ae)
- An exempt supply combined with a standard-rated one on a tax invoice (Guidelines V2.0, 10.2.2)

**Key Features:**

- Document type: `380`, BTAE-02 `00000000`
- Seller: Emirates Premier Bank PJSC — term loan interest AED 18,500.00 (`E`, SAC `9971.13`) and arrangement fee AED 4,000.00 (`S`, SAC `9971.19`)
- Interest rebate of AED 500.00 (reason `95`) and late payment interest of AED 250.00 (reason `FI`) on the exempt part

> **Why not exempt only:** an invoice whose lines are all exempt has no valid type code today. Guidelines V2.0, 18.3.1 states that type code `480` should not be used for exempt supplies, and PINT AE 1.0.4 rule ibr-151-ae rejects type code `380` when every line is `E` or `O`. The PINT AE examples for category E use `480`.

---

### 21. PUF_AE_Invoice_ZeroRated.xml

**Domestic Zero-Rated Supply with Document Level Allowance and Charge**

Demonstrates:

- A zero-rated supply (category `Z`) within the UAE, so BTAE-02 position 8 (Exports) stays `0`
- Rate `0.00` at every level: line, document level allowance and charge, and VAT breakdown
- Line VAT amount (BTAE-08) of zero (ibr-165-ae); type code `380`, because zero-rated supplies remain within the VAT framework (Guidelines V2.0, 18.3.1)

**Key Features:**

- Document type: `380`, BTAE-02 `00000000`
- Acme Medical Supplies LLC (Dubai) to Burj Healthcare LLC (Abu Dhabi): 40 × AED 220.00 insulin pens; HS code `3004.31.00`
- 2% early payment discount of AED 176.00 (reason `95`) and AED 150.00 cold-chain delivery (reason `DL`)

---

### 22. PUF_AE_Invoice_OutOfScope.xml

**Out of Scope of VAT (Commercial Invoice, Type 480)**

Demonstrates:

- Type code `480` for a transaction that relates exclusively to supplies outside the scope of VAT (Guidelines V2.0, 18.3.1)
- Goods supplied from outside the UAE to another location outside the UAE without entering the UAE, classified as out of scope rather than export (Guidelines V2.0, 18.3.2)
- Category `O` without a rate at any level, including a document level allowance and charge
- Buyer legal registration identifier, mandatory on type `480` (ibr-136-ae)
- Seller TIN (`AE:TIN`) as the seller tax registration identifier: when every VAT category is `O`, Pagero does not report the VAT identifiers sent in the document, and either IBT-031 or IBT-032 shall be provided (Guidelines V2.0, 18.1.1)

**Key Features:**

- Document type: `480`, BTAE-02 `00000000`
- 600 m × AED 75.00 seamless line pipe shipped from China to Sohar, Oman (OM); HS code `7304.19.00`
- 2% volume discount of AED 900.00 (reason `95`) and AED 1,500.00 sea freight (reason `FC`); net AED 45,600.00, no VAT

---

### 23. PUF_AE_Invoice_Exports_PeppolBuyer.xml

**Export to a Buyer on Peppol (Foreign Currency)**

Demonstrates:

- Export (BTAE-02 position 8) to a foreign buyer registered in Peppol with its own participant identifier, here an Australian Business Number under scheme `0151`
- Pagero keeps the buyer's endpoint when the buyer is reached over Peppol and reports `9900000099` otherwise (Guidelines V2.0, 18.3.3)
- An export invoiced in USD, with the AED amounts in the PUF extensions

**Key Features:**

- Document type: `380`, BTAE-02 `00000001`; DocumentCurrencyCode `USD`, TaxCurrencyCode `AED`, 1 USD = 3.6725 AED
- Buyer: Southern Cross Building Supplies Pty Ltd (Kewdale, WA, AU) — EndpointID `0151:98000000470`
- 1,500 kg × USD 6.00 aluminium extrusion profiles; HS code `7604.29.10`; Incoterms `CIF`; export declaration `EXP010105678`

> A test run without Pagero Online routing reports `0235:9900000099`, because it cannot tell that the buyer is reached over Peppol.

---

### 24. PUF_AE_Invoice_Extensive.xml

**Extensive Tax Invoice (Field Coverage Reference)**

Demonstrates:

- Where the optional PINT AE business terms go in PUF: document references, trading names, contacts, payee, seller tax representative, delivery location and recipient, payment card, paid and rounding amounts, and line references and item details
- Three transaction types at once: BTAE-02 `10001010` (Free Trade Zone, Continuous Supply, E-Commerce)
- The five VAT categories that can appear together on a tax invoice: `S`, `E`, `O`, `AE` and `Z`

**Key Features:**

- Document type: `380`, BTAE-02 `10001010`; free zone beneficiary (BTAE-01) in `puf:RestrictedInformationParty`
- Line and document level allowances and charges; total AED 23,723.50, paid AED 5,000.00, rounding AED 0.50, payable AED 18,724.00
- One `cac:PaymentMeans` with payment card information (BG-18): PUF carries one payment means code per document

> **BTAE-06 Frequency of billing is not shown:** the PINT AE 1.0.4 syntax binds it to `cac:InvoicePeriod/cbc:Description`, while rules ibr-005-ae and ibr-160-ae validate `cac:InvoicePeriod/cbc:DescriptionCode`.

---

## PINT AE Example Coverage

Each example in the Peppol PINT BIS Billing AE 1.0.4 resources (`trn-invoice/example`) has a PUF counterpart in this folder:

| PINT AE example | PUF example |
|-----------------|-------------|
| Standard tax invoice | `PUF_AE_Invoice.xml`; its optional fields are in `PUF_AE_Invoice_Extensive.xml` |
| Standard invoice Mandatory fields | `PUF_AE_Invoice.xml` |
| Standard invoice - Extensive | `PUF_AE_Invoice_Extensive.xml` |
| Standard tax invoice - predefined endpoint | `PUF_AE_Invoice_BuyerWithoutParticipantID.xml` |
| Buyer-PAS-identifier | `PUF_AE_Invoice_BuyerPassport.xml` |
| Seller-PAS-identifier | `PUF_AE_Invoice_NaturalPerson.xml` |
| Seller-TIN-identifier | `PUF_AE_Invoice_SellerTIN.xml` |
| Commercial invoice | `PUF_AE_Invoice_OutOfScope.xml` |
| Zero rated supplies | `PUF_AE_Invoice_ZeroRated.xml` |
| Doc-level-allowance-AE-category, Doc-level-charge-AE-category | `PUF_AE_Invoice_ReverseCharge_AllowanceCharge.xml` |
| Doc-level-allowance-E-category, Doc-level-charge-E-category | `PUF_AE_Invoice_Exempt.xml` (type `380`, see section 20) |
| Doc-level-allowance-O-category, Doc-level-charge-O-category | `PUF_AE_Invoice_OutOfScope.xml` |
| Doc-level-allowance-Z-category, Doc-level-charge-Z-category | `PUF_AE_Invoice_ZeroRated.xml` |
| Continuous supplies | `PUF_AE_Invoice_ContinuousSupply.xml` |
| Deemed supply - predefined endpoint | `PUF_AE_Invoice_DeemedSupply.xml` |
| Disclosed agent billing | `PUF_AE_Invoice_DisclosedAgent.xml` |
| Exports | `PUF_AE_Invoice_Exports_PeppolBuyer.xml` |
| Exports - predefined endpoint | `PUF_AE_Invoice_Exports.xml` |
| Margin scheme | `PUF_AE_Invoice_MarginScheme.xml` |
| Summary tax invoice | `PUF_AE_Invoice_SummaryInvoice.xml` |
| Supply involving free trade zone | `PUF_AE_Invoice_FreeTradeZone.xml` |
| Supply through e-commerce | `PUF_AE_Invoice_ECommerce.xml` |
| Supply under Reverse charge mechanism | `PUF_AE_Invoice_ReverseCharge.xml` |

> The PINT AE example "Supply through e-commerce" sets BTAE-02 to `00000001`, which is the Exports position. Rule ibr-142-ae reads E-Commerce from position 7, so `PUF_AE_Invoice_ECommerce.xml` uses `00000010`.

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
| `Z` | Zero rated | 0.00% | Exports and domestic zero-rated supplies |
| `E` | Exempt from VAT | no rate | Exemption reason code mandatory ([PUF-013](https://pagero.github.io/puf-code-lists/#_tax_exemption_codes_in_united_arab_emirates)) |
| `O` | Not subject to VAT | no rate | Outside scope; the document is type `480` when every supply on it is out of scope |
| `AE` | Reverse charge | 5.00% | Buyer TRN mandatory; line VAT = 0; NatureCode and GTIN required |
| `N` | Standard rate additional VAT | 5.00% | Used for Profit Margin Scheme; rate present; TaxAmount = 0; BTAE-02 position 3 must be set |

### VAT Rate by Level

The rate a category carries depends on where it appears:

| Category | Line (BT-152) | Document level allowance or charge (BT-96 / BT-103) | VAT breakdown (BT-119) |
|----------|---------------|------------------------------------------------------|------------------------|
| `S` | `5.00` | `5.00` | `5.00` |
| `Z` | `0.00` | `0.00` | `0.00` |
| `E` | no rate | `0.00` | no rate |
| `O` | no rate | no rate | no rate |
| `AE` | `5.00` | `0.00` | `5.00` |
| `N` | `5.00` | not allowed (ibr-114-ae, ibr-115-ae) | `5.00` |

Rules: ibr-190-ae; aligned-ibrp-z-05 to z-07 and ibr-120-ae; aligned-ibrp-e-05 to e-07 and ibr-121-ae; aligned-ibrp-o-05 to o-07 and aligned-ibrp-o-11-ae; aligned-ibrp-ae-05-ae to ae-07.

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
| Buyer without a Participant Identifier, not an export | `9900000098` |
| Export to non-Peppol buyer | `9900000099` |

Pagero also sets these endpoints itself, so they may be omitted from the PUF document. The examples send them explicitly.

### Participant Identifier (EndpointID)

The seller and buyer `cbc:EndpointID` is the Peppol Participant Identifier issued by the FTA: the **10-digit TIN** under scheme `0235`. The TIN is the first 10 digits of the 15-character TRN — the full TRN must **not** be used as the endpoint.

| Party | TRN (`cac:PartyTaxScheme/cbc:CompanyID`) | EndpointID (scheme `0235`) |
|-------|------------------------------------------|----------------------------|
| Seller (Acme Trading LLC) | `100000000000003` | `1000000000` |
| Buyer (Burj Holdings PJSC) | `100000010001003` | `1000000100` |

The PUF-008 scheme code `AE:TIN` is used on `cac:PartyIdentification/cbc:ID`, not on `cbc:EndpointID`.

### TRN Format

UAE Tax Registration Numbers must be exactly 15 digits, start with `1`, and end with `03`. The Deemed Supply example uses the illustrative TRN `100000000099903`. No official placeholder TRN is published.

The TRN is normally the VAT identifier on `cac:PartyTaxScheme/cbc:CompanyID`. For a party with no VAT accounting role in the document — the FTZ Beneficiary (BTAE-01) and the disclosed-agent Principle (BTAE-14), both carried in `puf:RestrictedInformationParty` — it is provided on `cac:PartyIdentification/cbc:ID` with the PUF-008 scheme code `AE:TRN`. A UAE identifier given without a scheme identifier is not processed.

---

## Validation

All examples validate against:

- PUF UBL 2.1 XSD schemas
- PUF-UBL.sch Schematron rules
- Peppol PINT BIS Billing AE 1.0.4 (PINT-UBL-validation-preprocessed + PINT-jurisdiction-aligned-rules)
- Peppol PINT BIS Self-Billing AE 1.0.4 (for `PUF_AE_SelfBilling_Invoice.xml`)

## References

- [PUF Code Lists — UAE Invoice Type Codes](https://pagero.github.io/puf-code-lists/#_invoice_type_codes_united_arab_emirates)
- [PUF Code Lists — UAE Invoice Transaction Type Code](https://pagero.github.io/puf-code-lists/#_invoice_transaction_type_code_united_arab_emirates)
- [PUF Code Lists — UAE Identification Schemes](https://pagero.github.io/puf-code-lists/#_identification_scheme_united_arab_emirates)
- [PUF Code Lists — UAE Tax Exemption Codes](https://pagero.github.io/puf-code-lists/#_tax_exemption_codes_in_united_arab_emirates)
- PUF Billing Specification — UAE section
- Peppol PINT BIS Billing AE 1.0.4 specification
