<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:u="utils" schemaVersion="iso" queryBinding="xslt2">

    <title>Rules for PUF 1.0 (Pagero Universal Format)</title>

    <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" prefix="cbc"/>
    <ns uri="urn:pagero:CommonAggregateComponents:1.0" prefix="cac"/>
    <ns uri="urn:pagero:ExtensionComponent:1.0" prefix="puf"/>
    <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" prefix="ext"/>
    <ns uri="urn:pagero:PageroUniversalFormat:CreditNote:1.0" prefix="ubl-creditnote"/>
    <ns uri="urn:pagero:PageroUniversalFormat:Invoice:1.0" prefix="ubl-invoice"/>
    <ns uri="http://www.w3.org/2001/XMLSchema" prefix="xs"/>
    <ns uri="utils" prefix="u"/>

    <!--
        Transaction rules
        Syntax: PUF-{NONE|REGION|VERTICAL}-RULENUMBER
        R0XXX - Document level
        R1XXX - Line level 
    -->

    <pattern>
        <!-- Document level -->
        <rule context="ubl-creditnote:CreditNote | ubl-invoice:Invoice">

            <assert id="PUF-R001" test="starts-with(normalize-space(cbc:CustomizationID/text()), 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0#conformant#urn:pagero.com:puf:billing:1.0')" flag="fatal">[PUF-R001]-Specification identifier MUST have the value
                'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0#conformant#urn:pagero.com:puf:billing:1.0'.</assert>

        </rule>

        <rule context="cac:Party/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:PartyExtension']/ext:ExtensionContent/puf:PageroExtension/puf:PartyExtension/puf:RegistrationData">
            <assert id="PUF-R002" test="puf:IDType/@listID = 'PUF-001-REGISTRATIONDATA'" flag="fatal">[PUF-R002]-Attribute listID MUST be 'PUF-001-REGISTRATIONDATA'</assert>
        </rule>

        <!--Existing EN16931 rule BR-CO-16 refactored to not include withholding amount if withholding exist this is checked in Rule PUF-R003-BR-CO-16. If new values that affect payable amount these will need to be exlucded aswell-->
        <rule context="cac:LegalMonetaryTotal">
            <let name="prepaidAmount" value="if (not(cbc:PrepaidAmount)) then '0.00' else cbc:PrepaidAmount"/>
            <let name="PayableRoundingAmount" value="if (not(cbc:PayableRoundingAmount)) then '0.00' else cbc:PayableRoundingAmount"/>
            <let name="PaymentInKind" value="if (not(ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:pagero:ExtensionComponent:1.0:PageroExtension:LegalMonetaryTotalExtension']/ext:ExtensionContent/puf:PageroExtension/puf:LegalMonetaryTotalExtension/puf:PaymentInKind/puf:Amount)) then '0.00' else ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:pagero:ExtensionComponent:1.0:PageroExtension:LegalMonetaryTotalExtension']/ext:ExtensionContent/puf:PageroExtension/puf:LegalMonetaryTotalExtension/puf:PaymentInKind/puf:Amount"/>
            <let name="TaxInclusiveAmount" value="cbc:TaxInclusiveAmount"/>
            <let name="PayableAmount" value="cbc:PayableAmount"/>
            <assert id="BR-CO-16-PUF-R003" test="((round((xs:decimal($PayableAmount) - xs:decimal($PayableRoundingAmount)) * 10 * 10) div 100) = (round((xs:decimal($TaxInclusiveAmount) - xs:decimal($PaymentInKind) - xs:decimal($prepaidAmount)) * 10 * 10) div 100))" flag="fatal">[BR-CO-16-PUF-R003]-Amount due for payment (BT-115) = Invoice total amount with VAT (BT-112) - Paid amount (BT-113) - Payment in kind amount + Rounding amount (BT-114).</assert>
        </rule>

        <!--Existing EN1631 rule BR-S-08 refactored to not check cac:TaxTotal/cac:TaxSubTotal on line level, new rule BR-S-08-PUF-R004 exlude check of line level-->
        <rule context="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S']">
            <assert
                test="every $rate in round(cbc:Percent) satisfies ((exists(//cac:InvoiceLine)
                and (../cbc:TaxableAmount = (sum(../../../cac:InvoiceLine[normalize-space(cac:Item/cac:ClassifiedTaxCategory/cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/round(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount))
                + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator='true'][normalize-space(cac:TaxCategory/cbc:ID)='S'][cac:TaxCategory/round(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))
                - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator='false'][normalize-space(cac:TaxCategory/cbc:ID)='S'][cac:TaxCategory/round(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))
                or (exists(//cac:CreditNoteLine)
                and (../cbc:TaxableAmount = (sum(../../../cac:CreditNoteLine[normalize-space(cac:Item/cac:ClassifiedTaxCategory/cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/round(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount))
                + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator='true'][normalize-space(cac:TaxCategory/cbc:ID)='S'][cac:TaxCategory/round(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))
                - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator='false'][normalize-space(cac:TaxCategory/cbc:ID)='S'][cac:TaxCategory/round(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))))))"
                flag="fatal" id="BR-S-08-PUF-R004">[BR-S-08-PUF-R004]-For each different value of VAT category rate (BT-119) where the VAT category code (BT-118) is "Standard rated", the VAT category taxable amount (BT-116) in a VATBReakdown (BG-23) shall equal the sum of Invoice line net amounts (BT-131) plus the sum of document level charge amounts (BT-99) minus the sum of document level allowance amounts (BT-92) where the VAT category code (BT-151, BT-102, BT-95) is “Standard rated” and the VAT rate (BT-152, BT-103, BT-96) equals the VAT category rate (BT-119).</assert>
        </rule>

        <!--Existing EN1631 rule BR-Z-08 and BR-Z-10 refactored to not check cac:TaxTotal/cac:TaxSubTotal on line level, new rule BR-Z-08-PUF-R005 and BR-Z-10-PUF-R006 exlude check of line level-->
        <rule context="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
            <assert id="BR-Z-08-PUF-R005" flag="fatal"
                test="(exists(//cac:InvoiceLine) 
                and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:LineExtensionAmount)) 
                + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount)) 
                - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount))))) 
                or (exists(//cac:CreditNoteLine) 
                and (xs:decimal(../cbc:TaxableAmount) 
                = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:LineExtensionAmount)) 
                + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount)) 
                - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount)))))"
                >[BR-Z-08-PUF-R005]-In a VAT breakdown (BG-23) where VAT category code (BT-118) is "Zero rated" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amount (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Zero rated".</assert>
            <assert id="BR-Z-10-PUF-R006" flag="fatal" test="not((cbc:TaxExemptionReason) or (cbc:TaxExemptionReasonCode))">[BR-Z-10-PUF-R006]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "Zero rated" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).</assert>
        </rule>

        <!--Existing EN1631 rule BR-E-08 and BR-E-10 refactored to not check cac:TaxTotal/cac:TaxSubTotal on line level, new rule BR-E-08-PUF-R007 and BR-E-10-PUF-R008 exlude check of line level-->
        <rule context="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
            <assert id="BR-E-08-PUF-R007" flag="fatal"
                test="(exists(//cac:InvoiceLine) 
                and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:LineExtensionAmount)) 
                + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) 
                - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount))))) 
                or (exists(//cac:CreditNoteLine) 
                and (xs:decimal(../cbc:TaxableAmount) 
                = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:LineExtensionAmount)) 
                + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) 
                - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)))))"
                >[BR-E-08-PUF-R007]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Exempt from VAT" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Exempt from VAT".</assert>
            <assert id="BR-E-10-PUF-R008" flag="fatal" test="exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode)">[BR-E-10-PUF-R008]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "Exempt from VAT" shall have a VAT exemption reason code (BT-121) or a VAT exemption reason text (BT-120).    </assert>
        </rule>

        <!--Existing EN1631 rule BR-G-08 and BR-G-10 refactored to not check cac:TaxTotal/cac:TaxSubTotal on line level, new rule BR-G-08-PUF-R009 and BR-G-10-PUF-R0010 exlude check of line level-->
        <rule context="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
            <assert id="BR-G-08-PUF-R009" flag="fatal"
                test="(exists(//cac:InvoiceLine) 
                and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:LineExtensionAmount)) 
                + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:Amount)) 
                - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:Amount))))) 
                or (exists(//cac:CreditNoteLine) 
                and (xs:decimal(../cbc:TaxableAmount) 
                = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:LineExtensionAmount)) 
                + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:Amount)) 
                - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:Amount)))))"
                >[BR-G-08-PUF-R009]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Export outside the EU" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Export outside the EU".</assert>
            <assert id="BR-G-10-PUF-R0010" flag="fatal" test="exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode)">[BR-G-10-PUF-R0010]-A VAT breakdown (BG-23) with the VAT Category code (BT-118) "Export outside the EU" shall have a VAT exemption reason code (BT-121), meaning "Export outside the EU" or the VAT exemption reason text (BT-120) "Export outside the EU" (or the equivalent standard text in another language).</assert>
        </rule>

        <!--Existing EN1631 rule BR-IC-08 and BR-IC-10 refactored to not check cac:TaxTotal/cac:TaxSubTotal on line level, new rule BR-IC-08-PUF-R011 and BR-IC-10-PUF-R012 exlude check of line level-->
        <rule context="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
            <assert id="BR-IC-08-PUF-R011" flag="fatal"
                test="(exists(//cac:InvoiceLine) 
                and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:LineExtensionAmount)) 
                + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:Amount)) 
                - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:Amount))))) 
                or (exists(//cac:CreditNoteLine) 
                and (xs:decimal(../cbc:TaxableAmount) 
                = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:LineExtensionAmount)) 
                + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:Amount)) 
                - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:Amount)))))"
                >[BR-IC-08-PUF-R011]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Intra-community supply" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Intra-community supply".</assert>
            <assert id="BR-IC-10-PUF-R012" flag="fatal" test="exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode)">[BR-IC-10-PUF-R012]-A VAT breakdown (BG-23) with the VAT Category code (BT-118) "Intra-community supply" shall have a VAT exemption reason code (BT-121), meaning "Intra-community supply" or the VAT exemption reason text (BT-120) "Intra-community supply" (or the equivalent standard text in another language).</assert>
        </rule>

        <!--Existing EN1631 rule BR-O-08 and BR-O-10 refactored to not check cac:TaxTotal/cac:TaxSubTotal on line level, new rule BR-O-08-PUF-R013 and BR-O-10-PUF-R014 exlude check of line level-->
        <rule context="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
            <assert id="BR-O-08-PUF-R013" flag="fatal"
                test="(exists(//cac:InvoiceLine) 
                and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:LineExtensionAmount)) 
                + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)) 
                - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount))))) 
                or (exists(//cac:CreditNoteLine) 
                and (xs:decimal(../cbc:TaxableAmount) 
                = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:LineExtensionAmount))
                + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)) 
                - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)))))"
                >[BR-O-08-PUF-R013]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is " Not subject to VAT" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Not subject to VAT".</assert>
            <assert id="BR-O-10-PUF-R014" flag="fatal" test="exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode)">[BR-O-10-PUF-R014]-A VAT breakdown (BG-23) with VAT Category code (BT-118) " Not subject to VAT" shall have a VAT exemption reason code (BT-121), meaning " Not subject to VAT" or a VAT exemption reason text (BT-120) " Not subject to VAT" (or the equivalent standard text in another language).</assert>
        </rule>

        <!--Existing EN1631 rule BR-IG-08 and BR-IG-10 refactored to not check cac:TaxTotal/cac:TaxSubTotal on line level, new rule BR-IG-08-PUF-R015 and BR-IG-10-PUF-R016 exlude check of line level-->
        <rule context="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
            <assert id="BR-IG-08-PUF-R015" flag="fatal"
                test="every $rate in xs:decimal(round(cbc:Percent)) satisfies ((exists(//cac:InvoiceLine) 
                and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(round(cbc:Percent)) =$rate]/xs:decimal(cbc:LineExtensionAmount)) 
                + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(round(cbc:Percent)) = $rate]/xs:decimal(cbc:Amount)) 
                - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(round(cbc:Percent)) = $rate]/xs:decimal(cbc:Amount)))) 
                and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(round(cbc:Percent)) =$rate]/xs:decimal(cbc:LineExtensionAmount)) 
                + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(round(cbc:Percent)) = $rate]/xs:decimal(cbc:Amount)) 
                - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(round(cbc:Percent)) = $rate]/xs:decimal(cbc:Amount)))))) 
                or (exists(//cac:CreditNoteLine) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(round(cbc:Percent)) =$rate]/xs:decimal(cbc:LineExtensionAmount)) 
                + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(round(cbc:Percent)) = $rate]/xs:decimal(cbc:Amount)) 
                - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(round(cbc:Percent)) = $rate]/xs:decimal(cbc:Amount)))) 
                and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(round(cbc:Percent)) =$rate]/xs:decimal(cbc:LineExtensionAmount)) 
                + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(round(cbc:Percent)) = $rate]/xs:decimal(cbc:Amount)) 
                - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(round(cbc:Percent)) = $rate]/xs:decimal(cbc:Amount)))))))"
                >[BR-IG-08-PUF-R015]-For each different value of VAT category rate (BT-119) where the VAT category code (BT-118) is "IGIC", the VAT category taxable amount (BT-116) in a VAT breakdown (BG-23) shall equal the sum of Invoice line net amounts (BT-131) plus the sum of document level charge amounts (BT-99) minus the sum of document level allowance amounts (BT-92) where the VAT category code (BT-151, BT-102, BT-95) is "IGIC" and the VAT rate (BT-152, BT-103, BT-96) equals the VAT category rate (BT-119).</assert>
            <assert id="BR-IG-10-PUF-R016" flag="fatal" test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)">[BR-IG-10-PUF-R016]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "IGIC" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).    </assert>
        </rule>

        <!--Existing EN1631 rule BR-IP-08 and BR-IP-10 refactored to not check cac:TaxTotal/cac:TaxSubTotal on line level, new rule BR-IP-08-PUF-R017 and BR-IP-10-PUF-R018 exlude check of line level-->
        <rule context="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
            <assert id="BR-IP-08-PUF-R017" flag="fatal"
                test="every $rate in xs:decimal(round(cbc:Percent)) satisfies ((exists(//cac:InvoiceLine) 
                and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(round(cbc:Percent)) =$rate]/xs:decimal(cbc:LineExtensionAmount)) 
                + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(round(cbc:Percent)) = $rate]/xs:decimal(cbc:Amount)) 
                - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(round(cbc:Percent)) = $rate]/xs:decimal(cbc:Amount)))) 
                and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(round(cbc:Percent)) =$rate]/xs:decimal(cbc:LineExtensionAmount)) 
                + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(round(cbc:Percent)) = $rate]/xs:decimal(cbc:Amount)) 
                - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(round(cbc:Percent)) = $rate]/xs:decimal(cbc:Amount)))))) 
                or (exists(//cac:CreditNoteLine) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(round(cbc:Percent)) =$rate]/xs:decimal(cbc:LineExtensionAmount)) 
                + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(round(cbc:Percent)) = $rate]/xs:decimal(cbc:Amount)) 
                - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(round(cbc:Percent)) = $rate]/xs:decimal(cbc:Amount)))) 
                and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(round(cbc:Percent)) =$rate]/xs:decimal(cbc:LineExtensionAmount)) 
                + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(round(cbc:Percent)) = $rate]/xs:decimal(cbc:Amount)) 
                - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(round(cbc:Percent)) = $rate]/xs:decimal(cbc:Amount)))))))"
                >[BR-IP-08-PUF-R017]-For each different value of VAT category rate (BT-119) where the VAT category code (BT-118) is "IPSI", the VAT category taxable amount (BT-116) in a VAT breakdown (BG-23) shall equal the sum of Invoice line net amounts (BT-131) plus the sum of document level charge amounts (BT-99) minus the sum of document level allowance amounts (BT-92) where the VAT category code (BT-151, BT-102, BT-95) is "IPSI" and the VAT rate (BT-152, BT-103, BT-96) equals the VAT category rate (BT-119).</assert>
            <assert id="BR-IP-10-PUF-R018" flag="fatal" test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)">[BR-IP-10-PUF-R018]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "IPSI" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).     </assert>
        </rule>

        <!--Existing EN1631 rule BR-AE-08 and BR-AE-10 refactored to not check cac:TaxTotal/cac:TaxSubTotal on line level, new rule BR-AE-08-PUF-R019 and BR-AE-10-PUF-R020 exlude check of line level-->
        <rule context="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']">
            <assert id="BR-AE-08-PUF-R019" flag="fatal"
                test="(exists(//cac:InvoiceLine) 
                and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:LineExtensionAmount)) 
                + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:Amount)) 
                - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:Amount))))) 
                or (exists(//cac:CreditNoteLine) 
                and (xs:decimal(../cbc:TaxableAmount) 
                = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:LineExtensionAmount)) 
                + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:Amount)) 
                - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:Amount)))))"
                >[BR-AE-08-PUF-R019]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Reverse charge" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Reverse charge".</assert>
            <assert id="BR-AE-10-PUF-R020" flag="fatal" test="exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode)">[BR-AE-10-PUF-R020]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "Reverse charge" shall have a VAT exemption reason code (BT-121), meaning "Reverse charge" or the VAT exemption reason text (BT-120) "Reverse charge" (or the equivalent standard text in another language).</assert>
        </rule>
    </pattern>

</schema>
