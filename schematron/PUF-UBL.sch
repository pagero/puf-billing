<?xml version="1.0" encoding="UTF-8"?>
<schema queryBinding="xslt2" schemaVersion="iso" xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:u="utils">

    <title>Rules for Pagero Universal Format (PUF) 2.0</title>

    <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
    <ns prefix="cac" uri="urn:pagero:CommonAggregateComponents:1.0"/>
    <ns prefix="puf" uri="urn:pagero:ExtensionComponent:1.0"/>
    <ns prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
    <ns prefix="ubl-creditnote" uri="urn:pagero:PageroUniversalFormat:CreditNote:1.0"/>
    <ns prefix="ubl-invoice" uri="urn:pagero:PageroUniversalFormat:Invoice:1.0"/>
    <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
    <ns prefix="u" uri="utils"/>

    <!--
        Transaction rules
        Syntax: PUF-{NONE|REGION|VERTICAL}-RULENUMBER
        R0XX - Document level
        R1XX - Line level 
    -->

    <pattern>
        <!-- Document level -->
        <rule context="ubl-creditnote:CreditNote | ubl-invoice:Invoice">
            <assert flag="fatal" id="PUF-R001" test="starts-with(normalize-space(cbc:CustomizationID/text()), 'urn:pagero.com:puf:billing:2.0') or starts-with(normalize-space(cbc:CustomizationID/text()), 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0#conformant#urn:pagero.com:puf:billing:1.0')">[PUF-R001]-Customization identifier MUST have the value 'urn:pagero.com:puf:billing:2.0' or 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0#conformant#urn:pagero.com:puf:billing:1.0'.</assert>
            <assert flag="fatal" id="PUF-R002" test="starts-with(normalize-space(cbc:ProfileID/text()), 'urn:pagero.com:puf:billing:1.0')">[PUF-R002]-Profile identifier MUST have the value 'urn:pagero.com:puf:billing:1.0'.</assert>
        </rule>

        <rule context="cac:Party/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:PartyExtension']/ext:ExtensionContent/puf:PageroExtension/puf:PartyExtension/puf:RegistrationData">
            <assert flag="fatal" id="PUF-R003" test="puf:IDType/@listID = 'PUF-001-REGISTRATIONDATA'">[PUF-R003]-Attribute listID MUST be 'PUF-001-REGISTRATIONDATA'</assert>
        </rule>

        <rule context="cac:Party/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:PartyExtension']/ext:ExtensionContent/puf:PageroExtension/puf:PartyExtension/puf:ADAID">
            <assert flag="fatal" id="PUF-R004" test="puf:IDType/@listID = 'PUF-002-ADAID'">[PUF-R004]-Attribute listID MUST be 'PUF-002-ADAID'</assert>
        </rule>

        <rule context="cac:TaxExchangeRate">
            <assert flag="fatal" id="PUF-R005" test="not(normalize-space(cbc:SourceCurrencyCode/text()) = normalize-space(cbc:TargetCurrencyCode/text()))">[PUF-R005]-Source currency code MUST be different from target currency code when tax exchange rate calculation is provided.</assert>
            <assert flag="fatal" id="PUF-R006" test="string(cbc:MathematicOperatorCode) = 'Multiply'">[PUF-R006]-If tax exchange calculation is provided the mathematic operator code MUST equal "Multiply".</assert>
            <assert flag="fatal" id="PUF-R007" test="cbc:CalculationRate">[PUF-R007]-If tax exchange calculation is provided the calculation rate MUST exist.</assert>
            <assert flag="fatal" id="PUF-R008" test="cbc:SourceCurrencyCode and cbc:TargetCurrencyCode">[PUF-R008]-If tax exchange calculation is provided both source and target currency MUST be provided.</assert>
        </rule>

        <rule context="cac:TaxTotal/cac:TaxSubtotal/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:TaxSubtotalExtension']/ext:ExtensionContent/puf:PageroExtension/puf:TaxSubtotalExtension/puf:TaxChargeability">
            <assert flag="fatal" id="PUF-R009" test="cbc:TaxTypeCode = 'I' or cbc:TaxTypeCode = 'S' or cbc:TaxTypeCode = 'D'">[PUF-R009]-Value in tax chargeability MUST be one of the valid codes "S","D" or "I".</assert>
        </rule>

        <rule context="cac:TaxTotal/cac:TaxSubtotal/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:TaxSubtotalExtension']/ext:ExtensionContent/puf:PageroExtension/puf:TaxSubtotalExtension/puf:TaxCurrencyTaxableAmount">
            <assert flag="fatal" id="PUF-R010" test="@currencyID = //cbc:TaxCurrencyCode">[PUF-R010]-Tax currency taxable amounts currency MUST not differ from documents tax currency.</assert>
        </rule>

        <rule context="cac:TaxTotal/cac:TaxSubtotal/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:TaxSubtotalExtension']/ext:ExtensionContent/puf:PageroExtension/puf:TaxSubtotalExtension/puf:TaxCurrencyTaxAmount">
            <assert flag="fatal" id="PUF-R011" test="@currencyID = //cbc:TaxCurrencyCode">[PUF-R011]-Tax currency tax amounts currency MUST not differ from documents tax currency.</assert>
        </rule>

        <rule context="cac:LegalMonetaryTotal/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:LegalMonetaryTotalExtension']/ext:ExtensionContent/puf:PageroExtension/puf:LegalMonetaryTotalExtension/puf:TaxCurrencyTaxExclusiveAmount">
            <assert flag="fatal" id="PUF-R012" test="@currencyID = //cbc:TaxCurrencyCode">[PUF-R012]-Tax currency tax exclusive amounts currency MUST not differ from documents tax currency.</assert>
        </rule>

        <rule context="cac:LegalMonetaryTotal/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:LegalMonetaryTotalExtension']/ext:ExtensionContent/puf:PageroExtension/puf:LegalMonetaryTotalExtension/puf:TaxCurrencyTaxInclusiveAmount">
            <assert flag="fatal" id="PUF-R013" test="@currencyID = //cbc:TaxCurrencyCode">[PUF-R013]-Tax currency tax inclusive amounts currency MUST not differ from documents tax currency.</assert>
        </rule>

        <rule context="cac:LegalMonetaryTotal/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:LegalMonetaryTotalExtension']/ext:ExtensionContent/puf:PageroExtension/puf:LegalMonetaryTotalExtension/puf:TaxCurrencyPayableAmount">
            <assert flag="fatal" id="PUF-R014" test="@currencyID = //cbc:TaxCurrencyCode">[PUF-R014]-Tax currency payable amounts currency MUST not differ from documents tax currency.</assert>
        </rule>

        <rule context="cac:LegalMonetaryTotal/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:LegalMonetaryTotalExtension']/ext:ExtensionContent/puf:PageroExtension/puf:LegalMonetaryTotalExtension/puf:PaymentInKind/puf:Amount">
            <assert flag="fatal" id="PUF-R015" test="@currencyID = //cbc:DocumentCurrencyCode">[PUF-R015]-Payment in kind amount currency MUST not differ from document currency.</assert>
        </rule>

        <rule context="cac:Party/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:PartyExtension']/ext:ExtensionContent/puf:PageroExtension/puf:PartyExtension/puf:RegistrationData/puf:IDType">
            <assert flag="fatal" id="PUF-R016" test="
                    (some $code in tokenize('IT:Ufficio IT:NumeroREA IT:CapitaleSociale IT:SocioUnico IT:StatoLiquidazione ES:Book ES:RegisterOfCompaniesLocation ES:Sheet ES:Folio ES:Section ES:Volume ES:AdditionalRegistrationData FR:DenomSociete FR:TypeSociete FR:CapitalSocial FR:RCSNumber FR:APE', '\s')
                        satisfies normalize-space(text()) = $code)">[PUF-R016]-ID type MUST be a valid type according to list PUF-001-REGISTRATIONDATA.</assert>
        </rule>

        <rule context="cac:Party/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:PartyExtension']/ext:ExtensionContent/puf:PageroExtension/puf:PartyExtension/puf:ADAID/puf:IDType">
            <assert flag="fatal" id="PUF-R017" test="
                (some $code in tokenize('FR:ServiceCode ES:OficinaContable ES:OrganoGestor ES:UnidadTramitadora ES:OrganoProponente GEN:UnitCode', '\s')
                        satisfies normalize-space(text()) = $code)">[PUF-R017]-ID type MUST be a valid type according to list PUF-002-ADAID.</assert>
        </rule>

        <rule context="cac:InvoiceLine/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:LineExtension']/ext:ExtensionContent/puf:PageroExtension/puf:LineExtension/puf:LineExclAllowanceChargeAmount | cac:CreditNoteLine/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:LineExtension']/ext:ExtensionContent/puf:PageroExtension/puf:LineExtension/puf:LineExclAllowanceChargeAmount">
            <assert flag="fatal" id="PUF-R101" test="@currencyID = //cbc:DocumentCurrencyCode">[PUF-R101]-Line exclusive allowance and charge amount currency MUST not differ from document currency.</assert>
        </rule>

        <rule context="cac:InvoiceLine/cac:Price/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:PriceExtension']/ext:ExtensionContent/puf:PageroExtension/puf:PriceExtension/puf:PriceInclAllowanceChargeAmount | cac:CreditNoteLine/cac:Price/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:PriceExtension']/ext:ExtensionContent/puf:PageroExtension/puf:PriceExtension/puf:PriceInclAllowanceChargeAmount">
            <assert flag="fatal" id="PUF-R102" test="@currencyID = //cbc:DocumentCurrencyCode">[PUF-R102]-Price including allowance charge amount currency MUST not differ from document currency.</assert>
        </rule>

        <rule context="cac:InvoiceLine/cac:TaxTotal/cac:TaxSubtotal | cac:CreditNoteLine/cac:TaxTotal/cac:TaxSubtotal">
            <assert flag="fatal" id="PUF-R103" test="cac:TaxCategory/cbc:Percent">[PUF-R103]-If Tax Subtotal exist on line, tax category percent MUST exist.</assert>
            <assert flag="fatal" id="PUF-R104" test="cac:TaxCategory[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:ID">[PUF-R104]-If Tax Subtotal exist on line, VAT category ID MUST exist.</assert>
        </rule>

    </pattern>

</schema>
