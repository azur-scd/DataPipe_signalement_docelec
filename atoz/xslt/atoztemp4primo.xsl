<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:import href="../../xsltroot.xsl"/>
   <xsl:import href="tables_conversion.xsl"/>
  <xsl:output  method="xml" version="1.0" encoding="UTF-8" indent="yes" />
   <xsl:strip-space elements="*"/>
   <xsl:param name="xml_file_name" select="concat($root,'/','atoz/atoz.xml')" />
   <!--variables de tables_conversion.xsl-->
     <xsl:variable name="all_specific_titles">
      <xsl:variable name="temp">~<xsl:for-each select="$specific/entry">
            <xsl:value-of select="Title"/>~</xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($temp)"/>
   </xsl:variable>
   <xsl:variable name="all_standard_packages">
      <xsl:variable name="temp">~<xsl:for-each select="$standard/entry">
            <xsl:value-of select="PackgeName"/>~</xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($temp)"/>
   </xsl:variable>
   
   <!--result-document template-->
   <xsl:template match="/">
  <xsl:result-document href="{$xml_file_name}">
    <xsl:apply-templates/>
  </xsl:result-document>
</xsl:template>

   <!--identity template-->
   <xsl:template match="node()|@*">
     <xsl:copy>
         <xsl:apply-templates select="node()|@*"/>
     </xsl:copy>
   </xsl:template>
  
   <xsl:template match="Resource">
      <xsl:variable name="source" select="Source"/>
      <xsl:variable name="title" select="Title"/>
      <xsl:variable name="rtype" select="ResourceType" />
      <xsl:if test="$rtype != 'Report'">
      <xsl:copy>
         <xsl:apply-templates select="node()|@*"/>
         <!--increment counter with position-->
         <LinkId>
            <xsl:value-of select="position()"/> 
         </LinkId>
         <!--new xml entry-->
         <ManagedCoverage>
            <xsl:variable name="start">
               <xsl:call-template name="coverage">
                  <xsl:with-param name="date" select="ManagedCoverageBegin"/>
               </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="end">
               <xsl:call-template name="coverage">
                  <xsl:with-param name="date" select="ManagedCoverageEnd"/>
               </xsl:call-template>
            </xsl:variable>
            <xsl:choose>
            <xsl:when test="$rtype = 'Book'">
              <xsl:value-of select="$start"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
               <xsl:when test="$end = 'present'">
                  <xsl:value-of select="concat($start,' to ',$end)"/> 
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="concat($start,' - ',$end)"/>
               </xsl:otherwise>
            </xsl:choose>
            </xsl:otherwise>
            </xsl:choose>
         </ManagedCoverage>
         <!--new entries by calling external template-->
        <xsl:call-template name="notes_and_accesstype">
                  <xsl:with-param name="title" select="$title"/>
                   <xsl:with-param name="source" select="$source"/>
        </xsl:call-template>
      </xsl:copy>
      </xsl:if>
   </xsl:template>

  <!-- remove elements -->
  <xsl:template match="ManagedCoverageBegin"/>
  <xsl:template match="ManagedCoverageEnd"/>

   <!--common template to manage date format-->
  <xsl:template name="coverage">
      <xsl:param name="date"/>
      <xsl:choose>
         <xsl:when test="$date = 'Present'">
            <xsl:value-of select="'present'"/>
         </xsl:when>
         <xsl:when test="string-length($date) = 10 and contains($date, '-')">
            <xsl:value-of select="substring($date,1,4)"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$date"/>
         </xsl:otherwise>
      </xsl:choose>
      </xsl:template>

   <!--template adding notes & accesstype by comparing with tables_conversion-->
       <xsl:template name="notes_and_accesstype">
      <xsl:param name="title"/>
      <xsl:param name="source"/>
      <xsl:choose>
         <xsl:when test="contains($all_specific_titles,$title)">
            <AccessType>
               <xsl:value-of select="$specific/entry[Title = $title]/AccessType"/>
            </AccessType>
            <Note>
               <xsl:value-of select="$specific/entry[Title = $title]/Note"/>
            </Note>
         </xsl:when>
         <xsl:when test="not(contains($all_specific_titles,$title)) and contains($all_standard_packages,$source)">
            <AccessType>
               <xsl:value-of select="$standard/entry[PackageName = $source]/AccessType"/>
            </AccessType>
            <Note>
               <xsl:value-of select="$standard/entry[PackageName = $source]/Note"/>
            </Note>
         </xsl:when>
        <xsl:when test="not(contains($all_specific_titles,$title)) and not(contains($all_standard_packages,$source))">
            <AccessType>
               <xsl:value-of select="'0'"/>
            </AccessType>
            <Note/>
         </xsl:when>
      </xsl:choose>
      </xsl:template>
</xsl:stylesheet>






