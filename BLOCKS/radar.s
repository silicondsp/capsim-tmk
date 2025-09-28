<BLOCK>
<LICENSE>
/*  Capsim (r) Text Mode Kernel (TMK) Star Library (Blocks)
    Copyright (C) 1989-2017  Silicon DSP Corporation

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

    http://www.silicondsp.com
    Silicon DSP  Corporation
    Las Vegas, Nevada
*/
</LICENSE>
<BLOCK_NAME>

radar 

</BLOCK_NAME> 

<COMMENTS>
<![CDATA[ 

/*
 	radar.s:	tracking filter
 	parameters:	alpha, beta, scan time, initial velocity
 	inputs:		range measurements in nautical miles
 	outputs:	predicted range
 			smoothed range
 			predicted velocity
			smoothed velocity
 	description:	This star implements an alpha-beta
 			tracking filter.
<NAME>
radar
</NAME>
<DESCRIPTION>
This star implements an alpha-beta tracking filter.
	parameters:	alpha, beta, scan time, initial velocity
 	inputs:		range measurements in nautical miles
 	outputs:	predicted range
 			smoothed range
 			predicted velocity
			smoothed velocity
</DESCRIPTION>
<PROGRAMMERS>
 			written by Ray Kassel
 			August 13, 1990
</PROGRAMMERS>
 */

]]>
</COMMENTS> 

   
<DESC_SHORT>
This star implements an alpha-beta tracking filter.
</DESC_SHORT>

<STATES>
	<STATE>
		<TYPE>int</TYPE>
		<NAME>npts</NAME>
		<VALUE>0</VALUE>
	</STATE>
</STATES>
 
<DECLARATIONS> 

	float dv;
	float tdel;
	float tmp;

</DECLARATIONS> 

           

<PARAMETERS>
<PARAM>
	<DEF>alpha</DEF>
	<TYPE>float</TYPE>
	<NAME>alpha</NAME>
	<VALUE>0.5</VALUE>
</PARAM>
<PARAM>
	<DEF>beta</DEF>
	<TYPE>float</TYPE>
	<NAME>beta</NAME>
	<VALUE>0.5</VALUE>
</PARAM>
<PARAM>
	<DEF>scan time (msec)</DEF>
	<TYPE>float</TYPE>
	<NAME>ts</NAME>
	<VALUE>10.0</VALUE>
</PARAM>
<PARAM>
	<DEF>initial velocity (-knots)</DEF>
	<TYPE>float</TYPE>
	<NAME>figuess</NAME>
	<VALUE>-400.0</VALUE>
</PARAM>
</PARAMETERS>

     

<INPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>xm</NAME>
		<DELAY><TYPE>max</TYPE><VALUE_MAX>1</VALUE_MAX></DELAY>
	</BUFFER>
</INPUT_BUFFERS>
 
         

<OUTPUT_BUFFERS>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>ys</NAME>
		<DELAY><TYPE>max</TYPE><VALUE_MAX>1</VALUE_MAX></DELAY>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>yp</NAME>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>ysd</NAME>
		<DELAY><TYPE>max</TYPE><VALUE_MAX>1</VALUE_MAX></DELAY>
	</BUFFER>
	<BUFFER>
		<TYPE>float</TYPE>
		<NAME>ypd</NAME>
	</BUFFER>
</OUTPUT_BUFFERS>
 
<INIT_CODE>
<![CDATA[ 


]]>
</INIT_CODE> 


<MAIN_CODE>
<![CDATA[ 


	tdel=ts/1000.0;
	dv=1.0;
	tmp=0.0;

	while(IT_IN(0))  {
		if(npts < 2)  {
			if(IT_OUT(0)) {
				KrnOverflow("radar",0);
				return(99);
			}
			ys(0) = xm(0);
			if(IT_OUT(1)) {
				KrnOverflow("radar",1);
				return(99);
			}
			yp(0) = xm(0);
			if(IT_OUT(2)) {
				KrnOverflow("radar",2);
				return(99);
			}

			if(npts == 1)
				ysd(0) = 3600.0*xm(1)/tdel-3600.0*xm(0)/tdel;
			else
				ysd(0) = figuess; 

			if(IT_OUT(3)) {
				KrnOverflow("radar",1);
				return(99);
			}
			ypd(0) = ysd(0);
		}
		else  {
			if(xm(0) == 0.0)
				dv = 0.0;
			else
				dv = 1.0;
			if(IT_OUT(1)) {
				KrnOverflow("radar",1);
				return(99);
			}
			if(IT_OUT(2)) {
				KrnOverflow("radar",2);
				return(99);
			}
			if(IT_OUT(3)) {
				KrnOverflow("radar",3);
				return(99);
			}
			if(IT_OUT(0)) {
				KrnOverflow("radar",0);
				return(99);
			}
			yp(0) = ys(1)+ysd(1)*tdel/3600.0;
			ypd(0) = ysd(1);
			ys(0) = yp(0)+dv*alpha*xm(0)-dv*alpha*yp(0);
			tmp = dv*beta*3600.0/tdel;
			ysd(0) = ypd(0)+tmp*xm(0)-tmp*yp(0);
		}
		npts++;
	}

	return(0);

]]>
</MAIN_CODE> 

<WRAPUP_CODE>
<![CDATA[ 


]]>
</WRAPUP_CODE> 



</BLOCK> 

