# Croatia E-Invoicing Examples

This directory contains example PUF invoice files demonstrating Croatia's e-invoicing system implementation with fiscalization requirements.

## Overview

Croatian e-invoicing requires specific fiscalization elements mandated by the Croatian Tax Administration. These examples demonstrate key Croatian requirements including:

- Invoice process types (P1-P12, P99)
- Issue time (mandatory)
- Operator information (fiscalization actor)
- OIB (Croatian tax identification number)
- Croatian tax category labels (HR:PDV25, HR:PDV13, HR:PDV5, HR:POVNAK, etc.)
- Item classification with CPA/KPD codes
- Line-level references

## Example Files

### 1. PUF_Croatia_Invoice_P1_Standard.xml

**Standard Invoice (P1)**

Demonstrates:

- Invoice type P1 (Standard contract-based invoice)
- Mandatory issue time (HR-BT-2)
- Operator information with OIB (HR-BT-4, HR-BT-5)
- Croatian OIB for endpoint identification (scheme 9934)
- Mixed tax rates: 25% standard (HR:PDV25) and exempt (HR:POVNAK)
- Item classification with CPA/KPD codes (listID="CG")

**Key Features:**

- Document type: 380 with name="P1"
- Issue time: 14:30:00
- Seller and buyer with Croatian OIB
- Payment information with Croatian IBAN and BIC
- Two invoice lines with different tax treatments

---

### 2. PUF_Croatia_Invoice_P2_Periodic.xml

**Periodic Invoice (P2)**

Demonstrates:

- Invoice type P2 (Periodic contract-based invoice)
- Invoicing period with start and end dates
- Multiple tax rates (25%, 13%, 5%)
- Purchase order reference
- Contract reference

**Key Features:**

- Document type: 380 with name="P2"
- BG-14 Invoicing period (monthly billing)
- Three tax subtotals with different Croatian tax labels
- Document-level references (contract, purchase order)

---

### 3. PUF_Croatia_Invoice_P4_AdvancePayment.xml

**Advance Payment Invoice (P4)**

Demonstrates:

- Invoice type P4 (Advance payment invoice per RD 386)
- Prepayment invoice characteristics
- Payment terms for advance payment
- Standard 25% VAT rate

**Key Features:**

- Document type: 386 with name="P4"
- Payment terms describing advance payment conditions
- Due date for advance payment
- Single tax rate applicable to advance

---

### 4. PUF_Croatia_Invoice_P10_Corrective.xml

**Corrective Invoice (P10)**

Demonstrates:

- Invoice type P10 (Corrective invoice - cancellation/correction)
- Billing reference to original invoice
- Preceding invoice issue date (HR-BR-6)
- Billing reference description (Croatian-specific)

**Key Features:**

- Document type: 384 with name="P10"
- BG-3 Billing reference with description
- Preceding invoice mandatory fields
- Corrective invoice flow

---

### 5. PUF_Croatia_CreditNote_P9.xml

**Credit Note (P9)**

Demonstrates:

- Credit note type P9 (Negative amounts/returns)
- Payment due date in PaymentMeans (credit note structure)
- Billing reference to original invoice
- Refund payment information

**Key Features:**

- Document type: 381 with name="P9"
- PaymentDueDate in cac:PaymentMeans (not document level)
- Billing reference with issue date
- Return fee exemption (HR:POVNAK)

---

### 6. PUF_Croatia_Invoice_P7_WithDeliveryNote.xml

**Invoice with Delivery Note Reference (P7)**

Demonstrates:

- Invoice type P7 (Invoice with delivery note reference)
- Despatch advice reference at document level
- Actual delivery date
- Delivery information

**Key Features:**

- Document type: 380 with name="P7"
- cac:DespatchDocumentReference at header level
- BT-72 Actual delivery date
- Delivery-related business flow

---

### 7. PUF_Croatia_Invoice_MultipleTaxRates.xml

**Invoice with Multiple Croatian Tax Rates**

Demonstrates:

- All major Croatian tax rates in one invoice
- Standard rates: 25%, 13%, 5% (HR:PDV25, HR:PDV13, HR:PDV5)
- Reverse charge (HR:AE)
- Exempt (HR:E)
- Export (HR:G)
- Zero-rated (HR:Z)
- Return fee exemption (HR:POVNAK)

**Key Features:**

- Eight tax subtotals demonstrating all common scenarios
- Correct tax scheme names for each Croatian category
- Multiple invoice lines with different tax treatments
- Document and line-level allowances/charges

**Validation Note:**

⚠️ This file is a **reference/educational example** designed to demonstrate all possible Croatian tax categories. It will **fail EN 16931 validation** because:

- EN 16931 rule BR-E-01 requires exactly ONE VAT breakdown per exempt category code
- This example intentionally shows multiple exempt-type categories (E, Z) in one invoice
- Real production invoices should not combine all these tax types together
- Use this file as a **developer reference** for individual tax category implementation, not as a production template

---

### 8. PUF_Croatia_Invoice_LineLevelReferences.xml

**Invoice with Line-Level References**

Demonstrates:

- Purchase order reference at line level (cac:OrderLineReference)
- Despatch advice reference at line level (cac:DespatchLineReference)
- Receipt advice reference at line level (cac:ReceiptLineReference)
- Mutual exclusivity with header-level references

**Key Features:**

- Line 1: Purchase order line reference
- Line 2: Despatch line reference
- Line 3: Receipt line reference
- Croatian item classification for each line

---

### 9. PUF_Croatia_Invoice_P12_SelfBilling.xml

**Self-Billing Invoice (P12)**

Demonstrates:

- Invoice type P12 (Self-billing invoice)
- Buyer issues invoice on behalf of seller
- Reversed party roles in fiscalization
- Self-billing business scenario

**Key Features:**

- Document type: 380 with name="P12"
- AccountingSupplierParty represents the actual supplier
- Self-billing note in document notes
- Appropriate payment terms for self-billing

---

### 10. PUF_Croatia_Invoice_P99_Custom.xml

**Custom Process Invoice (P99)**

Demonstrates:

- Invoice type P99 (Custom process with label)
- Custom process label: "P99:SpecialProject2025"
- Project reference
- Custom business flow

**Key Features:**

- Document type: 380 with name="P99:SpecialProject2025"
- Custom label after P99 colon
- Project-specific invoicing scenario
- Flexible process type for non-standard flows

---

## Croatian-Specific Requirements

### Mandatory Elements

1. **Issue Time (HR-BT-2)**: Required in format HH:MM:SS
2. **Operator Information**:
   - HR-BT-4: Operator name
   - HR-BT-5: Operator OIB (11-digit)
3. **Invoice Process Code (HR-BT-3)**: P1-P12 or P99 in InvoiceTypeCode/@name
4. **OIB Identification**:
   - Endpoint ID with scheme 9934
   - VAT number with HR prefix

### Croatian Tax Category Labels

| Tax Scheme Name | Tax Category ID | Rate | Description |
|-----------------|-----------------|------|-------------|
| HR:PDV25 | S | 25% | Standard rate |
| HR:PDV13 | S | 13% | Reduced rate |
| HR:PDV5 | S | 5% | Reduced rate |
| HR:AE | AE | - | Reverse charge |
| HR:E | E | 0% | Exempt from tax |
| HR:G | G | 0% | Free export item |
| HR:O | O | 0% | Outside scope of VAT |
| HR:K | K | 0% | Intra-Community supply |
| HR:Z | Z | 0% | Zero rated goods |
| HR:POVNAK | E | 0% | Return fee exemption |
| HR:PP | E | 0% | Special consumption tax (catering) |
| HR:PPMV | E | 0% | Motor vehicle tax |
| HR:N | E | 0% | Not subject to VAT |

### Item Classification

Croatian invoices require CPA/KPD classification:

```xml
<cac:CommodityClassification>
    <cbc:ItemClassificationCode listID="CG">XX.XX.XX</cbc:ItemClassificationCode>
</cac:CommodityClassification>
```

**Exception**: Not required for advance invoices (P4).

### Process Types Reference

| Code | Description | UBL Document |
|------|-------------|--------------|
| P1 | Standard Invoice (Contract-based) | Invoice |
| P2 | Periodic Invoice (Contract-based) | Invoice |
| P3 | Independent Purchase Order Invoice | Invoice |
| P4 | Advance Payment Invoice | Invoice (386) |
| P5 | Spot Payment Invoice | Invoice |
| P6 | Pre-delivery Payment Invoice | Invoice (386) |
| P7 | Invoice with Delivery Note Reference | Invoice |
| P8 | Invoice with Delivery Note and Receipt Reference | Invoice |
| P9 | Credit Note (Negative amounts/Returns) | CreditNote |
| P10 | Corrective Invoice (Cancellation/Correction) | Invoice (384) |
| P11 | Partial/Final Invoice | Invoice |
| P12 | Self-billing Invoice | Invoice |
| P99 | Custom Process Invoice | Invoice |

### Business Rules

- **HR-BR-1**: Invoice number must not contain whitespace characters
- **HR-BR-4**: Payment due date mandatory when payable amount > 0
- **HR-BR-6**: Preceding invoice issue date mandatory when billing reference exists
- **HR-BR-9**: Operator OIB mandatory for Croatian fiscalization
- **HR-BR-10**: Buyer electronic address mandatory

## Validation

All examples validate against:

- PUF UBL 2.1 XSD schemas
- PUF-UBL.sch Schematron rules
- Croatian fiscalization requirements

## References

- [PUF Code Lists - Croatia](https://pagero.github.io/puf-code-lists/#_invoice_type_codes_for_croatia)
- [PUF Code Lists - Croatian Tax Categories](https://pagero.github.io/puf-code-lists/#_tax_category_codes_croatia)
- Croatian Tax Administration e-Invoicing Specification
- PUF Billing Specification - Croatia Section

## Testing

These examples are designed for:

- Implementation validation
- Test data generation
- Integration testing with Croatian fiscalization systems
- Developer training and reference

Each file includes realistic Croatian party information (anonymized), proper OIB formatting, and complete business document structures suitable for production-grade implementations.
