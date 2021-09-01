<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns="http://www.openarchives.org/OAI/2.0/"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd"
                version="2.0">
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>
  <xsl:template match="/*">
       <OAI-PMH xmlns="http://www.openarchives.org/OAI/2.0/"
               xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
               xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd">
        <ListRecords>
          <xsl:for-each select="marc:record">
            <xsl:variable name="isbn">
              <xsl:value-of select="normalize-space(replace(./marc:datafield[@tag='010']/marc:subfield[@code='a'],'_',''))"/>
            </xsl:variable>
            <xsl:variable name="ppn">
              <xsl:value-of select="document(concat('https://www.sudoc.fr/services/isbn2ppn/', $isbn))//result/ppn[last()]"/>
            </xsl:variable>
            <xsl:call-template name="copyunimarc">
              <xsl:with-param name="isbn" select="$isbn"/>
              <xsl:with-param name="provider" select="'Numilog'"/>
              <xsl:with-param name="ppn" select="$ppn"/>
            </xsl:call-template>
          </xsl:for-each>
        </ListRecords>
      </OAI-PMH>
  </xsl:template>
  <xsl:template name="copyunimarc">
    <xsl:param name="isbn"/>
    <xsl:param name="provider"/>
    <xsl:param name="ppn"/>
    <xsl:variable name="id" select="concat($provider, '-', $isbn, '-', position())"/>
    <record>
      <header>
        <identifier>numilog-publish:<xsl:value-of select="$id"/>
            </identifier>
      </header>
      <metadata>
        <record>
          <leader>
            <xsl:value-of select="marc:leader"/>
          </leader>
          <controlfield tag="FMT">BK</controlfield>
          <xsl:apply-templates select="@*|marc:datafield"/>
          <xsl:call-template name="indexation">
            <xsl:with-param name="ppn" select="$ppn"/>
          </xsl:call-template>
          <xsl:call-template name="exemplaire" />
        </record>
      </metadata>
    </record>
  </xsl:template>
  <xsl:template match="*">
    <xsl:element name="{local-name(.)}">
      <xsl:apply-templates select="@* | node()"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="@*">
    <xsl:attribute name="{local-name(.)}">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template match="marc:record/marc:datafield[@tag='010']">
    <datafield tag="010" ind1="" ind2="">
      <subfield code="a">
        <xsl:value-of select="translate(marc:subfield[@code='a'],'_','')"/>
      </subfield>
    </datafield>
  </xsl:template>
  <xsl:template match="marc:record/marc:datafield[@tag='856']">
    <datafield tag="856" ind1="4" ind2="">
      <subfield code="u">
        <xsl:value-of select="concat('http://proxy.unice.fr/login?url','=',marc:subfield[@code='u'])"/>
      </subfield>
    </datafield>
  </xsl:template>
  <xsl:template name="indexation">
    <xsl:param name="ppn"/>
    <xsl:variable name="notice">
      <xsl:value-of select="document(concat('https://www.sudoc.fr/',$ppn,'.xml'))"/>
    </xsl:variable>
    <xsl:if test="$notice">
    <xsl:for-each select="document(concat('https://www.sudoc.fr/',$ppn,'.xml'))//datafield[@tag='606']">
      <xsl:copy-of select="."/>
    </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <xsl:template name="exemplaire">
    <datafield tag="Z30" ind1="-" ind2="1">
      <subfield code="m">LELEC</subfield>
      <subfield code="1">BIBEL</subfield>
      <subfield code="A">Bibliothèque électronique</subfield>
      <subfield code="2">LELEC</subfield>
      <subfield code="B">Livres électroniques en ligne</subfield>
      <subfield code="C">0</subfield>
      <subfield code="i">Accès en ligne</subfield>
      <subfield code="c"/>
      <subfield code="5"/>
      <subfield code="8"/>
      <subfield code="f">23</subfield>
      <subfield code="F">Document électronique</subfield>
      <subfield code="g">00000000</subfield>
      <subfield code="G">000</subfield>
      <subfield code="t"/>
    </datafield>
    <datafield tag="AVA" ind1=" " ind2=" ">
      <subfield code="a">UNS51</subfield>
      <subfield code="b">BIBEL</subfield>
      <subfield code="c">Livres électroniques en ligne</subfield>
      <subfield code="d">Accès en ligne</subfield>
      <subfield code="e">available</subfield>
      <subfield code="t">Disponible</subfield>
      <subfield code="f">1</subfield>
      <subfield code="g">0</subfield>
      <subfield code="h">N</subfield>
      <subfield code="i">0</subfield>
      <subfield code="j">LELEC</subfield>
      <subfield code="k">0</subfield>
    </datafield>
    <datafield tag="TYP" ind1=" " ind2=" ">
      <subfield code="a">ON</subfield>
      <subfield code="b">Online material</subfield>
    </datafield>
  </xsl:template>
</xsl:stylesheet>
