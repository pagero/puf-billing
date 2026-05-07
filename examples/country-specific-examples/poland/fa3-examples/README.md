# Poland KSeF FA(3) Examples

This directory contains PUF example files derived from the official KSeF FA(3) sample invoice set published by the Polish Ministry of Finance. Each file demonstrates how a specific Polish invoicing scenario can be expressed in PUF.

> **Note:** These files are approximations of the official FA(3) samples, not exact representations. PUF and FA(3) are structurally different formats — some FA(3) fields have no direct PUF equivalent, and some PUF constructs produce output that is semantically equivalent but structurally different from the FA(3) source. The goal of each example is to carry all business-relevant data from the FA(3) sample through PUF in a way that produces a correct FA(3) output after transformation — not to mirror the FA(3) XML structure exactly.

## Overview

Polish e-invoicing (KSeF) requires specific mandatory elements regulated by the Polish tax authorities (KAS). These examples demonstrate key Polish requirements including:

- Invoice type codes (VAT, KOR, ZAL, ROZ, KOR_ZAL, KOR_ROZ, UPR) via `@name` on `InvoiceTypeCode`
- FA(3) field references (P_1, P_2, P_12, etc.) documented in element comments
- KSeF clearance IDs (`puf:ClearanceID`) on billing references
- GTU goods/service designation codes (GTU_01–GTU_13) via `puf:LineExtension`
- Multi-currency invoices with PLN-equivalent VAT (`P_14_1W`) in a second `TaxTotal`
- Third-party roles (Podmiot3): co-buyer (Rola=4), primary entity (Rola=3), JST-recipient (Rola=8)
- Correction types (`correctionType` 1, 2, 3) and before/after line patterns (`stanPrzed`, `originalLine`)
- Advance and settlement invoice flows (ZAL → ROZ) with order value tracking (`WartoscZamowienia`)

## Example Files

### Example 1: PUF_Poland_Invoice_basic_VAT_FA3_Example1.xml

**Basic VAT Invoice**

Based on FA(3) sample: `FA_3_Przykład_1.xml`

Demonstrates:

- Standard VAT invoice (RodzajFaktury=VAT, InvoiceTypeCode=380)
- Place of issue (`P_1M`) as `RestrictedInformation`
- Simplified tripartite procedure indicator (`P_23`) and cash accounting flag (`P_16`)
- Standard 23% VAT rate (category S)
- GLN, REGON, KRS, BDO seller identifiers
- NIP buyer identifier

**Key Features:**

- Document type: 380 with `name="VAT"`
- Complete Polish party information (NIP, REGON, KRS, BDO, GLN)
- Standard single-line invoice structure

---

### Example 2: PUF_Poland_Invoice_KOR_FA3_Example2.xml

**KOR Correction Invoice — Method 3 (StanPrzed / StanPo)**

Based on FA(3) sample: `FA_3_Przykład_2.xml`

Demonstrates:

- Correction invoice (`RodzajFaktury=KOR`, InvoiceTypeCode=384)
- Method 3: original line state carried with `stanPrzed=true`, corrected line follows
- KSeF clearance reference (`puf:ClearanceID`) on `BillingReference`
- Correction type (`TypKorekty`) as `RestrictedInformation`
- Reason for correction (`PrzyczynaKorekty`) as `cbc:Note` on `BillingReference`

**Key Features:**

- Document type: 384 with `name="KOR"`
- Two lines per corrected item: before-state (`stanPrzed=true`) and after-state

---

### Example 3: PUF_Poland_Invoice_KOR_FA3_Example3.xml

**KOR Correction Invoice — Method 2 (Single Negative-Value Line)**

Based on FA(3) sample: `FA_3_Przykład_3.xml`

Demonstrates:

- Method 2: single negative-value line showing only the net change (delta approach)
- No `stanPrzed` flag — only the corrected difference is invoiced
- KSeF clearance reference and correction reason

**Key Features:**

- Document type: 384 with `name="KOR"`
- Single line with negative `LineExtensionAmount` representing the correction delta
- Use alongside Example 2 to compare Method 2 vs. Method 3

---

### Example 4: PUF_Poland_Invoice_VAT_FA3_Example4.xml

**VAT Invoice with Factoring, Per-Line Delivery Dates, CN Codes, Discount and Transport**

Based on FA(3) sample: `FA_3_Przykład_4.xml`

Demonstrates:

- Factoring party (Podmiot3 Rola=1) mapped as `factor` via `RestrictedInformationParty`
- Payment routed to factoring company's bank account (`RachunekBankowyFaktora`)
- WZ delivery note reference (`AdditionalDocumentReference`)
- Per-line delivery dates (`P_6A`) on three invoice lines
- CN commodity codes (`CommodityClassification`)
- Per-unit price discount on line 2 (`P_10`) via line-level `AllowanceCharge`
- Credit deduction (`Rozliczenie`) via `PrepaidAmount`
- Transport block: delivery terms (CIP), carrier, ship-from/ship-to
- Order reference (`Zamowienia`) and WZ delivery note

**Key Features:**

- Factoring entity in `RestrictedInformationParty` with key `factor`
- Three invoice lines with individual delivery dates and CN codes
- Delivery terms `CIP` in `DeliveryTerms`

---

### Example 5: PUF_Poland_Invoice_KOR_FA3_Example5.xml

**KOR Correction Invoice — Buyer Name Correction Only (No Financial Change)**

Based on FA(3) sample: `FA_3_Przykład_5.xml`

Demonstrates:

- Correction changing only the buyer name (no financial amounts change)
- Original buyer: "CeDeE s.c." → corrected to: "CDE sp. j."
- Corrected buyer (`Podmiot2K`) mapped as `correctedBuyerOrOtherPartyDetails` in `RestrictedInformationParty`
- `P_15=0` — no payment due; no invoice lines in source
- `PayableAmount=0`

**Key Features:**

- Document type: 384 with `name="KOR"`
- `correctedBuyerOrOtherPartyDetails` in `RestrictedInformationParty`
- No invoice lines; correction is purely a master data fix

---

### Example 6: PUF_Poland_Invoice_KOR_FA3_Example6.xml

**KOR Collective Correction — Six Invoices, Period Descriptor, TypKorekty=2**

Based on FA(3) sample: `FA_3_Przykład_6.xml`

Demonstrates:

- Collective correction covering six invoices from H1 2026 (pierwsze półrocze 2026)
- Six `BillingReference` entries referencing each corrected invoice by number and date
- Multiple KSeF references (`puf:ClearanceID`) at document level — one per corrected invoice
- `OkresFaKorygowanej` (corrected invoices period description) as `RestrictedInformation` key `correctedInvoicesPeriod`
- `TypKorekty=2`: correction effective on the correction invoice date (not the original date)
- Single summary `InvoiceLine` carrying the total correction amount

**Key Features:**

- Document type: 384 with `name="KOR"`
- Multiple `cac:BillingReference` entries (one per corrected invoice)
- `correctedInvoicesPeriod` in `RestrictedInformation`
- `correctionType=2` — distinct from the standard `correctionType=1`

---

### Example 7: PUF_Poland_Invoice_KOR_FA3_Example7.xml

**KOR Collective Correction — With Product Line Detail, TypKorekty=2**

Based on FA(3) sample: `FA_3_Przykład_7.xml`

Demonstrates:

- Identical to Example 6 (six-invoice collective correction, H1 2026) but with an informational `FaWiersz` line identifying the corrected product
- Product: lodówka Zimnotech mk1, CN code 8418 21 91, quantity 1000
- `LineExtensionAmount` carries the full correction amount (`P_13_1=-40650.41`)
- `TypKorekty=2`

**Key Features:**

- Document type: 384 with `name="KOR"`
- Informational line with item name and CN code (no unit price in source)
- Use alongside Example 6 to illustrate the line-detail variant of collective corrections

---

### Example 9: PUF_Poland_Invoice_VAT_FA3_Example9.xml

**VAT Invoice to Local Government Unit (JST) with Service Period and Exempt Line**

Based on FA(3) sample: `FA_3_Przykład_9.xml`

Demonstrates:

- Buyer is a local government unit (`JST=1`): Gmina Bzdziszewo (NIP)
- Podmiot3 Rola=8 (JST-recipient delivery location: Szkoła Podstawowa w Bzdziszewie) as `JST-recipient` in `RestrictedInformationParty`
- Service period (`OkresFa`) mapped as `cac:InvoicePeriod` with start/end dates
- Line 2 VAT-exempt: `P_12=zw`, `P_19=1`, `P_19A` referencing the specific VAT law article (`art. 43 ust. 1 pkt 37 ustawy VAT`)
- Additional description (`DodatkowyOpis`) carried as document-level `cbc:Note`

**Key Features:**

- `JST=1` in `RestrictedInformation` at document level
- `JST-recipient` in `RestrictedInformationParty` for Podmiot3 Rola=8
- `cac:InvoicePeriod` with `StartDate` and `EndDate`
- Exempt line with article reference in `TaxExemptionReason`

---

### Example 10: PUF_Poland_Invoice_ZAL_FA3_Example10.xml

**Advance Payment Invoice with Co-Buyer (ZAL)**

Based on FA(3) sample: `FA_3_Przykład_10.xml`

Demonstrates:

- Advance payment invoice (`RodzajFaktury=ZAL`, InvoiceTypeCode=386)
- Podmiot3 Rola=4 (co-buyer F.H.U. Grażyna Kowalska, 50% share) mapped as `additionalBuyer` in `RestrictedInformationParty`
- Order value (`WartoscZamowienia=375150`) as document-level `RestrictedInformation`
- Invoice fully paid (`Zaplacono=1`, `DataZaplaty=2026-02-15`) via `PrepaidAmount`
- Apartment (8% VAT) and additional services (23% VAT) lines

**Key Features:**

- Document type: 386 with `name="ZAL"`
- `additionalBuyer` with ownership share in `RestrictedInformationParty`
- `WartoscZamowienia` in `RestrictedInformation`
- Mixed VAT rates across lines (8% and 23%)

---

### Example 11: PUF_Poland_Invoice_KOR_ZAL_FA3_Example11.xml

**KOR_ZAL — Correction of Advance Invoice, Wrong VAT Rate**

Based on FA(3) sample: `FA_3_Przykład_11.xml`

Demonstrates:

- Correction of advance invoice FZ2026/02/150 (`RodzajFaktury=KOR_ZAL`, InvoiceTypeCode=384)
- Reason: wrong VAT rate — 23% corrected to 8% on apartment line; additional services line unchanged
- Before-state order lines (`ZamowienieWiersz`) with `originalLine=true` (`StanPrzedZ=1`)
- Updated `WartoscZamowienia` after correction

**Key Features:**

- Document type: 384 with `name="KOR_ZAL"`
- `originalLine=true` in `LineExtension` for before-state lines
- Mixed VAT rate correction (8% and 23% on different lines)

---

### Example 12: PUF_Poland_Invoice_KOR_ZAL_FA3_Example12.xml

**KOR_ZAL — Correction of Advance Invoice, Understated Deposit Amount**

Based on FA(3) sample: `FA_3_Przykład_12.xml`

Demonstrates:

- Correction of the same advance invoice FZ2026/02/150
- Reason: deposit amount understated — was 20,000, should be 30,000
- `TypKorekty=1` (increase in amount owed); `PayableAmount=10000` (the difference)
- Advance increases from 20,000 to 30,000

**Key Features:**

- Document type: 384 with `name="KOR_ZAL"`
- `correctionType=1` with positive `PayableAmount` representing the additional amount due

---

### Example 13: PUF_Poland_Invoice_KOR_ZAL_FA3_Example13.xml

**KOR_ZAL — Correction of Advance Invoice, Order Value Reduction**

Based on FA(3) sample: `FA_3_Przykład_13.xml`

Demonstrates:

- Correction of the same advance invoice FZ2026/02/150
- Reason: order value reduced by 10%
- `TypKorekty=3`; `PayableAmount=0` (no cash movement)
- `WartoscZamowienia` updated to 337,635 after correction

**Key Features:**

- Document type: 384 with `name="KOR_ZAL"`
- `correctionType=3` — correction with no financial settlement
- Use Examples 11, 12, 13 together to illustrate all three `TypKorekty` values on the same base invoice

---

### Example 14: PUF_Poland_Invoice_ROZ_FA3_Example14.xml

**Settlement Invoice with Co-Buyer, GTU_10 and Multiple Payment Deadlines (ROZ)**

Based on FA(3) sample: `Fa_3_Przykład_14.xml`

Demonstrates:

- Settlement invoice (`RodzajFaktury=ROZ`, InvoiceTypeCode=380)
- Advance invoice reference via KSeF ID (`NrKSeFFaZaliczkowej`) in `PrepaidPayment`
- Two payment deadlines (`TerminPlatnosci`) mapped as multiple `cac:PaymentMeans`
- Two Podmiot3 parties:
  - Rola=4 (F.H.U. Grażyna Kowalska, 50% share) → `additionalBuyer`
  - Rola=3 (ABC Developex sp. z o.o., original entity) → `primaryEntity`
- GTU_10 (construction services, transfer of building rights) on invoice line
- Line: apartment 50m² at 8% VAT; legal form change (sp. z o.o. → S.A.)

**Key Features:**

- Document type: 380 with `name="ROZ"`
- KSeF reference to prior advance invoice in `PrepaidPayment`
- Multiple `cac:PaymentMeans` for installment deadlines
- GTU_10 in `puf:LineExtension`

---

### Example 17: PUF_Poland_Invoice_ROZ_FA3_Example17.xml

**Settlement Invoice with Co-Buyer and GTU_10 (ROZ)**

Based on FA(3) sample: `Fa_3_Przykład_17.xml`

Demonstrates:

- Settlement invoice with a single Podmiot3 co-buyer (Rola=4, 50% share)
- Advance invoice reference via KSeF ID in `PrepaidPayment`
- GTU_10 (construction services) on the invoice line
- Use together with Example 18 to illustrate a ROZ → KOR_ROZ correction flow

**Key Features:**

- Document type: 380 with `name="ROZ"`
- Single `additionalBuyer` in `RestrictedInformationParty`
- GTU_10 in `puf:LineExtension`

---

### Example 18: PUF_Poland_Invoice_KOR_ROZ_FA3_Example18.xml

**KOR_ROZ — Correction of Settlement Invoice, Understated Remaining Balance**

Based on FA(3) sample: `Fa_3_Przykład_18.xml`

Demonstrates:

- Correction of settlement invoice FV2026/08/12 (Example 17) (`RodzajFaktury=KOR_ROZ`, InvoiceTypeCode=384)
- Reason: remaining balance incorrectly stated as 300,000 — should be 307,635
- `TypKorekty=1`; `PayableAmount=7635` (the correction difference)
- Before-state lines with `stanPrzed=true`
- GTU_10 on the corrected line

**Key Features:**

- Document type: 384 with `name="KOR_ROZ"`
- Use together with Example 17 to illustrate the full ROZ → KOR_ROZ correction flow

---

### Example 20: PUF_Poland_Invoice_VAT_FA3_Example20.xml

**VAT Invoice in EUR with PLN-Equivalent VAT (Same Exchange Rate on All Lines)**

Based on FA(3) sample: `Fa_3_Przykład_20.xml`

Demonstrates:

- Invoice currency EUR with same exchange rate (`KursWaluty=4.5005`) on all three lines
- Exchange rate carried at document level via `cac:TaxExchangeRate`
- PLN-equivalent VAT (`P_14_1W=14036.16`) in a second `TaxTotal` with `currencyID="PLN"`
- Per-line delivery dates (`P_6A`) and CN commodity codes
- Factoring bank account (`RachunekBankowyFaktora`)
- Buyer identified by GLN (`schemeID="0088"`)
- Order reference and WZ delivery note

**Key Features:**

- Two `cac:TaxTotal`: one in EUR (invoice currency), one in PLN (P_14_1W)
- Document-level `cac:TaxExchangeRate` for single uniform rate
- Use alongside Example 21 to illustrate single-rate vs. mixed-rate scenarios

---

### Example 21: PUF_Poland_Invoice_VAT_FA3_Example21.xml

**VAT Invoice in EUR with PLN-Equivalent VAT (Different Exchange Rates per Line)**

Based on FA(3) sample: `FA_3_Przykład_21.xml`

Demonstrates:

- Same structure as Example 20 but with **different exchange rates per line**:
  - Line 1: `KursWaluty=4.4080` (delivery 2026-02-05)
  - Line 2: `KursWaluty=4.5005` (delivery 2026-02-10)
  - Line 3: `KursWaluty=4.3250` (delivery 2026-02-20)
- Per-line rates carried as `KursWaluty` in `puf:LineExtension/puf:RestrictedInformation`
- Weighted PLN VAT total (`P_14_1W=13768.14`) reflecting mixed rates
- Factoring bank account and GLN buyer

**Key Features:**

- Per-line `KursWaluty` in `LineExtension` `RestrictedInformation`
- Demonstrates weighted PLN VAT calculation across lines with different rates
- Use alongside Example 20 to illustrate the single-rate vs. mixed-rate distinction

---

### Example 22: PUF_Poland_Invoice_VAT_FA3_Example22.xml

**VAT Invoice — Intra-Community Supply (WDT, 0% in EUR)**

Based on FA(3) sample: `FA_3_Przykład_22.xml`

Demonstrates:

- Intra-Community supply of goods (WDT): tax category K, `Name="0-WDT"`, Percent=0
- Invoice in EUR; buyer is an EU VAT-registered entity (EFG GmbH, Germany)
- Buyer VAT number: `DE999999999` (KodUE=DE + NrVatUE)
- `P_13_6_2=4000` (WDT taxable base at 0%)

**Key Features:**

- Tax category K (`0-WDT`) for intra-EU supply
- EU buyer identified by EU VAT number with country prefix
- 0% VAT, TaxAmount=0

---

### Example 23: PUF_Poland_Invoice_VAT_FA3_Example23.xml

**VAT Invoice — Export Supply (EX, 0% in USD)**

Based on FA(3) sample: `FA_3_Przykład_23.xml`

Demonstrates:

- Export supply outside the EU: tax category G, `Name="0-EX"`, Percent=0
- Invoice in USD; buyer is a non-EU entity (EFG Ltd., United States, Seattle)
- Non-EU buyer identifier: `schemeID="US:TaxID"` with US tax number
- `P_13_6_3=8000` (EX taxable base at 0%)

**Key Features:**

- Tax category G (`0-EX`) for export supply
- Non-EU buyer with `US:TaxID` schemeID (country-specific identifier pattern)
- 0% VAT, TaxAmount=0, invoice in USD

---

## Invoice Type Codes

All Polish invoice types use `InvoiceTypeCode` with the `@name` attribute to signal the KSeF type:

| KSeF Type | `@name` | `InvoiceTypeCode` | Description | Examples |
|---|---|---|---|---|
| VAT | `VAT` | 380 | Standard VAT invoice | 1, 4, 9, 20–23 |
| KOR | `KOR` | 384 | Correction invoice | 2, 3, 5, 6, 7 |
| ZAL | `ZAL` | 386 | Advance payment invoice | 10 |
| KOR_ZAL | `KOR_ZAL` | 384 | Correction of advance invoice | 11, 12, 13 |
| ROZ | `ROZ` | 380 | Settlement invoice after advance | 14, 17 |
| KOR_ROZ | `KOR_ROZ` | 384 | Correction of settlement invoice | 18 |
| UPR | `UPR` | 380 | Simplified invoice | — |

---

## Correction Types (TypKorekty)

| `correctionType` | Meaning | Examples |
|---|---|---|
| 1 | Correction effective on the original invoice date | 2, 3, 12, 18 |
| 2 | Correction effective on the correction invoice date | 6, 7 |
| 3 | Correction with no financial settlement (e.g. order value change only) | 13 |

---

## GTU Goods and Service Designation Codes

GTU codes are carried as `RestrictedInformation` entries within `puf:LineExtension` on each applicable invoice line:

```xml
<puf:RestrictedInformation>
    <puf:Key>GTU</puf:Key>
    <puf:Value>GTU_10</puf:Value>
</puf:RestrictedInformation>
```

| GTU Code | Description | Examples |
|---|---|---|
| GTU_10 | Buildings, structures, land; housing cooperative rights | 14, 17, 18 |

For other GTU codes (GTU_01–GTU_09, GTU_11–GTU_13) apply the same pattern with the relevant value.

---

## Margin Scheme Support

> **Note:** Margin scheme invoices (UBL tax category D — travel agency, F — second-hand goods, I — works of art, J — collectors items and antiques) are under investigation. The corresponding example files are kept in the WIP folder only.

---

## Key RestrictedInformation Keys

| Key | Description | Level | Examples |
|---|---|---|---|
| `placeOfIssue` | Place of invoice issue (P_1M) | Document | All |
| `checkoutMethod` | Cash accounting indicator (P_16) | Document | All |
| `correctionType` | Correction type 1/2/3 (TypKorekty) | Document | 2, 3, 5–7, 11–13, 18 |
| `correctedInvoicesPeriod` | Period description for collective corrections (OkresFaKorygowanej) | Document | 6, 7 |
| `sentToKSEFDate` | Date original invoice was sent to KSeF | Document | 2, 3 |
| `WartoscZamowienia` | Total order value on ZAL/ROZ invoices | Document | 10–14, 17 |
| `NrKSeFFaZaliczkowej` | KSeF ID of advance invoice being settled | Document | 14, 17, 18 |
| `wz` | WZ delivery note reference | Document | 4, 21 |
| `GTU` | Goods/service designation code (GTU_01–GTU_13) | Line | 14, 17, 18 |
| `KursWaluty` | Exchange rate per line (foreign currency invoices with mixed rates) | Line | 21 |
| `universalUniqueLineNumber` | Unique line identifier (UU_ID) | Line | 4, 9–14, 17, 20–23 |
| `originalLine` | Before-state line indicator (KOR Method 3 and KOR_ZAL) | Line | 2, 11, 18 |

---

## Source Reference

All files are derived from the official KSeF FA(3) sample set:
**Opisy przykładów dla struktury logicznej FA(3).pdf**
