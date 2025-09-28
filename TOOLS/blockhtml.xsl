<!--
 Copyright (C) 2006-2017 Silicon DSP  Corporation

 This program is free software; you can redistribute it and/or modify it
 under the terms of the GNU General Public License as published by the Free
 Software Foundation; either version 2 of the License, or (at your option)
 any later version.

 This program is distributed in the hope that it will be useful, but
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License
 for more details.

 You should have received a copy of the GNU General Public License along
 with this program; if not, write to the Free Software Foundation, Inc.,
 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 
 Written by Sasan Ardalan September 9, 2006

 Description:  Generate HTML Documentation from Block XML
-->


<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" encoding="UTF-8"/>



<xsl:template match="BLOCK" mode="Start">
<xsl:variable name="blockName" select="BLOCK_NAME" />

<![CDATA[

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">


<html>


<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"></meta>
<title>
]]>
<xsl:value-of select="BLOCK_NAME"/>
<![CDATA[
</title>
<style type="text/css">
<!--
.style2 {font-size: 12px}
.style3 {
	font-size: x-large;
	font-weight: bold;
}
.style5 {font-family: "Courier New", Courier, mono}
-->
</style>
</head>
<body>

<h1>
]]>
<xsl:value-of select="BLOCK_NAME"/>
<![CDATA[
<a name="top"></a></h1>
<p><a href="http://www.xcad.com">Capsim</a> Block Documentation </p>
<ul>
  <li><a href="#license">License</a></li>
  <li><a href="#description">Description</a></li>
  <li><a href="#inputs">Input Connections</a></li>
  <li><a href="#outputs">Output Connections</a></li>
  <li><a href="#parameters">Parameters</a></li>
  <li><a href="#Results">Result Variables</a></li>
  <li><a href="#states">States</a></li>
  <li><a href="#declarations">Declarations</a></li>
  <li><a href="#initialization">Initialization Code</a></li>
  <li><a href="#maincode">Main Code</a></li>
  <li><a href="#wrapup">Wrapup Code</a></li>
</ul>
]]>


</xsl:template>


<xsl:template match="BLOCK" mode="Done">
<![CDATA[
</body>
</html>
]]>

</xsl:template>



<xsl:template match="PARAMETERS" mode="paramTable">
<![CDATA[
<h6><a href="#top">Top</a></h6>
<table width="746" border="1" cellspacing="1" cellpadding="1">
  <caption>
  <span class="style3">  Parameters<a name="parameters"></a> </span>
  </caption>
  <tr>
    <th width="58" scope="col">Num</th>
    <th width="373" scope="col">Description</th>
    <th width="80" scope="col">Type</th>
    <th width="98" scope="col">Name</th>
    <th width="109" scope="col">Default Value </th>
  </tr>
]]>
  
<xsl:for-each select="PARAM">
<xsl:variable name="index" select="position()-1" />
<![CDATA[
 <tr>
    <td>
    ]]>
    <xsl:value-of select="$index" />
    <![CDATA[
    </td>
    <td>
    ]]>
    <xsl:value-of select="DEF"/>
    <![CDATA[
    </td>
    <td>
    ]]>
    <xsl:value-of select="TYPE"/>
    <![CDATA[
    </td>
    <td>
    ]]>
    <xsl:value-of select="NAME"/>
    <![CDATA[
    </td>
    <td>
    ]]>
    <xsl:value-of select="VALUE"/>
    <![CDATA[
    </td>
    <td>
     </tr>
    ]]>
 

</xsl:for-each>
<![CDATA[
</table>
]]>

</xsl:template>




<xsl:template match="STATES" mode="statesTable">
<![CDATA[
<h6><a href="#top">Top</a></h6>
<table width="746" border="1" cellspacing="1" cellpadding="1">
  <caption>
  <span class="style3">  States<a name="states"></a> </span>
  </caption>
  <tr>
    <th width="58" scope="col">Num</th>    
    <th width="80" scope="col">Type</th>
    <th width="98" scope="col">Name</th>
    <th width="109" scope="col">Initial Value </th>
    <th width="373" scope="col">Description</th>
  </tr>
]]>
  
<xsl:for-each select="STATE">
<xsl:variable name="index" select="position()-1" />
<![CDATA[
 <tr>
    <td>
    ]]>
    <xsl:value-of select="$index" />
    <![CDATA[
    </td>
    <td>
    ]]>
  
    <xsl:value-of select="TYPE"/>
    <![CDATA[
    </td>
    <td>
    ]]>
    <xsl:value-of select="NAME"/>
    <![CDATA[
    </td>
    <td>
    ]]>
    <xsl:value-of select="VALUE"/>
    <![CDATA[
    </td>
    <td>
    ]]>
      <xsl:value-of select="DEF"/>
    <![CDATA[
    </td>
     </tr>
    ]]>
 

</xsl:for-each>
<![CDATA[
</table>
]]>

</xsl:template>






<xsl:template match="RESULTS" mode="resultsTable">
<![CDATA[
<h6><a href="#top">Top</a></h6>
<table width="746" border="1" cellspacing="1" cellpadding="1">
  <caption>
  <span class="style3">Result Variables (TCL)<a name="Results"></a> </span>
  </caption>
  <tr>
    <th width="58" scope="col">Num</th>    
    <th width="80" scope="col">Type</th>
    <th width="98" scope="col">Name</th>
    <th width="373" scope="col">Description</th>
  </tr>
]]>
  
<xsl:for-each select="RESULT">
<xsl:variable name="index" select="position()-1" />
<![CDATA[
 <tr>
    <td>
    ]]>
    <xsl:value-of select="$index" />
    <![CDATA[
    </td>
    <td>
    ]]>
  
    <xsl:value-of select="TYPE"/>
    <![CDATA[
    </td>
    <td>
    ]]>
    <xsl:value-of select="NAME"/>
    <![CDATA[
    </td>
    <td>
    ]]>
      <xsl:value-of select="DESC"/>
    <![CDATA[
    </td>
     </tr>
    ]]>
 

</xsl:for-each>
<![CDATA[
</table>
]]>

</xsl:template>













<xsl:template match="INPUT_BUFFERS" mode="inputsTable">
<![CDATA[
<h6><a href="#top">Top</a></h6>
<table width="746" border="1" cellspacing="1" cellpadding="1">
  <caption>
  <span class="style3">  Input Connections<a name="inputs"></a> </span>
  </caption>
  <tr>
   <th width="45" scope="col">Port</th>
    <th width="201" scope="col">Type</th>
    <th width="500" scope="col">Name</th>
  </tr>
]]>
  
<xsl:for-each select="BUFFER">
<xsl:variable name="index" select="position()-1" />
<![CDATA[
 <tr>
    <td>
    ]]>
    <xsl:value-of select="$index" />
    <![CDATA[
    </td>
    <td>
    ]]>
    <xsl:value-of select="TYPE"/>
    <![CDATA[
    </td>
    <td>
    ]]>
    <xsl:value-of select="NAME"/>
    <![CDATA[
    </td>
    <td>
    ]]>
</xsl:for-each>
<![CDATA[
</table>
]]>

</xsl:template>


<xsl:template match="OUTPUT_BUFFERS" mode="outputsTable">
<![CDATA[
<h6><a href="#top">Top</a></h6>
<table width="746" border="1" cellspacing="1" cellpadding="1">
  <caption>
  <span class="style3">  Output Connections<a name="outputs"></a> </span>
  </caption>
  <tr>
   <th width="45" scope="col">Port</th>
    <th width="201" scope="col">Type</th>
    <th width="500" scope="col">Name</th>
  </tr>
]]>
  
<xsl:for-each select="BUFFER">
<xsl:variable name="index" select="position()-1" />
<![CDATA[
 <tr>
    <td>
    ]]>
    <xsl:value-of select="$index" />
    <![CDATA[
    </td>
    <td>
    ]]>
    <xsl:value-of select="TYPE"/>
    <![CDATA[
    </td>
    <td>
    ]]>
    <xsl:value-of select="NAME"/>
    <![CDATA[
    </td>
    <td>
    ]]>
</xsl:for-each>
<![CDATA[
</table>
]]>

</xsl:template>



<xsl:template match="BLOCK" mode="declarationTable">
<![CDATA[
<h6><a href="#top">Top</a></h6>
<h2>Declarations<a name="declarations"></a></h2>
<table width="754" height="98" border="1" cellpadding="1" cellspacing="1">
  <tr>
    <th class="style5" scope="col"><div align="left"> 
      <pre>
]]>
<xsl:value-of select="DECLARATIONS"/>
<![CDATA[
</pre>
    </div></th>
  </tr>
</table>
]]>

</xsl:template>


<xsl:template match="BLOCK" mode="initCodeTable">
<![CDATA[
<h6><a href="#top">Top</a></h6>
<h2>Initialization Code<a name="initialization"></a></h2>
<table width="754" height="98" border="1" cellpadding="1" cellspacing="1">
  <tr>
    <th class="style5" scope="col"><div align="left"> 
      <pre>
]]>
<xsl:value-of select="INIT_CODE"/>
<![CDATA[
</pre>
    </div></th>
  </tr>
</table>
]]>

</xsl:template>



<xsl:template match="BLOCK" mode="mainCodeTable">
<![CDATA[
<h6><a href="#top">Top</a></h6>
<h2>Main Code<a name="maincode"></a></h2>
<table width="754" height="98" border="1" cellpadding="1" cellspacing="1">
  <tr>
    <th class="style5" scope="col"><div align="left"> 
      <pre>
]]>
<xsl:value-of select="MAIN_CODE"/>
<![CDATA[
</pre>
    </div></th>
  </tr>
</table>
]]>

</xsl:template>


<xsl:template match="BLOCK" mode="wrapupCodeTable">
<![CDATA[
<h6><a href="#top">Top</a></h6>
<h2>Wrapup Code<a name="wrapup"></a></h2>
<table width="754" height="98" border="1" cellpadding="1" cellspacing="1">
  <tr>
    <th class="style5" scope="col"><div align="left"> 
      <pre>
]]>
<xsl:value-of select="WRAPUP_CODE"/>
<![CDATA[
</pre>
    </div></th>
  </tr>
</table>
]]>

</xsl:template>


<xsl:template match="BLOCK" mode="licenseTable">
<![CDATA[
<h6><a href="#top">Top</a></h6>
<h2>License<a name="license"></a></h2>
<table width="754" height="98" border="1" cellpadding="1" cellspacing="1">
  <tr>
    <th class="style5" scope="col"><div align="left"> 
      <pre>
]]>
<xsl:value-of select="LICENSE"/>
<![CDATA[
</pre>
    </div></th>
  </tr>
</table>
]]>

</xsl:template>


<xsl:template match="BLOCK" mode="descriptionTable">
<![CDATA[
<h6><a href="#top">Top</a></h6>
<h2>Description<a name="description"></a></h2>
<table width="754" height="98" border="1" cellpadding="1" cellspacing="1">
  <tr>
    <th class="style5" scope="col"><div align="left"> 
      <pre>
]]>
<xsl:value-of select="COMMENTS"/>
<![CDATA[
</pre>
    </div></th>
  </tr>
</table>
]]>

</xsl:template>






<xsl:template match="BLOCK" mode="shortDescription">
<![CDATA[
<h2>Short Description</h2><P>
]]>
<xsl:value-of select="DESC_SHORT"/>
</xsl:template>





<!--         OUTPUT THE GENERATED CODE      -->

<xsl:strip-space elements="BLOCK_NAME" />

<xsl:template match="/">
<xsl:apply-templates  select=".//BLOCK" mode="Start" /> 
<xsl:apply-templates  select=".//BLOCK" mode="shortDescription" />
<xsl:apply-templates  select=".//INPUT_BUFFERS" mode="inputsTable" /> 
<xsl:apply-templates  select=".//OUTPUT_BUFFERS" mode="outputsTable" />
<xsl:apply-templates  select=".//PARAMETERS" mode="paramTable" />
<xsl:apply-templates  select=".//RESULTS" mode="resultsTable" />
<xsl:apply-templates  select=".//STATES" mode="statesTable" />
<xsl:apply-templates  select=".//BLOCK" mode="declarationTable" />
<xsl:apply-templates  select=".//BLOCK" mode="initCodeTable" />  
<xsl:apply-templates  select=".//BLOCK" mode="mainCodeTable" /> 
<xsl:apply-templates  select=".//BLOCK" mode="wrapupCodeTable" /> 
<xsl:apply-templates  select=".//BLOCK" mode="licenseTable" />
<xsl:apply-templates  select=".//BLOCK" mode="descriptionTable" />    
<xsl:apply-templates  select=".//BLOCK" mode="Done" /> 



</xsl:template>                       


</xsl:stylesheet>
