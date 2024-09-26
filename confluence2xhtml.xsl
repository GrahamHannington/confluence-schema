<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:ac="http://www.atlassian.com/schema/confluence/4/ac/"
  xmlns:ri="http://www.atlassian.com/schema/confluence/4/ri/"
  xmlns:acxhtml="http://www.atlassian.com/schema/confluence/4/"
  xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="xsl ac ri acxhtml">

  <!-- Transform Confluence storage format to XHTML -->

  <!-- Identity transform: by default, simply copy all attributes and nodes to output -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Replace the Confluence page root element with XHTML wrapper -->
  <xsl:template match="/*">
    <html>
      <head>
        <title>Confluence page</title>
        <style type="text/css">
        /* <![CDATA[ */
          body {
            font-family: sans-serif;
            background-color: white;
            color: black;
          }
          /* Content styles */
          table
          {
            border-collapse: collapse;
          }
          th
          {
            vertical-align: bottom;
            text-align: left;
            background-color: #F0F0F0;
          }
          td
          {
            vertical-align: top;
          }
          td, th
          {
            border: 1px solid #909090;
            padding: 0.5em;
          }
          /* Markup-related styles */
          .markup {
            color: #A9A9A9;
          }
          .element-name {
            color: #800080;
            font-weight: bold;
          }
          .comment {
            color: green;
          }
          .cdata {
            color: #CC0066;
          }
          .text {
            font-family: sans-serif;
            color: black;
          }
          .attribute-name {
            color: #800080;
          }
          .attribute-value {
           color: black;
          }
          div.extension-element {
            margin-top: 0.5em;
            margin-bottom: 0.5em;
            border: 1px solid #DDDDDD;
            background-color: #F0F0F0;
          }
          p.extension-element-markup {
            margin-top: 0.2em;
            margin-bottom: 0.2em;
            padding-left: 0.5em;
            padding-right: 0.5em;
          }
          div.extension-element-contents {
            border-top: 1px solid #DDDDDD;
            padding: 0.5em;
            background-color: #FFFFFF;
          }
          /* ]]> */
          </style>
      </head>
      <body>
        <xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>

  <!-- Omit the xml-stylesheet PI from the output -->
  <xsl:template match="processing-instruction('xml-stylesheet')"/>

  <!-- Move XHTML-like elements into XHTML namespace -->
  <xsl:template match="acxhtml:*">
    <xsl:element name="{local-name(.)}" namespace = "http://www.w3.org/1999/xhtml">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element> 
  </xsl:template>

  <!-- Represent extension elements as their XML source -->
  <xsl:template match="ac:* | ri:*">
    <div class="extension-element">
      <p class="extension-element-markup">
        <span class="element-name">
         <xsl:value-of select="name(.)"/>
        </span>
        <xsl:apply-templates select="@*"/>
      </p>
      <xsl:if test="node()">
        <div class="extension-element-contents">
          <xsl:choose>
            <xsl:when test="name(.) = 'ac:plain-text-body'">
              <pre><xsl:apply-templates select="node()"/></pre>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="node()"/>
            </xsl:otherwise>
          </xsl:choose>
        </div>
      </xsl:if>
    </div>
  </xsl:template>

  <!-- Represent extension attributes as their XML source -->
  <xsl:template match="ac:*/@* | ri:*/@*">
    <xsl:text> </xsl:text>
    <span class="attribute-name">
      <xsl:value-of select="name(.)"/>
    </span>
    <span class="markup">
      <xsl:text>="</xsl:text>
    </span>
    <span class="attribute-value">
      <xsl:value-of select="."/>
    </span>
    <span class="markup">
      <xsl:text>"</xsl:text>
    </span>
  </xsl:template>

</xsl:stylesheet>