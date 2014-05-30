<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:DTS="www.microsoft.com/SqlServer/Dts"
  xmlns:my="my:my"
  exclude-result-prefixes="xs DTS my"
  version="2.0">

<!--
extract the mappings of SCD components and the maping type of the columns involved
tested with: SQL Server 2008R2

Usage
- process on the commandline:
   saxonb-xslt -o result.html your_ssis_package.dtsx scd.xsl
- in document
  add 
    <?xml-stylesheet type="text/xsl" href="scd.xsl"?>
    to the dtsx file right after the <?xml version="1.0"?>.
    Place the scd.xsl file in the same directory as the dtsx file
    and then open the dtsx in the browser (tested with firefox).

n.b.: needs xslt 2.0
-->

<my:map>
   <mapTypes>
    <mapType id="1" name="business key" />
    <mapType id="2" name="changing" />
    <mapType id="3" name="historic" />
    <mapType id="4" name="fixed" />
   </mapTypes>
   <scdClasses>
     <scd classid="{70909A92-ECE9-486D-B17E-30EDE908849E}" name="SCD sql server 2008r2"/>
   </scdClasses>
</my:map>

<xsl:variable name="typeNames" select="document('')/*/my:map/mapTypes/mapType"/>
<xsl:variable name="scd" select="document('')/*/my:map/scdClasses/scd/@classid"/>

<xsl:output omit-xml-declaration="yes"/>

<xsl:template match="/">
<html>
 <head>
<meta charset="UTF-8" />
</head>
<body>
    <xsl:apply-templates select="node()"/>
</body>
</html>
</xsl:template>

<xsl:template match="pipeline[descendant::component[@componentClassID=$scd]]">
<h2><xsl:value-of select="../../DTS:Property[@DTS:Name='ObjectName']"/></h2>
    <xsl:apply-templates select="@*|node()"/>
</xsl:template>

<xsl:template match="component[@componentClassID=$scd]">
<table border="1">
<tr>
<td colspan="3"><xsl:value-of select="@name"/></td>
</tr>
<tr><th>incoming</th><th>outgoing</th><th>maptype</th></tr>
<xsl:for-each select="inputs/input/inputColumns/inputColumn">
  <tr>
    <td>
      <xsl:value-of select="ancestor::pipeline//outputColumn[@lineageId=current()/@lineageId]/@name"/>
    </td>
    <td>
      <xsl:value-of select="../..//externalMetadataColumn[@id=current()/@externalMetadataColumnId]/@name"/>
    </td>
    <td>
      <xsl:value-of select="$typeNames[@id = current()//property[@name='ColumnType']/text()]/@name"/>
    </td>
  </tr>
</xsl:for-each>
</table>
</xsl:template>


<xsl:template match="@*|node()">
    <xsl:apply-templates select="node()"/>
</xsl:template>

</xsl:stylesheet>

