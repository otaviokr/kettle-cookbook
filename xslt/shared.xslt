<?xml version="1.0"?>
<!--

    This is shared.xslt.
    shared.xslt - an XSLT transformation that defines variables, parameters, templets etc
    required for each specific xslt file in kettle-cookbook.
    
    This is part of kettle-cookbook, a documentation generation framework for 
    the Pentaho Business Intelligence Suite.
    Kettle-cookbook is distributed on http://code.google.com/p/kettle-cookbook/

    Copyright (C) 2010 Roland Bouman 
    Roland.Bouman@gmail.com - http://rpbouman.blogspot.com/

    This library is free software; you can redistribute it and/or modify it under 
    the terms of the GNU Lesser General Public License as published by the 
    Free Software Foundation; either version 2.1 of the License, or (at your option)
    any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY 
    WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A 
    PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along 
    with this library; if not, write to 
    the Free Software Foundation, Inc., 
    59 Temple Place, Suite 330, 
    Boston, MA 02111-1307 USA

-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- =========================================================================
    Output
========================================================================== -->
<xsl:output
    method="html"
    version="4.0"
    encoding="UTF-8"
    omit-xml-declaration="yes"
    media-type="text/html"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
/>


<!-- =========================================================================
    XSLT VARIABLES
========================================================================== -->
<xsl:variable name="input-dir" select="/index/@input_dir"/>
<xsl:variable name="output-dir" select="/index/@output_dir"/>
<xsl:variable name="file-separator" select="/index/@file_separator"/>

<xsl:variable name="css-dir" select="'css/'"/>
<xsl:variable name="js-dir" select="'js/'"/>
<xsl:variable name="images-dir" select="'images/'"/>

<xsl:variable name="output-dir-uri">
    <xsl:variable name="output-dir-slashes">
        <xsl:call-template name="replace-backslashes-with-slash">
            <xsl:with-param name="text" select="$output-dir"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="trail">/</xsl:variable>
    <xsl:value-of select="concat('file://', $trail, $output-dir-slashes)"/>
</xsl:variable>

<xsl:variable name="connections-file" select="concat($output-dir-uri, '/connections.xml')"/>
<xsl:variable name="connections" select="document(concat($output-dir-uri, '/connections.xml'))/connections/connection"/>

<!--
    String utilities
-->
<xsl:variable name="lower-case-alphabet" select="'abcdefghijklmnopqrstuvwxyz'"/>
<xsl:variable name="upper-case-alphabet" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

<xsl:template name="lower-case">
    <xsl:param name="text"/>
    <xsl:value-of select="translate($text, $upper-case-alphabet, $lower-case-alphabet)"/>
</xsl:template>

<xsl:template name="upper-case">
    <xsl:param name="text"/>
    <xsl:value-of select="translate($text, $lower-case-alphabet, $upper-case-alphabet)"/>
</xsl:template>

<xsl:template name="replace">
    <xsl:param name="text"/>
    <xsl:param name="search"/>
    <xsl:param name="replace" select="''"/>
    <xsl:choose>
		<xsl:when test="contains($text, $search)">
			<xsl:call-template name="replace">
				<xsl:with-param 
					name="text" 
					select="
						concat(
							substring-before($text, $search)
						,	$replace
						,	substring-after($text, $search)
						)
					"
				/>
				<xsl:with-param name="search" select="$search"/>
				<xsl:with-param name="replace" select="$replace"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise><xsl:value-of select="$text"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="replace-backslashes-with-slash">
	<xsl:param name="text"/>
	<xsl:call-template name="replace">
		<xsl:with-param name="text" select="$text"/>
		<xsl:with-param name="search" select="'\'"/>
		<xsl:with-param name="replace" select="'/'"/>
	</xsl:call-template>
</xsl:template>


<!--
    Number utilities
-->
<xsl:template name="max">
    <xsl:param name="values"/>
    <xsl:for-each select="$values">
        <xsl:sort data-type="number" order="descending"/>
        <xsl:if test="position()=1">
          <xsl:value-of select="."/>
        </xsl:if>
    </xsl:for-each>
</xsl:template>

<xsl:template name="min">
    <xsl:param name="values"/>
    <xsl:for-each select="$values">
        <xsl:sort data-type="number"/>
        <xsl:if test="position()=1">
          <xsl:value-of select="."/>
        </xsl:if>
    </xsl:for-each>
</xsl:template>

<!--
    Generic templates
-->
<xsl:template name="copy-contents">
    <xsl:param name="parent" select="."/>
    <xsl:for-each select="$parent/node()"><xsl:copy-of select="."/></xsl:for-each>
</xsl:template>


<xsl:template name="description">
    <xsl:param name="node" select="."/>
    <xsl:param name="type" select="$item-type"/>
    <xsl:for-each select="$node">
        <xsl:choose>
            <xsl:when test="$node/description[text()]">
                <pre>
                    <p class="description">
                        <xsl:value-of select="$node/description"/>
                    </p>
                    </pre>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    This <xsl:value-of select="$type"/> does not have a description.
                </p>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="$node/extended_description[text()]">
            <pre>
                <p style="font-family:courier;font-size:9pt;color:blue">
                    <xsl:value-of select="$node/extended_description"/>
                </p>
                </pre>
        </xsl:if>
    </xsl:for-each>
    
    
</xsl:template>

<xsl:template name="transdescription">
    <xsl:param name="node" select="."/>
    <xsl:param name="type" select="$item-type"/>
    <xsl:for-each select="$node">
        <xsl:choose>
            <xsl:when test="$node/info/description[text()]">
                <pre>
                    <p class="description">
                        <xsl:value-of select="$node/info/description"/>
                    </p>
                    </pre>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    This <xsl:value-of select="$type"/> does not have a description.
                </p>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="$node/info/extended_description[text()]">
            <pre>
                <p style="font-family:courier;font-size:9pt;color:blue">
                    <xsl:value-of select="$node/info/extended_description"/>
                </p>
                </pre>
        </xsl:if>
    </xsl:for-each>
    
    
</xsl:template>

<xsl:variable name="meta">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=8" />
    <meta name="Generator" content="kettle-cookbook - see http://code.google.com/p/kettle-cookbook/" />
</xsl:variable>

<xsl:template name="stylesheet">
    <xsl:param name="name"/>
    <link rel="stylesheet" type="text/css">
        <xsl:attribute name="href">
            <xsl:value-of select="concat($css-dir, $name, '.css')"/>
        </xsl:attribute>
    </link>
</xsl:template>

<xsl:template name="favicon">
    <xsl:param name="name"/>
    <xsl:param name="extension" select="png"/>
    <link rel="shortcut icon" type="image/x-icon">
        <xsl:attribute name="href">
            <xsl:value-of select="concat($images-dir, $name, '.', $extension)"/>
        </xsl:attribute>
    </link>
</xsl:template>

<xsl:template name="script">
    <xsl:param name="name"/>
    <script type="text/javascript">
        <xsl:attribute name="src">
            <xsl:value-of select="concat($js-dir, $name, '.js')"/>
        </xsl:attribute>
    </script>
</xsl:template>

</xsl:stylesheet>
