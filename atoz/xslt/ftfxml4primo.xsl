<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
<xsl:import href="file:///////C:/Users/BUNICE/Desktop/temp/atoz_xml_workflow/tables_conversion.xsl"/>
  <xsl:output method="xml" indent="yes"/>
   <xsl:strip-space elements="*"/>
   <xsl:variable name="packages" select="holdings/packageCollection"/>
   <xsl:variable name="urls" select="holdings/urlCollection"/>
   <xsl:variable name="all_specific_titles">
<xsl:variable name="temp">~<xsl:for-each select="$specific/entry"><xsl:value-of select="Title"/>~</xsl:for-each></xsl:variable>
<xsl:value-of select="normalize-space($temp)"/>
</xsl:variable>
 <xsl:variable name="all_standard_packages">
<xsl:variable name="temp">~<xsl:for-each select="$standard/entry"><xsl:value-of select="PackgeName"/>~</xsl:for-each></xsl:variable>
<xsl:value-of select="normalize-space($temp)"/>
</xsl:variable>
  <xsl:template match="/*">
      <root>
         <xsl:for-each select="resourceCollection/resourceType">
            <xsl:variable name="id" select="./@ID"/>
            <xsl:variable name="title" select="title"/>
            <xsl:variable name="type" select="publicationType" />
            <xsl:if test="$type != '''Report'">
            <item>
               <LinkId>
                  <xsl:value-of select="$id"/>
               </LinkId>
               <ResourceId>
                  <xsl:value-of select="$id"/>
               </ResourceId>
               <Title>
                  <xsl:value-of select="title"/>
               </Title>
               <TitleSort>
                  <xsl:value-of select="alternatetitle"/>
               </TitleSort>
               <xsl:call-template name="package">
                  <xsl:with-param name="id" select="$id"/>
                  <xsl:with-param name="title" select="$title"/>
               </xsl:call-template>
               <ResourceType>
                  <xsl:value-of select="publicationType"/>
               </ResourceType>
               <Publisher>
                  <xsl:value-of select="publisher/publisherName"/>
               </Publisher>
               <xsl:choose>
                  <xsl:when test="contains(identifierCollection/isxnCollection/isxn[1]/isxnType,'ISSN')">
                     <PrintISSN>
                        <xsl:value-of select="identifierCollection/isxnCollection/isxn/isxnType[.='printISSN']/following-sibling::isxnValue"/>
                     </PrintISSN>
		                   <OnlineISSN>
                        <xsl:value-of select="identifierCollection/isxnCollection/isxn/isxnType[.='onlineISSN']/following-sibling::isxnValue"/>
                     </OnlineISSN>
                  </xsl:when>
                  <xsl:when test="contains(identifierCollection/isxnCollection/isxn[1]/isxnType,'ISBN')">
                     <PrintISBN>
                        <xsl:value-of select="identifierCollection/isxnCollection/isxn/isxnType[.='printISBN']/following-sibling::isxnValue"/>
                     </PrintISBN>
		                   <OnlineISBN>
                        <xsl:value-of select="identifierCollection/isxnCollection/isxn/isxnType[.='onlineISBN']/following-sibling::isxnValue"/>
                     </OnlineISBN>
                  </xsl:when>
               </xsl:choose>
               <xsl:if test="contributorCollection/contributor[@type='author']">
                 <creator>
                     <xsl:value-of select="contributorCollection/contributor[@type='author']/fullname"/>
                  </creator>
               </xsl:if>
		             <Display>Y</Display>
            </item>
            </xsl:if>
         </xsl:for-each>
      </root>
   </xsl:template>

   <xsl:template name="package">
      <xsl:param name="id"/>
      <xsl:param name="title"/>
       <!--on récupère le nom du package dans la section packageCollection-->
      <xsl:variable name="source"
                    select="($packages/*/packageResources/resource[@itemID=$id])/ancestor::packageItem/packageName"/>
      <Source>
         <xsl:value-of select="$source"/>
      </Source>
      <!--on appelle le template de récupération des urls dans la section urlCollection-->
      <xsl:variable name="urlid"
                    select="$packages/*/packageResources/resource[@itemID=$id]/@urlID"/>
      <xsl:call-template name="url">
        <xsl:with-param name="urlid" select="$urlid"/>
      </xsl:call-template>
      <!--on récupère les notes et AcessType-->
        <xsl:call-template name="notes_and_accesstype">
                  <xsl:with-param name="title" select="$title"/>
                   <xsl:with-param name="source" select="$source"/>
        </xsl:call-template>
   </xsl:template>
   
   <xsl:template name="notes_and_accesstype">
      <xsl:param name="title"/>
      <xsl:param name="source"/>
      <xsl:choose>
       <xsl:when test="contains($all_specific_titles,$title)">
       <AccessType><xsl:value-of select="$specific/entry[Title = $title]/AccessType" /></AccessType>
       <Note><xsl:value-of select="$specific/entry[Title = $title]/Note" /></Note>
       </xsl:when>
       <xsl:when test="not(contains($all_specific_titles,$title)) and contains($all_standard_packages,$source)">
         <AccessType><xsl:value-of select="$standard/entry[PackageName = $source]/AccessType" /></AccessType>
        <Note><xsl:value-of select="$standard/entry[PackageName = $source]/Note" /></Note>
       </xsl:when>
        <xsl:when test="not(contains($all_specific_titles,$title)) and not(contains($all_standard_packages,$source))">
       <AccessType><xsl:value-of select="'0'" /></AccessType>
        <Note/>
       </xsl:when>
      </xsl:choose>
      </xsl:template>

    <xsl:template name="url">
      <xsl:param name="urlid"/>
      <URL>
         <xsl:value-of select="$urls/urlType[@ID=$urlid]/URL"/>
      </URL>
       <proxiedURL>
         <xsl:value-of select="$urls/urlType[@ID=$urlid]/proxiedURL"/>
      </proxiedURL>
      <ManagedCoverage>
         <xsl:variable name="start">
            <xsl:call-template name="coverage">
               <xsl:with-param name="date"
                               select="$urls/urlType[@ID=$urlid]/coverageCollection/coverage/coverageRangeSet/coverageRange/begin"/>
            </xsl:call-template>
         </xsl:variable>
         <xsl:variable name="end">
            <xsl:call-template name="coverage">
               <xsl:with-param name="date"
                               select="$urls/urlType[@ID=$urlid]/coverageCollection/coverage/coverageRangeSet/coverageRange/ends"/>
            </xsl:call-template>
         </xsl:variable>
         <xsl:choose>
            <xsl:when test="$end = 'present'">
               <xsl:value-of select="concat($start,' to ',$end)"/> 
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="concat($start,' - ',$end)"/>
            </xsl:otherwise>
         </xsl:choose>  
      </ManagedCoverage>
   </xsl:template>

   <xsl:template name="coverage">
      <xsl:param name="date"/>
      <xsl:choose>
         <xsl:when test="$date = 'Present'">
            <xsl:value-of select="'present'"/>
         </xsl:when>
         <xsl:when test="string-length($date) = 10 and contains($date, '-')">
            <xsl:value-of select="substring($date,1,4)"/>
         </xsl:when>
      </xsl:choose>
      </xsl:template>
    
</xsl:stylesheet>


