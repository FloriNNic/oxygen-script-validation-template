<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:esp-d2e69903="http://www.example.org/cannot/really/use/XInclude"
                xmlns:esp-d2e69955="http://www.example.org/cannot/really/use/XInclude"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                xmlns:s="http://www.ascc.net/xml/schematron"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:teix="http://www.tei-c.org/ns/Examples"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is 
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
   <xsl:output method="text"/>
   <!--XSD TYPES FOR XSLT2-->
   <!--KEYS AND FUNCTIONS-->
   <!--DEFAULT RULES-->
   <!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path"/>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
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
      <xsl:variable name="preceding"
                    select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/>
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
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
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
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
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
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>
   <!--MODE: GENERATE-ID-2 -->
   <xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters-->
   <xsl:template match="text()" priority="-1"/>
   <!--SCHEMA SETUP-->
   <xsl:template match="/">
      <xsl:apply-templates select="/" mode="M10"/>
      <xsl:apply-templates select="/" mode="M11"/>
      <xsl:apply-templates select="/" mode="M12"/>
      <xsl:apply-templates select="/" mode="M13"/>
      <xsl:apply-templates select="/" mode="M14"/>
      <xsl:apply-templates select="/" mode="M15"/>
      <xsl:apply-templates select="/" mode="M16"/>
      <xsl:apply-templates select="/" mode="M17"/>
      <xsl:apply-templates select="/" mode="M18"/>
      <xsl:apply-templates select="/" mode="M19"/>
      <xsl:apply-templates select="/" mode="M20"/>
      <xsl:apply-templates select="/" mode="M21"/>
      <xsl:apply-templates select="/" mode="M22"/>
      <xsl:apply-templates select="/" mode="M23"/>
      <xsl:apply-templates select="/" mode="M24"/>
      <xsl:apply-templates select="/" mode="M25"/>
      <xsl:apply-templates select="/" mode="M26"/>
      <xsl:apply-templates select="/" mode="M27"/>
      <xsl:apply-templates select="/" mode="M28"/>
      <xsl:apply-templates select="/" mode="M29"/>
      <xsl:apply-templates select="/" mode="M30"/>
      <xsl:apply-templates select="/" mode="M31"/>
      <xsl:apply-templates select="/" mode="M32"/>
      <xsl:apply-templates select="/" mode="M33"/>
      <xsl:apply-templates select="/" mode="M34"/>
      <xsl:apply-templates select="/" mode="M35"/>
      <xsl:apply-templates select="/" mode="M36"/>
      <xsl:apply-templates select="/" mode="M37"/>
      <xsl:apply-templates select="/" mode="M38"/>
      <xsl:apply-templates select="/" mode="M39"/>
      <xsl:apply-templates select="/" mode="M40"/>
      <xsl:apply-templates select="/" mode="M41"/>
      <xsl:apply-templates select="/" mode="M42"/>
      <xsl:apply-templates select="/" mode="M43"/>
      <xsl:apply-templates select="/" mode="M44"/>
      <xsl:apply-templates select="/" mode="M45"/>
      <xsl:apply-templates select="/" mode="M46"/>
      <xsl:apply-templates select="/" mode="M47"/>
      <xsl:apply-templates select="/" mode="M48"/>
      <xsl:apply-templates select="/" mode="M49"/>
      <xsl:apply-templates select="/" mode="M50"/>
      <xsl:apply-templates select="/" mode="M51"/>
      <xsl:apply-templates select="/" mode="M52"/>
      <xsl:apply-templates select="/" mode="M53"/>
      <xsl:apply-templates select="/" mode="M54"/>
      <xsl:apply-templates select="/" mode="M55"/>
      <xsl:apply-templates select="/" mode="M56"/>
      <xsl:apply-templates select="/" mode="M57"/>
      <xsl:apply-templates select="/" mode="M58"/>
      <xsl:apply-templates select="/" mode="M59"/>
      <xsl:apply-templates select="/" mode="M60"/>
      <xsl:apply-templates select="/" mode="M61"/>
      <xsl:apply-templates select="/" mode="M62"/>
      <xsl:apply-templates select="/" mode="M63"/>
      <xsl:apply-templates select="/" mode="M64"/>
      <xsl:apply-templates select="/" mode="M65"/>
      <xsl:apply-templates select="/" mode="M66"/>
      <xsl:apply-templates select="/" mode="M67"/>
      <xsl:apply-templates select="/" mode="M68"/>
      <xsl:apply-templates select="/" mode="M69"/>
      <xsl:apply-templates select="/" mode="M70"/>
      <xsl:apply-templates select="/" mode="M71"/>
      <xsl:apply-templates select="/" mode="M72"/>
      <xsl:apply-templates select="/" mode="M73"/>
      <xsl:apply-templates select="/" mode="M74"/>
      <xsl:apply-templates select="/" mode="M75"/>
      <xsl:apply-templates select="/" mode="M76"/>
      <xsl:apply-templates select="/" mode="M77"/>
      <xsl:apply-templates select="/" mode="M78"/>
      <xsl:apply-templates select="/" mode="M79"/>
      <xsl:apply-templates select="/" mode="M80"/>
      <xsl:apply-templates select="/" mode="M81"/>
      <xsl:apply-templates select="/" mode="M82"/>
      <xsl:apply-templates select="/" mode="M83"/>
      <xsl:apply-templates select="/" mode="M84"/>
      <xsl:apply-templates select="/" mode="M85"/>
      <xsl:apply-templates select="/" mode="M86"/>
      <xsl:apply-templates select="/" mode="M87"/>
      <xsl:apply-templates select="/" mode="M88"/>
      <xsl:apply-templates select="/" mode="M89"/>
      <xsl:apply-templates select="/" mode="M90"/>
      <xsl:apply-templates select="/" mode="M91"/>
      <xsl:apply-templates select="/" mode="M92"/>
      <xsl:apply-templates select="/" mode="M93"/>
      <xsl:apply-templates select="/" mode="M94"/>
      <xsl:apply-templates select="/" mode="M95"/>
      <xsl:apply-templates select="/" mode="M96"/>
      <xsl:apply-templates select="/" mode="M97"/>
      <xsl:apply-templates select="/" mode="M98"/>
      <xsl:apply-templates select="/" mode="M99"/>
      <xsl:apply-templates select="/" mode="M100"/>
      <xsl:apply-templates select="/" mode="M101"/>
      <xsl:apply-templates select="/" mode="M102"/>
      <xsl:apply-templates select="/" mode="M103"/>
      <xsl:apply-templates select="/" mode="M104"/>
      <xsl:apply-templates select="/" mode="M105"/>
   </xsl:template>
   <!--SCHEMATRON PATTERNS-->
   <!--PATTERN schematron-constraint-tei_customization-att.datable.w3c-att-datable-w3c-when-1-->
   <!--RULE -->
   <xsl:template match="tei:*[@when]" priority="1000" mode="M10">

		<!--REPORT nonfatal-->
      <xsl:if test="@notBefore|@notAfter|@from|@to">
         <xsl:message>The @when attribute cannot be used with any other att.datable.w3c attributes. (@notBefore|@notAfter|@from|@to / nonfatal)</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M10"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M10"/>
   <xsl:template match="@*|node()" priority="-2" mode="M10">
      <xsl:apply-templates select="*" mode="M10"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-att.datable.w3c-att-datable-w3c-from-2-->
   <!--RULE -->
   <xsl:template match="tei:*[@from]" priority="1000" mode="M11">

		<!--REPORT nonfatal-->
      <xsl:if test="@notBefore">
         <xsl:message>The @from and @notBefore attributes cannot be used together. (@notBefore / nonfatal)</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M11"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M11"/>
   <xsl:template match="@*|node()" priority="-2" mode="M11">
      <xsl:apply-templates select="*" mode="M11"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-att.datable.w3c-att-datable-w3c-to-3-->
   <!--RULE -->
   <xsl:template match="tei:*[@to]" priority="1000" mode="M12">

		<!--REPORT nonfatal-->
      <xsl:if test="@notAfter">
         <xsl:message>The @to and @notAfter attributes cannot be used together. (@notAfter / nonfatal)</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M12"/>
   <xsl:template match="@*|node()" priority="-2" mode="M12">
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-att.datable-calendar-calendar-4-->
   <!--RULE -->
   <xsl:template match="tei:*[@calendar]" priority="1000" mode="M13">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length(.) gt 0"/>
         <xsl:otherwise>
            <xsl:message> @calendar indicates one or more systems or calendars to
              which the date represented by the content of this element belongs, but this
              <xsl:text/>
               <xsl:value-of select="name(.)"/>
               <xsl:text/> element has no textual content. (string-length(.) gt 0)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M13"/>
   <xsl:template match="@*|node()" priority="-2" mode="M13">
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-att.global.source-source-only_1_ODD_source-5-->
   <!--RULE -->
   <xsl:template match="tei:*/@source" priority="1000" mode="M14">
      <xsl:variable name="srcs" select="tokenize( normalize-space(.),' ')"/>
      <!--REPORT -->
      <xsl:if test="( parent::tei:classRef                               | parent::tei:dataRef                               | parent::tei:elementRef                               | parent::tei:macroRef                               | parent::tei:moduleRef                               | parent::tei:schemaSpec )                               and                               $srcs[2]">
         <xsl:message>
              When used on a schema description element (like
              <xsl:text/>
            <xsl:value-of select="name(..)"/>
            <xsl:text/>), the @source attribute
              should have only 1 value. (This one has <xsl:text/>
            <xsl:value-of select="count($srcs)"/>
            <xsl:text/>.)
             (( parent::tei:classRef | parent::tei:dataRef | parent::tei:elementRef | parent::tei:macroRef | parent::tei:moduleRef | parent::tei:schemaSpec ) and $srcs[2])</xsl:message>
      </xsl:if>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M14"/>
   <xsl:template match="@*|node()" priority="-2" mode="M14">
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-att.global-xmlid-unique_xmlIDs-6-->
   <!--RULE -->
   <xsl:template match="@xml:id" priority="1000" mode="M15">
      <xsl:variable name="myID" select="normalize-space(.)"/>
      <!--REPORT -->
      <xsl:if test="../(ancestor::*|preceding::*)/@xml:id[ normalize-space(.) eq $myID ]">
         <xsl:message>The @xml:id "<xsl:text/>
            <xsl:value-of select="."/>
            <xsl:text/>" on ＜<xsl:text/>
            <xsl:value-of select="name(..)"/>
            <xsl:text/>＞ duplicates an @xml:id found earlier in the document (../(ancestor::*|preceding::*)/@xml:id[ normalize-space(.) eq $myID ])</xsl:message>
      </xsl:if>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M15"/>
   <xsl:template match="@*|node()" priority="-2" mode="M15">
      <xsl:apply-templates select="*" mode="M15"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-att.measurement-att-measurement-unitRef-7-->
   <!--RULE -->
   <xsl:template match="tei:*[@unitRef]" priority="1000" mode="M16">

		<!--REPORT info-->
      <xsl:if test="@unit">
         <xsl:message>The @unit attribute may be unnecessary when @unitRef is present. (@unit / info)</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M16"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M16"/>
   <xsl:template match="@*|node()" priority="-2" mode="M16">
      <xsl:apply-templates select="*" mode="M16"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-att.typed-subtypeTyped-8-->
   <!--RULE -->
   <xsl:template match="tei:*[@subtype]" priority="1000" mode="M17">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@type"/>
         <xsl:otherwise>
            <xsl:message>The <xsl:text/>
               <xsl:value-of select="name(.)"/>
               <xsl:text/> element should not be categorized in detail with @subtype unless also categorized in general with @type (@type)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M17"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M17"/>
   <xsl:template match="@*|node()" priority="-2" mode="M17">
      <xsl:apply-templates select="*" mode="M17"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-att.pointing-targetLang-targetLang-9-->
   <!--RULE -->
   <xsl:template match="tei:*[not(self::tei:schemaSpec)][@targetLang]"
                 priority="1000"
                 mode="M18">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@target"/>
         <xsl:otherwise>
            <xsl:message>@targetLang should only be used on <xsl:text/>
               <xsl:value-of select="name(.)"/>
               <xsl:text/> if @target is specified. (@target)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M18"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M18"/>
   <xsl:template match="@*|node()" priority="-2" mode="M18">
      <xsl:apply-templates select="*" mode="M18"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-att.styleDef-schemeVersion-schemeVersionRequiresScheme-10-->
   <!--RULE -->
   <xsl:template match="tei:*[@schemeVersion]" priority="1000" mode="M19">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@scheme and not(@scheme = 'free')"/>
         <xsl:otherwise>
            <xsl:message>
              @schemeVersion can only be used if @scheme is specified.
             (@scheme and not(@scheme = 'free'))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M19"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M19"/>
   <xsl:template match="@*|node()" priority="-2" mode="M19">
      <xsl:apply-templates select="*" mode="M19"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-p-abstractModel-structure-p-in-ab-or-p-11-->
   <!--RULE -->
   <xsl:template match="tei:p" priority="1000" mode="M20">

		<!--REPORT -->
      <xsl:if test="    (ancestor::tei:ab or ancestor::tei:p)                          and not( ancestor::tei:floatingText                                 |parent::tei:exemplum                                 |parent::tei:item                                 |parent::tei:note                                 |parent::tei:q                                 |parent::tei:quote                                 |parent::tei:remarks                                 |parent::tei:said                                 |parent::tei:sp                                 |parent::tei:stage                                 |parent::tei:cell                                 |parent::tei:figure                                )">
         <xsl:message>
        Abstract model violation: Paragraphs may not occur inside other paragraphs or ab elements.
       ((ancestor::tei:ab or ancestor::tei:p) and not( ancestor::tei:floatingText |parent::tei:exemplum |parent::tei:item |parent::tei:note |parent::tei:q |parent::tei:quote |parent::tei:remarks |parent::tei:said |parent::tei:sp |parent::tei:stage |parent::tei:cell |parent::tei:figure ))</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M20"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M20"/>
   <xsl:template match="@*|node()" priority="-2" mode="M20">
      <xsl:apply-templates select="*" mode="M20"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-p-abstractModel-structure-p-in-l-or-lg-12-->
   <!--RULE -->
   <xsl:template match="tei:p" priority="1000" mode="M21">

		<!--REPORT -->
      <xsl:if test="    (ancestor::tei:l or ancestor::tei:lg)                          and not( ancestor::tei:floatingText                                 |parent::tei:figure                                 |parent::tei:note                                )">
         <xsl:message>
        Abstract model violation: Lines may not contain higher-level structural elements such as div, p, or ab, unless p is a child of figure or note, or is a descendant of floatingText.
       ((ancestor::tei:l or ancestor::tei:lg) and not( ancestor::tei:floatingText |parent::tei:figure |parent::tei:note ))</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M21"/>
   <xsl:template match="@*|node()" priority="-2" mode="M21">
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-desc-deprecationInfo-only-in-deprecated-13-->
   <!--RULE -->
   <xsl:template match="tei:desc[ @type eq 'deprecationInfo']"
                 priority="1000"
                 mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="../@validUntil"/>
         <xsl:otherwise>
            <xsl:message>Information about a
        deprecation should only be present in a specification element
        that is being deprecated: that is, only an element that has a
        @validUntil attribute should have a child &lt;desc
        type="deprecationInfo"&gt;. (../@validUntil)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M22"/>
   <xsl:template match="@*|node()" priority="-2" mode="M22">
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-rt-target-rt-target-not-span-14-->
   <!--RULE -->
   <xsl:template match="tei:rt/@target" priority="1000" mode="M23">

		<!--REPORT -->
      <xsl:if test="../@from | ../@to">
         <xsl:message>When target= is
            present, neither from= nor to= should be. (../@from | ../@to)</xsl:message>
      </xsl:if>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M23"/>
   <xsl:template match="@*|node()" priority="-2" mode="M23">
      <xsl:apply-templates select="*" mode="M23"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-rt-from-rt-from-15-->
   <!--RULE -->
   <xsl:template match="tei:rt/@from" priority="1000" mode="M24">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="../@to"/>
         <xsl:otherwise>
            <xsl:message>When from= is present, the to=
            attribute of <xsl:text/>
               <xsl:value-of select="name(.)"/>
               <xsl:text/> is required. (../@to)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M24"/>
   <xsl:template match="@*|node()" priority="-2" mode="M24">
      <xsl:apply-templates select="*" mode="M24"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-rt-to-rt-to-16-->
   <!--RULE -->
   <xsl:template match="tei:rt/@to" priority="1000" mode="M25">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="../@from"/>
         <xsl:otherwise>
            <xsl:message>When to= is present, the from=
            attribute of <xsl:text/>
               <xsl:value-of select="name(.)"/>
               <xsl:text/> is required. (../@from)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M25"/>
   <xsl:template match="@*|node()" priority="-2" mode="M25">
      <xsl:apply-templates select="*" mode="M25"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-ptr-ptrAtts-17-->
   <!--RULE -->
   <xsl:template match="tei:ptr" priority="1000" mode="M26">

		<!--REPORT -->
      <xsl:if test="@target and @cRef">
         <xsl:message>Only one of the
attributes @target and @cRef may be supplied on <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/>. (@target and @cRef)</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M26"/>
   <xsl:template match="@*|node()" priority="-2" mode="M26">
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-ref-refAtts-18-->
   <!--RULE -->
   <xsl:template match="tei:ref" priority="1000" mode="M27">

		<!--REPORT -->
      <xsl:if test="@target and @cRef">
         <xsl:message>Only one of the
	attributes @target' and @cRef' may be supplied on <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/>
          (@target and @cRef)</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M27"/>
   <xsl:template match="@*|node()" priority="-2" mode="M27">
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-list-gloss-list-must-have-labels-19-->
   <!--RULE -->
   <xsl:template match="tei:list[@type='gloss']" priority="1000" mode="M28">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:label"/>
         <xsl:otherwise>
            <xsl:message>The content of a "gloss" list should include a sequence of one or more pairs of a label element followed by an item element (tei:label)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M28"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M28"/>
   <xsl:template match="@*|node()" priority="-2" mode="M28">
      <xsl:apply-templates select="*" mode="M28"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-relatedItem-targetorcontent1-20-->
   <!--RULE -->
   <xsl:template match="tei:relatedItem" priority="1000" mode="M29">

		<!--REPORT -->
      <xsl:if test="@target and count( child::* ) &gt; 0">
         <xsl:message>
If the @target attribute on <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> is used, the
relatedItem element must be empty (@target and count( child::* ) &gt; 0)</xsl:message>
      </xsl:if>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@target or child::*"/>
         <xsl:otherwise>
            <xsl:message>A relatedItem element should have either a 'target' attribute
        or a child element to indicate the related bibliographic item (@target or child::*)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M29"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M29"/>
   <xsl:template match="@*|node()" priority="-2" mode="M29">
      <xsl:apply-templates select="*" mode="M29"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-citeStructure-delim-citestructure-inner-delim-21-->
   <!--RULE -->
   <xsl:template match="tei:citeStructure[parent::tei:citeStructure]"
                 priority="1000"
                 mode="M30">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@delim"/>
         <xsl:otherwise>
            <xsl:message>A <xsl:text/>
               <xsl:value-of select="name(.)"/>
               <xsl:text/> with a parent <xsl:text/>
               <xsl:value-of select="name(.)"/>
               <xsl:text/> must have a @delim attribute. (@delim)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M30"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M30"/>
   <xsl:template match="@*|node()" priority="-2" mode="M30">
      <xsl:apply-templates select="*" mode="M30"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-citeStructure-match-citestructure-outer-match-22-->
   <!--RULE -->
   <xsl:template match="tei:citeStructure[not(parent::tei:citeStructure)]"
                 priority="1000"
                 mode="M31">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="starts-with(@match,'/')"/>
         <xsl:otherwise>
            <xsl:message>An XPath in @match on the outer <xsl:text/>
               <xsl:value-of select="name(.)"/>
               <xsl:text/> must start with '/'. (starts-with(@match,'/'))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M31"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M31"/>
   <xsl:template match="@*|node()" priority="-2" mode="M31">
      <xsl:apply-templates select="*" mode="M31"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-citeStructure-match-citestructure-inner-match-23-->
   <!--RULE -->
   <xsl:template match="tei:citeStructure[parent::tei:citeStructure]"
                 priority="1000"
                 mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(starts-with(@match,'/'))"/>
         <xsl:otherwise>
            <xsl:message>An XPath in @match must not start with '/' except on the outer <xsl:text/>
               <xsl:value-of select="name(.)"/>
               <xsl:text/>. (not(starts-with(@match,'/')))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M32"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M32"/>
   <xsl:template match="@*|node()" priority="-2" mode="M32">
      <xsl:apply-templates select="*" mode="M32"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-div-abstractModel-structure-div-in-l-or-lg-26-->
   <!--RULE -->
   <xsl:template match="tei:div" priority="1000" mode="M33">

		<!--REPORT -->
      <xsl:if test="(ancestor::tei:l or ancestor::tei:lg) and not(ancestor::tei:floatingText)">
         <xsl:message>
        Abstract model violation: Lines may not contain higher-level structural elements such as div, unless div is a descendant of floatingText.
       ((ancestor::tei:l or ancestor::tei:lg) and not(ancestor::tei:floatingText))</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M33"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M33"/>
   <xsl:template match="@*|node()" priority="-2" mode="M33">
      <xsl:apply-templates select="*" mode="M33"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-div-abstractModel-structure-div-in-ab-or-p-27-->
   <!--RULE -->
   <xsl:template match="tei:div" priority="1000" mode="M34">

		<!--REPORT -->
      <xsl:if test="(ancestor::tei:p or ancestor::tei:ab) and not(ancestor::tei:floatingText)">
         <xsl:message>
        Abstract model violation: p and ab may not contain higher-level structural elements such as div, unless div is a descendant of floatingText.
       ((ancestor::tei:p or ancestor::tei:ab) and not(ancestor::tei:floatingText))</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M34"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M34"/>
   <xsl:template match="@*|node()" priority="-2" mode="M34">
      <xsl:apply-templates select="*" mode="M34"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-att.repeatable-MINandMAXoccurs-28-->
   <!--RULE -->
   <xsl:template match="*[ @minOccurs  and  @maxOccurs ]" priority="1001" mode="M35">
      <xsl:variable name="min" select="@minOccurs cast as xs:integer"/>
      <xsl:variable name="max"
                    select="if ( normalize-space( @maxOccurs ) eq 'unbounded')                         then -1                         else @maxOccurs cast as xs:integer"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$max eq -1  or  $max ge $min"/>
         <xsl:otherwise>
            <xsl:message>@maxOccurs should be greater than or equal to @minOccurs ($max eq -1 or $max ge $min)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M35"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="*[ @minOccurs  and  not( @maxOccurs ) ]"
                 priority="1000"
                 mode="M35">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@minOccurs cast as xs:integer lt 2"/>
         <xsl:otherwise>
            <xsl:message>When @maxOccurs is not specified, @minOccurs must be 0 or 1 (@minOccurs cast as xs:integer lt 2)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M35"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M35"/>
   <xsl:template match="@*|node()" priority="-2" mode="M35">
      <xsl:apply-templates select="*" mode="M35"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-att.identified-spec-in-module-29-->
   <!--RULE -->
   <xsl:template match="tei:elementSpec[@module]|tei:classSpec[@module]|tei:macroSpec[@module]"
                 priority="1000"
                 mode="M36">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="         (not(ancestor::tei:schemaSpec | ancestor::tei:TEI | ancestor::tei:teiCorpus)) or         (not(@module) or          (not(//tei:moduleSpec) and not(//tei:moduleRef))  or         (//tei:moduleSpec[@ident = current()/@module]) or          (//tei:moduleRef[@key = current()/@module]))         "/>
         <xsl:otherwise>
            <xsl:message>
        Specification <xsl:text/>
               <xsl:value-of select="@ident"/>
               <xsl:text/>: the value of the module attribute ("<xsl:text/>
               <xsl:value-of select="@module"/>
               <xsl:text/>") 
should correspond to an existing module, via a moduleSpec or
      moduleRef ((not(ancestor::tei:schemaSpec | ancestor::tei:TEI | ancestor::tei:teiCorpus)) or (not(@module) or (not(//tei:moduleSpec) and not(//tei:moduleRef)) or (//tei:moduleSpec[@ident = current()/@module]) or (//tei:moduleRef[@key = current()/@module])))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M36"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M36"/>
   <xsl:template match="@*|node()" priority="-2" mode="M36">
      <xsl:apply-templates select="*" mode="M36"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-att.deprecated-validUntil-deprecation-two-month-warning-30-->
   <!--RULE -->
   <xsl:template match="tei:*[@validUntil]" priority="1000" mode="M37">
      <xsl:variable name="advance_warning_period"
                    select="current-date() + xs:dayTimeDuration('P60D')"/>
      <xsl:variable name="me_phrase"
                    select="if (@ident)                                                then concat('The ', @ident )                                                else concat('This ',                                                            local-name(.),                                                            ' of ',                                                            ancestor::tei:*[@ident][1]/@ident )"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@validUntil cast as xs:date  ge  current-date()"/>
         <xsl:otherwise>
            <xsl:message>
               <xsl:text/>
               <xsl:value-of select="                  concat( $me_phrase,                          ' construct is outdated (as of ',                          @validUntil,                          '); ODD processors may ignore it, and its use is no longer supported'                        )"/>
               <xsl:text/>
          (@validUntil cast as xs:date ge current-date())</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT nonfatal-->
      <xsl:choose>
         <xsl:when test="@validUntil cast as xs:date  ge  $advance_warning_period"/>
         <xsl:otherwise>
            <xsl:message>
               <xsl:text/>
               <xsl:value-of select="concat( $me_phrase, ' construct becomes outdated on ', @validUntil )"/>
               <xsl:text/>
          (@validUntil cast as xs:date ge $advance_warning_period / nonfatal)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M37"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M37"/>
   <xsl:template match="@*|node()" priority="-2" mode="M37">
      <xsl:apply-templates select="*" mode="M37"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-att.deprecated-validUntil-deprecation-should-be-explained-31-->
   <!--RULE -->
   <xsl:template match="tei:*[@validUntil][ not( self::valDesc | self::valList | self::defaultVal )]"
                 priority="1000"
                 mode="M38">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="child::tei:desc[ @type eq 'deprecationInfo']"/>
         <xsl:otherwise>
            <xsl:message>
              A deprecated construct should include, whenever possible, an explanation, but this <xsl:text/>
               <xsl:value-of select="name(.)"/>
               <xsl:text/> does not have a child &lt;desc type="deprecationInfo"&gt; (child::tei:desc[ @type eq 'deprecationInfo'])</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M38"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M38"/>
   <xsl:template match="@*|node()" priority="-2" mode="M38">
      <xsl:apply-templates select="*" mode="M38"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-moduleRef-if-url-then-prefix-32-->
   <!--RULE -->
   <xsl:template match="tei:moduleRef[ @url ]" priority="1000" mode="M39">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@prefix"/>
         <xsl:otherwise>
            <xsl:message> a ＜moduleRef＞ that uses the url= attribute should
                        have a prefix= attribute, too  (@prefix)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M39"/>
   <xsl:template match="@*|node()" priority="-2" mode="M39">
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-moduleRef-no-duplicate-modules-33-->
   <!--RULE -->
   <xsl:template match="tei:moduleRef[ @key ]" priority="1000" mode="M40">
      <xsl:variable name="mykey" select="@key"/>
      <!--REPORT -->
      <xsl:if test="preceding-sibling::tei:moduleRef[ @key eq $mykey ]">
         <xsl:message>The
                          '<xsl:text/>
            <xsl:value-of select="@key"/>
            <xsl:text/>' module is included (by reference) more
                        than once (preceding-sibling::tei:moduleRef[ @key eq $mykey ])</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M40"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M40"/>
   <xsl:template match="@*|node()" priority="-2" mode="M40">
      <xsl:apply-templates select="*" mode="M40"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-moduleRef-need-required-34-->
   <!--RULE -->
   <xsl:template match="tei:moduleRef[ @except ]" priority="1000" mode="M41">
      <xsl:variable name="exceptions" select="tokenize( @except, '\s+' )"/>
      <!--REPORT -->
      <xsl:if test="'TEI'=$exceptions">
         <xsl:message>Removing ＜TEI＞ from your schema
                      guarantees it is not TEI conformant, and will will likely be outright
                      invalid ('TEI'=$exceptions)</xsl:message>
      </xsl:if>
      <!--REPORT -->
      <xsl:if test="'teiHeader'=$exceptions">
         <xsl:message>Removing ＜teiHeader＞ from your
                      schema guarantees it is not TEI conformant ('teiHeader'=$exceptions)</xsl:message>
      </xsl:if>
      <!--REPORT -->
      <xsl:if test="'fileDesc'=$exceptions">
         <xsl:message>Removing ＜fileDesc＞ from your
                      schema guarantees it is not TEI conformant ('fileDesc'=$exceptions)</xsl:message>
      </xsl:if>
      <!--REPORT -->
      <xsl:if test="'titleStmt'=$exceptions">
         <xsl:message>Removing ＜titleStmt＞ from your
                      schema guarantees it is not TEI conformant ('titleStmt'=$exceptions)</xsl:message>
      </xsl:if>
      <!--REPORT -->
      <xsl:if test="'title'=$exceptions">
         <xsl:message>Removing ＜title＞ from your schema
                      guarantees it is not TEI conformant ('title'=$exceptions)</xsl:message>
      </xsl:if>
      <!--REPORT -->
      <xsl:if test="'publicationStmt'=$exceptions">
         <xsl:message>Removing
                      ＜publicationStmt＞ from your schema guarantees it is not TEI
                      conformant ('publicationStmt'=$exceptions)</xsl:message>
      </xsl:if>
      <!--REPORT -->
      <xsl:if test="'sourceDesc'=$exceptions">
         <xsl:message>Removing ＜sourceDesc＞ from
                      your schema guarantees it is not TEI conformant ('sourceDesc'=$exceptions)</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M41"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M41"/>
   <xsl:template match="@*|node()" priority="-2" mode="M41">
      <xsl:apply-templates select="*" mode="M41"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-moduleRef-include-required-35-->
   <!--RULE -->
   <xsl:template match="tei:moduleRef[ @key eq 'textstructure' and @include ]"
                 priority="1006"
                 mode="M42">
      <xsl:variable name="inclusions" select="tokenize( @include, '\s+' )"/>
      <!--REPORT -->
      <xsl:if test="not('TEI'=$inclusions)">
         <xsl:message>Not including ＜TEI＞ in your
                            schema guarantees it is not TEI conformant, and will likely be outright
                            invalid (not('TEI'=$inclusions))</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M42"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:moduleRef[ @key eq 'header' and @include ]"
                 priority="1005"
                 mode="M42">
      <xsl:variable name="inclusions" select="tokenize( @include, '\s+' )"/>
      <!--REPORT -->
      <xsl:if test="not('teiHeader'=$inclusions)">
         <xsl:message>Not including ＜teiHeader＞
                            in your schema guarantees it is not TEI conformant (not('teiHeader'=$inclusions))</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M42"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:moduleRef[ @key eq 'header' and @include ]"
                 priority="1004"
                 mode="M42">
      <xsl:variable name="inclusions" select="tokenize( @include, '\s+' )"/>
      <!--REPORT -->
      <xsl:if test="not('fileDesc'=$inclusions)">
         <xsl:message>Not including ＜fileDesc＞ in
                            your schema guarantees it is not TEI conformant (not('fileDesc'=$inclusions))</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M42"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:moduleRef[ @key eq 'header' and @include ]"
                 priority="1003"
                 mode="M42">
      <xsl:variable name="inclusions" select="tokenize( @include, '\s+' )"/>
      <!--REPORT -->
      <xsl:if test="not('titleStmt'=$inclusions)">
         <xsl:message>Not including ＜titleStmt＞
                            in your schema guarantees it is not TEI conformant (not('titleStmt'=$inclusions))</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M42"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:moduleRef[ @key eq 'header' and @include ]"
                 priority="1002"
                 mode="M42">
      <xsl:variable name="inclusions" select="tokenize( @include, '\s+' )"/>
      <!--REPORT -->
      <xsl:if test="not('publicationStmt'=$inclusions)">
         <xsl:message>Not including
                            ＜publicationStmt＞ in your schema guarantees it is not TEI
                            conformant (not('publicationStmt'=$inclusions))</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M42"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:moduleRef[ @key eq 'header' and @include ]"
                 priority="1001"
                 mode="M42">
      <xsl:variable name="inclusions" select="tokenize( @include, '\s+' )"/>
      <!--REPORT -->
      <xsl:if test="not('sourceDesc'=$inclusions)">
         <xsl:message>Not including
                            ＜sourceDesc＞ in your schema guarantees it is not TEI
                            conformant (not('sourceDesc'=$inclusions))</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M42"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:moduleRef[ @key eq 'core' and @include ]"
                 priority="1000"
                 mode="M42">
      <xsl:variable name="inclusions" select="tokenize( @include, '\s+' )"/>
      <!--REPORT -->
      <xsl:if test="not('title'=$inclusions)">
         <xsl:message>Not including ＜title＞ in your
                            schema guarantees it is not TEI conformant (not('title'=$inclusions))</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M42"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M42"/>
   <xsl:template match="@*|node()" priority="-2" mode="M42">
      <xsl:apply-templates select="*" mode="M42"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-moduleRef-element-is-in-module-36-->
   <!--RULE -->
   <xsl:template match="tei:moduleRef[@key eq 'header']" priority="1019" mode="M43">
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $include satisfies $gi = ( 'teiHeader', 'fileDesc', 'titleStmt', 'sponsor', 'funder', 'principal', 'editionStmt', 'edition', 'extent', 'publicationStmt', 'distributor', 'authority', 'idno', 'availability', 'licence', 'seriesStmt', 'notesStmt', 'sourceDesc', 'biblFull', 'encodingDesc', 'schemaRef', 'projectDesc', 'samplingDecl', 'editorialDecl', 'correction', 'normalization', 'quotation', 'hyphenation', 'segmentation', 'stdVals', 'interpretation', 'punctuation', 'tagsDecl', 'tagUsage', 'namespace', 'rendition', 'styleDefDecl', 'refsDecl', 'citeStructure', 'citeData', 'cRefPattern', 'prefixDef', 'listPrefixDef', 'refState', 'classDecl', 'taxonomy', 'category', 'catDesc', 'geoDecl', 'unitDecl', 'unitDef', 'conversion', 'appInfo', 'application', 'profileDesc', 'handNote', 'abstract', 'creation', 'langUsage', 'language', 'textClass', 'keywords', 'classCode', 'catRef', 'calendarDesc', 'calendar', 'correspDesc', 'correspAction', 'correspContext', 'xenoData', 'revisionDesc', 'change', 'scriptNote', 'listChange' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements included on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $include satisfies $gi = ( 'teiHeader', 'fileDesc', 'titleStmt', 'sponsor', 'funder', 'principal', 'editionStmt', 'edition', 'extent', 'publicationStmt', 'distributor', 'authority', 'idno', 'availability', 'licence', 'seriesStmt', 'notesStmt', 'sourceDesc', 'biblFull', 'encodingDesc', 'schemaRef', 'projectDesc', 'samplingDecl', 'editorialDecl', 'correction', 'normalization', 'quotation', 'hyphenation', 'segmentation', 'stdVals', 'interpretation', 'punctuation', 'tagsDecl', 'tagUsage', 'namespace', 'rendition', 'styleDefDecl', 'refsDecl', 'citeStructure', 'citeData', 'cRefPattern', 'prefixDef', 'listPrefixDef', 'refState', 'classDecl', 'taxonomy', 'category', 'catDesc', 'geoDecl', 'unitDecl', 'unitDef', 'conversion', 'appInfo', 'application', 'profileDesc', 'handNote', 'abstract', 'creation', 'langUsage', 'language', 'textClass', 'keywords', 'classCode', 'catRef', 'calendarDesc', 'calendar', 'correspDesc', 'correspAction', 'correspContext', 'xenoData', 'revisionDesc', 'change', 'scriptNote', 'listChange' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $except  satisfies $gi = ( 'teiHeader', 'fileDesc', 'titleStmt', 'sponsor', 'funder', 'principal', 'editionStmt', 'edition', 'extent', 'publicationStmt', 'distributor', 'authority', 'idno', 'availability', 'licence', 'seriesStmt', 'notesStmt', 'sourceDesc', 'biblFull', 'encodingDesc', 'schemaRef', 'projectDesc', 'samplingDecl', 'editorialDecl', 'correction', 'normalization', 'quotation', 'hyphenation', 'segmentation', 'stdVals', 'interpretation', 'punctuation', 'tagsDecl', 'tagUsage', 'namespace', 'rendition', 'styleDefDecl', 'refsDecl', 'citeStructure', 'citeData', 'cRefPattern', 'prefixDef', 'listPrefixDef', 'refState', 'classDecl', 'taxonomy', 'category', 'catDesc', 'geoDecl', 'unitDecl', 'unitDef', 'conversion', 'appInfo', 'application', 'profileDesc', 'handNote', 'abstract', 'creation', 'langUsage', 'language', 'textClass', 'keywords', 'classCode', 'catRef', 'calendarDesc', 'calendar', 'correspDesc', 'correspAction', 'correspContext', 'xenoData', 'revisionDesc', 'change', 'scriptNote', 'listChange' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements excepted on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $except satisfies $gi = ( 'teiHeader', 'fileDesc', 'titleStmt', 'sponsor', 'funder', 'principal', 'editionStmt', 'edition', 'extent', 'publicationStmt', 'distributor', 'authority', 'idno', 'availability', 'licence', 'seriesStmt', 'notesStmt', 'sourceDesc', 'biblFull', 'encodingDesc', 'schemaRef', 'projectDesc', 'samplingDecl', 'editorialDecl', 'correction', 'normalization', 'quotation', 'hyphenation', 'segmentation', 'stdVals', 'interpretation', 'punctuation', 'tagsDecl', 'tagUsage', 'namespace', 'rendition', 'styleDefDecl', 'refsDecl', 'citeStructure', 'citeData', 'cRefPattern', 'prefixDef', 'listPrefixDef', 'refState', 'classDecl', 'taxonomy', 'category', 'catDesc', 'geoDecl', 'unitDecl', 'unitDef', 'conversion', 'appInfo', 'application', 'profileDesc', 'handNote', 'abstract', 'creation', 'langUsage', 'language', 'textClass', 'keywords', 'classCode', 'catRef', 'calendarDesc', 'calendar', 'correspDesc', 'correspAction', 'correspContext', 'xenoData', 'revisionDesc', 'change', 'scriptNote', 'listChange' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:moduleRef[@key eq 'core']" priority="1018" mode="M43">
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $include satisfies $gi = ( 'p', 'foreign', 'emph', 'hi', 'distinct', 'said', 'quote', 'q', 'cit', 'mentioned', 'soCalled', 'desc', 'gloss', 'term', 'ruby', 'rb', 'rt', 'sic', 'corr', 'choice', 'reg', 'orig', 'gap', 'ellipsis', 'add', 'del', 'unclear', 'name', 'rs', 'email', 'address', 'addrLine', 'street', 'postCode', 'postBox', 'num', 'measure', 'measureGrp', 'unit', 'date', 'time', 'abbr', 'expan', 'ptr', 'ref', 'list', 'item', 'label', 'head', 'headLabel', 'headItem', 'note', 'noteGrp', 'index', 'media', 'graphic', 'binaryObject', 'milestone', 'gb', 'pb', 'lb', 'cb', 'analytic', 'monogr', 'series', 'author', 'editor', 'respStmt', 'resp', 'title', 'meeting', 'imprint', 'publisher', 'biblScope', 'citedRange', 'pubPlace', 'bibl', 'biblStruct', 'listBibl', 'relatedItem', 'l', 'lg', 'sp', 'speaker', 'stage', 'teiCorpus', 'divGen', 'textLang' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements included on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $include satisfies $gi = ( 'p', 'foreign', 'emph', 'hi', 'distinct', 'said', 'quote', 'q', 'cit', 'mentioned', 'soCalled', 'desc', 'gloss', 'term', 'ruby', 'rb', 'rt', 'sic', 'corr', 'choice', 'reg', 'orig', 'gap', 'ellipsis', 'add', 'del', 'unclear', 'name', 'rs', 'email', 'address', 'addrLine', 'street', 'postCode', 'postBox', 'num', 'measure', 'measureGrp', 'unit', 'date', 'time', 'abbr', 'expan', 'ptr', 'ref', 'list', 'item', 'label', 'head', 'headLabel', 'headItem', 'note', 'noteGrp', 'index', 'media', 'graphic', 'binaryObject', 'milestone', 'gb', 'pb', 'lb', 'cb', 'analytic', 'monogr', 'series', 'author', 'editor', 'respStmt', 'resp', 'title', 'meeting', 'imprint', 'publisher', 'biblScope', 'citedRange', 'pubPlace', 'bibl', 'biblStruct', 'listBibl', 'relatedItem', 'l', 'lg', 'sp', 'speaker', 'stage', 'teiCorpus', 'divGen', 'textLang' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $except  satisfies $gi = ( 'p', 'foreign', 'emph', 'hi', 'distinct', 'said', 'quote', 'q', 'cit', 'mentioned', 'soCalled', 'desc', 'gloss', 'term', 'ruby', 'rb', 'rt', 'sic', 'corr', 'choice', 'reg', 'orig', 'gap', 'ellipsis', 'add', 'del', 'unclear', 'name', 'rs', 'email', 'address', 'addrLine', 'street', 'postCode', 'postBox', 'num', 'measure', 'measureGrp', 'unit', 'date', 'time', 'abbr', 'expan', 'ptr', 'ref', 'list', 'item', 'label', 'head', 'headLabel', 'headItem', 'note', 'noteGrp', 'index', 'media', 'graphic', 'binaryObject', 'milestone', 'gb', 'pb', 'lb', 'cb', 'analytic', 'monogr', 'series', 'author', 'editor', 'respStmt', 'resp', 'title', 'meeting', 'imprint', 'publisher', 'biblScope', 'citedRange', 'pubPlace', 'bibl', 'biblStruct', 'listBibl', 'relatedItem', 'l', 'lg', 'sp', 'speaker', 'stage', 'teiCorpus', 'divGen', 'textLang' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements excepted on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $except satisfies $gi = ( 'p', 'foreign', 'emph', 'hi', 'distinct', 'said', 'quote', 'q', 'cit', 'mentioned', 'soCalled', 'desc', 'gloss', 'term', 'ruby', 'rb', 'rt', 'sic', 'corr', 'choice', 'reg', 'orig', 'gap', 'ellipsis', 'add', 'del', 'unclear', 'name', 'rs', 'email', 'address', 'addrLine', 'street', 'postCode', 'postBox', 'num', 'measure', 'measureGrp', 'unit', 'date', 'time', 'abbr', 'expan', 'ptr', 'ref', 'list', 'item', 'label', 'head', 'headLabel', 'headItem', 'note', 'noteGrp', 'index', 'media', 'graphic', 'binaryObject', 'milestone', 'gb', 'pb', 'lb', 'cb', 'analytic', 'monogr', 'series', 'author', 'editor', 'respStmt', 'resp', 'title', 'meeting', 'imprint', 'publisher', 'biblScope', 'citedRange', 'pubPlace', 'bibl', 'biblStruct', 'listBibl', 'relatedItem', 'l', 'lg', 'sp', 'speaker', 'stage', 'teiCorpus', 'divGen', 'textLang' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:moduleRef[@key eq 'textstructure']"
                 priority="1017"
                 mode="M43">
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $include satisfies $gi = ( 'TEI', 'text', 'body', 'group', 'floatingText', 'div', 'div1', 'div2', 'div3', 'div4', 'div5', 'div6', 'div7', 'trailer', 'byline', 'dateline', 'argument', 'epigraph', 'opener', 'closer', 'salute', 'signed', 'postscript', 'titlePage', 'docTitle', 'titlePart', 'docAuthor', 'imprimatur', 'docEdition', 'docImprint', 'docDate', 'front', 'back' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements included on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $include satisfies $gi = ( 'TEI', 'text', 'body', 'group', 'floatingText', 'div', 'div1', 'div2', 'div3', 'div4', 'div5', 'div6', 'div7', 'trailer', 'byline', 'dateline', 'argument', 'epigraph', 'opener', 'closer', 'salute', 'signed', 'postscript', 'titlePage', 'docTitle', 'titlePart', 'docAuthor', 'imprimatur', 'docEdition', 'docImprint', 'docDate', 'front', 'back' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $except  satisfies $gi = ( 'TEI', 'text', 'body', 'group', 'floatingText', 'div', 'div1', 'div2', 'div3', 'div4', 'div5', 'div6', 'div7', 'trailer', 'byline', 'dateline', 'argument', 'epigraph', 'opener', 'closer', 'salute', 'signed', 'postscript', 'titlePage', 'docTitle', 'titlePart', 'docAuthor', 'imprimatur', 'docEdition', 'docImprint', 'docDate', 'front', 'back' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements excepted on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $except satisfies $gi = ( 'TEI', 'text', 'body', 'group', 'floatingText', 'div', 'div1', 'div2', 'div3', 'div4', 'div5', 'div6', 'div7', 'trailer', 'byline', 'dateline', 'argument', 'epigraph', 'opener', 'closer', 'salute', 'signed', 'postscript', 'titlePage', 'docTitle', 'titlePart', 'docAuthor', 'imprimatur', 'docEdition', 'docImprint', 'docDate', 'front', 'back' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:moduleRef[@key eq 'gaiji']" priority="1016" mode="M43">
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $include satisfies $gi = ( 'g', 'charDecl', 'char', 'glyph', 'localProp', 'mapping', 'unihanProp', 'unicodeProp' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements included on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $include satisfies $gi = ( 'g', 'charDecl', 'char', 'glyph', 'localProp', 'mapping', 'unihanProp', 'unicodeProp' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $except  satisfies $gi = ( 'g', 'charDecl', 'char', 'glyph', 'localProp', 'mapping', 'unihanProp', 'unicodeProp' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements excepted on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $except satisfies $gi = ( 'g', 'charDecl', 'char', 'glyph', 'localProp', 'mapping', 'unihanProp', 'unicodeProp' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:moduleRef[@key eq 'verse']" priority="1015" mode="M43">
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $include satisfies $gi = ( 'metDecl', 'metSym', 'caesura', 'rhyme' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements included on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $include satisfies $gi = ( 'metDecl', 'metSym', 'caesura', 'rhyme' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $except  satisfies $gi = ( 'metDecl', 'metSym', 'caesura', 'rhyme' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements excepted on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $except satisfies $gi = ( 'metDecl', 'metSym', 'caesura', 'rhyme' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:moduleRef[@key eq 'drama']" priority="1014" mode="M43">
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $include satisfies $gi = ( 'set', 'prologue', 'epilogue', 'performance', 'castList', 'castGroup', 'castItem', 'role', 'roleDesc', 'actor', 'spGrp', 'move', 'view', 'camera', 'sound', 'caption', 'tech' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements included on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $include satisfies $gi = ( 'set', 'prologue', 'epilogue', 'performance', 'castList', 'castGroup', 'castItem', 'role', 'roleDesc', 'actor', 'spGrp', 'move', 'view', 'camera', 'sound', 'caption', 'tech' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $except  satisfies $gi = ( 'set', 'prologue', 'epilogue', 'performance', 'castList', 'castGroup', 'castItem', 'role', 'roleDesc', 'actor', 'spGrp', 'move', 'view', 'camera', 'sound', 'caption', 'tech' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements excepted on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $except satisfies $gi = ( 'set', 'prologue', 'epilogue', 'performance', 'castList', 'castGroup', 'castItem', 'role', 'roleDesc', 'actor', 'spGrp', 'move', 'view', 'camera', 'sound', 'caption', 'tech' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:moduleRef[@key eq 'spoken']" priority="1013" mode="M43">
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $include satisfies $gi = ( 'scriptStmt', 'recordingStmt', 'recording', 'equipment', 'broadcast', 'transcriptionDesc', 'u', 'pause', 'vocal', 'kinesic', 'incident', 'writing', 'shift', 'annotationBlock' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements included on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $include satisfies $gi = ( 'scriptStmt', 'recordingStmt', 'recording', 'equipment', 'broadcast', 'transcriptionDesc', 'u', 'pause', 'vocal', 'kinesic', 'incident', 'writing', 'shift', 'annotationBlock' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $except  satisfies $gi = ( 'scriptStmt', 'recordingStmt', 'recording', 'equipment', 'broadcast', 'transcriptionDesc', 'u', 'pause', 'vocal', 'kinesic', 'incident', 'writing', 'shift', 'annotationBlock' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements excepted on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $except satisfies $gi = ( 'scriptStmt', 'recordingStmt', 'recording', 'equipment', 'broadcast', 'transcriptionDesc', 'u', 'pause', 'vocal', 'kinesic', 'incident', 'writing', 'shift', 'annotationBlock' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:moduleRef[@key eq 'dictionaries']"
                 priority="1012"
                 mode="M43">
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $include satisfies $gi = ( 'superEntry', 'entry', 'entryFree', 'hom', 'sense', 'dictScrap', 'form', 'orth', 'pron', 'hyph', 'syll', 'stress', 'gram', 'gen', 'number', 'case', 'per', 'tns', 'mood', 'iType', 'gramGrp', 'pos', 'subc', 'colloc', 'def', 'etym', 'lang', 'usg', 'lbl', 'xr', 're', 'oRef', 'pRef' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements included on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $include satisfies $gi = ( 'superEntry', 'entry', 'entryFree', 'hom', 'sense', 'dictScrap', 'form', 'orth', 'pron', 'hyph', 'syll', 'stress', 'gram', 'gen', 'number', 'case', 'per', 'tns', 'mood', 'iType', 'gramGrp', 'pos', 'subc', 'colloc', 'def', 'etym', 'lang', 'usg', 'lbl', 'xr', 're', 'oRef', 'pRef' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $except  satisfies $gi = ( 'superEntry', 'entry', 'entryFree', 'hom', 'sense', 'dictScrap', 'form', 'orth', 'pron', 'hyph', 'syll', 'stress', 'gram', 'gen', 'number', 'case', 'per', 'tns', 'mood', 'iType', 'gramGrp', 'pos', 'subc', 'colloc', 'def', 'etym', 'lang', 'usg', 'lbl', 'xr', 're', 'oRef', 'pRef' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements excepted on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $except satisfies $gi = ( 'superEntry', 'entry', 'entryFree', 'hom', 'sense', 'dictScrap', 'form', 'orth', 'pron', 'hyph', 'syll', 'stress', 'gram', 'gen', 'number', 'case', 'per', 'tns', 'mood', 'iType', 'gramGrp', 'pos', 'subc', 'colloc', 'def', 'etym', 'lang', 'usg', 'lbl', 'xr', 're', 'oRef', 'pRef' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:moduleRef[@key eq 'msdescription']"
                 priority="1011"
                 mode="M43">
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $include satisfies $gi = ( 'msDesc', 'catchwords', 'dimensions', 'dim', 'height', 'depth', 'width', 'heraldry', 'locus', 'locusGrp', 'material', 'objectType', 'origDate', 'origPlace', 'secFol', 'signatures', 'stamp', 'watermark', 'msIdentifier', 'institution', 'repository', 'collection', 'altIdentifier', 'msName', 'colophon', 'explicit', 'filiation', 'finalRubric', 'incipit', 'msContents', 'msItem', 'msItemStruct', 'rubric', 'summary', 'physDesc', 'objectDesc', 'supportDesc', 'support', 'collation', 'foliation', 'condition', 'layoutDesc', 'layout', 'handDesc', 'typeDesc', 'typeNote', 'scriptDesc', 'musicNotation', 'decoDesc', 'decoNote', 'additions', 'bindingDesc', 'binding', 'sealDesc', 'seal', 'accMat', 'history', 'origin', 'provenance', 'acquisition', 'additional', 'adminInfo', 'recordHist', 'source', 'custodialHist', 'custEvent', 'surrogates', 'msPart', 'msFrag' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements included on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $include satisfies $gi = ( 'msDesc', 'catchwords', 'dimensions', 'dim', 'height', 'depth', 'width', 'heraldry', 'locus', 'locusGrp', 'material', 'objectType', 'origDate', 'origPlace', 'secFol', 'signatures', 'stamp', 'watermark', 'msIdentifier', 'institution', 'repository', 'collection', 'altIdentifier', 'msName', 'colophon', 'explicit', 'filiation', 'finalRubric', 'incipit', 'msContents', 'msItem', 'msItemStruct', 'rubric', 'summary', 'physDesc', 'objectDesc', 'supportDesc', 'support', 'collation', 'foliation', 'condition', 'layoutDesc', 'layout', 'handDesc', 'typeDesc', 'typeNote', 'scriptDesc', 'musicNotation', 'decoDesc', 'decoNote', 'additions', 'bindingDesc', 'binding', 'sealDesc', 'seal', 'accMat', 'history', 'origin', 'provenance', 'acquisition', 'additional', 'adminInfo', 'recordHist', 'source', 'custodialHist', 'custEvent', 'surrogates', 'msPart', 'msFrag' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $except  satisfies $gi = ( 'msDesc', 'catchwords', 'dimensions', 'dim', 'height', 'depth', 'width', 'heraldry', 'locus', 'locusGrp', 'material', 'objectType', 'origDate', 'origPlace', 'secFol', 'signatures', 'stamp', 'watermark', 'msIdentifier', 'institution', 'repository', 'collection', 'altIdentifier', 'msName', 'colophon', 'explicit', 'filiation', 'finalRubric', 'incipit', 'msContents', 'msItem', 'msItemStruct', 'rubric', 'summary', 'physDesc', 'objectDesc', 'supportDesc', 'support', 'collation', 'foliation', 'condition', 'layoutDesc', 'layout', 'handDesc', 'typeDesc', 'typeNote', 'scriptDesc', 'musicNotation', 'decoDesc', 'decoNote', 'additions', 'bindingDesc', 'binding', 'sealDesc', 'seal', 'accMat', 'history', 'origin', 'provenance', 'acquisition', 'additional', 'adminInfo', 'recordHist', 'source', 'custodialHist', 'custEvent', 'surrogates', 'msPart', 'msFrag' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements excepted on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $except satisfies $gi = ( 'msDesc', 'catchwords', 'dimensions', 'dim', 'height', 'depth', 'width', 'heraldry', 'locus', 'locusGrp', 'material', 'objectType', 'origDate', 'origPlace', 'secFol', 'signatures', 'stamp', 'watermark', 'msIdentifier', 'institution', 'repository', 'collection', 'altIdentifier', 'msName', 'colophon', 'explicit', 'filiation', 'finalRubric', 'incipit', 'msContents', 'msItem', 'msItemStruct', 'rubric', 'summary', 'physDesc', 'objectDesc', 'supportDesc', 'support', 'collation', 'foliation', 'condition', 'layoutDesc', 'layout', 'handDesc', 'typeDesc', 'typeNote', 'scriptDesc', 'musicNotation', 'decoDesc', 'decoNote', 'additions', 'bindingDesc', 'binding', 'sealDesc', 'seal', 'accMat', 'history', 'origin', 'provenance', 'acquisition', 'additional', 'adminInfo', 'recordHist', 'source', 'custodialHist', 'custEvent', 'surrogates', 'msPart', 'msFrag' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:moduleRef[@key eq 'transcr']" priority="1010" mode="M43">
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $include satisfies $gi = ( 'facsimile', 'sourceDoc', 'surface', 'surfaceGrp', 'zone', 'path', 'addSpan', 'damage', 'damageSpan', 'delSpan', 'ex', 'fw', 'handNotes', 'handShift', 'am', 'restore', 'space', 'subst', 'substJoin', 'supplied', 'surplus', 'secl', 'line', 'listTranspose', 'metamark', 'mod', 'redo', 'retrace', 'transpose', 'undo' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements included on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $include satisfies $gi = ( 'facsimile', 'sourceDoc', 'surface', 'surfaceGrp', 'zone', 'path', 'addSpan', 'damage', 'damageSpan', 'delSpan', 'ex', 'fw', 'handNotes', 'handShift', 'am', 'restore', 'space', 'subst', 'substJoin', 'supplied', 'surplus', 'secl', 'line', 'listTranspose', 'metamark', 'mod', 'redo', 'retrace', 'transpose', 'undo' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $except  satisfies $gi = ( 'facsimile', 'sourceDoc', 'surface', 'surfaceGrp', 'zone', 'path', 'addSpan', 'damage', 'damageSpan', 'delSpan', 'ex', 'fw', 'handNotes', 'handShift', 'am', 'restore', 'space', 'subst', 'substJoin', 'supplied', 'surplus', 'secl', 'line', 'listTranspose', 'metamark', 'mod', 'redo', 'retrace', 'transpose', 'undo' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements excepted on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $except satisfies $gi = ( 'facsimile', 'sourceDoc', 'surface', 'surfaceGrp', 'zone', 'path', 'addSpan', 'damage', 'damageSpan', 'delSpan', 'ex', 'fw', 'handNotes', 'handShift', 'am', 'restore', 'space', 'subst', 'substJoin', 'supplied', 'surplus', 'secl', 'line', 'listTranspose', 'metamark', 'mod', 'redo', 'retrace', 'transpose', 'undo' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:moduleRef[@key eq 'textcrit']"
                 priority="1009"
                 mode="M43">
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $include satisfies $gi = ( 'app', 'listApp', 'lem', 'rdg', 'rdgGrp', 'witDetail', 'wit', 'listWit', 'witness', 'witStart', 'witEnd', 'lacunaStart', 'lacunaEnd', 'variantEncoding' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements included on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $include satisfies $gi = ( 'app', 'listApp', 'lem', 'rdg', 'rdgGrp', 'witDetail', 'wit', 'listWit', 'witness', 'witStart', 'witEnd', 'lacunaStart', 'lacunaEnd', 'variantEncoding' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $except  satisfies $gi = ( 'app', 'listApp', 'lem', 'rdg', 'rdgGrp', 'witDetail', 'wit', 'listWit', 'witness', 'witStart', 'witEnd', 'lacunaStart', 'lacunaEnd', 'variantEncoding' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements excepted on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $except satisfies $gi = ( 'app', 'listApp', 'lem', 'rdg', 'rdgGrp', 'witDetail', 'wit', 'listWit', 'witness', 'witStart', 'witEnd', 'lacunaStart', 'lacunaEnd', 'variantEncoding' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:moduleRef[@key eq 'namesdates']"
                 priority="1008"
                 mode="M43">
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $include satisfies $gi = ( 'orgName', 'persName', 'surname', 'forename', 'genName', 'nameLink', 'addName', 'roleName', 'placeName', 'bloc', 'country', 'region', 'settlement', 'district', 'offset', 'geogName', 'geogFeat', 'affiliation', 'age', 'birth', 'climate', 'death', 'education', 'event', 'faith', 'floruit', 'geo', 'langKnowledge', 'langKnown', 'listOrg', 'listEvent', 'listPerson', 'listPlace', 'listRelation', 'location', 'nationality', 'occupation', 'org', 'person', 'persona', 'personGrp', 'persPronouns', 'place', 'population', 'relation', 'residence', 'sex', 'socecStatus', 'state', 'terrain', 'trait', 'objectName', 'object', 'listObject', 'objectIdentifier', 'nym', 'listNym' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements included on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $include satisfies $gi = ( 'orgName', 'persName', 'surname', 'forename', 'genName', 'nameLink', 'addName', 'roleName', 'placeName', 'bloc', 'country', 'region', 'settlement', 'district', 'offset', 'geogName', 'geogFeat', 'affiliation', 'age', 'birth', 'climate', 'death', 'education', 'event', 'faith', 'floruit', 'geo', 'langKnowledge', 'langKnown', 'listOrg', 'listEvent', 'listPerson', 'listPlace', 'listRelation', 'location', 'nationality', 'occupation', 'org', 'person', 'persona', 'personGrp', 'persPronouns', 'place', 'population', 'relation', 'residence', 'sex', 'socecStatus', 'state', 'terrain', 'trait', 'objectName', 'object', 'listObject', 'objectIdentifier', 'nym', 'listNym' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $except  satisfies $gi = ( 'orgName', 'persName', 'surname', 'forename', 'genName', 'nameLink', 'addName', 'roleName', 'placeName', 'bloc', 'country', 'region', 'settlement', 'district', 'offset', 'geogName', 'geogFeat', 'affiliation', 'age', 'birth', 'climate', 'death', 'education', 'event', 'faith', 'floruit', 'geo', 'langKnowledge', 'langKnown', 'listOrg', 'listEvent', 'listPerson', 'listPlace', 'listRelation', 'location', 'nationality', 'occupation', 'org', 'person', 'persona', 'personGrp', 'persPronouns', 'place', 'population', 'relation', 'residence', 'sex', 'socecStatus', 'state', 'terrain', 'trait', 'objectName', 'object', 'listObject', 'objectIdentifier', 'nym', 'listNym' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements excepted on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $except satisfies $gi = ( 'orgName', 'persName', 'surname', 'forename', 'genName', 'nameLink', 'addName', 'roleName', 'placeName', 'bloc', 'country', 'region', 'settlement', 'district', 'offset', 'geogName', 'geogFeat', 'affiliation', 'age', 'birth', 'climate', 'death', 'education', 'event', 'faith', 'floruit', 'geo', 'langKnowledge', 'langKnown', 'listOrg', 'listEvent', 'listPerson', 'listPlace', 'listRelation', 'location', 'nationality', 'occupation', 'org', 'person', 'persona', 'personGrp', 'persPronouns', 'place', 'population', 'relation', 'residence', 'sex', 'socecStatus', 'state', 'terrain', 'trait', 'objectName', 'object', 'listObject', 'objectIdentifier', 'nym', 'listNym' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:moduleRef[@key eq 'figures']" priority="1007" mode="M43">
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $include satisfies $gi = ( 'table', 'row', 'cell', 'formula', 'notatedMusic', 'figure', 'figDesc' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements included on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $include satisfies $gi = ( 'table', 'row', 'cell', 'formula', 'notatedMusic', 'figure', 'figDesc' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $except  satisfies $gi = ( 'table', 'row', 'cell', 'formula', 'notatedMusic', 'figure', 'figDesc' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements excepted on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $except satisfies $gi = ( 'table', 'row', 'cell', 'formula', 'notatedMusic', 'figure', 'figDesc' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:moduleRef[@key eq 'corpus']" priority="1006" mode="M43">
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $include satisfies $gi = ( 'textDesc', 'particDesc', 'settingDesc', 'channel', 'constitution', 'derivation', 'domain', 'factuality', 'interaction', 'preparedness', 'purpose', 'setting', 'locale', 'activity' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements included on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $include satisfies $gi = ( 'textDesc', 'particDesc', 'settingDesc', 'channel', 'constitution', 'derivation', 'domain', 'factuality', 'interaction', 'preparedness', 'purpose', 'setting', 'locale', 'activity' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $except  satisfies $gi = ( 'textDesc', 'particDesc', 'settingDesc', 'channel', 'constitution', 'derivation', 'domain', 'factuality', 'interaction', 'preparedness', 'purpose', 'setting', 'locale', 'activity' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements excepted on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $except satisfies $gi = ( 'textDesc', 'particDesc', 'settingDesc', 'channel', 'constitution', 'derivation', 'domain', 'factuality', 'interaction', 'preparedness', 'purpose', 'setting', 'locale', 'activity' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:moduleRef[@key eq 'linking']" priority="1005" mode="M43">
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $include satisfies $gi = ( 'link', 'linkGrp', 'ab', 'anchor', 'seg', 'when', 'timeline', 'join', 'joinGrp', 'alt', 'altGrp', 'standOff', 'listAnnotation', 'annotation' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements included on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $include satisfies $gi = ( 'link', 'linkGrp', 'ab', 'anchor', 'seg', 'when', 'timeline', 'join', 'joinGrp', 'alt', 'altGrp', 'standOff', 'listAnnotation', 'annotation' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $except  satisfies $gi = ( 'link', 'linkGrp', 'ab', 'anchor', 'seg', 'when', 'timeline', 'join', 'joinGrp', 'alt', 'altGrp', 'standOff', 'listAnnotation', 'annotation' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements excepted on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $except satisfies $gi = ( 'link', 'linkGrp', 'ab', 'anchor', 'seg', 'when', 'timeline', 'join', 'joinGrp', 'alt', 'altGrp', 'standOff', 'listAnnotation', 'annotation' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:moduleRef[@key eq 'analysis']"
                 priority="1004"
                 mode="M43">
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $include satisfies $gi = ( 's', 'cl', 'phr', 'w', 'm', 'c', 'pc', 'span', 'spanGrp', 'interp', 'interpGrp' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements included on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $include satisfies $gi = ( 's', 'cl', 'phr', 'w', 'm', 'c', 'pc', 'span', 'spanGrp', 'interp', 'interpGrp' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $except  satisfies $gi = ( 's', 'cl', 'phr', 'w', 'm', 'c', 'pc', 'span', 'spanGrp', 'interp', 'interpGrp' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements excepted on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $except satisfies $gi = ( 's', 'cl', 'phr', 'w', 'm', 'c', 'pc', 'span', 'spanGrp', 'interp', 'interpGrp' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:moduleRef[@key eq 'iso-fs']" priority="1003" mode="M43">
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $include satisfies $gi = ( 'fsdDecl', 'fsDecl', 'fsDescr', 'fsdLink', 'fDecl', 'fDescr', 'vRange', 'vDefault', 'if', 'then', 'fsConstraints', 'cond', 'bicond', 'iff', 'fs', 'f', 'binary', 'symbol', 'numeric', 'string', 'vLabel', 'vColl', 'default', 'vAlt', 'vNot', 'vMerge', 'fLib', 'fvLib' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements included on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $include satisfies $gi = ( 'fsdDecl', 'fsDecl', 'fsDescr', 'fsdLink', 'fDecl', 'fDescr', 'vRange', 'vDefault', 'if', 'then', 'fsConstraints', 'cond', 'bicond', 'iff', 'fs', 'f', 'binary', 'symbol', 'numeric', 'string', 'vLabel', 'vColl', 'default', 'vAlt', 'vNot', 'vMerge', 'fLib', 'fvLib' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $except  satisfies $gi = ( 'fsdDecl', 'fsDecl', 'fsDescr', 'fsdLink', 'fDecl', 'fDescr', 'vRange', 'vDefault', 'if', 'then', 'fsConstraints', 'cond', 'bicond', 'iff', 'fs', 'f', 'binary', 'symbol', 'numeric', 'string', 'vLabel', 'vColl', 'default', 'vAlt', 'vNot', 'vMerge', 'fLib', 'fvLib' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements excepted on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $except satisfies $gi = ( 'fsdDecl', 'fsDecl', 'fsDescr', 'fsdLink', 'fDecl', 'fDescr', 'vRange', 'vDefault', 'if', 'then', 'fsConstraints', 'cond', 'bicond', 'iff', 'fs', 'f', 'binary', 'symbol', 'numeric', 'string', 'vLabel', 'vColl', 'default', 'vAlt', 'vNot', 'vMerge', 'fLib', 'fvLib' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:moduleRef[@key eq 'nets']" priority="1002" mode="M43">
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $include satisfies $gi = ( 'graph', 'node', 'arc', 'tree', 'root', 'iNode', 'leaf', 'eTree', 'triangle', 'eLeaf', 'forest', 'listForest' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements included on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $include satisfies $gi = ( 'graph', 'node', 'arc', 'tree', 'root', 'iNode', 'leaf', 'eTree', 'triangle', 'eLeaf', 'forest', 'listForest' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $except  satisfies $gi = ( 'graph', 'node', 'arc', 'tree', 'root', 'iNode', 'leaf', 'eTree', 'triangle', 'eLeaf', 'forest', 'listForest' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements excepted on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $except satisfies $gi = ( 'graph', 'node', 'arc', 'tree', 'root', 'iNode', 'leaf', 'eTree', 'triangle', 'eLeaf', 'forest', 'listForest' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:moduleRef[@key eq 'certainty']"
                 priority="1001"
                 mode="M43">
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $include satisfies $gi = ( 'precision', 'certainty', 'respons' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements included on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $include satisfies $gi = ( 'precision', 'certainty', 'respons' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $except  satisfies $gi = ( 'precision', 'certainty', 'respons' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements excepted on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $except satisfies $gi = ( 'precision', 'certainty', 'respons' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:moduleRef[@key eq 'tagdocs']" priority="1000" mode="M43">
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $include satisfies $gi = ( 'att', 'code', 'eg', 'egXML', 'gi', 'ident', 'tag', 'val', 'specList', 'specDesc', 'classRef', 'elementRef', 'macroRef', 'moduleRef', 'moduleSpec', 'schemaSpec', 'specGrp', 'specGrpRef', 'elementSpec', 'classSpec', 'dataSpec', 'macroSpec', 'remarks', 'listRef', 'exemplum', 'classes', 'memberOf', 'equiv', 'altIdent', 'model', 'modelSequence', 'modelGrp', 'outputRendition', 'paramList', 'paramSpec', 'param', 'content', 'sequence', 'alternate', 'constraint', 'constraintSpec', 'attList', 'attDef', 'attRef', 'datatype', 'dataRef', 'dataFacet', 'defaultVal', 'valDesc', 'valItem', 'valList', 'textNode', 'anyElement', 'empty' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements included on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $include satisfies $gi = ( 'att', 'code', 'eg', 'egXML', 'gi', 'ident', 'tag', 'val', 'specList', 'specDesc', 'classRef', 'elementRef', 'macroRef', 'moduleRef', 'moduleSpec', 'schemaSpec', 'specGrp', 'specGrpRef', 'elementSpec', 'classSpec', 'dataSpec', 'macroSpec', 'remarks', 'listRef', 'exemplum', 'classes', 'memberOf', 'equiv', 'altIdent', 'model', 'modelSequence', 'modelGrp', 'outputRendition', 'paramList', 'paramSpec', 'param', 'content', 'sequence', 'alternate', 'constraint', 'constraintSpec', 'attList', 'attDef', 'attRef', 'datatype', 'dataRef', 'dataFacet', 'defaultVal', 'valDesc', 'valItem', 'valList', 'textNode', 'anyElement', 'empty' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $gi in $except  satisfies $gi = ( 'att', 'code', 'eg', 'egXML', 'gi', 'ident', 'tag', 'val', 'specList', 'specDesc', 'classRef', 'elementRef', 'macroRef', 'moduleRef', 'moduleSpec', 'schemaSpec', 'specGrp', 'specGrpRef', 'elementSpec', 'classSpec', 'dataSpec', 'macroSpec', 'remarks', 'listRef', 'exemplum', 'classes', 'memberOf', 'equiv', 'altIdent', 'model', 'modelSequence', 'modelGrp', 'outputRendition', 'paramList', 'paramSpec', 'param', 'content', 'sequence', 'alternate', 'constraint', 'constraintSpec', 'attList', 'attDef', 'attRef', 'datatype', 'dataRef', 'dataFacet', 'defaultVal', 'valDesc', 'valItem', 'valList', 'textNode', 'anyElement', 'empty' )"/>
         <xsl:otherwise>
            <xsl:message>One or more of the elements excepted on the '<xsl:text/>
               <xsl:value-of select="@key"/>
               <xsl:text/>' ＜moduleRef＞ are not actually available in that module (every $gi in $except satisfies $gi = ( 'att', 'code', 'eg', 'egXML', 'gi', 'ident', 'tag', 'val', 'specList', 'specDesc', 'classRef', 'elementRef', 'macroRef', 'moduleRef', 'moduleSpec', 'schemaSpec', 'specGrp', 'specGrpRef', 'elementSpec', 'classSpec', 'dataSpec', 'macroSpec', 'remarks', 'listRef', 'exemplum', 'classes', 'memberOf', 'equiv', 'altIdent', 'model', 'modelSequence', 'modelGrp', 'outputRendition', 'paramList', 'paramSpec', 'param', 'content', 'sequence', 'alternate', 'constraint', 'constraintSpec', 'attList', 'attDef', 'attRef', 'datatype', 'dataRef', 'dataFacet', 'defaultVal', 'valDesc', 'valItem', 'valList', 'textNode', 'anyElement', 'empty' ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M43"/>
   <xsl:template match="@*|node()" priority="-2" mode="M43">
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-moduleRef-modref-37-->
   <!--RULE -->
   <xsl:template match="tei:moduleRef" priority="1000" mode="M44">

		<!--REPORT -->
      <xsl:if test="* and @key">
         <xsl:message>
Child elements of <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> are only allowed when an external module is being loaded
         (* and @key)</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M44"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M44"/>
   <xsl:template match="@*|node()" priority="-2" mode="M44">
      <xsl:apply-templates select="*" mode="M44"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-moduleRef-prefix-not-same-prefix-38-->
   <!--RULE -->
   <xsl:template match="tei:moduleRef" priority="1000" mode="M45">

		<!--REPORT -->
      <xsl:if test="//*[ not( generate-id(.) eq generate-id(      current() ) ) ]/@prefix = @prefix">
         <xsl:message>The prefix attribute
	    of <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> should not match that of any other
	    element (it would defeat the purpose) (//*[ not( generate-id(.) eq generate-id( current() ) ) ]/@prefix = @prefix)</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M45"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M45"/>
   <xsl:template match="@*|node()" priority="-2" mode="M45">
      <xsl:apply-templates select="*" mode="M45"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-moduleRef-prefix-not-except-and-include-39-->
   <!--RULE -->
   <xsl:template match="tei:moduleRef" priority="1000" mode="M46">

		<!--REPORT -->
      <xsl:if test="@except and @include">
         <xsl:message>It is an error to supply both the @include and @except attributes (@except and @include)</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M46"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M46"/>
   <xsl:template match="@*|node()" priority="-2" mode="M46">
      <xsl:apply-templates select="*" mode="M46"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-schemaSpec-required-modules-40-->
   <!--RULE -->
   <xsl:template match="tei:schemaSpec" priority="1000" mode="M47">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="                       ( tei:moduleRef[ @key eq 'tei'] or tei:specGrpRef[ id( substring-after( normalize-space( @target ), '#') )/tei:moduleRef[ @key eq 'tei'] ] )                                             and                       ( tei:moduleRef[ @key eq 'core'] or tei:specGrpRef[ id( substring-after( normalize-space( @target ), '#') )/tei:moduleRef[ @key eq 'core'] ] )                                             and                       ( tei:moduleRef[ @key eq 'header'] or tei:specGrpRef[ id( substring-after( normalize-space( @target ), '#') )/tei:moduleRef[ @key eq 'header'] ] )                                             and                       ( tei:moduleRef[ @key eq 'textstructure'] or tei:specGrpRef[ id( substring-after( normalize-space( @target ), '#') )/tei:moduleRef[ @key eq 'textstructure'] ] )                                             "/>
         <xsl:otherwise>
            <xsl:message> missing one or more of the required modules (tei, core, header,
                      textstructure).  (( tei:moduleRef[ @key eq 'tei'] or tei:specGrpRef[ id( substring-after( normalize-space( @target ), '#') )/tei:moduleRef[ @key eq 'tei'] ] ) and ( tei:moduleRef[ @key eq 'core'] or tei:specGrpRef[ id( substring-after( normalize-space( @target ), '#') )/tei:moduleRef[ @key eq 'core'] ] ) and ( tei:moduleRef[ @key eq 'header'] or tei:specGrpRef[ id( substring-after( normalize-space( @target ), '#') )/tei:moduleRef[ @key eq 'header'] ] ) and ( tei:moduleRef[ @key eq 'textstructure'] or tei:specGrpRef[ id( substring-after( normalize-space( @target ), '#') )/tei:moduleRef[ @key eq 'textstructure'] ] ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M47"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M47"/>
   <xsl:template match="@*|node()" priority="-2" mode="M47">
      <xsl:apply-templates select="*" mode="M47"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-schemaSpec-no-outside-specs-41-->
   <!--RULE -->
   <xsl:template match="tei:classSpec[ not( ancestor::tei:schemaSpec ) ]                                      | tei:elementSpec[ not( ancestor::tei:schemaSpec ) ]                                      | tei:macroSpec[ not( ancestor::tei:schemaSpec ) ]"
                 priority="1000"
                 mode="M48">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="//tei:schemaSpec//tei:specGrpRef                                         [ substring-after( normalize-space( @target ), '#')                                            eq                                           current()/ancestor::tei:specGrp/@xml:id ]"/>
         <xsl:otherwise>
            <xsl:message>＜<xsl:text/>
               <xsl:value-of select="name(.)"/>
               <xsl:text/>＞ should be in ＜schemaSpec＞ or referred to from within
                        ＜schemaSpec＞ (//tei:schemaSpec//tei:specGrpRef [ substring-after( normalize-space( @target ), '#') eq current()/ancestor::tei:specGrp/@xml:id ])</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M48"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M48"/>
   <xsl:template match="@*|node()" priority="-2" mode="M48">
      <xsl:apply-templates select="*" mode="M48"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-schemaSpec-only-one-schemaSpec-42-->
   <!--RULE -->
   <xsl:template match="/" priority="1000" mode="M49">

		<!--REPORT -->
      <xsl:if test="count( //tei:schemaSpec ) eq 0">
         <xsl:message>There's no ＜schemaSpec＞, so
                        this isn't much of a TEI customization (count( //tei:schemaSpec ) eq 0)</xsl:message>
      </xsl:if>
      <!--REPORT -->
      <xsl:if test="count( //tei:schemaSpec ) gt 1">
         <xsl:message>You have more than one
                        ＜schemaSpec＞; current ODD processors will only look at the first
                        one (count( //tei:schemaSpec ) gt 1)</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M49"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M49"/>
   <xsl:template match="@*|node()" priority="-2" mode="M49">
      <xsl:apply-templates select="*" mode="M49"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-elementSpec-module-except-when-add-43-->
   <!--RULE -->
   <xsl:template match="tei:elementSpec" priority="1000" mode="M50">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@mode"/>
         <xsl:otherwise>
            <xsl:message>in a customization ODD, the mode= attribute of
                      ＜elementSpec＞ should be specified (@mode)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--REPORT -->
      <xsl:if test="not( @module )  and  not( @mode='add')">
         <xsl:message>the module= attribute of ＜elementSpec＞ must be specified anytime the mode= is
                      not 'add' (not( @module ) and not( @mode='add'))</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M50"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M50"/>
   <xsl:template match="@*|node()" priority="-2" mode="M50">
      <xsl:apply-templates select="*" mode="M50"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-elementSpec-only-1-per-44-->
   <!--RULE -->
   <xsl:template match="tei:elementSpec" priority="1000" mode="M51">

		<!--REPORT -->
      <xsl:if test="//tei:elementSpec[ @ident eq current()/@ident  and  not( . is current() ) ]">
         <xsl:message>Current ODD processors will not correctly handle more than one ＜elementSpec＞ with the same @ident (//tei:elementSpec[ @ident eq current()/@ident and not( . is current() ) ])</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M51"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M51"/>
   <xsl:template match="@*|node()" priority="-2" mode="M51">
      <xsl:apply-templates select="*" mode="M51"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-elementSpec-dont-delete-required-45-->
   <!--RULE -->
   <xsl:template match="tei:elementSpec" priority="1000" mode="M52">

		<!--REPORT -->
      <xsl:if test="@mode='delete' and @ident='TEI'">
         <xsl:message>Removing ＜TEI＞ from your
                      schema guarantees it is not TEI conformant (@mode='delete' and @ident='TEI')</xsl:message>
      </xsl:if>
      <!--REPORT -->
      <xsl:if test="@mode='delete' and @ident='teiHeader'">
         <xsl:message>Removing ＜teiHeader＞
                      from your schema guarantees it is not TEI conformant (@mode='delete' and @ident='teiHeader')</xsl:message>
      </xsl:if>
      <!--REPORT -->
      <xsl:if test="@mode='delete' and @ident='fileDesc'">
         <xsl:message>Removing ＜fileDesc＞ from
                      your schema guarantees it is not TEI conformant (@mode='delete' and @ident='fileDesc')</xsl:message>
      </xsl:if>
      <!--REPORT -->
      <xsl:if test="@mode='delete' and @ident='titleStmt'">
         <xsl:message>Removing ＜titleStmt＞
                      from your schema guarantees it is not TEI conformant (@mode='delete' and @ident='titleStmt')</xsl:message>
      </xsl:if>
      <!--REPORT -->
      <xsl:if test="@mode='delete' and @ident='title'">
         <xsl:message>Removing ＜title＞ from your
                      schema guarantees it is not TEI conformant (@mode='delete' and @ident='title')</xsl:message>
      </xsl:if>
      <!--REPORT -->
      <xsl:if test="@mode='delete' and @ident='publicationStmt'">
         <xsl:message>Removing
                      ＜publicationStmt＞ from your schema guarantees it is not TEI
                      conformant (@mode='delete' and @ident='publicationStmt')</xsl:message>
      </xsl:if>
      <!--REPORT -->
      <xsl:if test="@mode='delete' and @ident='sourceDesc'">
         <xsl:message>Removing ＜sourceDesc＞
                      from your schema guarantees it is not TEI conformant (@mode='delete' and @ident='sourceDesc')</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M52"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M52"/>
   <xsl:template match="@*|node()" priority="-2" mode="M52">
      <xsl:apply-templates select="*" mode="M52"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-elementSpec-content_when_adding-46-->
   <!--RULE -->
   <xsl:template match="tei:elementSpec[@mode = ('add','replace')]"
                 priority="1000"
                 mode="M53">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:content"/>
         <xsl:otherwise>
            <xsl:message>When adding a new element (whether replacing an old one or not), a content model must be specified; but this ＜elementSpec＞ does not have a ＜content＞ child. (tei:content)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M53"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M53"/>
   <xsl:template match="@*|node()" priority="-2" mode="M53">
      <xsl:apply-templates select="*" mode="M53"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-elementSpec-empty_when_deleting-47-->
   <!--RULE -->
   <xsl:template match="tei:elementSpec[ @mode eq 'delete']"
                 priority="1000"
                 mode="M54">

		<!--REPORT -->
      <xsl:if test="*">
         <xsl:message>When used to delete an element from your schema, the ＜elementSpec＞ should be empty (*)</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M54"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M54"/>
   <xsl:template match="@*|node()" priority="-2" mode="M54">
      <xsl:apply-templates select="*" mode="M54"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-elementSpec-add_implies_ns-48-->
   <!--RULE -->
   <xsl:template match="tei:elementSpec[ @mode eq 'add'  or  not( @mode ) ]"
                 priority="1000"
                 mode="M55">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="ancestor-or-self::*/@ns"/>
         <xsl:otherwise>
            <xsl:message>When used to add an element, ＜elementSpec＞ (or its ancestor ＜schemaSpec＞) should have an @ns attribute. (ancestor-or-self::*/@ns)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M55"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M55"/>
   <xsl:template match="@*|node()" priority="-2" mode="M55">
      <xsl:apply-templates select="*" mode="M55"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-elementSpec-child-constraint-based-on-mode-49-->
   <!--RULE -->
   <xsl:template match="tei:elementSpec[ @mode eq 'delete' ]"
                 priority="1001"
                 mode="M56">

		<!--REPORT -->
      <xsl:if test="child::*">
         <xsl:message>This elementSpec element has a mode= of "delete" even though it has child elements. Change the mode= to "add", "change", or "replace", or remove the child elements. (child::*)</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M56"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:elementSpec[ @mode = ('add','change','replace') ]"
                 priority="1000"
                 mode="M56">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="child::* | (@* except (@mode, @ident))"/>
         <xsl:otherwise>
            <xsl:message>This elementSpec element has a mode= of "<xsl:text/>
               <xsl:value-of select="@mode"/>
               <xsl:text/>", but does not have any child elements or schema-changing attributes. Specify child elements, use validUntil=, predeclare=, ns=, or prefix=, or change the mode= to "delete". (child::* | (@* except (@mode, @ident)))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M56"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M56"/>
   <xsl:template match="@*|node()" priority="-2" mode="M56">
      <xsl:apply-templates select="*" mode="M56"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-listRef-TagDocsNestinglistRef-50-->
   <!--RULE -->
   <xsl:template match="( tei:classSpec | tei:dataSpec | tei:elementSpec | tei:macroSpec | tei:moduleSpec | tei:schemaSpec | tei:specGrp )/tei:listRef"
                 priority="1000"
                 mode="M57">

		<!--REPORT -->
      <xsl:if test="tei:listRef">
         <xsl:message>In the context of tagset documentation, the listRef element must not self-nest. (tei:listRef)</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M57"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M57"/>
   <xsl:template match="@*|node()" priority="-2" mode="M57">
      <xsl:apply-templates select="*" mode="M57"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-listRef-TagDocslistRefChildren-51-->
   <!--RULE -->
   <xsl:template match="( tei:classSpec | tei:dataSpec | tei:elementSpec | tei:macroSpec | tei:moduleSpec | tei:schemaSpec | tei:specGrp )/tei:listRef/tei:ptr                        | ( tei:classSpec | tei:dataSpec | tei:elementSpec | tei:macroSpec | tei:moduleSpec | tei:schemaSpec | tei:specGrp )/tei:listRef/tei:ref"
                 priority="1000"
                 mode="M58">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@target and not( matches( @target,'\s') )"/>
         <xsl:otherwise>
            <xsl:message>In the context of tagset documentation, each ptr or ref element inside a listRef must have a target attribute with only 1 pointer as its value. (@target and not( matches( @target,'\s') ))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M58"/>
   <xsl:template match="@*|node()" priority="-2" mode="M58">
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-altIdent-altIdent-only-NCName-52-->
   <!--RULE -->
   <xsl:template match="tei:altIdent" priority="1000" mode="M59">

		<!--REPORT -->
      <xsl:if test="if ( parent::taxonomy | parent::valItem )                                       then false()                                       else contains( .,':')">
         <xsl:message> The content of ＜altIdent＞ should be an XML Name (w/o a namespace prefix),
                      unless a child of ＜valItem＞ (and even then, it's not a bad idea :-) (if ( parent::taxonomy | parent::valItem ) then false() else contains( .,':'))</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M59"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M59"/>
   <xsl:template match="@*|node()" priority="-2" mode="M59">
      <xsl:apply-templates select="*" mode="M59"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-altIdent-deprecate_altIdent_in_non-ODD_places-53-->
   <!--RULE -->
   <xsl:template match="tei:altIdent" priority="1000" mode="M60">

		<!--REPORT nonfatal-->
      <xsl:if test="  parent::tei:model                         | parent::tei:modelGrp                         | parent::tei:modelSequence                         | parent::tei:paramSpec                         | parent::tei:schemaSpec">
         <xsl:message>
        Use of &lt;altIdent&gt; as a child of &lt;<xsl:text/>
            <xsl:value-of select="name(..)"/>
            <xsl:text/>&gt; is
        deprecated, and will no longer be valid after 2022-07-14.
       (parent::tei:model | parent::tei:modelGrp | parent::tei:modelSequence | parent::tei:paramSpec | parent::tei:schemaSpec / nonfatal)</xsl:message>
      </xsl:if>
      <!--REPORT nonfatal-->
      <xsl:if test="parent::tei:moduleSpec">
         <xsl:message>
        Use of &lt;altIdent&gt; to declare the FPI of a module is
        deprecated, and will no longer be valid after 2022-07-14;
        please use &lt;idno type="FPI"&gt; instead.
       (parent::tei:moduleSpec / nonfatal)</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M60"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M60"/>
   <xsl:template match="@*|node()" priority="-2" mode="M60">
      <xsl:apply-templates select="*" mode="M60"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-altIdent-altIdent_usually_an_NCName-54-->
   <!--RULE -->
   <xsl:template match="tei:altIdent[ not( parent::tei:moduleSpec or @type eq 'FPI' ) ]"
                 priority="1000"
                 mode="M61">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test=". castable as xs:NCName"/>
         <xsl:otherwise>
            <xsl:message>
          The content of this 'altIdent' element (<xsl:text/>
               <xsl:value-of select="normalize-space(.)"/>
               <xsl:text/>)
          should conform to teidata.xmlName.
         (. castable as xs:NCName)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M61"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M61"/>
   <xsl:template match="@*|node()" priority="-2" mode="M61">
      <xsl:apply-templates select="*" mode="M61"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-model-no_dup_default_models-55-->
   <!--RULE -->
   <xsl:template match="tei:model[ not( parent::tei:modelSequence ) ][ not( @predicate ) ]"
                 priority="1000"
                 mode="M62">
      <xsl:variable name="output" select="normalize-space( @output )"/>
      <!--REPORT -->
      <xsl:if test="following-sibling::tei:model                             [ not( @predicate )]                             [ normalize-space( @output ) eq $output ]">
         <xsl:message>
          There are 2 (or more) 'model' elements in this '<xsl:text/>
            <xsl:value-of select="local-name(..)"/>
            <xsl:text/>'
          that have no predicate, but are targeted to the same output
          ("<xsl:text/>
            <xsl:value-of select="( $output, parent::modelGrp/@output, 'all')[1]"/>
            <xsl:text/>") (following-sibling::tei:model [ not( @predicate )] [ normalize-space( @output ) eq $output ])</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M62"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M62"/>
   <xsl:template match="@*|node()" priority="-2" mode="M62">
      <xsl:apply-templates select="*" mode="M62"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-model-no_dup_models-56-->
   <!--RULE -->
   <xsl:template match="tei:model[ not( parent::tei:modelSequence ) ][ @predicate ]"
                 priority="1000"
                 mode="M63">
      <xsl:variable name="predicate" select="normalize-space( @predicate )"/>
      <xsl:variable name="output" select="normalize-space( @output )"/>
      <!--REPORT -->
      <xsl:if test="following-sibling::tei:model                             [ normalize-space( @predicate ) eq $predicate ]                             [ normalize-space( @output ) eq $output ]">
         <xsl:message>
          There are 2 (or more) 'model' elements in this
          '<xsl:text/>
            <xsl:value-of select="local-name(..)"/>
            <xsl:text/>' that have
          the same predicate, and are targeted to the same output
          ("<xsl:text/>
            <xsl:value-of select="( $output, parent::modelGrp/@output, 'all')[1]"/>
            <xsl:text/>") (following-sibling::tei:model [ normalize-space( @predicate ) eq $predicate ] [ normalize-space( @output ) eq $output ])</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M63"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M63"/>
   <xsl:template match="@*|node()" priority="-2" mode="M63">
      <xsl:apply-templates select="*" mode="M63"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-modelSequence-no_outputs_nor_predicates_4_my_kids-57-->
   <!--RULE -->
   <xsl:template match="tei:modelSequence" priority="1000" mode="M64">

		<!--REPORT warning-->
      <xsl:if test="tei:model[@output]">
         <xsl:message>The 'model' children
      of a 'modelSequence' element inherit the @output attribute of the
      parent 'modelSequence', and thus should not have their own (tei:model[@output] / warning)</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M64"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M64"/>
   <xsl:template match="@*|node()" priority="-2" mode="M64">
      <xsl:apply-templates select="*" mode="M64"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-sequence-sequencechilden-58-->
   <!--RULE -->
   <xsl:template match="tei:sequence" priority="1000" mode="M65">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(*)&gt;1"/>
         <xsl:otherwise>
            <xsl:message>The sequence element must have at least two child elements (count(*)&gt;1)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M65"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M65"/>
   <xsl:template match="@*|node()" priority="-2" mode="M65">
      <xsl:apply-templates select="*" mode="M65"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-alternate-alternatechilden-59-->
   <!--RULE -->
   <xsl:template match="tei:alternate" priority="1000" mode="M66">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(*)&gt;1"/>
         <xsl:otherwise>
            <xsl:message>The alternate element must have at least two child elements (count(*)&gt;1)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M66"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M66"/>
   <xsl:template match="@*|node()" priority="-2" mode="M66">
      <xsl:apply-templates select="*" mode="M66"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-constraintSpec-empty-based-on-mode-60-->
   <!--RULE -->
   <xsl:template match="tei:constraintSpec[ @mode eq 'delete']"
                 priority="1002"
                 mode="M67">

		<!--REPORT -->
      <xsl:if test="child::*">
         <xsl:message>This constraintSpec element has a mode= of "delete" even though it has child elements. Change the mode= to "add", "change", or "replace", or remove the child elements. (child::*)</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M67"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:constraintSpec[ @mode eq 'change']"
                 priority="1001"
                 mode="M67">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="child::*"/>
         <xsl:otherwise>
            <xsl:message>This constraintSpec element has a mode= of "change", but does not have any child elements. Specify child elements, or change the mode= to "delete". (child::*)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M67"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:constraintSpec[ @mode = ('add','replace') ]"
                 priority="1000"
                 mode="M67">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="child::tei:constraint"/>
         <xsl:otherwise>
            <xsl:message>This constraintSpec element has a mode= of "<xsl:text/>
               <xsl:value-of select="@mode"/>
               <xsl:text/>", but does not have a child 'constraint' element. Use a child 'constraint' element or change the mode= to "delete" or "change". (child::tei:constraint)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M67"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M67"/>
   <xsl:template match="@*|node()" priority="-2" mode="M67">
      <xsl:apply-templates select="*" mode="M67"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-constraintSpec-sch_no_more-61-->
   <!--RULE -->
   <xsl:template match="tei:constraintSpec" priority="1000" mode="M68">

		<!--REPORT -->
      <xsl:if test="tei:constraint/s:*  and  @scheme = ('isoschematron','schematron')">
         <xsl:message>Rules
        in the Schematron 1.* language must be inside a constraintSpec
        with a value other than 'schematron' or 'isoschematron' on the
        scheme attribute (tei:constraint/s:* and @scheme = ('isoschematron','schematron'))</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M68"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M68"/>
   <xsl:template match="@*|node()" priority="-2" mode="M68">
      <xsl:apply-templates select="*" mode="M68"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-constraintSpec-isosch-62-->
   <!--RULE -->
   <xsl:template match="tei:constraintSpec" priority="1000" mode="M69">

		<!--REPORT -->
      <xsl:if test="tei:constraint/sch:*  and  not( @scheme eq 'schematron')">
         <xsl:message>Rules
        in the ISO Schematron language must be inside a constraintSpec
        with the value 'schematron' on the scheme attribute (tei:constraint/sch:* and not( @scheme eq 'schematron'))</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M69"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M69"/>
   <xsl:template match="@*|node()" priority="-2" mode="M69">
      <xsl:apply-templates select="*" mode="M69"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-constraintSpec-needrules-63-->
   <!--RULE -->
   <xsl:template match="tei:macroSpec/tei:constraintSpec[@scheme eq 'schematron']/tei:constraint"
                 priority="1000"
                 mode="M70">

		<!--REPORT -->
      <xsl:if test="sch:assert|sch:report">
         <xsl:message>An ISO Schematron constraint specification for a macro should not
        have an 'assert' or 'report' element without a parent 'rule' element (sch:assert|sch:report)</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M70"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M70"/>
   <xsl:template match="@*|node()" priority="-2" mode="M70">
      <xsl:apply-templates select="*" mode="M70"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-constraintSpec-unique-constraintSpec-ident-64-->
   <!--RULE -->
   <xsl:template match="tei:constraintSpec[ @mode eq 'add'  or  not( @mode ) ]"
                 priority="1000"
                 mode="M71">
      <xsl:variable name="myIdent" select="normalize-space(@ident)"/>
      <!--REPORT -->
      <xsl:if test="preceding::tei:constraintSpec[ normalize-space(@ident) eq $myIdent ]">
         <xsl:message>
        The @ident of 'constraintSpec' should be unique; this one (<xsl:text/>
            <xsl:value-of select="$myIdent"/>
            <xsl:text/>) is the same as that of a previous 'constraintSpec'.
         (preceding::tei:constraintSpec[ normalize-space(@ident) eq $myIdent ])</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M71"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M71"/>
   <xsl:template match="@*|node()" priority="-2" mode="M71">
      <xsl:apply-templates select="*" mode="M71"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-attDef-attDefContents-65-->
   <!--RULE -->
   <xsl:template match="tei:attDef" priority="1000" mode="M72">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="ancestor::teix:egXML[@valid='feasible'] or @mode eq 'change' or @mode eq 'delete' or tei:datatype or tei:valList[@type='closed']"/>
         <xsl:otherwise>
            <xsl:message>Attribute: the definition of the @<xsl:text/>
               <xsl:value-of select="@ident"/>
               <xsl:text/> attribute in the <xsl:text/>
               <xsl:value-of select="ancestor::*[@ident][1]/@ident"/>
               <xsl:text/>
               <xsl:text/>
               <xsl:value-of select="' '"/>
               <xsl:text/>
               <xsl:text/>
               <xsl:value-of select="local-name(ancestor::*[@ident][1])"/>
               <xsl:text/> should have a closed valList or a datatype (ancestor::teix:egXML[@valid='feasible'] or @mode eq 'change' or @mode eq 'delete' or tei:datatype or tei:valList[@type='closed'])</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M72"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M72"/>
   <xsl:template match="@*|node()" priority="-2" mode="M72">
      <xsl:apply-templates select="*" mode="M72"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-attDef-noDefault4Required-66-->
   <!--RULE -->
   <xsl:template match="tei:attDef[@usage eq 'req']" priority="1000" mode="M73">

		<!--REPORT -->
      <xsl:if test="tei:defaultVal">
         <xsl:message>Since the @<xsl:text/>
            <xsl:value-of select="@ident"/>
            <xsl:text/> attribute is required, it will always be specified. Thus the default value (of "<xsl:text/>
            <xsl:value-of select="normalize-space(tei:defaultVal)"/>
            <xsl:text/>") will never be used. Either change the definition of the attribute so it is not required ("rec" or "opt"), or remove the defaultVal element. (tei:defaultVal)</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M73"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M73"/>
   <xsl:template match="@*|node()" priority="-2" mode="M73">
      <xsl:apply-templates select="*" mode="M73"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-attDef-defaultIsInClosedList-twoOrMore-67-->
   <!--RULE -->
   <xsl:template match="tei:attDef[   tei:defaultVal   and   tei:valList[@type eq 'closed']   and   tei:datatype[    @maxOccurs &gt; 1    or    @minOccurs &gt; 1    or    @maxOccurs = 'unbounded'    ]   ]"
                 priority="1000"
                 mode="M74">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="     tokenize(normalize-space(tei:defaultVal),' ')     =     tei:valList/tei:valItem/@ident"/>
         <xsl:otherwise>
            <xsl:message>In the <xsl:text/>
               <xsl:value-of select="local-name(ancestor::*[@ident][1])"/>
               <xsl:text/> defining
        <xsl:text/>
               <xsl:value-of select="ancestor::*[@ident][1]/@ident"/>
               <xsl:text/> the default value of the
        @<xsl:text/>
               <xsl:value-of select="@ident"/>
               <xsl:text/> attribute is not among the closed list of possible
        values (tokenize(normalize-space(tei:defaultVal),' ') = tei:valList/tei:valItem/@ident)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M74"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M74"/>
   <xsl:template match="@*|node()" priority="-2" mode="M74">
      <xsl:apply-templates select="*" mode="M74"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-attDef-defaultIsInClosedList-one-68-->
   <!--RULE -->
   <xsl:template match="tei:attDef[   tei:defaultVal   and   tei:valList[@type eq 'closed']   and   tei:datatype[    not(@maxOccurs)    or (    if ( @maxOccurs castable as xs:integer )     then ( @maxOccurs cast as xs:integer eq 1 )     else false()    )]   ]"
                 priority="1000"
                 mode="M75">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string(tei:defaultVal)      =      tei:valList/tei:valItem/@ident"/>
         <xsl:otherwise>
            <xsl:message>In the <xsl:text/>
               <xsl:value-of select="local-name(ancestor::*[@ident][1])"/>
               <xsl:text/> defining
        <xsl:text/>
               <xsl:value-of select="ancestor::*[@ident][1]/@ident"/>
               <xsl:text/> the default value of the
        @<xsl:text/>
               <xsl:value-of select="@ident"/>
               <xsl:text/> attribute is not among the closed list of possible
        values (string(tei:defaultVal) = tei:valList/tei:valItem/@ident)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M75"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M75"/>
   <xsl:template match="@*|node()" priority="-2" mode="M75">
      <xsl:apply-templates select="*" mode="M75"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-dataRef-restrictDataFacet-69-->
   <!--RULE -->
   <xsl:template match="tei:dataRef[tei:dataFacet]" priority="1000" mode="M76">

		<!--ASSERT nonfatal-->
      <xsl:choose>
         <xsl:when test="@name"/>
         <xsl:otherwise>
            <xsl:message>Data facets can only be specified for references to datatypes specified by
          XML Schemas: Part 2: Datatypes (@name / nonfatal)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M76"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M76"/>
   <xsl:template match="@*|node()" priority="-2" mode="M76">
      <xsl:apply-templates select="*" mode="M76"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-dataRef-restrictAttRestriction-70-->
   <!--RULE -->
   <xsl:template match="tei:dataRef[tei:dataFacet]" priority="1000" mode="M77">

		<!--REPORT nonfatal-->
      <xsl:if test="@restriction">
         <xsl:message>The attribute restriction cannot be used when dataFacet elements are present. (@restriction / nonfatal)</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M77"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M77"/>
   <xsl:template match="@*|node()" priority="-2" mode="M77">
      <xsl:apply-templates select="*" mode="M77"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-dataRef-restrictAttResctrictionName-71-->
   <!--RULE -->
   <xsl:template match="tei:dataRef" priority="1000" mode="M78">

		<!--REPORT fatal-->
      <xsl:if test="@restriction and not(@name)">
         <xsl:message>The attribute restriction can only be used with a name attribute. (@restriction and not(@name) / fatal)</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M78"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M78"/>
   <xsl:template match="@*|node()" priority="-2" mode="M78">
      <xsl:apply-templates select="*" mode="M78"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-mode-child-sanity-72-->
   <!--RULE -->
   <xsl:template match="*[ @mode eq 'delete' ]" priority="1001" mode="M79">

		<!--REPORT -->
      <xsl:if test="child::*">
         <xsl:message>The specification element ＜<xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/>＞ has both a
                      mode= of "delete" and child elements, which is incongruous (child::*)</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M79"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="                       tei:valList[ @mode = ('add','change','replace') ]                     | tei:moduleSpec[ @mode = ('add','change','replace') ]                     | tei:schemaSpec[ @mode = ('add','change','replace') ]                     | tei:elementSpec[ @mode = ('add','change','replace') ]                     | tei:classSpec[ @mode = ('add','change','replace') ]                     | tei:macroSpec[ @mode = ('add','change','replace') ]                     | tei:constraintSpec[ @mode = ('add','change','replace') ]                     | tei:attDef[ @mode = ('add','change','replace') ]                     | tei:classes[ @mode = ('add','change','replace') ]"
                 priority="1000"
                 mode="M79">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="child::* | (@* except (@mode, @ident))"/>
         <xsl:otherwise>
            <xsl:message>The specification
                      element ＜<xsl:text/>
               <xsl:value-of select="name(.)"/>
               <xsl:text/>＞ has a mode= of "<xsl:text/>
               <xsl:value-of select="@mode"/>
               <xsl:text/>", but
                      does not have any child elements or schema-changing attributes, which is
                      incongruous (child::* | (@* except (@mode, @ident)))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M79"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M79"/>
   <xsl:template match="@*|node()" priority="-2" mode="M79">
      <xsl:apply-templates select="*" mode="M79"/>
   </xsl:template>
   <!--PATTERN schematron-constraint-tei_customization-tei-source-73-->
   <!--RULE -->
   <xsl:template match=" tei:classRef[@source]                                      |tei:dataRef[@source]                                      |tei:elementRef[@source]                                      |tei:macroRef[@source]                                      |tei:moduleRef[@source]                                      |tei:schemaSpec[@source]"
                 priority="1000"
                 mode="M80">

		<!--ASSERT information-->
      <xsl:choose>
         <xsl:when test="matches(normalize-space(@source), '^tei:([0-9]+\.[0-9]+\.[0-9]+|current)$')"/>
         <xsl:otherwise>
            <xsl:message>The @source attribute of ＜<xsl:text/>
               <xsl:value-of select="name(.)"/>
               <xsl:text/>＞ is not in the
                      recommended format, which is either "tei:current" or "tei:x.y.z", where x.y.z is a version number. (matches(normalize-space(@source), '^tei:([0-9]+\.[0-9]+\.[0-9]+|current)$') / information)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M80"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M80"/>
   <xsl:template match="@*|node()" priority="-2" mode="M80">
      <xsl:apply-templates select="*" mode="M80"/>
   </xsl:template>
   <!--PATTERN teipm-model-paramList-1-->
   <!--RULE -->
   <xsl:template match="tei:param[parent::tei:model/@behaviour='alternate']"
                 priority="1000"
                 mode="M81">

		<!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@name='default'   or  @name='alternate'"/>
         <xsl:otherwise>
            <xsl:message>
          Parameter name '<xsl:text/>
               <xsl:value-of select="@name"/>
               <xsl:text/>'  (on <xsl:text/>
               <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>
               <xsl:text/>) not allowed.
          Must  be  drawn from the list: default, alternate (@name='default' or @name='alternate' / error)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M81"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M81"/>
   <xsl:template match="@*|node()" priority="-2" mode="M81">
      <xsl:apply-templates select="*" mode="M81"/>
   </xsl:template>
   <!--PATTERN teipm-model-paramList-2-->
   <!--RULE -->
   <xsl:template match="tei:param[parent::tei:model/@behaviour='anchor']"
                 priority="1000"
                 mode="M82">

		<!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@name='id'"/>
         <xsl:otherwise>
            <xsl:message>
          Parameter name '<xsl:text/>
               <xsl:value-of select="@name"/>
               <xsl:text/>'  (on <xsl:text/>
               <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>
               <xsl:text/>) not allowed.
          Must  be  drawn from the list: id (@name='id' / error)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M82"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M82"/>
   <xsl:template match="@*|node()" priority="-2" mode="M82">
      <xsl:apply-templates select="*" mode="M82"/>
   </xsl:template>
   <!--PATTERN teipm-model-paramList-3-->
   <!--RULE -->
   <xsl:template match="tei:param[parent::tei:model/@behaviour='block']"
                 priority="1000"
                 mode="M83">

		<!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@name='content'"/>
         <xsl:otherwise>
            <xsl:message>
          Parameter name '<xsl:text/>
               <xsl:value-of select="@name"/>
               <xsl:text/>'  (on <xsl:text/>
               <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>
               <xsl:text/>) not allowed.
          Must  be  drawn from the list: content (@name='content' / error)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M83"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M83"/>
   <xsl:template match="@*|node()" priority="-2" mode="M83">
      <xsl:apply-templates select="*" mode="M83"/>
   </xsl:template>
   <!--PATTERN teipm-model-paramList-4-->
   <!--RULE -->
   <xsl:template match="tei:param[parent::tei:model/@behaviour='body']"
                 priority="1000"
                 mode="M84">

		<!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@name='content'"/>
         <xsl:otherwise>
            <xsl:message>
          Parameter name '<xsl:text/>
               <xsl:value-of select="@name"/>
               <xsl:text/>'  (on <xsl:text/>
               <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>
               <xsl:text/>) not allowed.
          Must  be  drawn from the list: content (@name='content' / error)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M84"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M84"/>
   <xsl:template match="@*|node()" priority="-2" mode="M84">
      <xsl:apply-templates select="*" mode="M84"/>
   </xsl:template>
   <!--PATTERN teipm-model-paramList-5-->
   <!--RULE -->
   <xsl:template match="tei:param[parent::tei:model/@behaviour='break']"
                 priority="1000"
                 mode="M85">

		<!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@name='type'   or  @name='label'"/>
         <xsl:otherwise>
            <xsl:message>
          Parameter name '<xsl:text/>
               <xsl:value-of select="@name"/>
               <xsl:text/>'  (on <xsl:text/>
               <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>
               <xsl:text/>) not allowed.
          Must  be  drawn from the list: type, label (@name='type' or @name='label' / error)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M85"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M85"/>
   <xsl:template match="@*|node()" priority="-2" mode="M85">
      <xsl:apply-templates select="*" mode="M85"/>
   </xsl:template>
   <!--PATTERN teipm-model-paramList-6-->
   <!--RULE -->
   <xsl:template match="tei:param[parent::tei:model/@behaviour='cell']"
                 priority="1000"
                 mode="M86">

		<!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@name='content'"/>
         <xsl:otherwise>
            <xsl:message>
          Parameter name '<xsl:text/>
               <xsl:value-of select="@name"/>
               <xsl:text/>'  (on <xsl:text/>
               <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>
               <xsl:text/>) not allowed.
          Must  be  drawn from the list: content (@name='content' / error)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M86"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M86"/>
   <xsl:template match="@*|node()" priority="-2" mode="M86">
      <xsl:apply-templates select="*" mode="M86"/>
   </xsl:template>
   <!--PATTERN teipm-model-paramList-7-->
   <!--RULE -->
   <xsl:template match="tei:param[parent::tei:model/@behaviour='cit']"
                 priority="1000"
                 mode="M87">

		<!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@name='content'   or  @name='source'"/>
         <xsl:otherwise>
            <xsl:message>
          Parameter name '<xsl:text/>
               <xsl:value-of select="@name"/>
               <xsl:text/>'  (on <xsl:text/>
               <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>
               <xsl:text/>) not allowed.
          Must  be  drawn from the list: content, source (@name='content' or @name='source' / error)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M87"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M87"/>
   <xsl:template match="@*|node()" priority="-2" mode="M87">
      <xsl:apply-templates select="*" mode="M87"/>
   </xsl:template>
   <!--PATTERN teipm-model-paramList-8-->
   <!--RULE -->
   <xsl:template match="tei:param[parent::tei:model/@behaviour='document']"
                 priority="1000"
                 mode="M88">

		<!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@name='content'"/>
         <xsl:otherwise>
            <xsl:message>
          Parameter name '<xsl:text/>
               <xsl:value-of select="@name"/>
               <xsl:text/>'  (on <xsl:text/>
               <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>
               <xsl:text/>) not allowed.
          Must  be  drawn from the list: content (@name='content' / error)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M88"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M88"/>
   <xsl:template match="@*|node()" priority="-2" mode="M88">
      <xsl:apply-templates select="*" mode="M88"/>
   </xsl:template>
   <!--PATTERN teipm-model-paramList-9-->
   <!--RULE -->
   <xsl:template match="tei:param[parent::tei:model/@behaviour='figure']"
                 priority="1000"
                 mode="M89">

		<!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@name='title'"/>
         <xsl:otherwise>
            <xsl:message>
          Parameter name '<xsl:text/>
               <xsl:value-of select="@name"/>
               <xsl:text/>'  (on <xsl:text/>
               <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>
               <xsl:text/>) not allowed.
          Must  be  drawn from the list: title (@name='title' / error)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M89"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M89"/>
   <xsl:template match="@*|node()" priority="-2" mode="M89">
      <xsl:apply-templates select="*" mode="M89"/>
   </xsl:template>
   <!--PATTERN teipm-model-paramList-10-->
   <!--RULE -->
   <xsl:template match="tei:param[parent::tei:model/@behaviour='glyph']"
                 priority="1000"
                 mode="M90">

		<!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@name='uri'"/>
         <xsl:otherwise>
            <xsl:message>
          Parameter name '<xsl:text/>
               <xsl:value-of select="@name"/>
               <xsl:text/>'  (on <xsl:text/>
               <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>
               <xsl:text/>) not allowed.
          Must  be  drawn from the list: uri (@name='uri' / error)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M90"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M90"/>
   <xsl:template match="@*|node()" priority="-2" mode="M90">
      <xsl:apply-templates select="*" mode="M90"/>
   </xsl:template>
   <!--PATTERN teipm-model-paramList-11-->
   <!--RULE -->
   <xsl:template match="tei:param[parent::tei:model/@behaviour='graphic']"
                 priority="1000"
                 mode="M91">

		<!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@name='url'   or  @name='width'   or  @name='height'   or  @name='scale'   or  @name='title'"/>
         <xsl:otherwise>
            <xsl:message>
          Parameter name '<xsl:text/>
               <xsl:value-of select="@name"/>
               <xsl:text/>'  (on <xsl:text/>
               <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>
               <xsl:text/>) not allowed.
          Must  be  drawn from the list: url, width, height, scale, title (@name='url' or @name='width' or @name='height' or @name='scale' or @name='title' / error)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M91"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M91"/>
   <xsl:template match="@*|node()" priority="-2" mode="M91">
      <xsl:apply-templates select="*" mode="M91"/>
   </xsl:template>
   <!--PATTERN teipm-model-paramList-12-->
   <!--RULE -->
   <xsl:template match="tei:param[parent::tei:model/@behaviour='heading']"
                 priority="1000"
                 mode="M92">

		<!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@name='content'   or  @name='level'"/>
         <xsl:otherwise>
            <xsl:message>
          Parameter name '<xsl:text/>
               <xsl:value-of select="@name"/>
               <xsl:text/>'  (on <xsl:text/>
               <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>
               <xsl:text/>) not allowed.
          Must  be  drawn from the list: content, level (@name='content' or @name='level' / error)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M92"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M92"/>
   <xsl:template match="@*|node()" priority="-2" mode="M92">
      <xsl:apply-templates select="*" mode="M92"/>
   </xsl:template>
   <!--PATTERN teipm-model-paramList-13-->
   <!--RULE -->
   <xsl:template match="tei:param[parent::tei:model/@behaviour='index']"
                 priority="1000"
                 mode="M93">

		<!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@name='type'"/>
         <xsl:otherwise>
            <xsl:message>
          Parameter name '<xsl:text/>
               <xsl:value-of select="@name"/>
               <xsl:text/>'  (on <xsl:text/>
               <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>
               <xsl:text/>) not allowed.
          Must  be  drawn from the list: type (@name='type' / error)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M93"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M93"/>
   <xsl:template match="@*|node()" priority="-2" mode="M93">
      <xsl:apply-templates select="*" mode="M93"/>
   </xsl:template>
   <!--PATTERN teipm-model-paramList-14-->
   <!--RULE -->
   <xsl:template match="tei:param[parent::tei:model/@behaviour='inline']"
                 priority="1000"
                 mode="M94">

		<!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@name='content'   or  @name='label'"/>
         <xsl:otherwise>
            <xsl:message>
          Parameter name '<xsl:text/>
               <xsl:value-of select="@name"/>
               <xsl:text/>'  (on <xsl:text/>
               <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>
               <xsl:text/>) not allowed.
          Must  be  drawn from the list: content, label (@name='content' or @name='label' / error)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M94"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M94"/>
   <xsl:template match="@*|node()" priority="-2" mode="M94">
      <xsl:apply-templates select="*" mode="M94"/>
   </xsl:template>
   <!--PATTERN teipm-model-paramList-15-->
   <!--RULE -->
   <xsl:template match="tei:param[parent::tei:model/@behaviour='link']"
                 priority="1000"
                 mode="M95">

		<!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@name='content'   or  @name='uri'"/>
         <xsl:otherwise>
            <xsl:message>
          Parameter name '<xsl:text/>
               <xsl:value-of select="@name"/>
               <xsl:text/>'  (on <xsl:text/>
               <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>
               <xsl:text/>) not allowed.
          Must  be  drawn from the list: content, uri (@name='content' or @name='uri' / error)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M95"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M95"/>
   <xsl:template match="@*|node()" priority="-2" mode="M95">
      <xsl:apply-templates select="*" mode="M95"/>
   </xsl:template>
   <!--PATTERN teipm-model-paramList-16-->
   <!--RULE -->
   <xsl:template match="tei:param[parent::tei:model/@behaviour='list']"
                 priority="1000"
                 mode="M96">

		<!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@name='content'"/>
         <xsl:otherwise>
            <xsl:message>
          Parameter name '<xsl:text/>
               <xsl:value-of select="@name"/>
               <xsl:text/>'  (on <xsl:text/>
               <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>
               <xsl:text/>) not allowed.
          Must  be  drawn from the list: content (@name='content' / error)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M96"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M96"/>
   <xsl:template match="@*|node()" priority="-2" mode="M96">
      <xsl:apply-templates select="*" mode="M96"/>
   </xsl:template>
   <!--PATTERN teipm-model-paramList-17-->
   <!--RULE -->
   <xsl:template match="tei:param[parent::tei:model/@behaviour='listItem']"
                 priority="1000"
                 mode="M97">

		<!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@name='content'"/>
         <xsl:otherwise>
            <xsl:message>
          Parameter name '<xsl:text/>
               <xsl:value-of select="@name"/>
               <xsl:text/>'  (on <xsl:text/>
               <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>
               <xsl:text/>) not allowed.
          Must  be  drawn from the list: content (@name='content' / error)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M97"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M97"/>
   <xsl:template match="@*|node()" priority="-2" mode="M97">
      <xsl:apply-templates select="*" mode="M97"/>
   </xsl:template>
   <!--PATTERN teipm-model-paramList-18-->
   <!--RULE -->
   <xsl:template match="tei:param[parent::tei:model/@behaviour='metadata']"
                 priority="1000"
                 mode="M98">

		<!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@name='content'"/>
         <xsl:otherwise>
            <xsl:message>
          Parameter name '<xsl:text/>
               <xsl:value-of select="@name"/>
               <xsl:text/>'  (on <xsl:text/>
               <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>
               <xsl:text/>) not allowed.
          Must  be  drawn from the list: content (@name='content' / error)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M98"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M98"/>
   <xsl:template match="@*|node()" priority="-2" mode="M98">
      <xsl:apply-templates select="*" mode="M98"/>
   </xsl:template>
   <!--PATTERN teipm-model-paramList-19-->
   <!--RULE -->
   <xsl:template match="tei:param[parent::tei:model/@behaviour='note']"
                 priority="1000"
                 mode="M99">

		<!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@name='content'   or  @name='place'   or  @name='label'"/>
         <xsl:otherwise>
            <xsl:message>
          Parameter name '<xsl:text/>
               <xsl:value-of select="@name"/>
               <xsl:text/>'  (on <xsl:text/>
               <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>
               <xsl:text/>) not allowed.
          Must  be  drawn from the list: content, place, label (@name='content' or @name='place' or @name='label' / error)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M99"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M99"/>
   <xsl:template match="@*|node()" priority="-2" mode="M99">
      <xsl:apply-templates select="*" mode="M99"/>
   </xsl:template>
   <!--PATTERN teipm-model-paramList-20-->
   <!--RULE -->
   <xsl:template match="tei:param[parent::tei:model/@behaviour='paragraph']"
                 priority="1000"
                 mode="M100">

		<!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@name='content'"/>
         <xsl:otherwise>
            <xsl:message>
          Parameter name '<xsl:text/>
               <xsl:value-of select="@name"/>
               <xsl:text/>'  (on <xsl:text/>
               <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>
               <xsl:text/>) not allowed.
          Must  be  drawn from the list: content (@name='content' / error)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M100"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M100"/>
   <xsl:template match="@*|node()" priority="-2" mode="M100">
      <xsl:apply-templates select="*" mode="M100"/>
   </xsl:template>
   <!--PATTERN teipm-model-paramList-21-->
   <!--RULE -->
   <xsl:template match="tei:param[parent::tei:model/@behaviour='row']"
                 priority="1000"
                 mode="M101">

		<!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@name='content'"/>
         <xsl:otherwise>
            <xsl:message>
          Parameter name '<xsl:text/>
               <xsl:value-of select="@name"/>
               <xsl:text/>'  (on <xsl:text/>
               <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>
               <xsl:text/>) not allowed.
          Must  be  drawn from the list: content (@name='content' / error)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M101"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M101"/>
   <xsl:template match="@*|node()" priority="-2" mode="M101">
      <xsl:apply-templates select="*" mode="M101"/>
   </xsl:template>
   <!--PATTERN teipm-model-paramList-22-->
   <!--RULE -->
   <xsl:template match="tei:param[parent::tei:model/@behaviour='section']"
                 priority="1000"
                 mode="M102">

		<!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@name='content'"/>
         <xsl:otherwise>
            <xsl:message>
          Parameter name '<xsl:text/>
               <xsl:value-of select="@name"/>
               <xsl:text/>'  (on <xsl:text/>
               <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>
               <xsl:text/>) not allowed.
          Must  be  drawn from the list: content (@name='content' / error)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M102"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M102"/>
   <xsl:template match="@*|node()" priority="-2" mode="M102">
      <xsl:apply-templates select="*" mode="M102"/>
   </xsl:template>
   <!--PATTERN teipm-model-paramList-23-->
   <!--RULE -->
   <xsl:template match="tei:param[parent::tei:model/@behaviour='table']"
                 priority="1000"
                 mode="M103">

		<!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@name='content'"/>
         <xsl:otherwise>
            <xsl:message>
          Parameter name '<xsl:text/>
               <xsl:value-of select="@name"/>
               <xsl:text/>'  (on <xsl:text/>
               <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>
               <xsl:text/>) not allowed.
          Must  be  drawn from the list: content (@name='content' / error)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M103"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M103"/>
   <xsl:template match="@*|node()" priority="-2" mode="M103">
      <xsl:apply-templates select="*" mode="M103"/>
   </xsl:template>
   <!--PATTERN teipm-model-paramList-24-->
   <!--RULE -->
   <xsl:template match="tei:param[parent::tei:model/@behaviour='text']"
                 priority="1000"
                 mode="M104">

		<!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@name='content'"/>
         <xsl:otherwise>
            <xsl:message>
          Parameter name '<xsl:text/>
               <xsl:value-of select="@name"/>
               <xsl:text/>'  (on <xsl:text/>
               <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>
               <xsl:text/>) not allowed.
          Must  be  drawn from the list: content (@name='content' / error)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M104"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M104"/>
   <xsl:template match="@*|node()" priority="-2" mode="M104">
      <xsl:apply-templates select="*" mode="M104"/>
   </xsl:template>
   <!--PATTERN teipm-model-paramList-25-->
   <!--RULE -->
   <xsl:template match="tei:param[parent::tei:model/@behaviour='title']"
                 priority="1000"
                 mode="M105">

		<!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@name='content'"/>
         <xsl:otherwise>
            <xsl:message>
          Parameter name '<xsl:text/>
               <xsl:value-of select="@name"/>
               <xsl:text/>'  (on <xsl:text/>
               <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>
               <xsl:text/>) not allowed.
          Must  be  drawn from the list: content (@name='content' / error)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M105"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M105"/>
   <xsl:template match="@*|node()" priority="-2" mode="M105">
      <xsl:apply-templates select="*" mode="M105"/>
   </xsl:template>
</xsl:stylesheet>
