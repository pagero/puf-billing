# Spain VeriFactu Examples

This directory contains example PUF invoice files demonstrating Spain's VeriFactu e-invoicing system implementation.

## Overview

VeriFactu is a voluntary e-invoicing framework regulated by the Spanish Tax Agency (AEAT). These examples demonstrate key VeriFactu requirements including:

- Invoice series (mandatory)
- Invoice type codes with Spanish identifiers (F1-F3, R1-R5)
- Special regime keys (ClaveRegimen) - mandatory for all tax breakdowns
- Tax exemption codes
- Correction methods (differences and substitutive)

## Example Files

### 1. PUF_Spain_VeriFactu_Standard_Invoice.xml

**Standard Invoice (F1)**

Demonstrates:

- Invoice type F1 (Standard invoice per RD 1619/2012)
- Mandatory invoice series extension (`InvoiceSeries`)
- Spanish NIF for seller and buyer parties
- IVA (VAT) at 21% standard rate
- Special regime key `01` (General regime)

**Key Features:**

- Document type: 380 with name="F1"
- Single tax breakdown with mandatory special regime key
- Complete party information with Spanish tax identifiers

---

### 2. PUF_Spain_VeriFactu_Simplified_Invoice.xml

**Simplified Invoice (F2)**

Demonstrates:

- Invoice type F2 (Factura Simplificada)
- Simplified invoice qualifier (`puf:Simplified` extension)
- Alternative buyer identification (passport) when VAT number not available
- Simplified invoice characteristics per Article 6.1.d) RD 1619/2012

**Key Features:**

- Document type: 380 with name="F2"
- `puf:Simplified` boolean extension (`true` indicates simplified case)
- Buyer identification using scheme ES:PASSPORT

---

### 3. PUF_Spain_VeriFactu_CreditNote_Substitutive.xml

**Credit Note - Substitutive Method (R1)**

Demonstrates:

- Credit note with rectificative type R1
- Substitutive correction method "S" (método sustitutivo)
- Referenced invoice amounts (mandatory for substitutive method):
  - TaxableAmount
  - TaxAmount
- Complete credit note

**Key Features:**

- Document type: 381 with name="R1"
- BillingReferenceExtension with Code="S"
- All referenced amounts included in extension

---

### 4. PUF_Spain_VeriFactu_MultipleTaxRates.xml

#### Invoice with Multiple Tax Rates and Exemptions

Demonstrates:

- Multiple tax rates (21% standard, 10% reduced)
- Export operations with special regime key `02`
- Tax exemption code E2 (Exempt per Article 21)
- Different special regime keys for different scenarios

**Key Features:**

- Three tax subtotals with different treatments:
  1. Standard rate 21% - General regime (01)
  2. Reduced rate 10% - General regime (01)
  3. Exempt (E) - Export operations (02) with exemption code E2
- TaxExemptionReasonCode and TaxExemptionReason for exempt cases

---

### 5. PUF_Spain_VeriFactu_OutOfScope.xml

#### Invoice with Not Subject to VAT Transactions

Demonstrates:

- Not subject to VAT transactions (category O)
- Tax exemption code N2 (Location rules - Article 7 LIVA)
- Services provided outside Spain
- Special regime key for out of scope operations
- Separate invoice from taxable transactions (best practice)

**Key Features:**

- Tax category: O (Out of scope)
- TaxExemptionReasonCode: N2 (Article 7 location rules)
- Zero tax amount with valid tax base
- Foreign buyer identification
- Service delivery outside Spanish territory

---

## Common VeriFactu Requirements

### Mandatory Elements

1. **Invoice Series** (`InvoiceSeries` extension)
   - Required for all VeriFactu invoices
   - URI: `urn:pagero:ExtensionComponent:1.0:PageroExtension:InvoiceSeries`

2. **Invoice Type Code with @name attribute**
   - Standard invoices: F1, F2, F3
   - Rectifications: R1, R2, R3, R4, R5
   - Example: `<cbc:InvoiceTypeCode name="F1">380</cbc:InvoiceTypeCode>`

3. **Special Regime Key** (ClaveRegimen)
   - Mandatory for ALL tax breakdowns
   - URI: `urn:pagero:ExtensionComponent:1.0:PageroExtension:TaxSubtotalExtension`
   - Common codes:
     - `01` - General regime (Régimen general)
     - `02` - Export operations (Exportación)
     - `06` - VAT group advanced level
     - `18` - Equivalence surcharge

4. **Spanish Tax Identification**
   - Seller NIF: Mandatory
   - Buyer NIF: Conditionally mandatory
   - Format: ES + 9 characters (e.g., ESB12345678)

### Optional Elements

1. **Simplified Invoice Indicator**
   - RestrictedInformation extension
   - Key: "SimplifiedInvoice"
   - Value: "S" (yes) or "N" (no)

2. **Equivalence Surcharge**
   - For retail traders subject to Recargo de Equivalencia
   - Requires special regime key `18`
   - Includes both percentage and amount

3. **Tax Base at Cost**
   - For special group regimes
   - Used with special regime key `06`

## Tax Types Supported

- **VAT** (IVA): Standard Spanish VAT - Use TaxScheme/ID = "VAT"
- **IGIC**: Canary Islands special tax - Use TaxScheme/ID = "IGIC"
- **IPSI**: Ceuta and Melilla special tax - Use TaxScheme/ID = "IPSI"

## Special Regime Keys (ClaveRegimen)

See [PUF-022-SPECIALREGIMEKEY](https://pagero.github.io/puf-code-lists/#_puf_022_specialregimekey) for the complete list.

Common codes:

- `01` - General regime (IVA)
- `02` - Export operations
- `03` - Operations subject to IPSI (Ceuta/Melilla)
- `04` - Operations subject to IGIC (Canary Islands)
- `05` - Travel agencies
- `06` - VAT group advanced level
- `07` - Cash basis scheme
- `18` - Equivalence surcharge

## Tax Exemption Codes

See [PUF-013-TAXEXEMPTIONCODE](https://pagero.github.io/puf-code-lists/#_tax_exemption_codes_in_spain_verifactu) for Spain-specific codes.

**Exempt (E):**

- `E2` - Exempt pursuant to Article 21
- `E5` - Exempt pursuant to Article 22

**Not Subject (O):**

- `N1` - Not subject per Article 7 (Location of operation)
- `N2` - Not subject due to location rules

## Correction Methods

### Method I - Correction by Differences (corrección por diferencias)

- Shows only the difference amounts
- Use `puf:Code = "I"` in BillingReferenceExtension

### Method S - Substitutive (método sustitutivo)

- Complete cancellation and re-issue
- Use `puf:Code = "S"` in BillingReferenceExtension
- **Mandatory fields in BillingReferenceExtension:**
  - `cbc:TaxableAmount` - Original invoice tax base
  - `cbc:TaxAmount` - Original invoice tax amount
  - `puf:EquivalenceSurchargeAmount` - If applicable

## Extensions Used

### Document Level

1. **InvoiceSeries**
   - Location: Invoice/ext:UBLExtensions
   - URI: `urn:pagero:ExtensionComponent:1.0:PageroExtension:InvoiceSeries`

2. **RestrictedInformation**
   - Location: Invoice/ext:UBLExtensions
   - URI: `urn:pagero:ExtensionComponent:1.0:PageroExtension:RestrictedInformation`

3. **BillingReferenceExtension**
   - Location: BillingReference/InvoiceDocumentReference/ext:UBLExtensions
   - URI: `urn:pagero:ExtensionComponent:1.0:PageroExtension:BillingReferenceExtension`

### Tax Level

1. **TaxSubtotalExtension**
   - Location: TaxTotal/TaxSubtotal/ext:UBLExtensions
   - URI: `urn:pagero:ExtensionComponent:1.0:PageroExtension:TaxSubtotalExtension`
   - Contains: SpecialRegimeKey, EquivalenceSurcharge, TaxBaseAtCost

## References

- [PUF Billing Specification](https://pagero.github.io/puf-billing/)
- [Spain VeriFactu Documentation](https://pagero.github.io/puf-billing/#_spain_verifactu)
- [PUF Code Lists](https://pagero.github.io/puf-code-lists/)
- [PUF-003-INVOICETYPECODE (Spain)](https://pagero.github.io/puf-code-lists/#_invoice_type_codes_for_spain_verifactu)
- [PUF-022-SPECIALREGIMEKEY](https://pagero.github.io/puf-code-lists/#_puf_022_specialregimekey)
- [PUF-013-TAXEXEMPTIONCODE (Spain)](https://pagero.github.io/puf-code-lists/#_tax_exemption_codes_in_spain_verifactu)

## Validation

All examples should validate against:

- PUF XSD schemas (`xml-schemas/maindoc/UBL-Invoice-2.1.xsd`)
- PUF Schematron rules (`validation-artefacts/PUF-UBL.sch`)
- Spain VeriFactu business rules

## Notes

- **Special Regime Key is ALWAYS mandatory** for VeriFactu - every tax subtotal must include it
- Invoice series is mandatory for all VeriFactu invoices
- Equivalence surcharge applies only to certain retail traders
- Substitutive method requires all original invoice amounts in the billing reference
- Tax exemption codes are mandatory when using tax categories E (Exempt) or O (Not subject)
