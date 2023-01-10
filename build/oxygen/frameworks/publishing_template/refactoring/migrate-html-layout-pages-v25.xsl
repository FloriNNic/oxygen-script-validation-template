<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xr="http://www.oxygenxml.com/ns/xmlRefactoring"
    xmlns:whc="http://www.oxygenxml.com/webhelp/components"
    xmlns:saxon="http://saxon.sf.net/"
    exclude-result-prefixes="xs xr saxon"
    xpath-default-namespace="http://www.w3.org/1999/xhtml"
    version="3.0">
    
    <!-- Change whc:version attribute value -->
    <xsl:template match="@whc:version" mode="#default">
        <xsl:attribute name="whc:version">25.0</xsl:attribute>
    </xsl:template>
    
    <!-- Add feedback fragment in search page -->
    <xsl:template match="body[contains(@class, 'wh_search_page')]//whc:include_html[contains(@href, 'footer.xml')]" mode="#default">
        <xsl:text>&#xa;</xsl:text>
        <whc:include_html>
            <xsl:attribute name="href">${webhelp.fragment.feedback}</xsl:attribute>
        </whc:include_html>
        <xsl:text>&#xa;</xsl:text>
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- Add feedback fragment in search page -->
    <xsl:template match="body[contains(@class, 'wh_search_page') or contains(@class, 'wh_main_page')]//whc:include_html[contains(@href, 'footer.xml')]" mode="#default">
        <xsl:text>&#xa;</xsl:text>
        <whc:include_html>
            <xsl:attribute name="href">${webhelp.fragment.feedback}</xsl:attribute>
        </whc:include_html>
        <xsl:text>&#xa;</xsl:text>
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="* | text() | processing-instruction() | comment() | @*" mode="#default" >
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" />
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>