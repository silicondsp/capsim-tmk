<!--
 Copyright (C) 2006  Sasan H Ardalan

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
 
 Written by Sasan Ardalan June 18, 2006

-->


<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" encoding="UTF-8"/>



<xsl:template match="BLOCK" mode="Common">
<![CDATA[




#include <stdio.h>
#include <math.h>

/* Note: these paths are installation dependent! */
#include <capsim.h>
#include <stars.h>

]]>
</xsl:template>


<xsl:template match="BLOCK" mode="NoParam">
<xsl:choose>
    <xsl:when test="not(PARAMETERS)">
 /********* PARAMETER INITIALIZATION CODE ************/
case PARAM_INIT:

        {
        int indexModel88 = block_P->model_index;

        KrnModelParam(indexModel88,-1,"","","","");
        }

break;
   
         <xsl:text> &#xa; </xsl:text>

   </xsl:when>
   <xsl:otherwise>
        <xsl:text> &#xa; &#xa;</xsl:text>
   </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="BLOCK" mode="Includes">
<xsl:value-of select="INCLUDES"/>
</xsl:template>


<xsl:template match="BLOCK" mode="Defines">
/*
 *     DEFINES 
 */ 
<xsl:value-of select="DEFINES"/>
</xsl:template>

<xsl:template match="BLOCK" mode="Declarations">

<xsl:text>/*-------------- BLOCK CODE ---------------*/</xsl:text>
<xsl:text>&#xa;</xsl:text>
<xsl:text xml:space="preserve"> int  </xsl:text>
<xsl:value-of select="BLOCK_NAME"/>
<xsl:text>(int run_state,block_Pt block_P)</xsl:text>

{
	param_Pt *param_P = block_P->param_AP;
	star_Pt star_P = block_P->star_P;

     <xsl:variable name="isState" select="STATES/STATE/NAME" />
     <xsl:if test="$isState" >
	state_Pt state_P = (state_Pt)star_P->state_P;
     </xsl:if>
/*
 *              Declarations 
 */
<xsl:value-of select="DECLARATIONS"/>
switch (run_state) {

</xsl:template>


<xsl:template match="BLOCK" mode="License"> 
#ifdef LICENSE
<xsl:value-of select="LICENSE"/>
#endif
</xsl:template>



<xsl:template match="BLOCK" mode="ShortDesc"> 
#ifdef SHORT_DESCRIPTION
<xsl:value-of select="DESC_SHORT"/>
#endif
</xsl:template>
<xsl:template match="BLOCK" mode="Programmers"> 
#ifdef PROGRAMMERS
<xsl:value-of select="PROGRAMMERS"/>
#endif
</xsl:template>




<xsl:template match="STATES" mode="StateStruct">
/*
 *           STATES STRUCTURE 
 */ 
<xsl:text>typedef struct {</xsl:text>
<xsl:text>&#xa;</xsl:text>
<xsl:for-each select="STATE">
 <xsl:variable name="stateName" select="NAME" />
  <xsl:variable name="spaces" select="string(' &#x9;')" />
  <xsl:variable name="none" select="string('')" />


     <xsl:text>      </xsl:text>
     <xsl:value-of select="TYPE"/>
     <xsl:text>  __</xsl:text>
     <xsl:value-of select="translate($stateName,$spaces,$none)" />
     <xsl:text>;</xsl:text>
     <xsl:text>&#xa;</xsl:text>
</xsl:for-each>
<xsl:text>     } state_t,*state_Pt;</xsl:text>
<xsl:text>&#xa;</xsl:text>

</xsl:template>


<xsl:template match="STATES" mode="StateDefines">
/*
 *         STATE DEFINES 
 */ 
<xsl:for-each select="STATE">
 <xsl:variable name="stateName1" select="NAME" />
  <xsl:variable name="spaces" select="string(' &#x9;')" />
  <xsl:variable name="none" select="string('')" />

     <xsl:text>#define </xsl:text>
     <xsl:variable name="stateName" select="translate($stateName1,$spaces,$none)" />
     <xsl:variable name="stateNameCheck" select="substring-before($stateName,'[')" />
     <xsl:if test="$stateNameCheck">
           <xsl:value-of select="$stateNameCheck"/>
     </xsl:if>
     <xsl:if test="not($stateNameCheck)">
           <xsl:value-of select="NAME" />
     </xsl:if>

     <xsl:text> (state_P->__</xsl:text>
     <xsl:if test="$stateNameCheck">
           <xsl:value-of select="$stateNameCheck"/>
     </xsl:if>
     <xsl:if test="not($stateNameCheck)">
           <xsl:value-of select="translate($stateName,$spaces,$none)" />
     </xsl:if>
     <xsl:text>)</xsl:text>
     <xsl:text>&#xa;</xsl:text>
</xsl:for-each>

</xsl:template>


<xsl:template match="BLOCK" mode="SysInitBegin">
/*
 *        SYSTEM INITIALIZATION CODE 
 */
case SYSTEM_INIT:
     <xsl:variable name="isState" select="STATES/STATE/NAME" />
     <xsl:if test="$isState" >
	star_P->state_P = (char*)calloc(1,sizeof(state_t));
	state_P = (state_Pt)star_P->state_P;
     </xsl:if>
</xsl:template>	

<xsl:template match="BLOCK" mode="SysInitEnd">
<xsl:text>break;&#xa;</xsl:text>
</xsl:template>	
	
<xsl:template match="STATES" mode="SystemInit">

<xsl:for-each select="STATE">
<xsl:variable name="value" select="VALUE" />
     <xsl:if test="$value">
          <xsl:text>       </xsl:text>
          <xsl:value-of select="NAME"/>
          <xsl:text>=</xsl:text>
          <xsl:value-of select="VALUE"/>
          <xsl:text>;</xsl:text>
          <xsl:text>&#xa;</xsl:text>
     </xsl:if>
</xsl:for-each>
<xsl:text>&#xa;</xsl:text>
</xsl:template>


<xsl:template match="OUTPUT_BUFFERS" mode="outBuffDefines">
/*         
 *    OUTPUT BUFFER  DEFINES 
 */ 
<xsl:for-each select="BUFFER">
  <xsl:variable name="spaces" select="string(' &#x9;')" />
  <xsl:variable name="none" select="string('')" />
   <xsl:variable name="buffName" select="NAME" />

     <xsl:variable name="index" select="position()-1" />
     <xsl:text>#define </xsl:text>
     <xsl:value-of select="translate($buffName,$spaces,$none)"/>
     <xsl:text>(delay) *(</xsl:text>
     <xsl:value-of select="TYPE"/>
     <xsl:text>  *)POUT(</xsl:text>
     <xsl:value-of select="$index" />
     <xsl:text>,delay)</xsl:text>
     <xsl:text>&#xa;</xsl:text>

</xsl:for-each>

</xsl:template>



<xsl:template match="OUTPUT_BUFFERS" mode="outBuffSysInitsChecks">

<xsl:for-each select="BUFFER">
<xsl:variable name="numberOutputBuffers" select="position()" />
</xsl:for-each>  
 <xsl:variable name="numberOutputBuffers" select="count(.//BUFFER)" />         
   if(NO_OUTPUT_BUFFERS() != <xsl:value-of select="$numberOutputBuffers" /> ){
       fprintf(stdout,"%s:<xsl:value-of select="$numberOutputBuffers" /> outputs expected; %d connected\n",
              STAR_NAME,NO_OUTPUT_BUFFERS());
	      return(201);
   }
<xsl:for-each select="BUFFER">
<xsl:variable name="index" select="position()-1" />
   SET_CELL_SIZE_OUT(<xsl:value-of select="$index" />,sizeof(<xsl:value-of select="TYPE" />));
</xsl:for-each>


<xsl:text>&#xa;</xsl:text>

</xsl:template>





<xsl:template match="INPUT_BUFFERS" mode="inBuffDefines">
/*         
 *    INPUT BUFFER DEFINES 
 */ 
<xsl:for-each select="BUFFER">
  <xsl:variable name="spaces" select="string(' &#x9;')" />
  <xsl:variable name="none" select="string('')" />
   <xsl:variable name="buffName" select="NAME" />

     <xsl:variable name="index" select="position()-1" />
     <xsl:text>#define </xsl:text>
     <xsl:value-of select="translate($buffName,$spaces,$none)"/>
     <xsl:text>(DELAY) (*((</xsl:text>
     <xsl:value-of select="TYPE"/>
     <xsl:text>  *)PIN(</xsl:text>
     <xsl:value-of select="$index" />
     <xsl:text>,DELAY)))</xsl:text>
     <xsl:text>&#xa;</xsl:text>


</xsl:for-each>

</xsl:template>


<xsl:template match="INPUT_BUFFERS" mode="inBuffSysInitsChecks">

<xsl:for-each select="BUFFER">
<xsl:variable name="numberInputBuffers" select="position()" />
</xsl:for-each>  
 <xsl:variable name="numberInputBuffers" select="count(.//BUFFER)" />         
   if(NO_INPUT_BUFFERS() != <xsl:value-of select="$numberInputBuffers" /> ){
       fprintf(stdout,"%s:<xsl:value-of select="$numberInputBuffers" /> inputs expected; %d connected\n",
              STAR_NAME,NO_INPUT_BUFFERS());
	      return(200);
   }
<xsl:for-each select="BUFFER">
<xsl:variable name="index" select="position()-1" />
   SET_CELL_SIZE_IN(<xsl:value-of select="$index" />,sizeof(<xsl:value-of select="TYPE" />));
</xsl:for-each>


<xsl:text>&#xa;</xsl:text>

</xsl:template>



<xsl:template match="OUTPUT_BUFFERS" mode="outBuffInits">
/*         
 *    OUTPUT BUFFER SYSTEM  INITS 
 */ 
 case OUTPUT_BUFFER_INIT: 
 {
 int indexOC = block_P->model_index;
<xsl:for-each select="BUFFER">
      <xsl:variable name="index" select="position()-1" />
      <xsl:text>     char   *ptypeOut</xsl:text>
      <xsl:value-of select="$index" />
      <xsl:text> = "</xsl:text>
      <xsl:value-of select="TYPE"/>
      <xsl:text>";</xsl:text>
      <xsl:text>&#xa;</xsl:text>
      <xsl:text>     char   *pnameOut</xsl:text>
      <xsl:value-of select="$index" />
      <xsl:text> = "</xsl:text>
      <xsl:value-of select="NAME"/>
      <xsl:text>";</xsl:text>
      <xsl:text>&#xa;</xsl:text>
</xsl:for-each> 

 <xsl:for-each select="BUFFER">
      <xsl:variable name="index" select="position()-1" />
      <xsl:text>KrnModelConnectionOutput(indexOC,</xsl:text><xsl:value-of select="$index" /><xsl:text> ,pnameOut</xsl:text>
      <xsl:value-of select="$index" />
      <xsl:text>,ptypeOut</xsl:text>
      <xsl:value-of select="$index" />
      <xsl:text>);</xsl:text>
      <xsl:text>&#xa;</xsl:text>
 
</xsl:for-each>
<xsl:text>}&#xa; break;&#xa;</xsl:text>
</xsl:template>


<xsl:template match="OUTPUT_BUFFERS" mode="outBuffSysInits">
<xsl:for-each select="BUFFER">
     <xsl:variable name="index" select="position()-1" />
             <xsl:for-each select="DELAY">
     
     <xsl:variable name="delayType" select="DELAY/TYPE" />
     <xsl:if test="$delayType='max'"> 
          <xsl:text>  delay_max((buffer_Pt)star_P->outBuffer_P[</xsl:text>
          <xsl:value-of select="$index" />
          <xsl:text>],</xsl:text>
          <xsl:value-of select="DELAY/VALUE_MAX" />
	  <xsl:text>);&#xa;</xsl:text>
     </xsl:if>
     <xsl:if test="$delayType='min'"> 
          <xsl:text>  delay_min((buffer_Pt)star_P->outBuffer_P[</xsl:text>
          <xsl:value-of select="$index" />
          <xsl:text>],</xsl:text>
          <xsl:value-of select="DELAY/VALUE_MIN" />
	  <xsl:text>);&#xa;</xsl:text>
     </xsl:if>   
     
     
 </xsl:for-each>    
       

</xsl:for-each>
<xsl:text>&#xa;</xsl:text>

</xsl:template>


<xsl:template match="INPUT_BUFFERS" mode="inBuffInits">
/*         
 *    INPUT BUFFER SYSTEM  INITS 
 */ 
 case INPUT_BUFFER_INIT:
 {
 int indexIC = block_P->model_index;
<xsl:for-each select="BUFFER">
      <xsl:variable name="index" select="position()-1" />
      <xsl:text>     char   *ptypeIn</xsl:text>
      <xsl:value-of select="$index" />
      <xsl:text> = "</xsl:text>
      <xsl:value-of select="TYPE"/>
      <xsl:text>";</xsl:text>
      <xsl:text>&#xa;</xsl:text>
      <xsl:text>     char   *pnameIn</xsl:text>
      <xsl:value-of select="$index" />
      <xsl:text> = "</xsl:text>
      <xsl:value-of select="NAME"/>
      <xsl:text>";</xsl:text>
      <xsl:text>&#xa;</xsl:text>
</xsl:for-each> 

 <xsl:for-each select="BUFFER">
      <xsl:variable name="index" select="position()-1" />
      <xsl:text>KrnModelConnectionInput(indexIC,</xsl:text><xsl:value-of select="$index" /><xsl:text> ,pnameIn</xsl:text>
      <xsl:value-of select="$index" />
      <xsl:text>,ptypeIn</xsl:text>
      <xsl:value-of select="$index" />
      <xsl:text>);</xsl:text>
      <xsl:text>&#xa;</xsl:text>
 
</xsl:for-each>
<xsl:text>}&#xa; break;&#xa;</xsl:text>
</xsl:template>

<xsl:template match="INPUT_BUFFERS" mode="inBuffSysInits">
 
<xsl:for-each select="BUFFER">
     <xsl:variable name="index" select="position()-1" />
    
     
     <xsl:variable name="delayType" select="DELAY/TYPE" />
     <xsl:if test="$delayType='max'"> 
          <xsl:text>  delay_max((buffer_Pt)star_P->inBuffer_P[</xsl:text>
          <xsl:value-of select="$index" />
          <xsl:text>],</xsl:text>
          <xsl:value-of select="DELAY/VALUE_MAX" />
	  <xsl:text>);&#xa;</xsl:text>
     </xsl:if>
     <xsl:if test="$delayType='min'"> 
          <xsl:text>  delay_min((buffer_Pt)star_P->inBuffer_P[</xsl:text>
          <xsl:value-of select="$index" />
          <xsl:text>],</xsl:text>
          <xsl:value-of select="DELAY/VALUE_MIN" />
	  <xsl:text>);&#xa;</xsl:text>
     </xsl:if>
     

</xsl:for-each>
<xsl:text>&#xa;</xsl:text>

</xsl:template>


<xsl:template match="PARAMETERS" mode="ParamDefines">
/*         
 *    PARAMETER DEFINES 
 */ 
<xsl:for-each select="PARAM">
  <xsl:variable name="spaces" select="string(' &#x9;')" />
  <xsl:variable name="none" select="string('')" />
   <xsl:variable name="typeName" select="TYPE" />
    <xsl:variable name="paramName" select="NAME" />


     <xsl:variable name="index" select="position()-1" />
     <xsl:text>#define </xsl:text>
     <xsl:value-of select="translate($paramName,$spaces,$none)"/>
     <xsl:variable name="type" select="translate($typeName,$spaces,$none)" />
     <xsl:choose>
        <xsl:when test="$type='array'">
	     <xsl:text> ((float*)param_P[</xsl:text>
	</xsl:when>
        <xsl:otherwise> (param_P[</xsl:otherwise>  
     </xsl:choose> 
     <xsl:value-of select="$index" />
     <xsl:text>]->value.</xsl:text>
     <xsl:choose>
        <xsl:when test="$type='float'">
	     <xsl:text>f)&#xa;</xsl:text>
	</xsl:when>
        <xsl:when test="$type='int'">
	     <xsl:text>d)&#xa;</xsl:text>
	</xsl:when>
        <xsl:when test="$type='file'">
	     <xsl:text>s)&#xa;</xsl:text>
	</xsl:when>
        <xsl:when test="$type='function'">
	     <xsl:text>s)&#xa;</xsl:text>
	</xsl:when>
        <xsl:when test="$type='string'">
	     <xsl:text>s)&#xa;</xsl:text>
	</xsl:when>
        <xsl:when test="$type='array'">
	       <xsl:text>s)&#xa;</xsl:text>
               <xsl:text>#define n_</xsl:text>
	       <xsl:value-of select="translate($paramName,$spaces,$none)"/>
	       <xsl:text>  (param_P[</xsl:text>
	       <xsl:value-of select="$index" />
	       <xsl:text>]->array_size)</xsl:text>
               <xsl:text>&#xa;</xsl:text>
	</xsl:when>
     </xsl:choose>
	  
</xsl:for-each>

</xsl:template>

<xsl:template match="PARAMETERS" mode="InitCode">

 
case PARAM_INIT: 
    {
      int indexModel88 = block_P->model_index;
<xsl:for-each select="PARAM">
  <xsl:variable name="spaces" select="string(' &#x9;')" />
  <xsl:variable name="none" select="string('')" />
   <xsl:variable name="paramName" select="NAME" />
   <xsl:variable name="paramType" select="TYPE" />
    <xsl:variable name="paramValue" select="VALUE" />

      <xsl:variable name="index" select="position()-1" />
      <xsl:text>     char   *pdef</xsl:text>
      <xsl:value-of select="$index" />
      <xsl:text> = "</xsl:text>
      <xsl:value-of select="DEF"/>
      <xsl:text>";</xsl:text>
      <xsl:text>&#xa;</xsl:text>

      <xsl:text>     char   *ptype</xsl:text>
      <xsl:value-of select="$index" />
      <xsl:text> = "</xsl:text>
      <xsl:value-of select="translate($paramType,$spaces,$none)"/>
      <xsl:text>";</xsl:text>
      <xsl:text>&#xa;</xsl:text>


      <xsl:text>     char   *pval</xsl:text>
      <xsl:value-of select="$index" />
      <xsl:text> = "</xsl:text>
      <xsl:value-of select="translate($paramValue,$spaces,$none)"/>
      <xsl:text>";</xsl:text>
      <xsl:text>&#xa;</xsl:text>

      <xsl:text>     char   *pname</xsl:text>
      <xsl:value-of select="$index" />
      <xsl:text> = "</xsl:text>
      <xsl:value-of select="translate($paramName,$spaces,$none)"/>
      <xsl:text>";</xsl:text>
      <xsl:text>&#xa;</xsl:text>

</xsl:for-each>
 <xsl:for-each select="PARAM">
      <xsl:variable name="index" select="position()-1" />
      <xsl:text>KrnModelParam(indexModel88,</xsl:text><xsl:value-of select="$index" /><xsl:text> ,pdef</xsl:text>
      <xsl:value-of select="$index" />
      <xsl:text>,ptype</xsl:text>
      <xsl:value-of select="$index" />
      <xsl:text>,pval</xsl:text>
      <xsl:value-of select="$index" />
      <xsl:text>,pname</xsl:text>
      <xsl:value-of select="$index" />
      <xsl:text>);</xsl:text>
      <xsl:text>&#xa;</xsl:text>
 
</xsl:for-each>
      }
break;
   

</xsl:template>

<xsl:template match="BLOCK" mode="UserInit">
/*
 *               USER INITIALIZATION CODE 
 */
case USER_INIT: 
<xsl:value-of select="INIT_CODE"/>
<xsl:text>break;&#xa;</xsl:text>
</xsl:template>

<xsl:template match="BLOCK" mode="MainCode">
/* 
 *             MAIN CODE 
 */
case MAIN_CODE: 
<xsl:value-of select="MAIN_CODE"/>
<xsl:text>break;&#xa;</xsl:text>
</xsl:template> 
<xsl:template match="BLOCK" mode="WrapupCode">
/*             
 *            WRAPUP CODE 
 */
case WRAPUP: 
<xsl:value-of select="WRAPUP_CODE"/>
<xsl:text>break;&#xa;</xsl:text>
<xsl:text>}&#xa;return(0);&#xa;}&#xa;</xsl:text>
</xsl:template> 






<!--         OUTPUT THE GENERATED CODE      -->

<xsl:strip-space elements="BLOCK_NAME" />

<xsl:template match="/">

 
   <xsl:apply-templates  select=".//BLOCK" mode="License" /> 
      <xsl:apply-templates  select=".//BLOCK" mode="ShortDesc" /> 
   <xsl:apply-templates  select=".//BLOCK" mode="Programmers" /> 
   <xsl:apply-templates  select=".//BLOCK" mode="Common" />  
    <xsl:apply-templates  select=".//INCLUDES" mode="Includes" /> 
    <xsl:apply-templates  select=".//DEFINES" mode="Defines" /> 
    <xsl:apply-templates  select=".//STATES" mode="StateStruct" />

    <xsl:apply-templates  select=".//STATES" mode="StateDefines" />

    
            <xsl:apply-templates  select=".//INPUT_BUFFERS" mode="inBuffDefines" />
	    
        <xsl:apply-templates  select=".//OUTPUT_BUFFERS" mode="outBuffDefines" />
 
    
       
    <xsl:apply-templates  select=".//PARAMETERS" mode="ParamDefines" />
  <xsl:apply-templates  select=".//BLOCK" mode="Declarations" />     
    
  <xsl:apply-templates  select=".//BLOCK" mode="NoParam" />  
    <xsl:apply-templates select=".//PARAMETERS" mode="InitCode" />
       <xsl:apply-templates select=".//OUTPUT_BUFFERS" mode="outBuffInits" />
        <xsl:apply-templates select=".//INPUT_BUFFERS" mode="inBuffInits" />	

    
    
    <xsl:apply-templates select=".//BLOCK" mode="SysInitBegin" />    
    <xsl:apply-templates select=".//STATES" mode="SystemInit" /> 
        <xsl:apply-templates select=".//OUTPUT_BUFFERS" mode="outBuffSysInits" />
        <xsl:apply-templates select=".//INPUT_BUFFERS" mode="inBuffSysInits" />	
       <xsl:apply-templates select=".//OUTPUT_BUFFERS" mode="outBuffSysInitsChecks" />
       <xsl:apply-templates select=".//INPUT_BUFFERS" mode="inBuffSysInitsChecks" />

    <xsl:apply-templates select=".//BLOCK" mode="SysInitEnd" />
	   
    <xsl:apply-templates select=".//BLOCK" mode="UserInit" />
    <xsl:apply-templates select=".//BLOCK" mode="MainCode" /> 
    <xsl:apply-templates select=".//BLOCK" mode="WrapupCode" />             


</xsl:template>                       


</xsl:stylesheet>
