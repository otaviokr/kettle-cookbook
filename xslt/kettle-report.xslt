<?xml version="1.0"?>
<!--

    This is kettle-report.xslt. 
    kettle-report.xslt - an XSLT transformation that generates HTML documentation
    from a Kettle (aka Pentaho Data Integration) transformation or job file.

    This is part of kettle-cookbook, a documentation generation framework for 
    the Pentaho Business Intelligence Suite.
    Kettle-cookbook is distributed on http://code.google.com/p/kettle-cookbook/

    Copyright (C) 2010 Roland Bouman 
    Roland.Bouman@gmail.com - http://rpbouman.blogspot.com/
    David Bouyssel, Samatar Hassan (IE8 / IE7 compatibility for diagram hops)

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

    <xsl:import href="shared.xslt"/>
    <xsl:import href="file.xslt"/>
    <xsl:import href="io_steps.xslt"/>

    <xsl:variable name="item-type">
        <xsl:choose>
            <xsl:when test="$file-type = 'kjb'">job</xsl:when>
            <xsl:when test="$file-type = 'ktr'">transformation</xsl:when>
            <xsl:otherwise> </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="steps-or-job-entries">
        <xsl:choose>
            <xsl:when test="$file-type = 'kjb'">Job Entries</xsl:when>
            <xsl:when test="$file-type = 'ktr'">Steps</xsl:when>
            <xsl:otherwise> </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="step-or-job-entry">
        <xsl:choose>
            <xsl:when test="$file-type = 'kjb'">job entry</xsl:when>
            <xsl:when test="$file-type = 'ktr'">step</xsl:when>
            <xsl:otherwise> </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="quick-links">
        <div class="quicklinks">
            <a href="#diagram">Diagram</a>
    |   <a>
                <xsl:attribute name="href">#<xsl:value-of select="$steps-or-job-entries"
                    /></xsl:attribute>
                <xsl:value-of select="$steps-or-job-entries"/>
            </a>
    |   <a href="#parameters">Parameters</a>
    |   <a href="#variables"
                >Variables</a>
    |   <a href="#connections">Database Connections</a>
            <!--
    |   <a
                href="#files">Flat Files</a> -->
        </div>
    </xsl:variable>

    <xsl:template match="/">
        <html>
            <head>

                <xsl:copy-of select="$meta"/>

                <xsl:comment>
            Debugging info - please ignore
            param_filename: "<xsl:value-of select="$param_filename"/>"
            normalized_filename: "<xsl:value-of select="$normalized_filename"/>"
            file: <xsl:value-of select="count($file)"/>
            document: <xsl:value-of select="count($document)"/>
            document-element: <xsl:value-of select="local-name($document/*)"/>
            name: <xsl:value-of select="$document/*/name/text()"/>
            relative-path: "<xsl:value-of select="$relative-path"/>"
            documentation-root: "<xsl:value-of select="$documentation-root"/>"
        </xsl:comment>
                <title>Kettle Documentation: <xsl:value-of select="$item-type"/> "<xsl:value-of
                        select="$document/*/name"/>"</title>

                <xsl:call-template name="favicon">
                    <xsl:with-param name="name" select="'spoon'"/>
                </xsl:call-template>

                <xsl:call-template name="stylesheet">
                    <xsl:with-param name="name" select="'default'"/>
                </xsl:call-template>
                <xsl:call-template name="stylesheet">
                    <xsl:with-param name="name" select="'kettle'"/>
                </xsl:call-template>
                <xsl:call-template name="stylesheet">
                    <xsl:with-param name="name" select="$item-type"/>
                </xsl:call-template>
                <xsl:call-template name="stylesheet">
                    <xsl:with-param name="name" select="'shCoreDefault'"/>
                </xsl:call-template>

            </head>
            <body class="kettle-file">
                <xsl:copy-of select="$quick-links"/>

                <xsl:for-each select="$document">
                    <xsl:apply-templates/>
                </xsl:for-each>

                <xsl:call-template name="script">
                    <xsl:with-param name="name" select="'wz_jsgraphics'"/>
                </xsl:call-template>
                <xsl:call-template name="script">
                    <xsl:with-param name="name" select="'kettle'"/>
                </xsl:call-template>

                <xsl:call-template name="script">
                    <xsl:with-param name="name" select="'shCore'"/>
                </xsl:call-template>
                <xsl:call-template name="script">
                    <xsl:with-param name="name" select="'shBrushBash'"/>
                </xsl:call-template>
                <xsl:call-template name="script">
                    <xsl:with-param name="name" select="'shBrushJava'"/>
                </xsl:call-template>
                <xsl:call-template name="script">
                    <xsl:with-param name="name" select="'shBrushJScript'"/>
                </xsl:call-template>
                <xsl:call-template name="script">
                    <xsl:with-param name="name" select="'shBrushSql'"/>
                </xsl:call-template>
                <xsl:call-template name="script">
                    <xsl:with-param name="name" select="'shBrushMdx'"/>
                </xsl:call-template>
                <xsl:call-template name="script">
                    <xsl:with-param name="name" select="'shBrushXml'"/>
                </xsl:call-template>

                <script type="text/javascript">
            SyntaxHighlighter.all();drawHops();
        </script>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="parameters">
        <h2>
            <a name="parameters">Parameters</a>
        </h2>
        <xsl:choose>
            <xsl:when test="parameter">
                <p>
                This <xsl:value-of select="$item-type"/> defines <xsl:value-of
                        select="count(parameter)"/> parameters.
            </p>
                <table>
                    <thead>
                        <tr>
                            <th>
                            Name
                        </th>
                            <th>
                            Default Value
                        </th>
                            <th>
                            Description
                        </th>
                        </tr>
                    </thead>
                    <tbody>
                        <xsl:for-each select="parameter">
                            <tr>
                                <th>
                                    <xsl:value-of select="name"/>
                                </th>
                                <td>
                                    <xsl:value-of select="default_value"/>
                                </td>
                                <td>
                                    <xsl:value-of select="description"/>
                                </td>
                            </tr>
                        </xsl:for-each>
                    </tbody>
                </table>
            </xsl:when>
            <xsl:otherwise>
                <p>
                This <xsl:value-of select="$item-type"
                    /> does not define any parameters.
            </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- 
    =========================================================================
    Utils
    ========================================================================== 
    -->

    <xsl:template name="replace-dir-variables-with-doc-dir">
        <xsl:param name="text"/>
        <xsl:call-template name="replace">
            <xsl:with-param name="text">
                <xsl:call-template name="replace-backslashes-with-slash">
                    <xsl:with-param name="text" select="$text"/>
                </xsl:call-template>
            </xsl:with-param>
            <xsl:with-param name="search">${<xsl:choose>
                    <xsl:when test="$item-type='job'">Internal.Job.Filename.Directory</xsl:when>
                    <xsl:when test="$item-type='transformation'"
                        >Internal.Transformation.Filename.Directory</xsl:when>
                </xsl:choose>}/</xsl:with-param>
            <xsl:with-param name="replace" select="''"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="only-filename-from-object-id">
        <xsl:param name="id"/>
        <xsl:param name="separator" select="'/'"/>

        <xsl:choose>
            <xsl:when test="contains($id, $separator)">
                <xsl:call-template name="only-filename-from-object-id">
                    <xsl:with-param name="id" select="substring-after($id, $separator)"/>
                    <xsl:with-param name="separator" select="$separator"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$id"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="get-doc-uri-for-filename">
        <xsl:param name="step-or-job-entry"/>
        <xsl:variable name="type" select="local-name($step-or-job-entry)"/>
 
         <xsl:variable name="filename">
            <xsl:choose>
                <xsl:when test="$step-or-job-entry/filename/text()">
                    <xsl:value-of select="concat($step-or-job-entry/filename/text(), '.html')"/>
                </xsl:when>
                <!-- this is to support repository based etl -->
                <xsl:otherwise>
                    <!--
                    <xsl:variable name="prefix" select="concat($documentation-root, '/html', $step-or-job-entry/directory/text(), '/')"/>
                    -->
                    <xsl:variable name="prefix" select="concat($documentation-root, '/html')"/>
                    <xsl:choose>
                        <xsl:when test="$step-or-job-entry/type/text()='TRANS'">
                            <xsl:choose>
                                <!-- If the transformation is referred using trans_object_id -->
                                <xsl:when test="$step-or-job-entry/specification_method/text()='rep_ref'">
                                <!-- <xsl:when test="$step-or-job-entry/trans_object_id/text()"> -->
                                    <!-- <xsl:value-of select="concat($prefix, $step-or-job-entry/job_object_id/text(), '.html')"/> -->
                                    <xsl:variable name="trans_object_id_name">
                                        <xsl:call-template name="only-filename-from-object-id">
                                            <xsl:with-param name="id" select="$step-or-job-entry/trans_object_id/text()"/>
                                            <xsl:with-param name="separator" select="'/'"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:value-of select="concat($prefix, '/', $trans_object_id_name, '.html')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat($prefix, '/', $step-or-job-entry/transname/text(), '.ktr.html')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="$step-or-job-entry/type/text()='Mapping'">
                        	<xsl:choose>
                                <!-- If the transformation is referred using a relative path from repository -->
                                <xsl:when test="$step-or-job-entry/specification_method/text()='rep_name'">
                                	<xsl:choose>
		                                <!-- If transformation is in the relative root path, ignore directory field value -->
		                                <xsl:when test="ends-with($step-or-job-entry/directory_path/text(), '/')">
                                			<xsl:value-of select="concat($prefix, $step-or-job-entry/directory_path/text(), $step-or-job-entry/trans_name/text(), '.ktr.html')"/>
                                		</xsl:when>
                                		<xsl:otherwise>
                                			<xsl:value-of select="concat($prefix, $step-or-job-entry/directory_path/text(), 'CAIUNOOTHERWISE/', $step-or-job-entry/trans_name/text(), '.html')"/>
                                		</xsl:otherwise>
                                	</xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat($prefix, '/', $step-or-job-entry/transname/text(), '.ktr.html')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <!-- If the job is referred using job_object_id -->
                                <xsl:when test="$step-or-job-entry/specification_method/text() = 'rep_ref'">
                                <!-- <xsl:when test="$step-or-job-entry/job_object_id/text()"> -->
                                    <!-- <xsl:value-of select="concat($prefix, $step-or-job-entry/job_object_id/text(), '.html')"/> -->
                                    <xsl:variable name="job_object_id_name">
                                        <xsl:call-template name="only-filename-from-object-id">
                                            <xsl:with-param name="id" select="$step-or-job-entry/job_object_id/text()"/>
                                            <xsl:with-param name="separator" select="'/'"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:value-of select="concat($prefix, '/', $job_object_id_name, '.html')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat($prefix, '/', $step-or-job-entry/jobname/text(), '.kjb.html')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:call-template name="replace-dir-variables-with-doc-dir">
            <xsl:with-param name="text" select="$filename"/>
        </xsl:call-template>
    </xsl:template>


    <!-- 
    =========================================================================
    Database connections
    ========================================================================== 
    -->
    <xsl:template name="database-connections">
        <xsl:variable name="connection-usages"
            select="/*/step[connection[text()]] | /*/entries/entry[connection[text()]]"/>
        <h2>
            <a name="connections">Database Connections</a>
        </h2>
        <xsl:choose>
            <xsl:when test="count($connection-usages) &gt; 0">
                <p>This <xsl:value-of select="$item-type"/> defines <xsl:value-of
                        select="count(connection)"/> database connections.</p>
                <h3>Database Connection Summary</h3>
                <table>
                    <thead>
                        <tr>
                            <th>
                            Name
                        </th>
                            <th>
                            Type
                        </th>
                            <th>
                            Access
                        </th>
                            <th>
                            Host
                        </th>
                            <th>
                            Port
                        </th>
                            <th>
                            User
                        </th>
                            <th>
                            Used in <xsl:value-of
                                    select="$steps-or-job-entries"/>
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <xsl:for-each select="/*/connection">
                            <xsl:variable name="name" select="name/text()"/>
                            <xsl:variable name="usages"
                                select="$connection-usages[connection[text() = $name]]"/>
                            <tr>
                                <th>
                                    <a>
                                        <xsl:attribute name="href">#connection.<xsl:value-of
                                                select="$name"/></xsl:attribute>
                                        <xsl:value-of select="$name"/>
                                    </a>
                                </th>
                                <td>
                                    <xsl:value-of select="type"/>
                                </td>
                                <td>
                                    <xsl:value-of select="access"/>
                                </td>
                                <td>
                                    <xsl:value-of select="server"/>
                                </td>
                                <td>
                                    <xsl:value-of select="port"/>
                                </td>
                                <td>
                                    <xsl:value-of select="username"/>
                                </td>
                                <td>
                                    <xsl:for-each select="$usages">
                                        <xsl:if test="position()&gt;1">, </xsl:if>
                                        <a>
                                            <xsl:attribute name="href">#<xsl:value-of
                                                  select="name/text()"/></xsl:attribute>
                                            <xsl:value-of select="name/text()"/>
                                        </a>
                                    </xsl:for-each>
                                </td>
                            </tr>
                        </xsl:for-each>
                    </tbody>
                </table>
                <h3>Database Connection Details</h3>
                <xsl:apply-templates select="connection"/>
            </xsl:when>
            <xsl:otherwise>
                <p>This <xsl:value-of select="$item-type"
                    /> does not define any database connections.</p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="/*/connection">
        <h4>
            <a>
                <xsl:attribute name="name">connection.<xsl:value-of select="name"/></xsl:attribute>
                <xsl:value-of select="name"/>
            </a>
        </h4>
        <table>
            <thead>
                <tr>
                    <th>Property</th>
                    <th>Value</th>
                </tr>
            </thead>
            <tbody>
                <xsl:apply-templates select="*"/>
            </tbody>
        </table>
    </xsl:template>

    <xsl:template match="/*/connection/*[node()]">
        <xsl:variable name="tag" select="local-name()"/>
        <tr>
            <td>
                <xsl:value-of select="$tag"/>
            </td>
            <td>
                <xsl:choose>
                    <xsl:when test="$tag = 'attributes'"> </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
    </xsl:template>

    <!-- 
    =========================================================================
    VARIABLES
    ========================================================================== 
    -->
    <xsl:template name="get-variables">
        <xsl:param name="text"/>
        <xsl:param name="variables" select="''"/>
        <xsl:choose>
            <xsl:when test="contains($text, '${')">
                <xsl:variable name="after" select="substring-after($text, '${')"/>
                <xsl:variable name="var" select="substring-before($after, '}')"/>
                <xsl:variable name="vars">
                    <xsl:choose>
                        <xsl:when test="contains(concat(',', $variables), concat(',', $var, ','))">
                            <xsl:value-of select="$variables"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($variables, $var, ',')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:call-template name="get-variables">
                    <xsl:with-param name="text" select="substring-after($after, '}')"/>
                    <xsl:with-param name="variables" select="$vars"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$variables"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="variable-list">
        <xsl:variable name="nodes-using-variables" select="$document//*[contains(text(), '${')]"/>
        <xsl:variable name="list">
            <xsl:for-each select="$nodes-using-variables[0]">
                <xsl:call-template name="get-variables">
                    <xsl:with-param name="text" select="text()"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$list"/>
    </xsl:template>

    <xsl:template name="unique-variables">
        <xsl:param name="before" select="''"/>
        <xsl:param name="after">
            <xsl:call-template name="variables"/>
        </xsl:param>
        <xsl:variable name="var" select="substring-before($after, ',')"/>
        <xsl:if test="not(contains(concat(',', $before, ','), concat(',',$var,',')))">
            <tr>
                <th>
                    <xsl:value-of select="$var"/>
                </th>
                <td> </td>
                <td>
                    <xsl:for-each
                        select="/*/connection[.//*[contains(text(),concat('${',$var,'}'))]]">
                        <xsl:if test="position()&gt;1">, </xsl:if>
                        <a>
                            <xsl:attribute name="href">#connection.<xsl:value-of select="name"
                                /></xsl:attribute>
                            <xsl:value-of select="name"/>
                        </a>
                    </xsl:for-each>
                </td>
                <td>
                    <xsl:choose>
                        <xsl:when test="$item-type = 'job'">
                            <xsl:for-each
                                select="/*/entries/entry[.//*[contains(text(), concat('${', $var, '}'))]]">
                                <xsl:if test="position()&gt;1">, </xsl:if>
                                <a>
                                    <xsl:attribute name="href">#<xsl:value-of select="name"
                                        /></xsl:attribute>
                                    <xsl:value-of select="name"/>
                                </a>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="$item-type = 'transformation'">
                            <xsl:for-each
                                select="/*/step[.//*[contains(text(), concat('${', $var, '}'))]]">
                                <xsl:if test="position()&gt;1">, </xsl:if>
                                <a>
                                    <xsl:attribute name="href">#<xsl:value-of select="name"
                                        /></xsl:attribute>
                                    <xsl:value-of select="name"/>
                                </a>
                            </xsl:for-each>
                        </xsl:when>
                    </xsl:choose>
                </td>
            </tr>
        </xsl:if>
        <xsl:if test="string-length($var)!=0">
            <xsl:call-template name="unique-variables">
                <xsl:with-param name="before" select="concat($before, ',', $var)"/>
                <xsl:with-param name="after" select="substring-after($after, ',')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="variables">
        <xsl:variable name="variables-list">
            <xsl:call-template name="variable-list"/>
        </xsl:variable>
        <h2>
            <a name="variables">Variables</a>
        </h2>
        <xsl:choose>
            <xsl:when test="string-length($variables-list)=0">
                <p>This <xsl:value-of select="$item-type"/> does not read any variables.</p>
            </xsl:when>
            <xsl:otherwise>
                <p>This <xsl:value-of select="$item-type"/> reads the following variables:</p>
                <table>
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Value</th>
                            <th>Connections</th>
                            <th>
                                <xsl:value-of select="$steps-or-job-entries"/>
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <xsl:call-template name="unique-variables">
                            <xsl:with-param name="after" select="$variables-list"/>
                        </xsl:call-template>
                    </tbody>
                </table>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- 
    ==========================================================================
    DIAGRAM
    ========================================================================== 
    -->

    <xsl:template match="notepad">
        <pre class="note">
        <xsl:attribute name="style">
            left: <xsl:value-of select="xloc"/>px;
            top: <xsl:value-of select="yloc"/>px;
            width: <xsl:value-of select="width"/>px;
            height: <xsl:value-of select="height"/>px;
            font-family: <xsl:value-of select="fontname"/>;
            font-size: <xsl:value-of select="fontsize"/>;
            <xsl:if test="fontbold/text()='Y'">font-weight: bold;</xsl:if>
            <xsl:if test="fontitalic/text()='Y'">font-style: italic;</xsl:if>
            color: rgb(<xsl:value-of select="fontcolorred"/>
                    ,<xsl:value-of select="fontcolorgreen"/>
                    ,<xsl:value-of select="fontcolorblue"/>);
            background-color: rgb(<xsl:value-of select="backgroundcolorred"/>
                    ,<xsl:value-of select="backgroundcolorgreen"/>
                    ,<xsl:value-of select="backgroundcolorblue"/>);
            border-color: rgb(<xsl:value-of select="bordercolorred"/>
                    ,<xsl:value-of select="bordercolorgreen"/>
                    ,<xsl:value-of select="bordercolorblue"/>);
        </xsl:attribute>
        <xsl:value-of select="note"/>
    </pre>
    </xsl:template>
    <!-- 
    ==========================================================================
    Code
    ========================================================================== 
    -->
    <xsl:template match="sql[text()][../type/text()!='MondrianInput']">
        <h4>SQL</h4>
        Connection: <a>
            <xsl:attribute name="href">#connection.<xsl:value-of select="../connection/text()"/></xsl:attribute>
            <xsl:value-of select="../connection/text()"/>
        </a>
        <pre class="brush: sql;"><xsl:value-of select="text()"/></pre>
    </xsl:template>

    <xsl:template match="sql[text()][../type/text()='MondrianInput']">
        <h4>MDX</h4>
        <pre class="brush: mdx;"><xsl:value-of select="text()"/></pre>
    </xsl:template>

    <xsl:template match="jsScripts">
        <xsl:apply-templates select="jsScript"/>
    </xsl:template>

    <xsl:template match="jsScript">
        <h5>
            <xsl:value-of select="jsScript_name"/>
        </h5>
        <pre class="brush: js;"><xsl:value-of select="jsScript_script/text()"/></pre>
    </xsl:template>

    <xsl:template match="script">
        <pre class="brush: js;"><xsl:value-of select="text()"/></pre>
    </xsl:template>
	
    <xsl:template match="definitions[../type='UserDefinedJavaClass']">
        <h4>Java Class Source Code</h4>
        <xsl:apply-templates select="definition"/>
    </xsl:template>

    <xsl:template match="step[type='UserDefinedJavaClass']/definitions/definition">
        <h5>
            <xsl:value-of select="class_name"/>
        </h5>
        <pre class="brush: java;"><xsl:value-of select="class_source/text()"/></pre>
    </xsl:template>

    <!-- 
    =========================================================================
    KETTLE TRANSFORMATION
    ========================================================================== 
    -->
    <xsl:template match="transformation">
        <h1>
            <xsl:value-of select="info/name"/>
        </h1>
        <xsl:call-template name="info">
            <xsl:with-param name="created_user" select="info/created_user"/>
            <xsl:with-param name="created_date" select="info/created_date"/>
            <xsl:with-param name="modified_user" select="info/modified_user"/>
            <xsl:with-param name="modified_date" select="$modified_date"/>
            <xsl:with-param name="version" select="info/trans_version"/>
            <xsl:with-param name="status" select="info/trans_status/text()"/>
        </xsl:call-template>
        <xsl:call-template name="transdescription"/>


        <xsl:apply-templates select="info/parameters"/>
        <xsl:call-template name="high-level-data-flow-diagram"/>
        <xsl:call-template name="transformation-diagram"/>
        <xsl:call-template name="variables"/>
        <xsl:call-template name="database-connections"/>
        <!-- 
        <h2>Flat Files</h2>
        <p>
        t.b.d.
        </p>
        -->
        <xsl:call-template name="transformation-steps"/>
        <!-- <xsl:call-template name="transformation-dependencies"/> -->
    </xsl:template>

    <xsl:template name="info">
        <xsl:param name="created_user"/>
        <xsl:param name="created_date"/>
        <xsl:param name="modified_user"/>
        <xsl:param name="modified_date"/>
        <xsl:param name="version"/>
        <xsl:param name="status"/>
        <table>
            <thead>
                <tr>
                    <th>What?</th>
                    <th>Who?</th>
                    <th>When?</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <th>Created</th>
                    <td>
                        <xsl:value-of select="$created_user"/>
                    </td>
                    <td>
                        <xsl:value-of select="$created_date"/>
                    </td>
                </tr>
                <tr>
                    <th>Modified</th>
                    <td>
                        <xsl:value-of select="$modified_user"/>
                    </td>
                    <td>
                        <xsl:value-of select="$modified_date"/>
                    </td>
                </tr>
            </tbody>
            <tfoot>
                <tr>
                    <th>Version</th>
                    <td>
                        <xsl:value-of select="$version"/>
                    </td>
                </tr>
                <tr>
                    <th>Status</th>
                    <td>
                        <xsl:choose>
                            <xsl:when test="$status=1">Draft</xsl:when>
                            <xsl:when test="$status=2">Production</xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$status"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </td>
                </tr>
            </tfoot>
        </table>
    </xsl:template>
      
    <xsl:template name="high-level-data-flow-diagram-execute">
        <xsl:param name="input-steps"/>
        <xsl:param name="output-steps"/>
        <h2>High Level Data Flow Diagram</h2>
        <table>
            <thead>
                <tr>
                    <th>Input (<xsl:value-of select="count($input-steps)"/>)</th>
                    <th>Transform</th>
                    <th>Output (<xsl:value-of select="count($output-steps)"/>)</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>
                        <xsl:for-each select="$input-steps">
                            <div>
                                <a>
                                    <xsl:attribute name="href">#<xsl:value-of select="name"
                                    />-text</xsl:attribute>
                                    <xsl:value-of select="name"/>
                                </a>
                            </div>
                        </xsl:for-each>
                    </td>
                    <td> </td>
                    <td>
                        <xsl:for-each select="$output-steps">
                            <div>
                               <a>
                                   <xsl:attribute name="href">#<xsl:value-of select="name"
                                   />-text</xsl:attribute>
                                   <xsl:value-of select="name"/>
                                </a>
                            </div>
                        </xsl:for-each>
                    </td>
                </tr>
            </tbody>
        </table>
    </xsl:template>

    <xsl:template match="transformation/info">
        <h1>
            <xsl:value-of select="name"/>
        </h1>
        <xsl:call-template name="description"/>
    </xsl:template>

    <xsl:template name="transformation-steps">
        <h2>
            <a>
                <xsl:attribute name="name">
                    <xsl:value-of select="$steps-or-job-entries"/>
                </xsl:attribute>
                <xsl:value-of select="$steps-or-job-entries"/>
            </a>
        </h2>
        <xsl:apply-templates select="step[GUI/draw/text()!='N']"/>
    </xsl:template>

    <xsl:template name="transformation-dependencies">
        <h2>
            <a name="dependencies">Transformation Uses</a>
        </h2>
        <p>t.b.d</p>

        <h2>
            <a name="reverse-dependencies">Transformation Used By</a>
        </h2>
        <p>t.b.d</p>
    </xsl:template>

    <xsl:template match="step[GUI/draw/text()!='N']">
        <xsl:variable name="name" select="name/text()"/>
        <hr/>
        <div>
            <xsl:attribute name="class">
            step-icon
            step-icon-<xsl:value-of
                    select="type"/>
            </xsl:attribute>
        </div>
        <h3 class="step-heading">
            <a>
                <xsl:attribute name="name"><xsl:value-of select="$name"/>-text</xsl:attribute>
                <xsl:attribute name="href">#<xsl:value-of select="$name"/>-icon</xsl:attribute>
                <xsl:value-of select="$name"/>
            </a>
        </h3>
        <xsl:call-template name="description">
            <xsl:with-param name="type" select="$step-or-job-entry"/>
        </xsl:call-template>
        <xsl:call-template name="links">
            <xsl:with-param name="step_name" select="$name"/>
        </xsl:call-template>
        <xsl:apply-templates select="sql"/>
        <xsl:apply-templates select="jsScripts"/>
        <xsl:apply-templates select="script"/>
        <xsl:apply-templates select="definitions"/>
        <xsl:if test="descendant-or-self::table">
            <h4>Database</h4>
            <table>
                <thead>
                    <tr>
                        <th/>
                        <th>Connection</th>
                        <th>Schema</th>
                        <th>Table</th>
                        <th>Commit</th>
                        <th>Truncate</th>
                    </tr>
                </thead>
                <tbody>
                        <tr>
                            <th>Value</th>
                            <td>
                                <a>
                                    <xsl:attribute name="href">#connection.<xsl:value-of select="descendant-or-self::connection/text()"/></xsl:attribute>
                                    <xsl:value-of select="descendant-or-self::connection/text()"/>
                                </a>
                            </td>                                
                            <td><xsl:value-of select="descendant-or-self::schema/text()"/></td>
                            <td><xsl:value-of select="descendant-or-self::table/text()"/></td>
                            <td><xsl:value-of select="descendant-or-self::commmit/text()"/></td>
                            <td><xsl:value-of select="descendant-or-self::truncate/text()"/></td>
                        </tr>
                </tbody>
            </table>
        </xsl:if>
        <xsl:apply-templates select="fields"/>
        <xsl:apply-templates select="mappings"/>
        <xsl:apply-templates select="lookup"/>
        <xsl:if test="formula">
            <xsl:call-template name="attribute_table">
                <xsl:with-param name="table" select="formula"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="links">
        <xsl:param name="step_name"/>
        <h4>Hops</h4>
        <table>
            <thead>
                <tr>
                    <th/>
                    <th>Type</th>
                    <th>Step</th>
                    <th>Enabled</th>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each select="//order/hop[to=$step_name] | //hops/hop[to=$step_name]">
                    <tr>
                        <th>
                            <xsl:value-of select="position()"/>
                        </th>
                        <td>From</td>
                        <td>
                            <a>
                                <xsl:attribute name="href">#<xsl:value-of select="from"
                                    />-text</xsl:attribute>
                                <xsl:value-of select="from"/>
                            </a>
                        </td>
                        <td>
                            <xsl:value-of select="enabled"/>
                        </td>
                    </tr>
                </xsl:for-each>
                <xsl:for-each select="//order/hop[from=$step_name] | //hops/hop[from=$step_name]">
                    <tr>
                        <th>
                            <xsl:value-of
                                select="position()+count(//order/hop[to=$step_name])+count(//hops/hop[to=$step_name])"
                            />
                        </th>
                        <td>To</td>
                        <td>
                            <a>
                                <xsl:attribute name="href">#<xsl:value-of select="to"
                                    />-text</xsl:attribute>
                                <xsl:value-of select="to"/>
                            </a>
                        </td>
                        <td>
                            <xsl:value-of select="enabled"/>
                        </td>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>
    </xsl:template>

    <xsl:template name="attribute_table">
        <xsl:param name="table"/>
        <h4>
            <xsl:choose>
                <xsl:when test="name($table[0])='field'">Fields</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="name($table[0])"/>
                </xsl:otherwise>
            </xsl:choose>
        </h4>
        <table>
            <thead>
                <tr>
                    <th>Position</th>
                    <xsl:for-each select="$table[1]/*">
                        <th>
                            <xsl:value-of select="local-name()"/>
                        </th>
                    </xsl:for-each>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each select="$table">
                    <tr>
                        <th>
                            <xsl:value-of select="position()"/>
                        </th>
                        <xsl:for-each select="*">
                            <td>
                                <xsl:value-of select="."/>
                            </td>
                        </xsl:for-each>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>
    </xsl:template>

    <xsl:template match="fields">
        <xsl:if test="field">
            <xsl:call-template name="attribute_table">
                <xsl:with-param name="table" select="field"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="remove">
            <xsl:call-template name="attribute_table">
                <xsl:with-param name="table" select="remove"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="meta">
            <xsl:call-template name="attribute_table">
                <xsl:with-param name="table" select="meta"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template match="lookup">
        <xsl:if test="key">
            <xsl:call-template name="attribute_table">
                <xsl:with-param name="table" select="key"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="value">
            <xsl:call-template name="attribute_table">
                <xsl:with-param name="table" select="value"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="mappings">
        <xsl:if test="../filename">
            <h4>Called sub-transformation</h4>
            <a>
                <xsl:attribute name="href">
                    <xsl:call-template name="get-doc-uri-for-filename">
                        <xsl:with-param name="step-or-job-entry" select=".."/>
                    </xsl:call-template>
                </xsl:attribute>
                <xsl:value-of select="../filename/text()"/>
            </a>
        </xsl:if>
        <xsl:call-template name="attribute_table">
            <xsl:with-param name="table" select="mapping"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="transformation-diagram">
        <xsl:param name="transformation" select="$document/transformation"/>

        <xsl:variable name="steps" select="$transformation/step"/>
        <xsl:variable name="notepads" select="$transformation/notepads/notepad"/>
        <xsl:variable name="error-handlers" select="$transformation/step_error_handling/error"/>

        <!-- 
        TODO: for notepads, take the width / height into account.
        -->
        <xsl:variable name="xlocs" select="$steps/GUI/xloc | $notepads/xloc"/>
        <xsl:variable name="ylocs" select="$steps/GUI/yloc | $notepads/yloc"/>
        <xsl:variable name="hops" select="$transformation/order/hop"/>

        <xsl:variable name="max-xloc">
            <xsl:call-template name="max">
                <xsl:with-param name="values" select="$xlocs"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="min-xloc">
            <xsl:call-template name="min">
                <xsl:with-param name="values" select="$xlocs"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="max-yloc">
            <xsl:call-template name="max">
                <xsl:with-param name="values" select="$ylocs"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="min-yloc">
            <xsl:call-template name="min">
                <xsl:with-param name="values" select="$ylocs"/>
            </xsl:call-template>
        </xsl:variable>

        <h2>
            <a name="diagram">Diagram</a>
        </h2>
        <div class="diagram" id="canvas">
            <xsl:attribute name="style">
          width: <xsl:value-of
                    select="($max-xloc - $min-xloc) + 128"/>px;
          height: <xsl:value-of
                    select="($max-yloc - $min-yloc) + 128"/>px;
      </xsl:attribute>
            <div class="diagram" id="thediagram">
                <xsl:attribute name="style">
              width: <xsl:value-of
                        select="($max-xloc - $min-xloc) + 128"
                        />px;
              height: <xsl:value-of
                        select="($max-yloc - $min-yloc) + 128"/>px;
          </xsl:attribute>
                <xsl:for-each select="$steps">
                    <xsl:variable name="type" select="type/text()"/>
                    <xsl:variable name="name" select="name/text()"/>
                    <xsl:variable name="xloc" select="GUI/xloc"/>
                    <xsl:variable name="yloc" select="GUI/yloc"/>
                    <xsl:variable name="text-pixels" select="string-length(name) * 4"/>
                    <xsl:variable name="hide" select="GUI/draw/text()='N'"/>
                    <xsl:variable name="copies" select="copies/text()"/>
                    <xsl:variable name="send-true-to" select="send_true_to/text()"/>
                    <xsl:variable name="send-false-to" select="send_false_to/text()"/>
                    <xsl:variable name="distribute" select="distribute/text() = 'Y'"/>
                    <a>
                        <xsl:attribute name="name"><xsl:value-of select="$name"
                            />-icon</xsl:attribute>
                    </a>
                    <div>
                        <xsl:attribute name="id">
                            <xsl:value-of select="$name"/>
                        </xsl:attribute>
                        <xsl:attribute name="class"
                                >
                      step-icon
                      step-icon-<xsl:value-of
                                select="$type"/>
                            <xsl:if test="$error-handlers[target_step/text() = $name]"
                                >
                          step-error
                      </xsl:if>
                            <xsl:if test="$hide"
                                >
                          step-hidden
                      </xsl:if>
                        </xsl:attribute>
                        <xsl:attribute name="style">
                      left:<xsl:value-of
                                select="$xloc"/>px;
                      top:<xsl:value-of
                                select="$yloc"/>px;
                  </xsl:attribute>
                        <div class="step-hops">
                            <xsl:for-each select="$hops[from/text()=$name]">
                                <xsl:variable name="from" select="from/text()"/>
                                <xsl:variable name="to" select="to/text()"/>
                                <xsl:variable name="enabled" select="enabled/text() = 'Y'"/>
                                <a>
                                    <xsl:attribute name="class"
                                            >
                                  step-hop
                                  <xsl:if
                                            test="
                                          $error-handlers[
                                              source_step/text()=$from
                                          and target_step/text()=$to
                                          ]
                                      "
                                            >
                                  step-hop-error
                                  </xsl:if>
                                        <xsl:choose>
                                            <xsl:when test="$enabled"
                                                >
                                      step-hop-enabled
                                      </xsl:when>
                                            <xsl:otherwise>
                                      step-hop-disabled
                                      </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:choose>
                                            <xsl:when test="$send-true-to = $to"
                                                >step-hop-true</xsl:when>
                                            <xsl:when test="$send-false-to = $to"
                                                >step-hop-false</xsl:when>
                                            <xsl:when test="$distribute"
                                                >step-hop-distribute-data</xsl:when>
                                            <xsl:otherwise>step-hop-copy-data</xsl:otherwise>
                                        </xsl:choose><xsl:text> </xsl:text>
                                    </xsl:attribute>
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="concat('#', $to)"/>
                                    </xsl:attribute>
                                </a>
                            </xsl:for-each>
                        </div>
                    </div>
                    <a>
                        <xsl:attribute name="class"
                                >
                      step-label
                      <xsl:if
                                test="$hide"
                                >
                          step-label-hidden
                      </xsl:if>
                        </xsl:attribute>
                        <xsl:attribute name="href">
                            <xsl:choose>
                                <xsl:when
                                    test="
                                  $type = 'Mapping'
                              ">
                                    <xsl:call-template name="get-doc-uri-for-filename">
                                        <xsl:with-param name="step-or-job-entry" select="."/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>#<xsl:value-of select="$name"/>-text</xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:attribute name="style">
                      top:<xsl:value-of
                                select="$yloc + 32"/>px;
                      left:<xsl:value-of
                                select="$xloc - ($text-pixels div 3)"
                            />px;                    
                  </xsl:attribute>
                        <xsl:value-of select="$name"/>
                    </a>
                </xsl:for-each>
                <xsl:apply-templates select="//notepads"/>
            </div>
        </div>

    </xsl:template>
    <!-- 
    =========================================================================
    KETTLE JOB
    ========================================================================== 
    -->

    <xsl:template match="job">
        <h1>
            <xsl:value-of select="name"/>
        </h1>
        <xsl:call-template name="info">
            <xsl:with-param name="created_user" select="created_user"/>
            <xsl:with-param name="created_date" select="created_date"/>
            <xsl:with-param name="modified_user" select="modified_user"/>
            <xsl:with-param name="modified_date" select="$modified_date"/>
            <xsl:with-param name="version" select="job_version"/>
            <xsl:with-param name="status" select="job_status/text()"/>
        </xsl:call-template>

        <xsl:call-template name="description"/>
        <xsl:apply-templates select="parameters"/>
        <xsl:call-template name="job-diagram"/>
        <xsl:call-template name="variables"/>
        <xsl:call-template name="database-connections"/>
        <xsl:call-template name="job-entries"/>
        <!-- <xsl:call-template name="job-dependencies"/> -->
    </xsl:template>

    <xsl:template name="job-dependencies">
        <h2>
            <a name="dependencies">Job Uses</a>
        </h2>
        <p>t.b.d</p>

        <h2>
            <a name="reverse-dependencies">Job Used By</a>
        </h2>
        <p>t.b.d</p>
    </xsl:template>

    <xsl:template name="job-entries">
        <h2>
            <a>
                <xsl:attribute name="name">
                    <xsl:value-of select="$steps-or-job-entries"/>
                </xsl:attribute>
                <xsl:value-of select="$steps-or-job-entries"/>
            </a>
        </h2>
        <xsl:apply-templates select="entries/entry"/>
    </xsl:template>

    <xsl:template match="entry[draw!='N']">
        <xsl:variable name="name" select="name/text()"/>
        <xsl:variable name="type" select="type/text()"/>
        <hr/>
        <div>
            <xsl:attribute name="class">
            entry-icon
            entry-icon-<xsl:choose>
                    <xsl:when test="$type='SPECIAL'"><xsl:call-template name="upper-case">
                            <xsl:with-param name="text" select="$name"/>
                        </xsl:call-template></xsl:when>
                    <xsl:otherwise><xsl:value-of select="$type"/></xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </div>
        <h3 class="entry-heading">
            <a>
                <xsl:attribute name="name"><xsl:value-of select="$name"/>-text</xsl:attribute>
                <xsl:attribute name="href">#<xsl:value-of select="$name"/>-icon</xsl:attribute>
                <xsl:value-of select="$name"/>
            </a>
        </h3>
        <xsl:call-template name="description">
            <xsl:with-param name="type" select="'job entry'"/>
        </xsl:call-template>
        <xsl:call-template name="links">
            <xsl:with-param name="step_name" select="$name"/>
        </xsl:call-template>
        <xsl:apply-templates select="sql"/>
    </xsl:template>

    <xsl:template name="job-diagram">
        <xsl:param name="job" select="$document/job"/>
        <xsl:variable name="entries" select="$job/entries/entry"/>

        <xsl:variable name="notepads" select="$job/notepads/notepad"/>
        <!-- 
        TODO: for notepads, take the width / height into account.
    -->
        <xsl:variable name="xlocs" select="$entries/xloc | $notepads/xloc"/>
        <xsl:variable name="ylocs" select="$entries/yloc | $notepads/yloc"/>
        <xsl:variable name="hops" select="$job/hops/hop"/>

        <xsl:variable name="max-xloc">
            <xsl:call-template name="max">
                <xsl:with-param name="values" select="$xlocs"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="min-xloc">
            <xsl:call-template name="min">
                <xsl:with-param name="values" select="$xlocs"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="max-yloc">
            <xsl:call-template name="max">
                <xsl:with-param name="values" select="$ylocs"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="min-yloc">
            <xsl:call-template name="min">
                <xsl:with-param name="values" select="$ylocs"/>
            </xsl:call-template>
        </xsl:variable>

        <h2>
            <a name="diagram">Diagram</a>
        </h2>
        <div class="diagram" id="canvas">
            <xsl:attribute name="style">
            width: <xsl:value-of
                    select="($max-xloc - $min-xloc) + 128"/>px;
            height: <xsl:value-of
                    select="($max-yloc - $min-yloc) + 128"/>px;
        </xsl:attribute>
            <div class="diagram" id="thediagram">
                <xsl:attribute name="style">
              width: <xsl:value-of
                        select="($max-xloc - $min-xloc) + 128"
                        />px;
              height: <xsl:value-of
                        select="($max-yloc - $min-yloc) + 128"/>px;
          </xsl:attribute>
                <xsl:for-each select="$entries">
                    <xsl:variable name="type" select="type/text()"/>
                    <xsl:variable name="name" select="name/text()"/>
                    <xsl:variable name="xloc" select="xloc"/>
                    <xsl:variable name="yloc" select="yloc"/>
                    <xsl:variable name="text-pixels" select="string-length(name) * 4"/>
                    <xsl:variable name="hide" select="draw/text()='N'"/>
                    <a>
                        <xsl:attribute name="name"><xsl:value-of select="$name"
                            />-icon</xsl:attribute>
                    </a>
                    <div>
                        <xsl:attribute name="id">
                            <xsl:value-of select="$name"/>
                        </xsl:attribute>
                        <xsl:attribute name="class">
                      entry-icon
                      entry-icon-<xsl:choose>
                                <xsl:when test="$type='SPECIAL'"><xsl:call-template
                                        name="upper-case">
                                        <xsl:with-param name="text" select="$name"/>
                                    </xsl:call-template></xsl:when>
                                <xsl:otherwise><xsl:value-of select="$type"/></xsl:otherwise>
                            </xsl:choose>
                            <xsl:if test="$hide"
                                >
                          entry-hidden
                      </xsl:if>
                        </xsl:attribute>
                        <xsl:attribute name="style">
                      left:<xsl:value-of
                                select="$xloc"/>px;
                      top:<xsl:value-of
                                select="$yloc"/>px;
                  </xsl:attribute>
                        <div class="entry-hops">
                            <xsl:for-each select="$hops[from/text()=$name]">
                                <a>
                                    <xsl:attribute name="class">
                                  entry-hop
                                  <xsl:choose>
                                            <xsl:when test="unconditional/text()='Y'"
                                                >entry-hop-unconditional</xsl:when>
                                            <xsl:when test="evaluation/text()='Y'"
                                                >entry-hop-true</xsl:when>
                                            <xsl:when test="evaluation/text()='N'"
                                                >entry-hop-false</xsl:when>
                                        </xsl:choose>
                                    </xsl:attribute>
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="concat('#', to/text())"/>
                                    </xsl:attribute>
                                </a>
                            </xsl:for-each>
                        </div>
                    </div>
                    <a>
                        <xsl:attribute name="class"
                                >
                      entry-label
                      <xsl:if
                                test="$hide"
                                >
                          entry-label-hidden
                      </xsl:if>
                        </xsl:attribute>
                        <xsl:attribute name="style">
                      top:<xsl:value-of
                                select="$yloc + 32"/>px;
                      left:<xsl:value-of
                                select="$xloc - ($text-pixels div 3)"
                            />px;
                  </xsl:attribute>
                        <xsl:attribute name="href">
                            <xsl:choose>
                                <xsl:when
                                    test="
                                  $type = 'JOB'
                              or    $type = 'TRANS'
                              ">
                                    <xsl:call-template name="get-doc-uri-for-filename">
                                        <xsl:with-param name="step-or-job-entry" select="."/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>#<xsl:value-of select="$name"/>-text</xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:value-of select="$name"/>
                    </a>
                </xsl:for-each>
                <xsl:apply-templates select="//notepad"/>
            </div>
        </div>
    </xsl:template>

</xsl:stylesheet>
