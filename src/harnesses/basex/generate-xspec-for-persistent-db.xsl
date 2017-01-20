<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:x="http://www.jenitennison.com/xslt/xspec"
	xmlns:dbs="http://els.eu/ns/efl/offresMetiers/BaseX/DatabaseStructure" xmlns:local="local"
	exclude-result-prefixes="#all" version="3.0">

	<xsl:variable name="dbElements" as="xs:string*" select="('dbs:database', 'dbs:resource')"/>

	<xsl:template match="/*">
		<xsl:copy>
			<xsl:attribute name="xml:base" select="base-uri()"/>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="x:param[local:isDbParam(.)]">
		<xsl:variable name="scenario" as="element(x:scenario)" select="ancestor::x:scenario[1]"/>
		<xsl:variable name="index" as="xs:integer" select="count($scenario/preceding::x:scenario) + 1"/>
		<xsl:variable name="dbElement" as="element()" select="*[1]"/>
		<x:param name="{@name}"
			select="{local:dbPath($dbElement, $index)}{if (@select) then @select else ()}"/>
	</xsl:template>

	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:function name="local:isDbParam" as="xs:boolean">
		<xsl:param name="p" as="element(x:param)"/>
		<xsl:value-of
			select="
				$p/@as[starts-with(., 'element(') and
				substring-before(substring-after(., 'element('), ')') = $dbElements] or
				$p/*[1]/name() = $dbElements"
		/>
	</xsl:function>

	<xsl:function name="local:dbPath" as="xs:string">
		<xsl:param name="dbElement" as="element()"/>
		<xsl:param name="index" as="xs:integer"/>
		<xsl:variable name="db_name" as="xs:string" select="concat($dbElement/@name, '_', $index)"/>
		<xsl:choose>
			<xsl:when test="$dbElement/name() = 'dbs:database'">
				<!-- collection('<base-name>') -->
				<xsl:value-of select="concat('collection(''', $db_name, ''')')"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- dbs:resource -->
				<!-- doc('<base-name>/<doc-path>') -->
				<xsl:value-of select="concat('doc(''', $db_name, '/', $dbElement/@path, ''')')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

</xsl:stylesheet>
