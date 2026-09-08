# Oman PUF Examples

Synthetic PUF Billing examples based on the published PINT OM 1.0.1 billing and
self-billing specifications, released 2026-07-29. Reviewed 2026-09-07.
These illustrate customer input, not live taxpayer registrations or bank details.

## Examples

| File | Scenario | Invoice Currency | Net / VAT / Gross | Target Check |
|---|---|---|---|---|
| [PUF_OM_Standard_Invoice.xml](PUF_OM_Standard_Invoice.xml) | Full-tax service invoice | OMR | 100.00 / 5.00 / 105.00 | Billing passed |
| [PUF_OM_CreditNote.xml](PUF_OM_CreditNote.xml) | Return of goods, reason CAN, preceding invoice number and UUID | OMR | 20.00 / 1.00 / 21.00 | Credit note passed |
| [PUF_OM_SelfBilled_Invoice.xml](PUF_OM_SelfBilled_Invoice.xml) | Buyer-issued invoice using SelfBilled and PUF type 380 | OMR | 2.00 / 0.10 / 2.10 | Self-billing passed, target type 389 |
| [PUF_OM_ThirdParty_Invoice.xml](PUF_OM_ThirdParty_Invoice.xml) | Seller agent with SR role and a complete agent address | OMR | 100.00 / 5.00 / 105.00 | Billing passed |
| [PUF_OM_Prepayment_Settlement_Invoice.xml](PUF_OM_Prepayment_Settlement_Invoice.xml) | Final invoice fully settled by a referenced prepayment | OMR | 2400.00 / 120.00 / 2520.00 | Billing passed, prepaid 2520.00 and payable 0.00 |
| [PUF_OM_ForeignCurrency_Invoice_DRAFT.xml](PUF_OM_ForeignCurrency_Invoice_DRAFT.xml) | EUR invoice with OMR VAT accounting and exchange rate 0.4000000 | EUR | 100.00 / 5.00 / 105.00 | Draft: ALIGNED-IBRP-S-01-OM fails |

The foreign-currency example intentionally includes the OMR standard-rate breakdown
required by IBR-066-OM. ALIGNED-IBRP-S-01-OM also counts that breakdown alongside the
EUR breakdown and rejects the resulting count. This is the only expected target
failure for that draft. Do not remove the OMR amount to make it pass.

## Input Conventions

- The current document UUID is omitted because Pagero generates it during processing.
  Local validation supplies a deterministic, synthetic UUID-v5-shaped placeholder.
  Never reuse that validation placeholder as a production identifier.
- Referenced document UUIDs are customer inputs on native `cbc:UUID`. Their
  illustrative original documents are not included in this set.
- PUF item types are `GOODS` and `SERVICE`, not the target codes `G` and `S`.
- Oman party identifiers use `OM:` scheme IDs; endpoint IDs use Peppol EAS schemes.
- PO boxes use `cbc:Postbox`. The third-party example uses `cbc:BuildingName` for
  the agent's third address line and separately supplies `cbc:AdditionalStreetName`.
- Line VAT is supplied in `cac:TaxTotal/cac:TaxSubtotal`, with the line gross amount
  in the existing PUF LineExtension. No tax calculation is left implicit in these files.
- The currency draft uses `TaxSubtotalExtension/TaxCurrencyTaxAmount` for OMR VAT
  and supplies the PUF-required exchange operator `Multiply`.

## Source Basis

These are adaptations, not literal conversions. Optional unrelated sections were
removed, personal-looking source names were replaced with synthetic company names,
and dates, monetary values and classifications were chosen to make the examples
small and internally consistent. Source payload quirks are not reproduced as guidance.

| Example | Official Source Basis | Adaptation |
|---|---|---|
| Standard invoice | Billing `trn-invoice/example/FullInvoice.xml` | Full-tax scenario reduced to one service line with ISIC 620202 and service type 81000000 |
| Credit note | Billing `trn-creditnote/example/StandardCN.xml` | Preserves the CAN reason and native preceding UUID pattern; one goods line uses the frankincense HS code from `Exports-2.xml` |
| Self-billing | Self-billing `trn-invoice/example/SB-INV-01-no-gap-exact-calculation.xml` | Retains 2.00 net and 0.10 VAT; correct PUF SelfBilled representation and service classification |
| Third party | Billing `trn-invoice/example/ThirdParty.xml` | Keeps the third-party context and required agent fields; adds the existing PUF SR qualifier |
| Prepayment settlement | Billing `trn-invoice/example/Prepayment-Final-Net.xml` | Retains 2400.00 net, 120.00 VAT and 2520.00 prepaid; native PDR reference with no duplicated payment amount |
| Foreign currency draft | PINT OM Billing BIS, "Dual Currency VAT Example", plus the full-tax invoice structure | Smaller EUR amounts and an illustrative 0.4000000 rate; both currency amounts supplied, conflict left visible |

Authoritative packages retrieved 2026-09-02:

- [PINT OM Billing 1.0.1](https://docs.peppol.eu/poac/om/pint-om/),
  [resource package](https://docs.peppol.eu/poac/om/pint-om/resources.zip), SHA-256
  `023F57B9CC13AE641DAB0C1726FC8167B86C125837875DA98274CC6C0AAF8402`.
- [PINT OM Self-Billing 1.0.1](https://docs.peppol.eu/poac/om/pint-om-sb/),
  [resource package](https://docs.peppol.eu/poac/om/pint-om-sb/resources.zip), SHA-256
  `0F8095FECC15393D792CFDDFD4CFC56B58E6FC3588B02B0E7C47DF9DE5FB532B`.

Source locators: IBR-002-OM (UUID v5), IBR-015-OM (third party), IBR-023-OM and
IBR-032-OM (correction reason and preceding reference), IBR-058-OM (prepayment),
IBR-066-OM (accounting-currency breakdown), IBR-078-OM and IBR-081-OM (item type
and industrial classification), and the package code lists `BuyerSellerIdentifier.gc`,
`ISIC.gc`, `ServiceType.gc`, `HSCodes-1.gc` / `HSCodes-2.gc`, and `IssuanceReason.gc`.

The specifications remain authoritative for obligations. These examples do not cover
every Oman scenario, including customs, seller UUID input or simplified-invoice rules.
