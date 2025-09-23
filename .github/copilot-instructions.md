# Copilot Instructions for PUF Billing

## Repository Context
This repository contains the **Pagero Universal Format (PUF) Billing 2.0** specification - a UBL 2.1-based invoice format designed for global e-invoicing compliance. PUF extends UBL to support country-specific requirements while maintaining compatibility with EN 16931-1:2017 and Peppol BIS Billing 3.0.

## Architecture & Key Components

### Documentation Structure
- **`specification/`** - AsciiDoc source files for the main specification
- **`index.adoc`** - Main documentation entry point that includes all specification modules
- **`examples/`** - Reference implementations organized by country and industry
- **`xml-schemas/`** - XSD schemas (common/, extensions/, maindoc/)
- **`validation-artefacts/`** - Schematron validation rules (`PUF-UBL.sch`, `PUF-UBL.xslt`)

### Namespace Architecture
PUF uses a hybrid approach combining UBL 2.1 with Pagero extensions:
```xml
xmlns="urn:pagero:PageroUniversalFormat:Invoice:1.0"          <!-- Main PUF namespace -->
xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"  <!-- UBL basic components -->
xmlns:cac="urn:pagero:CommonAggregateComponents:1.0"          <!-- PUF aggregate components -->
xmlns:puf="urn:pagero:ExtensionComponent:1.0"                 <!-- PUF extensions -->
xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"  <!-- UBL extensions -->
```

## Country-Specific Implementation Patterns

### File Organization
Country examples follow this structure:
```
examples/country-specific-examples/[country]/
├── PUF_[Country]_Invoice.xml           # Primary invoice example
├── PUF_[Country]_CreditNote.xml        # Credit note (if applicable)
└── [Country]_specific_elements.xml     # Additional country requirements
```

### Country Code Standards
- **BT-40 Country Codes**: Use ISO 3166-1 alpha-2 (HR, FR, DE, etc.)
- **VAT Number Prefixes**: Include country prefix (HR12345678901, FR12345678901)
- **Endpoint ID Schemes**: Use country-specific schemes (9934 for Croatia OIB, 9927 for France SIREN)

### Mandatory Country Elements Pattern
Countries often require additional mandatory fields beyond EN 16931:
```xml
<!-- Croatia example: Issue time is mandatory -->
<cbc:IssueTime>14:30:00</cbc:IssueTime>

<!-- Invoice type with process type -->
<cbc:InvoiceTypeCode name="P1">380</cbc:InvoiceTypeCode>
```

## PUF Extension Patterns

### Using UBL Extensions
PUF extends UBL through the `ext:UBLExtensions` mechanism at multiple levels:
```xml
<ext:UBLExtensions>
    <ext:UBLExtension>
        <ext:ExtensionContent>
            <puf:PufExtensions>
                <!-- Country or business-specific extensions -->
            </puf:PufExtensions>
        </ext:ExtensionContent>
    </ext:UBLExtension>
</ext:UBLExtensions>
```

### Extension Scope
Unlike standard UBL 2.1, PUF allows extensions at any aggregate level, not just document level.

## Validation & Compliance

### Validation Files
- **`PUF-UBL.sch`** - Schematron business rules for PUF compliance
- **`PUF-UBL.xslt`** - Compiled XSLT for validation execution
- **XSD schemas** - Structural validation in `xml-schemas/`

### Key Validation Patterns
1. **Mandatory Field Validation**: Each country may have additional mandatory fields
2. **Code List Validation**: Country-specific code lists (tax categories, payment means)
3. **Format Validation**: Date formats, currency codes, identifier schemes
4. **Business Logic**: Cross-field validation rules (due dates, tax calculations)

## UBL Structure & BG/BT Code Compliance

### EN 16931 Business Group (BG) Numbering
Always use correct BG group numbers according to EN 16931-1:2017:

- **BG-3**: Billing reference (for credit notes referencing original invoices)
- **BG-4**: Seller information
- **BG-7**: Buyer information  
- **BG-20**: Document level charges (ChargeIndicator=true)
- **BG-22**: Document totals (LegalMonetaryTotal)
- **BG-23**: VAT breakdown (TaxTotal)
- **BG-25**: Invoice line / Credit note line
- **BG-27**: Document level allowances (ChargeIndicator=false)

### Credit Note vs Invoice Structure Differences
**Critical**: Credit Notes have different element placement than Invoices:

#### Due Date Placement
```xml
<!-- INVOICE: Document-level due date -->
<cbc:DueDate>2025-02-15</cbc:DueDate>

<!-- CREDIT NOTE: Due date in PaymentMeans -->
<cac:PaymentMeans>
    <cbc:PaymentDueDate>2025-02-20</cbc:PaymentDueDate>
</cac:PaymentMeans>
```

#### Document Type Codes
```xml
<!-- Invoice -->
<cbc:InvoiceTypeCode>380</cbc:InvoiceTypeCode>

<!-- Credit Note -->
<cbc:CreditNoteTypeCode>381</cbc:CreditNoteTypeCode>
```

### Croatian-Specific Mandatory Elements
When creating Croatian examples, always include:

#### Fiscalization Requirements
```xml
<!-- HR-BT-2: Issue time (mandatory) -->
<cbc:IssueTime>14:30:00</cbc:IssueTime>

<!-- HR-BT-4 & HR-BT-5: Operator information -->
<cac:SellerContact>
    <cbc:ID>11111111111</cbc:ID>  <!-- HR-BT-5 Operator OIB -->
    <cbc:Name>Operater Zagreb</cbc:Name>  <!-- HR-BT-4 Operator Name -->
</cac:SellerContact>
```

#### Croatian Tax Labels
```xml
<cac:TaxScheme>
    <cbc:ID>VAT</cbc:ID>
    <cbc:Name>HR:PDV25</cbc:Name>  <!-- HR-BT-12 Croatian tax label -->
</cac:TaxScheme>
```

#### Croatian Identification Schemes
```xml
<!-- Croatian OIB scheme -->
<cbc:EndpointID schemeID="9934">12345678901</cbc:EndpointID>
<cbc:CompanyID>HR12345678901</cbc:CompanyID>  <!-- VAT with HR prefix -->
```

## Development Workflows

### AsciiDoc Documentation Development

#### Setup and Build Process
The PUF specification is written in AsciiDoc and must be compiled to HTML for viewing. 

**Build Command** (run from repository root):
```bash
asciidoctor -a stylesheet=css/pagero.css -o index.html index.adoc
```

This command:
- Uses the Pagero-specific stylesheet (`css/pagero.css`) to override AsciiDoctor defaults
- Compiles `index.adoc` (which includes all specification modules) into `index.html`
- Overwrites existing `index.html` if it exists

#### Development Workflow
1. **Edit AsciiDoc files**: Modify files in `specification/` directory or `index.adoc`
2. **Recompile**: Run the build command after each change
3. **Preview**: Open `index.html` in browser and refresh to see changes
4. **Iterate**: Repeat edit-compile-preview cycle for development

#### AsciiDoc File Structure
```
index.adoc                    # Main entry point, includes all modules
specification/
├── introduction.adoc         # Project introduction and version history
├── guidelines.adoc          # Core guidelines and namespace usage
├── syntax.adoc             # Syntax specifications
├── extensions.adoc         # Extension mechanisms
├── country-specifics.adoc  # Country-specific requirements
├── puf-for-tdr.adoc       # Tax data reporting
├── code-lists.adoc        # Code list definitions
├── xml-schemas.adoc       # Schema documentation
├── excel-specification.adoc # Excel format specs
├── validation.adoc        # Validation rules and processes
├── examples.adoc          # Example documentation
├── supported-countries.adoc # Country support matrix
└── support.adoc          # Support information
```

#### Pagero Styling
- **Always use** the Pagero stylesheet: `css/pagero.css`
- Copy this stylesheet to new AsciiDoc projects
- Maintains consistent branding across Pagero documentation

### Adding New Country Support
1. **Create country example**: `examples/country-specific-examples/[country]/`
2. **Identify mandatory extensions**: Research local e-invoicing requirements
3. **Update validation rules**: Add country-specific business rules to `PUF-UBL.sch`
4. **Document requirements**: Add to `specification/country-specifics.adoc`
5. **Update specification**: Recompile AsciiDoc to reflect changes

### Specification Updates
1. **Edit AsciiDoc files**: Modify files in `specification/` directory
2. **Regenerate HTML**: Run `asciidoctor -a stylesheet=css/pagero.css -o index.html index.adoc`
3. **Update examples**: Ensure examples reflect specification changes
4. **Validate changes**: Run validation against updated schemas

### Testing New Examples
```bash
# Validate against XSD schema
xmllint --schema xml-schemas/maindoc/UBL-Invoice-2.1.xsd examples/country-specific-examples/[country]/PUF_[Country]_Invoice.xml

# Validate against Schematron rules  
saxon -s:examples/country-specific-examples/[country]/PUF_[Country]_Invoice.xml -xsl:validation-artefacts/PUF-UBL.xslt
```

## Common Implementation Patterns

### Party Information Structure
```xml
<cac:AccountingSupplierParty>
    <cac:Party>
        <cbc:EndpointID schemeID="[scheme]">[identifier]</cbc:EndpointID>  <!-- Country-specific scheme -->
        <cac:PartyName><cbc:Name>[trading_name]</cbc:Name></cac:PartyName>
        <cac:PostalAddress>
            <cbc:StreetName>[street]</cbc:StreetName>
            <cbc:CityName>[city]</cbc:CityName>
            <cbc:PostalZone>[postal_code]</cbc:PostalZone>
            <cac:Country><cbc:IdentificationCode>[ISO_country]</cbc:IdentificationCode></cac:Country>
        </cac:PostalAddress>
        <cac:PartyTaxScheme>
            <cbc:CompanyID>[country_vat_number]</cbc:CompanyID>  <!-- Include country prefix -->
            <cac:TaxScheme><cbc:ID>VAT</cbc:ID></cac:TaxScheme>
        </cac:PartyTaxScheme>
        <cac:PartyLegalEntity>
            <cbc:RegistrationName>[legal_name]</cbc:RegistrationName>
        </cac:PartyLegalEntity>
    </cac:Party>
</cac:AccountingSupplierParty>
```

### Document Identification Pattern
```xml
<cbc:CustomizationID>urn:pagero.com:puf:billing:2.0</cbc:CustomizationID>
<cbc:ProfileID>urn:pagero.com:puf:billing:1.0</cbc:ProfileID>
```

### Best Practices

### When Creating Examples
- Use realistic but anonymized data (company names, addresses, tax numbers)
- Include country-specific mandatory fields even if not in EN 16931
- Include comments explaining country-specific requirements

### Critical Structural Rules
1. **BG Group Compliance**: Always verify BG numbers match EN 16931-1:2017 exactly
2. **Document Type Differences**: Credit Notes require different element placement than Invoices
3. **Due Date Location**: 
   - Invoices: `cbc:DueDate` at document level
   - Credit Notes: `cbc:PaymentDueDate` in PaymentMeans section
4. **Allowances vs Charges**: Use correct BG groups (BG-20 for header level allowances, BG-21 for header level charges, BG-27 for line level allowances, BG-28 for line level charges)

### When Extending PUF
- Always check if existing UBL elements can accommodate the requirement
- Use extensions only when UBL 2.1 lacks suitable elements
- Document the business rationale for extensions
- Consider impact on validation rules

### Documentation Updates
- Update `specification/country-specifics.adoc` for new country requirements
- Include examples that demonstrate the feature usage
- Maintain backward compatibility with existing implementations

## Release Management
- **Minor releases**: Backward compatible (new elements, bug fixes)
- **Major releases**: May break compatibility (3-month advance notice)
- Follow project updates at https://github.com/pagero/puf-billing
- Register at https://pagero.validex.net for major release notifications