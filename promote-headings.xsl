<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:ac="http://www.atlassian.com/schema/confluence/4/ac/"
  xmlns:ri="http://www.atlassian.com/schema/confluence/4/ri/"
  xmlns:acxhtml="http://www.atlassian.com/schema/confluence/4/"
  xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="acxhtml">

  <!-- Transforms Confluence XML storage format: deletes h1, promotes h2-h6 to h1-h5 -->
  
  <xsl:output method="xml" doctype-system="confluence.dtd"/>

  <!-- Identity transform: by default, simply copy all attributes and nodes to output -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Delete h1 -->
  <xsl:template match="acxhtml:h1"/>

  <!-- Replace h2-h6 with h1-h5 -->
  <xsl:template match="acxhtml:*[starts-with(local-name(), 'h') and (string-length(local-name()) = 2) and contains('23456', substring(local-name(), 2, 1))]">
    <xsl:element name="{concat('h', string(number(substring(local-name(), 2, 1)) - 1))}" namespace="http://www.atlassian.com/schema/confluence/4/">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

  <!-- Omit the xml-stylesheet PI (if it exists) from the output -->
  <xsl:template match="processing-instruction('xml-stylesheet')"/>

</xsl:stylesheet>