<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns="http://www.openarchives.org/OAI/2.0/"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd"
                exclude-result-prefixes="#default"
                version="2.0">
  	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
  <xsl:template match="/*">
      <OAI-PMH xmlns="http://www.openarchives.org/OAI/2.0/"
               xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
               xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd">
         <ListRecords>
            <xsl:for-each select="record">
               <xsl:variable name="isbn">
                  <xsl:value-of select="isbn"/>
               </xsl:variable>
                <xsl:variable name="url">
                  <xsl:value-of select="url"/>
               </xsl:variable>
               <xsl:variable name="ppn">
                  <xsl:value-of select="document(concat('https://www.sudoc.fr/services/isbn2ppn/', $isbn))//result/ppn[1]"/>
               </xsl:variable>
                <xsl:variable name="sudoc_record">
                    <xsl:copy-of select="document(concat('https://www.sudoc.fr/',$ppn,'.xml'))"/>
                  </xsl:variable> 
               <xsl:call-template name="copyrecord">
                  <xsl:with-param name="isbn" select="$isbn"/>
                   <xsl:with-param name="ppn" select="$ppn"/>
                  <xsl:with-param name="url" select="$url"/>
                  <xsl:with-param name="provider_prefixe" select="'lextenso'"/>
                  <xsl:with-param name="sudoc_record" select="$sudoc_record"/>
               </xsl:call-template>
            </xsl:for-each>
         </ListRecords>
      </OAI-PMH>
  </xsl:template>
  <xsl:template name="copyrecord">
      <xsl:param name="isbn"/>
      <xsl:param name="ppn"/>
       <xsl:param name="url"/>
      <xsl:param name="provider_prefixe"/>
       <xsl:param name="sudoc_record"/>
      <xsl:variable name="id" select="concat($provider_prefixe, replace($isbn,'-',''))"/>
      <record>
         <header>
            <identifier>
               <xsl:value-of select="lower-case($provider_prefixe)"/>-publish:<xsl:value-of select="$id"/>
            </identifier>
         </header>
         <metadata>
            <record>
               <xsl:copy-of select="$sudoc_record/record/leader"/>
               <controlfield tag="FMT">BK</controlfield>
               <controlfield tag="001">PPN<xsl:value-of select="$ppn"/>
               </controlfield>
               <xsl:copy-of select="$sudoc_record/record/datafield[not(@tag = '181') and not(@tag = '182') and not(@tag = '183') and not(@tag = '215') and not(starts-with(@tag,'8')) and not(starts-with(@tag,'9'))]"/>
               <datafield tag="856" ind1="4" ind2=" ">
                  <subfield code="u">
                     <xsl:value-of select="concat('http://proxy.unice.fr/login?url=',$url)"/>
                  </subfield>
               </datafield>
               <xsl:call-template name="donnees_exemplaire"/>
            </record>
         </metadata>
      </record>
  </xsl:template>
  
  <xsl:template name="donnees_exemplaire">
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
