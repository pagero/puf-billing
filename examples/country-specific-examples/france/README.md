# France E-Invoicing Examples

This directory contains example PUF invoice files demonstrating France's e-invoicing system implementation with mandatory French business requirements.

## Overview

French e-invoicing requires specific mandatory elements regulated by the French tax authorities (DGFiP). These examples demonstrate key French requirements including:

- Business process types (B1, B2, B4, B7, S1, S2, S4, S5, S6, S7, M1, M2, M4)
- French text codes (REG, ABL, AAI, PMD, PMT, BAR)
- SIRET identification (14-digit business identifier)
- RCS registration and APE codes
- Late payment penalties and fixed indemnity (€40)
- Treatment type qualification (B2B/B2C)
- Complex use cases (factoring, third-party payment, self-billing, etc.)

## Example Files

### Generic Examples

#### 1. PUF_France_Generic_Invoice.xml

**Simple B2B Invoice**

Demonstrates:

- Invoice type B1 (Goods invoice)
- All mandatory French text codes (#REG#, #ABL#, #AAI#, #PMD#, #PMT#, #BAR#)
- SIRET identifier (schemeID 0009)
- French company legal form and capital
- RCS trade register number
- APE business activity code
- Standard VAT rate (20%)

**Key Features:**

- Document type: 380 with name="B1"
- Complete French party information (SIRET, VAT, RCS, APE)
- French payment terms with mandatory late payment penalties
- French IBAN and BIC

---

#### 2. PUF_France_Generic_CreditNote.xml

**Simple B2B Credit Note**

Demonstrates:

- Credit note type B1 (Goods credit note)
- Billing reference to original invoice (mandatory for credit notes)
- French text codes for credit note context
- Product return scenario
- Purchase order reference via AdditionalDocumentReference

**Key Features:**

- Document type: 381 with name="B1"
- BillingReference with preceding invoice details
- Credit reason explanation in Note
- Credited quantity and amounts

---

### Use Case Examples

#### UC1: PUF_France_UC1_MultiOrder_MultiDelivery_Invoice.xml

**Multi-Order / Multi-Delivery Invoice**

Demonstrates:

- Consolidated invoice covering multiple purchase orders
- Multiple delivery locations across different invoice lines
- Line-level order references (EXT-FR-FE-135)
- Line-level despatch advice references (EXT-FR-FE-140/141)
- Line-level delivery information (EXT-FR-FE-BG-10)
- Line-level delivery addresses (EXT-FR-FE-150)

**Key Extensions:**

- Header-level: Multiple OrderReference elements
- Line-level: OrderLineReference, DeliveryLocation, DeliveryAddress per line

---

#### UC2: PUF_France_UC2_AlreadyPaid_Invoice.xml

**Already Paid Invoice**

Demonstrates:

- Invoice with prepaid amount before invoicing
- Payment instructions showing zero amount due
- Historical payment reference
- Payment means code 1 (Instrument not defined)

**Key Features:**

- PayableAmount = 0
- PrepaidAmount in AllowanceCharge or PaymentMeans extension
- Payment date and reference for completed payment

---

#### UC3: PUF_France_UC3_ThirdPartyPayer_Invoice.xml

**Third-Party Payer Invoice**

Demonstrates:

- Buyer different from payer
- PayeeParty extension for third-party payer information
- Payment instructions directed to third party

**Key Features:**

- AccountingCustomerParty (buyer)
- PayeeParty extension (actual payer)
- Clear distinction between buyer and payment responsible party

---

#### UC4: PUF_France_UC4_PartialThirdPartyPayment_Invoice.xml

**Partial Third-Party Payment**

Demonstrates:

- Split payment between buyer and third party
- Multiple PaymentMeans entries
- Proportional amounts for each payer

**Key Features:**

- Two PaymentMeans with different PayeeParty
- PayableAmount split across payers
- Clear payment allocation

---

#### UC5: PUF_France_UC5_EmployeeExpense_Invoice.xml

**Employee Expense Reimbursement**

Demonstrates:

- Invoice for employee expense reimbursement
- Employer as buyer, service provider as seller
- Employee identification in extensions

**Key Features:**

- Business process related to employee expenses
- Employee information in party extensions
- Expense category classification

---

#### UC7: PUF_France_UC7_CorporateCard_Invoice.xml

**Corporate Card Payment**

Demonstrates:

- Invoice paid via corporate card
- Payment means code 48 (Card payment)
- Card issuer information

**Key Features:**

- Payment means with card details
- Cardholder reference
- Card payment timestamp

---

#### UC8: PUF_France_UC8_Factoring_Invoice.xml

**Factoring Invoice**

Demonstrates:

- Invoice with factoring arrangement
- PayeeParty different from seller (factor)
- Payment to factor instead of seller

**Key Features:**

- PayeeParty = Factoring company
- Payment instructions to factor's bank account
- Note explaining factoring arrangement

---

#### UC9: PUF_France_UC9_Distributor_Invoice.xml

**Distributor Invoice**

Demonstrates:

- Invoice from distributor (not manufacturer)
- Additional party roles in supply chain
- Origin country and manufacturer details

**Key Features:**

- Seller = Distributor
- Item manufacturer information
- Origin country codes

---

#### UC10: PUF_France_UC10_PostFactoring_Invoice.xml

**Post-Factoring Invoice**

Demonstrates:

- Invoice issued after factoring contract established
- Direct payment instructions to factor
- Factoring reference codes

**Key Features:**

- Immediate factor payment routing
- Factoring agreement reference
- Factor as payee from invoice issuance

---

#### UC11: PUF_France_UC11_ThirdPartyProcessing_Invoice.xml

**Third-Party Processing Invoice**

Demonstrates:

- Invoice processed by third party on behalf of seller
- TaxRepresentativeParty for processing intermediary
- Supplier relationship management

**Key Features:**

- TaxRepresentativeParty extension
- Processing party information
- Authorization references

---

#### UC12: PUF_France_UC12_IntermediationService_Invoice.xml

**Intermediation Service Invoice**

Demonstrates:

- Service invoice with intermediary
- Commission-based billing
- Intermediary party details

**Key Features:**

- Service type code
- Intermediary identification
- Commission calculation basis

---

#### UC12 (alt): PUF_France_UC12_MainInvoice_TransparentIntermediary.xml

**Main Invoice with Transparent Intermediary**

Demonstrates:

- Primary invoice with transparent intermediary role
- Clear seller-buyer relationship despite intermediary
- Intermediary as facilitator not principal

**Key Features:**

- Direct seller-buyer VAT treatment
- Intermediary in extensions only
- No commission on main invoice

---

#### UC13: PUF_France_UC13_SellerAgent_CoContractor_Invoice.xml

**Seller Agent - Co-Contractor Invoice**

Demonstrates:

- Co-contractor invoice with seller agent (platform acting on behalf of seller)
- Seller agent party (EXT-FR-FE-BG-03) with role code "SR"
- Construction subcontractor as seller
- Platform managing invoice lifecycle on behalf of seller

**Key Features:**

- Business process S6 (Co-contractor services invoice)
- Seller agent in `cac:AccountingSupplierParty/cac:Party/cac:AgentParty`
- Role code "SR" (Seller's agent) per UNTDID 3035
- Complete agent party details (SIREN/SIRET, VAT, address)
- Co-contractor agreement reference
- Construction services scenario (structural reinforcement, waterproofing)

---

#### UC14: PUF_France_UC14_BuyerAgent_SellerAgent_CoContractor_Invoice.xml

**Buyer Agent + Seller Agent - Dual Agent Co-Contractor Invoice**

Demonstrates:

- Co-contractor invoice with both buyer agent AND seller agent
- Seller agent party (EXT-FR-FE-BG-03) with role code "SR"
- Buyer agent party (EXT-FR-FE-BG-01) with role code "AB"
- Dual agent management of invoice lifecycle

**Key Features:**

- Business process S6 (Co-contractor services invoice)
- Seller agent in `cac:AccountingSupplierParty/cac:Party/cac:AgentParty` (role "SR")
- Buyer agent in `cac:AccountingCustomerParty/cac:Party/cac:AgentParty` (role "AB")
- BT-49 electronic address with SIREN_ACHATIT format for buyer agent routing
- Complete agent party details for both agents
- IT co-contractor services scenario (software architecture, cybersecurity audit)

---

#### UC15: PUF_France_UC15_BuyerAgent_MediaBuying_Invoice.xml

**Buyer Agent - Media Buying**

Demonstrates:

- Invoice where buyer uses agent for media purchases
- Agent acts on behalf of buyer
- Media buying industry specifics

**Key Features:**

- Buyer agent identification
- Media buying category codes
- Agent commission handling

---

#### UC16: PUF_France_UC16_Disbursement_Invoice.xml

**Disbursement Invoice (Frais Débours)**

Demonstrates:

- Invoice combining seller's own fees (VAT category S) and disbursements paid on behalf of buyer (VAT category O)
- French EXTENDED-CTC-FR profile permits O + S mixing (not allowed under EN 16931 alone)
- BT-23 = S1 (services invoice with disbursements)
- Architect or lawyer scenario: own professional fees + refundable expense advances

**Key Features:**

- Two TaxSubtotals: S @ 20% (professional fees) + O @ 0% (disbursements)
- `#DEB#` text note identifying disbursement items per CGI obligations
- EXTENDED-CTC-FR note confirming extended mixing is authorized by French profile
- Disbursements are expenses advanced by seller strictly on buyer's behalf

---

#### UC17a: Payment Intermediary / Marketplace (F1 + F2)

**PUF_France_UC17a_PaymentIntermediary_F1_Sale_Invoice.xml** — Sale Invoice (SELLER → BUYER)
**PUF_France_UC17a_PaymentIntermediary_F2_ServiceFee_Invoice.xml** — Service Fee Invoice (INTERMEDIARY → SELLER)

Demonstrates:

- Sale through payment intermediary (marketplace) with two-invoice model
- F1: Already-paid goods invoice from SELLER to BUYER (UC2 pattern)
- F2: Service fee/commission invoice from marketplace to SELLER (settled via netting)
- SELLER creates and transmits F1 via their own PA-E

**Key Features (F1 - Sale Invoice):**

- Business process B2 (already-paid goods invoice)
- BT-113 (PrepaidAmount) = BT-112, BT-115 (PayableAmount) = 0
- BT-81 = 57 (Standing Agreement) — SELLER doesn't know BUYER's payment method at marketplace
- Wine sale scenario (Saint-Émilion Grand Cru, Pomerol, Bordeaux Blanc)

**Key Features (F2 - Service Fee Invoice):**

- Business process S2 (already-paid service invoice)
- BT-113 = BT-112, BT-115 = 0
- BT-81 = 97 (Clearing between partners) — settled via netting
- 8% marketplace commission on F1 sale amount
- Reference to companion F1 invoice

---

#### UC17b: PUF_France_UC17b_BillingMandate_F1_Sale_Invoice.xml

**Payment Intermediary with Billing Mandate (F1 only — F2 same as UC17a)**

Demonstrates:

- Intermediary creates F1 on behalf of SELLER under billing mandate (UC19a rules)
- Billing mandatary identified via EXT-FR-FE-BG-05 (ServiceProviderParty, role "II")
- BT-34 routes to facturant's PA-T (not SELLER's PA-E)
- Mandate declaration via #DCL# text code

**Key Features (differences from UC17a F1):**

- EXT-FR-FE-BG-05 in `cac:AccountingSupplierParty/cac:Party/cac:ServiceProviderParty`
- Role code "II" (Invoicer) per UNTDID 3035
- BT-81 = 48 (Bank card) — actual payment method known by intermediary
- BT-34: Routes to facturant's PA-T for lifecycle status management
- #DCL# mandate declaration note per BOI-TVA-DECLA-30-20-10-30 (§210)
- Same invoice lines and amounts as UC17a F1

---

#### UC19a: PUF_France_UC19a_BillingAgent_Invoice.xml

**Billing Agent Invoice**

Demonstrates:

- Agent invoices on behalf of principal
- AccountingSupplierParty = Agent
- Principal seller in extensions

**Key Features:**

- Agent as invoicing party
- Principal seller reference
- Agency relationship codes

---

#### UC19b: PUF_France_UC19b_SelfBilling_Invoice.xml

**Self-Billing Invoice**

Demonstrates:

- Buyer creates invoice on behalf of seller
- Self-billing agreement reference
- Reverse invoicing flow

**Key Features:**

- AccountingSupplierParty = Original seller
- Invoice created by buyer indicator
- Self-billing agreement details

---

#### UC20: PUF_France_UC20_PrepaymentInvoice.xml

**Prepayment Invoice**

Demonstrates:

- Invoice type 386 (Prepayment invoice)
- Advance payment before goods/services delivery
- Payment due before delivery

**Key Features:**

- Document type: 386
- Prepayment terms and conditions
- Advance percentage or amount

---

#### UC21: PUF_France_UC21_FinalInvoiceAfterPrepayment.xml

**Final Invoice After Prepayment**

Demonstrates:

- Final invoice deducting prepaid amounts
- Reference to prepayment invoice(s)
- Net amount due calculation

**Key Features:**

- PrepaidAmount or AllowanceCharge for advance
- BillingReference to prepayment invoice
- Remaining balance due

---

#### UC22a: PUF_France_UC22a_EarlyPaymentDiscount_Services_Invoice.xml

**Early Payment Discount - Services Invoice (VAT on Cash Receipt)**

Demonstrates:

- Services invoice with mandatory early payment discount mention (escompte)
- Full amount invoiced — discount is NOT deducted on the invoice
- BT-21/BT-22 with AAB code (Conditions of sale) describing discount terms
- VAT due on cash receipt — discount reflected via "Encaissée" lifecycle status (no credit note needed)

**Key Features:**

- Business process S1 (Services invoice)
- `#AAB#` text code with discount conditions (mandatory even when no discount exists)
- Invoice totals at full amount (BT-115 = BT-112)
- IT consulting scenario: 10,000 EUR HT + 20% VAT = 12,000 EUR TTC
- If BUYER takes 2% discount: pays 11,760 EUR, "Encaissée" status declares 11,760 EUR

---

#### UC22b: PUF_France_UC22b_EarlyPaymentDiscount_CreditNote.xml

**Early Payment Discount - Tax-Free Credit Note (VATEX-FR-CNWVAT)**

Demonstrates:

- Tax-free credit note for early payment discount on goods invoice
- VATEX-FR-CNWVAT exemption code (Approach 2: avoir net de taxe)
- Preceding invoice reference (BG-3) to original goods invoice
- Faculty (not obligation) — SELLER may issue this to inform tax administration

**Key Features:**

- Document type 381 (Credit note) with business process B1
- BT-118 = E (Exempt), BT-121 = `VATEX-FR-CNWVAT`
- BT-117 = 0 (no VAT on credit note)
- Business rule G6.21: VATEX-FR-CNWVAT requires BT-3 in {261, 381, 396}
- Goods scenario: 3% discount on 6,000 EUR TTC = 180 EUR credit note
- VATEX-FR-CNWVAT applies to all types of tax-free credit notes, not just discounts

---

---

#### UC23: PUF_France_UC23_SelfBilling_FranchiseEnBase.xml

**Self-Billing for Franchise en Base (Individual Photovoltaic Producer)**

Demonstrates:

- Self-billing by energy aggregator for an individual solar producer exempt from VAT
  (franchise en base — annual income above 3kWc threshold but VAT-exempt by law)
- `<puf:SelfBilled>true</puf:SelfBilled>` document-level extension
- BT-23 = B1 (goods invoice — electricity sale), BT-118 = Z (zero-rated for buyer)
- `#DCL#` mandate declaration note referencing the self-billing agreement

**Key Features:**

- SelfBilled extension as first child before CustomizationID (document level)
- NO BT-31 (seller has no VAT number — franchise en base individual)
- SchemeID 0002 (SIREN) for individual without SIRET
- BT-119 = 0 (zero VAT rate — seller VAT-exempt, buyer cannot recover)

---

#### UC25: PUF_France_UC25_BUU_Sale_Invoice.xml

**Single-Purpose Voucher (BUU) Sale Invoice**

Demonstrates:

- B2B sale of single-purpose vouchers (bons à usage unique) by the issuer
- VAT charged at issuance because place of supply and VAT are determinable (BUU definition)
- Standard invoice format — no special voucher-specific data elements required
- Entertainment venue selling concert access vouchers to a corporate buyer

**Key Features:**

- Business process S1 (Services invoice)
- BUU = place of supply + VAT known at issuance → VAT at each transfer
- Sale to taxable person = e-invoicing; sale to individual = e-reporting
- If Issuer = Supplier: redemption is NOT a separate taxable event
- 50 vouchers at 50 EUR each = 2,500 EUR HT + 20% VAT

> **Note**: This use case is still under discussion per the specification and subject to significant additions.

---

#### UC25 (alt): PUF_France_UC25_Redemption_SupplierToIssuer_Invoice.xml

**Voucher Redemption — Supplier to Issuer Invoice (Three-Party Flow)**

Demonstrates:

- Three-party voucher redemption where Issuer ≠ Supplier
- **Party role inversion**: the voucher ISSUER becomes the BUYER (AccountingCustomerParty)
- Supplier is deemed to have supplied goods/services to the Issuer, not the end user
- Restaurant invoicing a gift card network after end user redeems voucher

**Key Features:**

- Business process S1 (Services invoice)
- Supplier (restaurant) = AccountingSupplierParty
- Issuer (gift card network) = AccountingCustomerParty (party role inversion)
- 10% reduced VAT rate for on-premise restaurant services
- Voucher face value 150 EUR TTC; HT = 136.36 EUR
- Commissions/management fees must be invoiced separately (not on this invoice)

> **Note**: This use case is still under discussion per the specification and subject to significant additions.

---

#### UC26: PUF_France_UC26_ReservationClause_Invoice.xml

**Invoice with Contractual Reservation Clause (Retenue de Garantie)**

Demonstrates:

- Full invoice with contractual retention guarantee (retenue de garantie) of 5%
- Retention expressed ONLY via free-text note: BT-21 = `ABU` (Contract clause) + BT-22
- Invoice issued for 100% of the amount — retention is a payment timing arrangement, not a deduction
- EN 16931 and EXTENDED-CTC-FR do NOT support structured payment schedules for reservations

**Key Features:**

- Business process S1 (Services invoice — construction/renovation)
- `#ABU#` text code with detailed retention terms (mandatory for this use case)
- BT-115 (PayableAmount) = full 100% amount (48,000 EUR TTC)
- Payment split described only in BT-20 and `#ABU#` notes: 95% immediate + 5% withheld
- Construction scenario: structural renovation + waterproofing (40,000 EUR HT + 20% VAT)
- For VAT on cash basis: SELLER transmits partial "Encaissée" statuses (95% then 5%)

---

#### UC26 (alt): PUF_France_UC26_ReservationClause_CreditNote.xml

**Reservation Clause Enforced — Credit Note for Withheld Retention**

Demonstrates:

- Mandatory credit note when the reservation clause is definitively enforced
- References original invoice (FR-INV-2026-026) via BG-3
- Pro-rata credit across original invoice lines (proportional to original amounts)
- For VAT on cash basis: no "Encaissée" status needed for balance or credit note

**Key Features:**

- Document type 381 (Credit note) with business process S1
- 5% retention of original 48,000 TTC = 2,400 TTC credit note (2,000 HT + 400 VAT)
- Two credit note lines matching original invoice line proportions
- Issued ~1 year after original invoice (after guarantee period expiry)

---

---

#### UC29: PUF_France_UC29_SingleVATEntity_Invoice.xml

**Single VAT Entity Member Invoice (Assujetti Unique)**

Demonstrates:

- A member of a French Single VAT Entity (groupe TVA) invoicing an external third party
- BT-29 with schemeID 0231 in seller party: the Entity's SIREN (grouped VAT identifier)
- `<cac:TaxRepresentativeParty>` representing the Entity (name, VAT, address)
- Mandatory note `#TXD#MEMBRE_ASSUJETTI_UNIQUE` identifying the VAT-group member

**Key Features:**

- TWO PartyIdentification entries for seller: schemeID 0009 (member SIRET) + schemeID 0231 (entity SIREN)
- TaxRepresentativeParty carries BT-62 (entity name), BT-63 (`FR` + entity VAT), BG-12 (entity address)
- BT-62/BT-63 represent the Entity, NOT the member company's own VAT details
- Intra-entity B2B supplies between members are outside scope of French e-invoicing

---

#### UC30: PUF_France_UC30_VATAlreadyCollected.xml

**VAT Already Collected**

Demonstrates:

- Scenario where VAT was collected earlier
- Reference to original VAT collection
- Adjustment invoice

**Key Features:**

- VAT collection reference
- Previous payment details
- Corrective VAT treatment

---

---

#### UC31: PUF_France_UC31_MixedInvoice.xml

**Mixed Invoice — Independent Goods and Services (M1)**

Demonstrates:

- Invoice covering both goods and services that are independently provided (not accessory)
- BT-23 = M1 (mixed independent operations — affects e-reporting routing, not VAT)
- Both goods and services taxed at standard 20% S category
- M-prefix signals to tax authority that both types are present and independently priced

**Key Features:**

- `<cbc:InvoiceTypeCode name="M1">380</cbc:InvoiceTypeCode>`
- Four invoice lines: goods lines (B1 category) + service lines (S1 category)
- All VAT at S 20% — the M1 prefix is a routing/reporting distinction only
- Use M-series when neither goods nor services component is an accessory to the other

---

#### UC32a: PUF_France_UC32a_MonthlyPayments_AdditionalDue.xml

**Monthly Payments - Additional Amount Due**

Demonstrates:

- Periodic billing scenario
- Additional amount due beyond monthly installments
- Reconciliation invoice

**Key Features:**

- Monthly payment schedule reference
- Additional charges calculation
- Cumulative totals

---

#### UC32b: PUF_France_UC32b_MonthlyPayments_CreditDue.xml

**Monthly Payments - Credit Due**

Demonstrates:

- Periodic billing scenario
- Credit due to buyer (overpayment)
- Reconciliation credit note or negative invoice

**Key Features:**

- Monthly payment schedule reference
- Credit amount calculation
- Overpayment handling

---

---

#### UC33: PUF_France_UC33_MarginScheme_Invoice.xml

**VAT Margin Scheme Invoice (Régime de la Marge — Biens d'Occasion)**

Demonstrates:

- Invoice for second-hand goods sold under VAT margin scheme (Article 297 A CGI)
- Buyer CANNOT deduct VAT — all amounts are VAT-inclusive, no separate VAT shown
- BT-118 = E (Exempt), BT-117 = 0, BT-119 = 0, BT-121 = `VATEX-FR-F`
- BT-131 (net line amount) and BT-146 (unit price) hold VAT-inclusive values

**Key Features:**

- VATEX-FR code for specific margin regime: VATEX-FR-F (2nd-hand goods), VATEX-FR-I (art), VATEX-FR-J (antiques), VATEX-EU-D (travel agency)
- BT-109 = BT-112 = TTC amount (no separate HT and VAT breakdown)
- BT-110 (TaxAmount) = 0 — VAT is embedded in the price, not disclosed
- BT-120 carries the human-readable exemption reason text

---

#### UC36: PUF_France_UC36_ProfessionalSecrecy_Invoice.xml

**Professional Secrecy Invoice (Secret Professionnel — Avocats)**

Demonstrates:

- Legal services invoice where client confidentiality requires split between public/private content
- BT-153 (ItemName): GENERIC description — sent to tax authority in Flux 1 (e-invoicing)
- BT-154 (ItemDescription): CONFIDENTIAL detail — present in Flux 2 data sent only to buyer
- Lawyer/legal services scenario; same structure applies to other regulated professions

**Key Features:**

- BT-153 = generic name (e.g., "Conseil juridique — Propriété industrielle") sent to PPF
- BT-154 = full case/matter detail kept confidential from tax authority
- Standard S1 invoice with 20% VAT — no special extensions; confidentiality is structural
- Both BT-153 and BT-154 present on same line (PA selectively filters for Flux 1 transmission)

---

#### UC37: PUF_France_UC37_Partnership_SEP_Invoice.xml

**Partnership Invoice — Société en Participation (SEP) Manager**

Demonstrates:

- Supplier invoice to the Manager of an undisclosed partnership (SEP) using a dedicated SEP reception address
- BT-49 with schemeID 0225 and format `[SIREN]_gestiontiers` — SEP-specific routing endpoint
- Separates SEP purchases from the Manager's own procurement inbox at the PA-R
- BT-10 (buyer reference) carries the SEP project code for cost allocation

**Key Features:**

- `<cbc:EndpointID schemeID="0225">456789012_gestiontiers</cbc:EndpointID>` — dedicated SEP inbox
- Manager's SIREN + `_gestiontiers` suffix routes to the SEP-specific receiving inbox
- BT-11 (purchase order reference) from Manager for the SEP project work order
- VAT pre-filling will be systematically misaligned for SEP (Manager declares only their share)

---

#### UC40: PUF_France_UC40_Netting_Invoice1_CoopToFarmer.xml &amp; Invoice2_FarmerToCoop.xml

**Netting Invoices (Cooperative and Farmer)**

Demonstrates:

- Bilateral netting arrangement
- Invoice 1: Cooperative to Farmer (services/supplies)
- Invoice 2: Farmer to Cooperative (produce delivery)
- Cross-referenced for netting

**Key Features:**

- Netting agreement reference
- Cross-invoice references
- Net settlement calculation

---

---

#### UC41: PUF_France_UC41_Barter_Invoice.xml

**Barter Invoice (Échange — Compensation en Nature)**

Demonstrates:

- Invoice where HT consideration is settled in kind (barter exchange), only VAT paid in cash
- BT-113 (PrepaidAmount) RE-PURPOSED: holds the HT value of the in-kind compensation
- BT-115 (PayableAmount) = VAT only (the sole cash payment)
- `#PAI#` note explaining the barter arrangement and convention reference

**Key Features:**

- BT-113 = EUR 10,000 HT (barter exchange amount — NOT a cash prepayment)
- BT-115 = EUR 2,000 (VAT portion paid in cash)
- BT-112 = EUR 12,000 TTC (full invoice value including in-kind exchange)
- A companion Encaissée (puf-invoice-response UC41_Barter_Encaissee.xml) with dual MEN entries is required for correct tax pre-filling

---

#### UC42: PUF_France_UC42_TaxFree_Scenario3_Invoice.xml

**Tourist Tax Refund — Détaxe Scenario 3 (Merchant → Detax Operator)**

Demonstrates:

- B2B invoice from merchant to detax operator after tourist's BVE is validated by customs
- BT-23 = B7 (goods with VAT already collected via B2C e-reporting)
- BT-113 = BT-112 (tourist paid full TTC at point of sale — entire amount is "prepaid")
- BT-115 = 0 (nothing further owed by operator to merchant at this stage)

**Key Features:**

- BT-18 (Invoiced object identifier): optional BVE reference with schemeID="APT", DocumentTypeCode=130
- BT-113 = BT-112 (all TTC treated as prepaid — tourist settlement at POS)
- BT-115 = 0 (the detax operator settles with merchant via a separate fee/commission invoice)
- BT-119 = 20% S category: VAT was collected at standard rate, now being transferred to operator for refund to tourist

---

### E-Reporting Examples (Flux 10.1 — Invoice Reporting)

Invoice e-reporting examples (UC43, UC44) are located in the **tax-data-report** directory:
- **Invoice reporting**: [`examples/tax-data-report/country-specific-examples/france/`](../tax-data-report/country-specific-examples/france/)
- **Payment reporting**: [`puf-tax-report/examples/country-specific-examples/france/`](../../../../puf-tax-report/examples/country-specific-examples/france/)

---

## French Text Codes Reference

| Code | Description | Usage | Required Note Text |
|------|-------------|-------|--------------------|
| **#REG#** | Registration data | Regulatory information, e.g. share capital | *(free text)* |
| **#ABL#** | Legal information | Trade register number (RCS) or other legal registration information | *(free text)* |
| **#AAI#** | General information | General elements typically found at the bottom of paper invoice pages | *(free text)* |
| **#PMD#** | Late payment penalties | Payment terms regarding late payment penalties | *(free text)* |
| **#PMT#** | Collection costs (€40) | Fixed €40 indemnity for collection costs in case of late payment | *(free text)* |
| **#BAR#** | Treatment type qualification | Expected treatment type for the invoice. Only ONE BAR note per invoice. | `B2B`, `B2BINT`, `B2C`, `OUTOFSCOPE`, or `ARCHIVEONLY` |
| **#AAB#** | Early payment discount | Statement whether customer can apply a discount for early payment. Does NOT correspond to the discount amount itself. | *(free text)* |
| **#ABU#** | Contract clause | Contractual reservation clause / Retenue de garantie | *(free text)* |
| **#ACC#** | Subrogation factoring clause | Factoring arrangement details and subrogation clauses | *(free text)* |
| **#ADN#** | B2G indicator | Indicates if invoice is subject to B2G treatment (additional Chorus Pro rules apply) | *(free text)* |
| **#BLU#** | Eco-participation / Eco-contribution | Eco-participation or Eco-contribution WEEE; also used for other eco-taxes | `Eco-participation (L. 541-10 du code de l'environnement)` or `Eco-contribution DEEE` |
| **#CUS#** | Customs information | Customs-related details and information | *(free text)* |
| **#PAI#** | Third party payment | Third party payment information (e.g. partial third-party payer or barter arrangement) | *(free text)* |
| **#SUR#** | Supplier notes | Additional remarks from the supplier | *(free text)* |
| **#TXD#** | Single taxable person member | Identifies a member of a single taxable person (assujetti unique) — for external transactions only | `Membre d'un assujetti unique` |

## Business Process Types

French e-invoicing uses business process types in the `InvoiceTypeCode/@name` attribute:

### B-Series (Goods)

- **B1**: Goods invoice
- **B2**: Goods invoice (already paid)
- **B4**: Final invoice for goods (after down payment)
- **B7**: Goods invoice (e-reporting VAT collected)

### S-Series (Services)

- **S1**: Services invoice
- **S2**: Services invoice (already paid)
- **S4**: Final invoice for services (after down payment)
- **S5**: Subcontractor services invoice
- **S6**: Co-contractor services invoice
- **S7**: Services invoice (e-reporting VAT collected)

### M-Series (Mixed)

- **M1**: Mixed invoice (goods + services)
- **M2**: Mixed invoice (already paid)
- **M4**: Final invoice for mixed goods and services (after down payment)

## Identification Schemes

| Scheme ID | Description | Example |
|-----------|-------------|---------|
| **0009** | SIRET (14-digit business identifier) | `12345678900034` |
| **0002** | SIREN (9-digit registration number) | `123456789` |
| **0225** | E-invoicing electronic address (SIREN format for endpoint ID) | `123456789` |
| **0224** | CODE ROUTAGE (Platform routing identifier) | `ROUTE123` |
