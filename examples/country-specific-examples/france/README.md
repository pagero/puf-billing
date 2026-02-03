# France E-Invoicing Examples

This directory contains example PUF invoice files demonstrating France's e-invoicing system implementation with mandatory French business requirements.

## Overview

French e-invoicing requires specific mandatory elements regulated by the French tax authorities (DGFiP). These examples demonstrate key French requirements including:

- Business process types (B1-B7, S1-S7, M1-M7)
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

#### UC40: PUF_France_UC40_Netting_Invoice1_CoopToFarmer.xml & Invoice2_FarmerToCoop.xml

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

## French Text Codes Reference

| Code | Description | Example |
|------|-------------|---------|
| **#REG#** | Company legal form and share capital | `SARL au capital de 100000.00 EUR` |
| **#ABL#** | Trade register number (RCS) | `RCS Lyon B 987 654 321` |
| **#AAI#** | APE business activity code | `APE 4651Z - Commerce de gros d'ordinateurs` |
| **#PMD#** | Late payment penalties | `En cas de retard de paiement, application des pénalités...` |
| **#PMT#** | Fixed collection costs indemnity | `Indemnité forfaitaire pour frais de recouvrement : 40 EUR` |
| **#BAR#** | Treatment type qualification | `B2B` or `B2C` |

## Business Process Types

French e-invoicing uses business process types in the `InvoiceTypeCode/@name` attribute:

### B-Series (Goods)

- **B1**: Goods invoice
- **B2**: Export goods invoice
- **B4**: Intra-community goods invoice

### S-Series (Services)

- **S1**: Service invoice
- **S2**: Export service invoice
- **S4**: Intra-community service invoice
- **S5**: Service invoice with reverse charge
- **S6**: Service invoice with VAT exemption
- **S7**: Service invoice for specific sectors

### M-Series (Mixed)

- **M1**: Mixed goods and services invoice
- **M2**: Export mixed invoice
- **M4**: Intra-community mixed invoice

## Identification Schemes

| Scheme ID | Description | Example |
|-----------|-------------|---------|
| **0009** | SIRET (14-digit business identifier) | `12345678900034` |
| **0002** | SIREN (9-digit registration number) | `123456789` |
| **0225** | E-invoicing electronic address (SIREN format for endpoint ID) | `123456789` |
| **0224** | CODE ROUTAGE (Platform routing identifier) | `ROUTE123` |
