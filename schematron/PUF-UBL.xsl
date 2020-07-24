<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet version="2.0" xmlns:cac="urn:pagero:CommonAggregateComponents:1.0" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:puf="urn:pagero:ExtensionComponent:1.0" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:u="utils" xmlns:ubl-creditnote="urn:pagero:PageroUniversalFormat:CreditNote:1.0" xmlns:ubl-invoice="urn:pagero:PageroUniversalFormat:Invoice:1.0" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->
    <xsl:param name="archiveDirParameter"/>
    <xsl:param name="archiveNameParameter"/>
    <xsl:param name="fileNameParameter"/>
    <xsl:param name="fileDirParameter"/>
    <xsl:variable name="document-uri">
        <xsl:value-of select="document-uri(/)"/>
    </xsl:variable>

    <!--PHASES-->


    <!--PROLOG-->
    <xsl:output indent="yes" method="xml" omit-xml-declaration="no" standalone="yes" xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>

    <!--XSD TYPES FOR XSLT2-->


    <!--KEYS AND FUNCTIONS-->


    <!--DEFAULT RULES-->


    <!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
    <!--This mode can be used to generate an ugly though full XPath for locators-->
    <xsl:template match="*" mode="schematron-select-full-path">
        <xsl:apply-templates mode="schematron-get-full-path" select="."/>
    </xsl:template>

    <!--MODE: SCHEMATRON-FULL-PATH-->
    <!--This mode can be used to generate an ugly though full XPath for locators-->
    <xsl:template match="*" mode="schematron-get-full-path">
        <xsl:apply-templates mode="schematron-get-full-path" select="parent::*"/>
        <xsl:text>/</xsl:text>
        <xsl:choose>
            <xsl:when test="namespace-uri() = ''">
                <xsl:value-of select="name()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>*:</xsl:text>
                <xsl:value-of select="local-name()"/>
                <xsl:text>[namespace-uri()='</xsl:text>
                <xsl:value-of select="namespace-uri()"/>
                <xsl:text>']</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:variable name="preceding" select="count(preceding-sibling::*[local-name() = local-name(current()) and namespace-uri() = namespace-uri(current())])"/>
        <xsl:text>[</xsl:text>
        <xsl:value-of select="1 + $preceding"/>
        <xsl:text>]</xsl:text>
    </xsl:template>
    <xsl:template match="@*" mode="schematron-get-full-path">
        <xsl:apply-templates mode="schematron-get-full-path" select="parent::*"/>
        <xsl:text>/</xsl:text>
        <xsl:choose>
            <xsl:when test="namespace-uri() = ''">@<xsl:value-of select="name()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>@*[local-name()='</xsl:text>
                <xsl:value-of select="local-name()"/>
                <xsl:text>' and namespace-uri()='</xsl:text>
                <xsl:value-of select="namespace-uri()"/>
                <xsl:text>']</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--MODE: SCHEMATRON-FULL-PATH-2-->
    <!--This mode can be used to generate prefixed XPath for humans-->
    <xsl:template match="node() | @*" mode="schematron-get-full-path-2">
        <xsl:for-each select="ancestor-or-self::*">
            <xsl:text>/</xsl:text>
            <xsl:value-of select="name(.)"/>
            <xsl:if test="preceding-sibling::*[name(.) = name(current())]">
                <xsl:text>[</xsl:text>
                <xsl:value-of select="count(preceding-sibling::*[name(.) = name(current())]) + 1"/>
                <xsl:text>]</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:if test="not(self::*)">
            <xsl:text/>/@<xsl:value-of select="name(.)"/>
        </xsl:if>
    </xsl:template>
    <!--MODE: SCHEMATRON-FULL-PATH-3-->
    <!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
    <xsl:template match="node() | @*" mode="schematron-get-full-path-3">
        <xsl:for-each select="ancestor-or-self::*">
            <xsl:text>/</xsl:text>
            <xsl:value-of select="name(.)"/>
            <xsl:if test="parent::*">
                <xsl:text>[</xsl:text>
                <xsl:value-of select="count(preceding-sibling::*[name(.) = name(current())]) + 1"/>
                <xsl:text>]</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:if test="not(self::*)">
            <xsl:text/>/@<xsl:value-of select="name(.)"/>
        </xsl:if>
    </xsl:template>

    <!--MODE: GENERATE-ID-FROM-PATH -->
    <xsl:template match="/" mode="generate-id-from-path"/>
    <xsl:template match="text()" mode="generate-id-from-path">
        <xsl:apply-templates mode="generate-id-from-path" select="parent::*"/>
        <xsl:value-of select="concat('.text-', 1 + count(preceding-sibling::text()), '-')"/>
    </xsl:template>
    <xsl:template match="comment()" mode="generate-id-from-path">
        <xsl:apply-templates mode="generate-id-from-path" select="parent::*"/>
        <xsl:value-of select="concat('.comment-', 1 + count(preceding-sibling::comment()), '-')"/>
    </xsl:template>
    <xsl:template match="processing-instruction()" mode="generate-id-from-path">
        <xsl:apply-templates mode="generate-id-from-path" select="parent::*"/>
        <xsl:value-of select="concat('.processing-instruction-', 1 + count(preceding-sibling::processing-instruction()), '-')"/>
    </xsl:template>
    <xsl:template match="@*" mode="generate-id-from-path">
        <xsl:apply-templates mode="generate-id-from-path" select="parent::*"/>
        <xsl:value-of select="concat('.@', name())"/>
    </xsl:template>
    <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
        <xsl:apply-templates mode="generate-id-from-path" select="parent::*"/>
        <xsl:text>.</xsl:text>
        <xsl:value-of select="concat('.', name(), '-', 1 + count(preceding-sibling::*[name() = name(current())]), '-')"/>
    </xsl:template>

    <!--MODE: GENERATE-ID-2 -->
    <xsl:template match="/" mode="generate-id-2">U</xsl:template>
    <xsl:template match="*" mode="generate-id-2" priority="2">
        <xsl:text>U</xsl:text>
        <xsl:number count="*" level="multiple"/>
    </xsl:template>
    <xsl:template match="node()" mode="generate-id-2">
        <xsl:text>U.</xsl:text>
        <xsl:number count="*" level="multiple"/>
        <xsl:text>n</xsl:text>
        <xsl:number count="node()"/>
    </xsl:template>
    <xsl:template match="@*" mode="generate-id-2">
        <xsl:text>U.</xsl:text>
        <xsl:number count="*" level="multiple"/>
        <xsl:text>_</xsl:text>
        <xsl:value-of select="string-length(local-name(.))"/>
        <xsl:text>_</xsl:text>
        <xsl:value-of select="translate(name(), ':', '.')"/>
    </xsl:template>
    <!--Strip characters-->
    <xsl:template match="text()" priority="-1"/>

    <!--SCHEMA SETUP-->
    <xsl:template match="/">
        <svrl:schematron-output schemaVersion="iso" title="Rules for PUF 1.0 (Pagero Universal Format)" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
            <xsl:comment>
            <xsl:value-of select="$archiveDirParameter"/>   
		 <xsl:value-of select="$archiveNameParameter"/>  
		 <xsl:value-of select="$fileNameParameter"/>  
		 <xsl:value-of select="$fileDirParameter"/>
         </xsl:comment>
            <svrl:ns-prefix-in-attribute-values prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
            <svrl:ns-prefix-in-attribute-values prefix="cac" uri="urn:pagero:CommonAggregateComponents:1.0"/>
            <svrl:ns-prefix-in-attribute-values prefix="puf" uri="urn:pagero:ExtensionComponent:1.0"/>
            <svrl:ns-prefix-in-attribute-values prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
            <svrl:ns-prefix-in-attribute-values prefix="ubl-creditnote" uri="urn:pagero:PageroUniversalFormat:CreditNote:1.0"/>
            <svrl:ns-prefix-in-attribute-values prefix="ubl-invoice" uri="urn:pagero:PageroUniversalFormat:Invoice:1.0"/>
            <svrl:ns-prefix-in-attribute-values prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
            <svrl:ns-prefix-in-attribute-values prefix="u" uri="utils"/>
            <svrl:active-pattern>
                <xsl:attribute name="document">
                    <xsl:value-of select="document-uri(/)"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </svrl:active-pattern>
            <xsl:apply-templates mode="M9" select="/"/>
        </svrl:schematron-output>
    </xsl:template>

    <!--SCHEMATRON PATTERNS-->
    <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Rules for PUF 1.0 (Pagero Universal Format)</svrl:text>

    <!--PATTERN -->


    <!--RULE -->
    <xsl:template match="ubl-creditnote:CreditNote | ubl-invoice:Invoice" mode="M9" priority="1025">
        <svrl:fired-rule context="ubl-creditnote:CreditNote | ubl-invoice:Invoice" xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="starts-with(normalize-space(cbc:CustomizationID/text()), 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0#conformant#urn:pagero.com:puf:billing:1.0')"/>
            <xsl:otherwise>
                <svrl:failed-assert test="starts-with(normalize-space(cbc:CustomizationID/text()), 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0#conformant#urn:pagero.com:puf:billing:1.0')" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">PUF-R001</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[PUF-R001]-Customization identifier MUST have the value 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0#conformant#urn:pagero.com:puf:billing:1.0'.</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="starts-with(normalize-space(cbc:ProfileID/text()), 'urn:pagero.com:puf:billing:1.0')"/>
            <xsl:otherwise>
                <svrl:failed-assert test="starts-with(normalize-space(cbc:ProfileID/text()), 'urn:pagero.com:puf:billing:1.0')" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">PUF-R002</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[PUF-R002]-Profile identifier MUST have the value 'urn:pagero.com:puf:billing:1.0'.</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates mode="M9" select="*"/>
    </xsl:template>

    <!--RULE -->
    <xsl:template match="cac:Party/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:PartyExtension']/ext:ExtensionContent/puf:PageroExtension/puf:PartyExtension/puf:RegistrationData" mode="M9" priority="1024">
        <svrl:fired-rule context="cac:Party/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:PartyExtension']/ext:ExtensionContent/puf:PageroExtension/puf:PartyExtension/puf:RegistrationData" xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="puf:IDType/@listID = 'PUF-001-REGISTRATIONDATA'"/>
            <xsl:otherwise>
                <svrl:failed-assert test="puf:IDType/@listID = 'PUF-001-REGISTRATIONDATA'" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">PUF-R003</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[PUF-R003]-Attribute listID MUST be 'PUF-001-REGISTRATIONDATA'</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates mode="M9" select="*"/>
    </xsl:template>

    <!--RULE -->
    <xsl:template match="cac:Party/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:PartyExtension']/ext:ExtensionContent/puf:PageroExtension/puf:PartyExtension/puf:ADAID" mode="M9" priority="1023">
        <svrl:fired-rule context="cac:Party/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:PartyExtension']/ext:ExtensionContent/puf:PageroExtension/puf:PartyExtension/puf:ADAID" xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="puf:IDType/@listID = 'PUF-002-ADAID'"/>
            <xsl:otherwise>
                <svrl:failed-assert test="puf:IDType/@listID = 'PUF-002-ADAID'" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">PUF-R004</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[PUF-R004]-Attribute listID MUST be 'PUF-002-ADAID'</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates mode="M9" select="*"/>
    </xsl:template>

    <!--RULE -->
    <xsl:template match="cac:TaxExchangeRate" mode="M9" priority="1022">
        <svrl:fired-rule context="cac:TaxExchangeRate" xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="not(normalize-space(cbc:SourceCurrencyCode/text()) = normalize-space(cbc:TargetCurrencyCode/text()))"/>
            <xsl:otherwise>
                <svrl:failed-assert test="not(normalize-space(cbc:SourceCurrencyCode/text()) = normalize-space(cbc:TargetCurrencyCode/text()))" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">PUF-R005</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[PUF-R005]-Source currency code MUST be different from target currency code when tax exchange rate calculation is provided.</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="string(cbc:MathematicOperatorCode) = 'Multiply'"/>
            <xsl:otherwise>
                <svrl:failed-assert test="string(cbc:MathematicOperatorCode) = 'Multiply'" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">PUF-R006</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[PUF-R006]-If tax exchange calculation is provided the mathematic operator code MUST equal "Multiply".</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="cbc:CalculationRate"/>
            <xsl:otherwise>
                <svrl:failed-assert test="cbc:CalculationRate" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">PUF-R007</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[PUF-R007]-If tax exchange calculation is provided the calculation rate MUST exist.</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="cbc:SourceCurrencyCode and cbc:TargetCurrencyCode"/>
            <xsl:otherwise>
                <svrl:failed-assert test="cbc:SourceCurrencyCode and cbc:TargetCurrencyCode" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">PUF-R008</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[PUF-R008]-If tax exchange calculation is provided both source and target currency MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates mode="M9" select="*"/>
    </xsl:template>

    <!--RULE -->
    <xsl:template match="cac:TaxTotal/cac:TaxSubtotal/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:TaxSubtotalExtension']/ext:ExtensionContent/puf:PageroExtension/puf:TaxSubtotalExtension/puf:TaxChargeability" mode="M9" priority="1021">
        <svrl:fired-rule context="cac:TaxTotal/cac:TaxSubtotal/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:TaxSubtotalExtension']/ext:ExtensionContent/puf:PageroExtension/puf:TaxSubtotalExtension/puf:TaxChargeability" xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="cbc:TaxTypeCode = 'I' or cbc:TaxTypeCode = 'S' or cbc:TaxTypeCode = 'D'"/>
            <xsl:otherwise>
                <svrl:failed-assert test="cbc:TaxTypeCode = 'I' or cbc:TaxTypeCode = 'S' or cbc:TaxTypeCode = 'D'" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">PUF-R009</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[PUF-R009]-Value in tax chargeability MUST be one of the valid codes "S","D" or "I".</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates mode="M9" select="*"/>
    </xsl:template>

    <!--RULE -->
    <xsl:template match="cac:TaxTotal/cac:TaxSubtotal/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:TaxSubtotalExtension']/ext:ExtensionContent/puf:PageroExtension/puf:TaxSubtotalExtension/puf:TaxCurrencyTaxableAmount" mode="M9" priority="1020">
        <svrl:fired-rule context="cac:TaxTotal/cac:TaxSubtotal/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:TaxSubtotalExtension']/ext:ExtensionContent/puf:PageroExtension/puf:TaxSubtotalExtension/puf:TaxCurrencyTaxableAmount" xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="@currencyID = //cbc:TaxCurrencyCode"/>
            <xsl:otherwise>
                <svrl:failed-assert test="@currencyID = //cbc:TaxCurrencyCode" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">PUF-R010</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[PUF-R010]-Tax currency taxable amounts currency MUST not differ from documents tax currency.</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates mode="M9" select="*"/>
    </xsl:template>

    <!--RULE -->
    <xsl:template match="cac:TaxTotal/cac:TaxSubtotal/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:TaxSubtotalExtension']/ext:ExtensionContent/puf:PageroExtension/puf:TaxSubtotalExtension/puf:TaxCurrencyTaxAmount" mode="M9" priority="1019">
        <svrl:fired-rule context="cac:TaxTotal/cac:TaxSubtotal/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:TaxSubtotalExtension']/ext:ExtensionContent/puf:PageroExtension/puf:TaxSubtotalExtension/puf:TaxCurrencyTaxAmount" xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="@currencyID = //cbc:TaxCurrencyCode"/>
            <xsl:otherwise>
                <svrl:failed-assert test="@currencyID = //cbc:TaxCurrencyCode" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">PUF-R011</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[PUF-R011]-Tax currency tax amounts currency MUST not differ from documents tax currency.</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates mode="M9" select="*"/>
    </xsl:template>

    <!--RULE -->
    <xsl:template match="cac:LegalMonetaryTotal/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:LegalMonetaryTotalExtension']/ext:ExtensionContent/puf:PageroExtension/puf:LegalMonetaryTotalExtension/puf:TaxCurrencyTaxExclusiveAmount" mode="M9" priority="1018">
        <svrl:fired-rule context="cac:LegalMonetaryTotal/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:LegalMonetaryTotalExtension']/ext:ExtensionContent/puf:PageroExtension/puf:LegalMonetaryTotalExtension/puf:TaxCurrencyTaxExclusiveAmount" xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="@currencyID = //cbc:TaxCurrencyCode"/>
            <xsl:otherwise>
                <svrl:failed-assert test="@currencyID = //cbc:TaxCurrencyCode" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">PUF-R012</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[PUF-R012]-Tax currency tax exclusive amounts currency MUST not differ from documents tax currency.</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates mode="M9" select="*"/>
    </xsl:template>

    <!--RULE -->
    <xsl:template match="cac:LegalMonetaryTotal/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:LegalMonetaryTotalExtension']/ext:ExtensionContent/puf:PageroExtension/puf:LegalMonetaryTotalExtension/puf:TaxCurrencyTaxInclusiveAmount" mode="M9" priority="1017">
        <svrl:fired-rule context="cac:LegalMonetaryTotal/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:LegalMonetaryTotalExtension']/ext:ExtensionContent/puf:PageroExtension/puf:LegalMonetaryTotalExtension/puf:TaxCurrencyTaxInclusiveAmount" xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="@currencyID = //cbc:TaxCurrencyCode"/>
            <xsl:otherwise>
                <svrl:failed-assert test="@currencyID = //cbc:TaxCurrencyCode" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">PUF-R013</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[PUF-R013]-Tax currency tax inclusive amounts currency MUST not differ from documents tax currency.</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates mode="M9" select="*"/>
    </xsl:template>

    <!--RULE -->
    <xsl:template match="cac:LegalMonetaryTotal/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:LegalMonetaryTotalExtension']/ext:ExtensionContent/puf:PageroExtension/puf:LegalMonetaryTotalExtension/puf:TaxCurrencyPayableAmount" mode="M9" priority="1016">
        <svrl:fired-rule context="cac:LegalMonetaryTotal/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:LegalMonetaryTotalExtension']/ext:ExtensionContent/puf:PageroExtension/puf:LegalMonetaryTotalExtension/puf:TaxCurrencyPayableAmount" xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="@currencyID = //cbc:TaxCurrencyCode"/>
            <xsl:otherwise>
                <svrl:failed-assert test="@currencyID = //cbc:TaxCurrencyCode" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">PUF-R014</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[PUF-R014]-Tax currency payable amounts currency MUST not differ from documents tax currency.</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates mode="M9" select="*"/>
    </xsl:template>

    <!--RULE -->
    <xsl:template match="cac:LegalMonetaryTotal/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:LegalMonetaryTotalExtension']/ext:ExtensionContent/puf:PageroExtension/puf:LegalMonetaryTotalExtension/puf:PaymentInKind/puf:Amount" mode="M9" priority="1015">
        <svrl:fired-rule context="cac:LegalMonetaryTotal/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:LegalMonetaryTotalExtension']/ext:ExtensionContent/puf:PageroExtension/puf:LegalMonetaryTotalExtension/puf:PaymentInKind/puf:Amount" xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="@currencyID = //cbc:DocumentCurrencyCode"/>
            <xsl:otherwise>
                <svrl:failed-assert test="@currencyID = //cbc:DocumentCurrencyCode" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">PUF-R015</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[PUF-R015]-Payment in kind amount currency MUST not differ from document currency.</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates mode="M9" select="*"/>
    </xsl:template>

    <!--RULE -->
    <xsl:template match="cac:Party/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:PartyExtension']/ext:ExtensionContent/puf:PageroExtension/puf:PartyExtension/puf:RegistrationData/puf:IDType" mode="M9" priority="1014">
        <svrl:fired-rule context="cac:Party/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:PartyExtension']/ext:ExtensionContent/puf:PageroExtension/puf:PartyExtension/puf:RegistrationData/puf:IDType" xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="
                    (some $code in tokenize('IT:Ufficio IT:NumeroREA IT:CapitaleSociale IT:SocioUnico IT:StatoLiquidazione ES:Book ES:RegisterOfCompaniesLocation ES:Sheet ES:Folio ES:Section ES:Volume ES:AdditionalRegistrationData FR:DenomSociete FR:TypeSociete FR:CapitalSocial FR:RCSNumber FR:APE', '\s')
                        satisfies normalize-space(text()) = $code)"/>
            <xsl:otherwise>
                <svrl:failed-assert test="(some $code in tokenize('IT:Ufficio IT:NumeroREA IT:CapitaleSociale IT:SocioUnico IT:StatoLiquidazione ES:Book ES:RegisterOfCompaniesLocation ES:Sheet ES:Folio ES:Section ES:Volume ES:AdditionalRegistrationData FR:DenomSociete FR:TypeSociete FR:CapitalSocial FR:RCSNumber FR:APE', '\s') satisfies normalize-space(text()) = $code)" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">PUF-R016</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[PUF-R016]-ID type MUST be a valid type according to list PUF-001-REGISTRATIONDATA.</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates mode="M9" select="*"/>
    </xsl:template>

    <!--RULE -->
    <xsl:template match="cac:Party/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:PartyExtension']/ext:ExtensionContent/puf:PageroExtension/puf:PartyExtension/puf:ADAID/puf:IDType" mode="M9" priority="1013">
        <svrl:fired-rule context="cac:Party/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:PartyExtension']/ext:ExtensionContent/puf:PageroExtension/puf:PartyExtension/puf:ADAID/puf:IDType" xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="
                    (some $code in tokenize('FR:ServiceCode ES:OficinaContable ES:OrganoGestor ES:UnidadTramitadora ES:OrganoProponente', '\s')
                        satisfies normalize-space(text()) = $code)"/>
            <xsl:otherwise>
                <svrl:failed-assert test="(some $code in tokenize('FR:ServiceCode ES:OficinaContable ES:OrganoGestor ES:UnidadTramitadora ES:OrganoProponente', '\s') satisfies normalize-space(text()) = $code)" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">PUF-R017</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[PUF-R017]-ID type MUST be a valid type according to list PUF-002-ADAID.</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates mode="M9" select="*"/>
    </xsl:template>

    <!--RULE -->
    <xsl:template match="cac:LegalMonetaryTotal" mode="M9" priority="1012">
        <svrl:fired-rule context="cac:LegalMonetaryTotal" xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>
        <xsl:variable name="prepaidAmount" select="
                if (not(cbc:PrepaidAmount)) then
                    '0.00'
                else
                    cbc:PrepaidAmount"/>
        <xsl:variable name="PayableRoundingAmount" select="
                if (not(cbc:PayableRoundingAmount)) then
                    '0.00'
                else
                    cbc:PayableRoundingAmount"/>
        <xsl:variable name="PaymentInKind" select="
                if (not(ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:LegalMonetaryTotalExtension']/ext:ExtensionContent/puf:PageroExtension/puf:LegalMonetaryTotalExtension/puf:PaymentInKind/puf:Amount)) then
                    '0.00'
                else
                    ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:LegalMonetaryTotalExtension']/ext:ExtensionContent/puf:PageroExtension/puf:LegalMonetaryTotalExtension/puf:PaymentInKind/puf:Amount"/>
        <xsl:variable name="TaxInclusiveAmount" select="cbc:TaxInclusiveAmount"/>
        <xsl:variable name="PayableAmount" select="cbc:PayableAmount"/>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="((round((xs:decimal($PayableAmount) - xs:decimal($PayableRoundingAmount)) * 10 * 10) div 100) = (round((xs:decimal($TaxInclusiveAmount) - xs:decimal($PaymentInKind) - xs:decimal($prepaidAmount)) * 10 * 10) div 100))"/>
            <xsl:otherwise>
                <svrl:failed-assert test="((round((xs:decimal($PayableAmount) - xs:decimal($PayableRoundingAmount)) * 10 * 10) div 100) = (round((xs:decimal($TaxInclusiveAmount) - xs:decimal($PaymentInKind) - xs:decimal($prepaidAmount)) * 10 * 10) div 100))" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">BR-CO-16-PUF-OR001</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[BR-CO-16-PUF-OR001]-Amount due for payment (BT-115) = Invoice total amount with VAT (BT-112) - Paid amount (BT-113) - Payment in kind amount + Rounding amount (BT-114).</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates mode="M9" select="*"/>
    </xsl:template>

    <!--RULE -->
    <xsl:template match="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S']" mode="M9" priority="1011">
        <svrl:fired-rule context="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S']" xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when
                test="
                    every $rate in cbc:Percent
                        satisfies (((exists(//cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID) = 'S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate])) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) &gt; (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))) or (exists(//cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID) = 'S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate])) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) &gt; (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))))))"/>
            <xsl:otherwise>
                <svrl:failed-assert
                    test="every $rate in cbc:Percent satisfies (((exists(//cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID) = 'S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate])) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) &gt; (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))) or (exists(//cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID) = 'S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate])) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) &gt; (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))))))"
                    xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">BR-S-08-PUF-OR002</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[BR-S-08-PUF-OR002]-For each different value of VAT category rate (BT-119) where the VAT category code (BT-118) is "Standard rated", the VAT category taxable amount (BT-116) in a VATBReakdown (BG-23) shall equal the sum of Invoice line net amounts (BT-131) plus the sum of document level charge amounts (BT-99) minus the sum of document level allowance amounts (BT-92) where the VAT category code (BT-151, BT-102, BT-95) is “Standard rated” and the VAT rate (BT-152, BT-103, BT-96) equals the VAT category rate (BT-119).</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates mode="M9" select="*"/>
    </xsl:template>

    <!--RULE -->
    <xsl:template match="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT']" mode="M9" priority="1010">
        <svrl:fired-rule context="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT']" xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'Z']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'Z']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'Z']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'Z']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'Z']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'Z']/xs:decimal(cbc:Amount)))))"/>
            <xsl:otherwise>
                <svrl:failed-assert
                    test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'Z']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'Z']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'Z']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'Z']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'Z']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'Z']/xs:decimal(cbc:Amount)))))"
                    xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">BR-Z-08-PUF-OR003</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[BR-Z-08-PUF-OR003]-In a VAT breakdown (BG-23) where VAT category code (BT-118) is "Zero rated" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amount (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Zero rated".</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="not((cbc:TaxExemptionReason) or (cbc:TaxExemptionReasonCode))"/>
            <xsl:otherwise>
                <svrl:failed-assert test="not((cbc:TaxExemptionReason) or (cbc:TaxExemptionReasonCode))" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">BR-Z-10-PUF-OR004</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[BR-Z-10-PUF-OR004]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "Zero rated" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates mode="M9" select="*"/>
    </xsl:template>

    <!--RULE -->
    <xsl:template match="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT']" mode="M9" priority="1009">
        <svrl:fired-rule context="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT']" xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'E']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'E']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'E']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'E']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'E']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'E']/xs:decimal(cbc:Amount)))))"/>
            <xsl:otherwise>
                <svrl:failed-assert
                    test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'E']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'E']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'E']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'E']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'E']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'E']/xs:decimal(cbc:Amount)))))"
                    xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">BR-E-08-PUF-OR005</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[BR-E-08-PUF-OR005]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Exempt from VAT" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Exempt from VAT".</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode)"/>
            <xsl:otherwise>
                <svrl:failed-assert test="exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode)" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">BR-E-10-PUF-OR006</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[BR-E-10-PUF-OR006]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "Exempt from VAT" shall have a VAT exemption reason code (BT-121) or a VAT exemption reason text (BT-120).    </svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates mode="M9" select="*"/>
    </xsl:template>

    <!--RULE -->
    <xsl:template match="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT']" mode="M9" priority="1008">
        <svrl:fired-rule context="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT']" xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'G']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'G']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'G']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'G']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'G']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'G']/xs:decimal(cbc:Amount)))))"/>
            <xsl:otherwise>
                <svrl:failed-assert
                    test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'G']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'G']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'G']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'G']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'G']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'G']/xs:decimal(cbc:Amount)))))"
                    xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">BR-G-08-PUF-OR007</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[BR-G-08-PUF-OR007]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Export outside the EU" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Export outside the EU".</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode)"/>
            <xsl:otherwise>
                <svrl:failed-assert test="exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode)" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">BR-G-10-PUF-OR008</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[BR-G-10-PUF-OR008]-A VAT breakdown (BG-23) with the VAT Category code (BT-118) "Export outside the EU" shall have a VAT exemption reason code (BT-121), meaning "Export outside the EU" or the VAT exemption reason text (BT-120) "Export outside the EU" (or the equivalent standard text in another language).</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates mode="M9" select="*"/>
    </xsl:template>

    <!--RULE -->
    <xsl:template match="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT']" mode="M9" priority="1007">
        <svrl:fired-rule context="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT']" xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'K']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'K']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'K']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'K']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'K']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'K']/xs:decimal(cbc:Amount)))))"/>
            <xsl:otherwise>
                <svrl:failed-assert
                    test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'K']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'K']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'K']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'K']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'K']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'K']/xs:decimal(cbc:Amount)))))"
                    xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">BR-IC-08-PUF-OR009</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[BR-IC-08-PUF-OR009]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Intra-community supply" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Intra-community supply".</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode)"/>
            <xsl:otherwise>
                <svrl:failed-assert test="exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode)" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">BR-IC-10-PUF-OR010</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[BR-IC-10-PUF-OR010]-A VAT breakdown (BG-23) with the VAT Category code (BT-118) "Intra-community supply" shall have a VAT exemption reason code (BT-121), meaning "Intra-community supply" or the VAT exemption reason text (BT-120) "Intra-community supply" (or the equivalent standard text in another language).</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates mode="M9" select="*"/>
    </xsl:template>

    <!--RULE -->
    <xsl:template match="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT']" mode="M9" priority="1006">
        <svrl:fired-rule context="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT']" xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'O']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'O']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'O']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'O']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'O']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'O']/xs:decimal(cbc:Amount)))))"/>
            <xsl:otherwise>
                <svrl:failed-assert
                    test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'O']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'O']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'O']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'O']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'O']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'O']/xs:decimal(cbc:Amount)))))"
                    xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">BR-O-08-PUF-OR011</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[BR-O-08-PUF-OR011]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is " Not subject to VAT" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Not subject to VAT".</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="exists(cbc:TaxExemptionReason) or (exists(cbc:TaxExemptionReasonCode))"/>
            <xsl:otherwise>
                <svrl:failed-assert test="exists(cbc:TaxExemptionReason) or (exists(cbc:TaxExemptionReasonCode))" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">BR-O-10-PUF-OR012</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[BR-O-10-PUF-OR012]-A VAT breakdown (BG-23) with VAT Category code (BT-118) " Not subject to VAT" shall have a VAT exemption reason code (BT-121), meaning " Not subject to VAT" or a VAT exemption reason text (BT-120) " Not subject to VAT" (or the equivalent standard text in another language).</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates mode="M9" select="*"/>
    </xsl:template>

    <!--RULE -->
    <xsl:template match="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT']" mode="M9" priority="1005">
        <svrl:fired-rule context="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT']" xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when
                test="
                    every $rate in xs:decimal(cbc:Percent)
                        satisfies ((exists(//cac:InvoiceLine) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) &gt; (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))) or (exists(//cac:CreditNoteLine) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) &gt; (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))))"/>
            <xsl:otherwise>
                <svrl:failed-assert
                    test="every $rate in xs:decimal(cbc:Percent) satisfies ((exists(//cac:InvoiceLine) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) &gt; (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))) or (exists(//cac:CreditNoteLine) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) &gt; (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))))"
                    xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">BR-IG-08-PUF-OR013</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[BR-IG-08-PUF-OR013]-For each different value of VAT category rate (BT-119) where the VAT category code (BT-118) is "IGIC", the VAT category taxable amount (BT-116) in a VAT breakdown (BG-23) shall equal the sum of Invoice line net amounts (BT-131) plus the sum of document level charge amounts (BT-99) minus the sum of document level allowance amounts (BT-92) where the VAT category code (BT-151, BT-102, BT-95) is "IGIC" and the VAT rate (BT-152, BT-103, BT-96) equals the VAT category rate (BT-119).</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)"/>
            <xsl:otherwise>
                <svrl:failed-assert test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">BR-IG-10-PUF-OR014</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[BR-IG-10-PUF-OR014]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "IGIC" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).    </svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates mode="M9" select="*"/>
    </xsl:template>

    <!--RULE -->
    <xsl:template match="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT']" mode="M9" priority="1004">
        <svrl:fired-rule context="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT']" xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when
                test="
                    every $rate in xs:decimal(cbc:Percent)
                        satisfies ((exists(//cac:InvoiceLine) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) &gt; (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))) or (exists(//cac:CreditNoteLine) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) &gt; (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))))"/>
            <xsl:otherwise>
                <svrl:failed-assert
                    test="every $rate in xs:decimal(cbc:Percent) satisfies ((exists(//cac:InvoiceLine) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) &gt; (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))) or (exists(//cac:CreditNoteLine) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) &gt; (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))))"
                    xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">BR-IP-08-PUF-OR015</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[BR-IP-08-PUF-OR015]-For each different value of VAT category rate (BT-119) where the VAT category code (BT-118) is "IPSI", the VAT category taxable amount (BT-116) in a VAT breakdown (BG-23) shall equal the sum of Invoice line net amounts (BT-131) plus the sum of document level charge amounts (BT-99) minus the sum of document level allowance amounts (BT-92) where the VAT category code (BT-151, BT-102, BT-95) is "IPSI" and the VAT rate (BT-152, BT-103, BT-96) equals the VAT category rate (BT-119).</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)"/>
            <xsl:otherwise>
                <svrl:failed-assert test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">BR-IP-10-PUF-OR016</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[BR-IP-10-PUF-OR016]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "IPSI" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).     </svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates mode="M9" select="*"/>
    </xsl:template>

    <!--RULE -->
    <xsl:template match="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT']" mode="M9" priority="1003">
        <svrl:fired-rule context="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT']" xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'AE']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'AE']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'AE']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'AE']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'AE']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'AE']/xs:decimal(cbc:Amount)))))"/>
            <xsl:otherwise>
                <svrl:failed-assert
                    test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'AE']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'AE']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'AE']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'AE']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'AE']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'AE']/xs:decimal(cbc:Amount)))))"
                    xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">BR-AE-08-PUF-OR017</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[BR-AE-08-PUF-OR017]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Reverse charge" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Reverse charge".</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode)"/>
            <xsl:otherwise>
                <svrl:failed-assert test="exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode)" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">BR-AE-10-PUF-OR018</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[BR-AE-10-PUF-OR018]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "Reverse charge" shall have a VAT exemption reason code (BT-121), meaning "Reverse charge" or the VAT exemption reason text (BT-120) "Reverse charge" (or the equivalent standard text in another language).</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates mode="M9" select="*"/>
    </xsl:template>

    <!--RULE -->
    <xsl:template match="cac:InvoiceLine/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:LineExtension']/ext:ExtensionContent/puf:PageroExtension/puf:LineExtension/puf:LineExclAllowanceChargeAmount | cac:CreditNoteLine/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:LineExtension']/ext:ExtensionContent/puf:PageroExtension/puf:LineExtension/puf:LineExclAllowanceChargeAmount" mode="M9" priority="1002">
        <svrl:fired-rule context="cac:InvoiceLine/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:LineExtension']/ext:ExtensionContent/puf:PageroExtension/puf:LineExtension/puf:LineExclAllowanceChargeAmount | cac:CreditNoteLine/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:LineExtension']/ext:ExtensionContent/puf:PageroExtension/puf:LineExtension/puf:LineExclAllowanceChargeAmount" xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="@currencyID = //cbc:DocumentCurrencyCode"/>
            <xsl:otherwise>
                <svrl:failed-assert test="@currencyID = //cbc:DocumentCurrencyCode" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">PUF-R101</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[PUF-R101]-Line exclusive allowance and charge amount currency MUST not differ from document currency.</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates mode="M9" select="*"/>
    </xsl:template>

    <!--RULE -->
    <xsl:template match="cac:InvoiceLine/cac:Price/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:PriceExtension']/ext:ExtensionContent/puf:PageroExtension/puf:PriceExtension/puf:PriceInclAllowanceChargeAmount | cac:CreditNoteLine/cac:Price/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:PriceExtension']/ext:ExtensionContent/puf:PageroExtension/puf:PriceExtension/puf:PriceInclAllowanceChargeAmount" mode="M9" priority="1001">
        <svrl:fired-rule context="cac:InvoiceLine/cac:Price/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:PriceExtension']/ext:ExtensionContent/puf:PageroExtension/puf:PriceExtension/puf:PriceInclAllowanceChargeAmount | cac:CreditNoteLine/cac:Price/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:PriceExtension']/ext:ExtensionContent/puf:PageroExtension/puf:PriceExtension/puf:PriceInclAllowanceChargeAmount" xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="@currencyID = //cbc:DocumentCurrencyCode"/>
            <xsl:otherwise>
                <svrl:failed-assert test="@currencyID = //cbc:DocumentCurrencyCode" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">PUF-R102</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[PUF-R102]-Price including allowance charge amount currency MUST not differ from document currency.</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates mode="M9" select="*"/>
    </xsl:template>

    <!--RULE -->
    <xsl:template match="cac:InvoiceLine/cac:TaxTotal/cac:TaxSubtotal | cac:CreditNoteLine/cac:TaxTotal/cac:TaxSubtotal" mode="M9" priority="1000">
        <svrl:fired-rule context="cac:InvoiceLine/cac:TaxTotal/cac:TaxSubtotal | cac:CreditNoteLine/cac:TaxTotal/cac:TaxSubtotal" xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="cac:TaxCategory/cbc:Percent"/>
            <xsl:otherwise>
                <svrl:failed-assert test="cac:TaxCategory/cbc:Percent" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">PUF-R103</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[PUF-R103]-If Tax Subtotal exist on line, tax category percent MUST exist.</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>

        <!--ASSERT -->
        <xsl:choose>
            <xsl:when test="cac:TaxCategory[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:ID"/>
            <xsl:otherwise>
                <svrl:failed-assert test="cac:TaxCategory[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:ID" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                    <xsl:attribute name="id">PUF-R104</xsl:attribute>
                    <xsl:attribute name="flag">fatal</xsl:attribute>
                    <xsl:attribute name="location">
                        <xsl:apply-templates mode="schematron-select-full-path" select="."/>
                    </xsl:attribute>
                    <svrl:text>[PUF-R104]-If Tax Subtotal exist on line, VAT category ID MUST exist.</svrl:text>
                </svrl:failed-assert>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates mode="M9" select="*"/>
    </xsl:template>
    <xsl:template match="text()" mode="M9" priority="-1"/>
    <xsl:template match="@* | node()" mode="M9" priority="-2">
        <xsl:apply-templates mode="M9" select="*"/>
    </xsl:template>
</xsl:stylesheet>
