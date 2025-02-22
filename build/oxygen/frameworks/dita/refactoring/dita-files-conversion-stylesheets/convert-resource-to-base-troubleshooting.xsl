<?xml version="1.0" encoding="UTF-8"?>
<!--
  Copyright 2001-2022 Syncro Soft SRL. All rights reserved.
 --> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">

    <xsl:import href="copy-template.xsl"/>


    <xsl:template match="concept">
        <topic>
          <xsl:apply-templates select="@*|node()"/>
        </topic>
    </xsl:template>

    <xsl:template match="conbody">
        <body>
          <xsl:apply-templates select="@*|node()"/>
        </body>
    </xsl:template>

    <xsl:template match="conbodydiv">
        <bodydiv>
          <xsl:apply-templates select="@*|node()"/>
        </bodydiv>
    </xsl:template>

    <xsl:template match="reference">
        <topic>
          <xsl:apply-templates select="@*|node()"/>
        </topic>
    </xsl:template>

    <xsl:template match="refbody">
        <body>
          <xsl:apply-templates select="@*|node()"/>
        </body>
    </xsl:template>

    <xsl:template match="refsyn">
        <section>
          <xsl:apply-templates select="@*|node()"/>
        </section>
    </xsl:template>

    <xsl:template match="properties">
        <simpletable>
          <xsl:apply-templates select="@*|node()"/>
        </simpletable>
    </xsl:template>

    <xsl:template match="prophead">
        <sthead>
          <xsl:apply-templates select="@*|node()"/>
        </sthead>
    </xsl:template>

    <xsl:template match="proptypehd">
        <stentry>
          <xsl:apply-templates select="@*|node()"/>
        </stentry>
    </xsl:template>

    <xsl:template match="propvaluehd">
        <stentry>
          <xsl:apply-templates select="@*|node()"/>
        </stentry>
    </xsl:template>

    <xsl:template match="propdeschd">
        <stentry>
          <xsl:apply-templates select="@*|node()"/>
        </stentry>
    </xsl:template>

    <xsl:template match="property">
        <strow>
          <xsl:apply-templates select="@*|node()"/>
        </strow>
    </xsl:template>

    <xsl:template match="proptype">
        <stentry>
          <xsl:apply-templates select="@*|node()"/>
        </stentry>
    </xsl:template>

    <xsl:template match="propvalue">
        <stentry>
          <xsl:apply-templates select="@*|node()"/>
        </stentry>
    </xsl:template>

    <xsl:template match="propdesc">
        <stentry>
          <xsl:apply-templates select="@*|node()"/>
        </stentry>
    </xsl:template>

    <xsl:template match="task">
        <topic>
          <xsl:apply-templates select="@*|node()"/>
        </topic>
    </xsl:template>

    <xsl:template match="taskbody">
        <body>
          <xsl:apply-templates select="@*|node()"/>
        </body>
    </xsl:template>

    <xsl:template match="prereq">
        <section>
          <xsl:apply-templates select="@*|node()"/>
        </section>
    </xsl:template>

    <xsl:template match="context">
        <section>
          <xsl:apply-templates select="@*|node()"/>
        </section>
    </xsl:template>

    <xsl:template match="steps">
        <ol>
          <xsl:apply-templates select="@*|node()"/>
        </ol>
    </xsl:template>

    <xsl:template match="steps-informal">
        <section>
          <xsl:apply-templates select="@*|node()"/>
        </section>
    </xsl:template>

    <xsl:template match="steps-unordered">
        <ul>
          <xsl:apply-templates select="@*|node()"/>
        </ul>
    </xsl:template>

    <xsl:template match="step">
        <li>
          <xsl:apply-templates select="@*|node()"/>
        </li>
    </xsl:template>

    <xsl:template match="stepsection">
        <li>
          <xsl:apply-templates select="@*|node()"/>
        </li>
    </xsl:template>

    <xsl:template match="info">
        <itemgroup>
          <xsl:apply-templates select="@*|node()"/>
        </itemgroup>
    </xsl:template>

    <xsl:template match="responsibleParty">
        <p>
          <xsl:apply-templates select="@*|node()"/>
        </p>
    </xsl:template>

    <xsl:template match="substeps">
        <ol>
          <xsl:apply-templates select="@*|node()"/>
        </ol>
    </xsl:template>

    <xsl:template match="substep">
        <li>
          <xsl:apply-templates select="@*|node()"/>
        </li>
    </xsl:template>

    <xsl:template match="stepxmp">
        <itemgroup>
          <xsl:apply-templates select="@*|node()"/>
        </itemgroup>
    </xsl:template>

    <xsl:template match="choicetable">
        <simpletable>
          <xsl:apply-templates select="@*|node()"/>
        </simpletable>
    </xsl:template>

    <xsl:template match="chhead">
        <sthead>
          <xsl:apply-templates select="@*|node()"/>
        </sthead>
    </xsl:template>

    <xsl:template match="choptionhd">
        <stentry>
          <xsl:apply-templates select="@*|node()"/>
        </stentry>
    </xsl:template>

    <xsl:template match="chdeschd">
        <stentry>
          <xsl:apply-templates select="@*|node()"/>
        </stentry>
    </xsl:template>

    <xsl:template match="chrow">
        <strow>
          <xsl:apply-templates select="@*|node()"/>
        </strow>
    </xsl:template>

    <xsl:template match="choption">
        <stentry>
          <xsl:apply-templates select="@*|node()"/>
        </stentry>
    </xsl:template>

    <xsl:template match="chdesc">
        <stentry>
          <xsl:apply-templates select="@*|node()"/>
        </stentry>
    </xsl:template>

    <xsl:template match="choices">
        <ul>
          <xsl:apply-templates select="@*|node()"/>
        </ul>
    </xsl:template>

    <xsl:template match="choice">
        <li>
          <xsl:apply-templates select="@*|node()"/>
        </li>
    </xsl:template>

    <xsl:template match="steptroubleshooting">
        <itemgroup>
          <xsl:apply-templates select="@*|node()"/>
        </itemgroup>
    </xsl:template>

    <xsl:template match="stepresult">
        <itemgroup>
          <xsl:apply-templates select="@*|node()"/>
        </itemgroup>
    </xsl:template>

    <xsl:template match="tutorialinfo">
        <itemgroup>
          <xsl:apply-templates select="@*|node()"/>
        </itemgroup>
    </xsl:template>

    <xsl:template match="tasktroubleshooting">
        <section>
          <xsl:apply-templates select="@*|node()"/>
        </section>
    </xsl:template>

    <xsl:template match="result">
        <section>
          <xsl:apply-templates select="@*|node()"/>
        </section>
    </xsl:template>

    <xsl:template match="postreq">
        <section>
          <xsl:apply-templates select="@*|node()"/>
        </section>
    </xsl:template>

</xsl:stylesheet>