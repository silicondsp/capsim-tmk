#!/bin/perl
# Copyright (C) 1989-2016 Silicon DSP Corporation
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation; either version 2 of the License, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#
#
#
# Written by Sasan Ardalan, Dec.2, 1997
# Revised  by Sasan Ardalan, June 18, 2006 
#


$no_param=0;
$paramdoit=0;
$inBufdoit=0;
$outBufdoit=0;
$statedoit=0;

print "\n$0\n$DateTime\n Fix XML\n==============================================\n";


foreach $f (@ARGV) {


if($flagTrue ==0)  {
     $flag=$f;
}



   {
	#
	# Here we process an individual file
	#
	$file=$f;
	$file2="./XML_CONVERTED/".$f;
	$f="";
	
	$fileFlag=1;



  }
        print "filename name is: $file\n";

#        `mv $file /tmp/zzzz`
        # rename($file,"zzzz");

	open (INFILE, $file ) || die "could not open infile /tmp/zzzz";
	open (OUTFILE, ">$file2") || die "could not open outfile $file";
	while(<INFILE>) {
           #  s/\r//;

             s/<INIT_CODE>/<INIT_CODE>\n<![CDATA[/;
             s/<\/INIT_CODE>/]]>\n<\/INIT_CODE>/;
             s/<MAIN_CODE>/<MAIN_CODE>\n<![CDATA[/;
             s/<\/MAIN_CODE>/]]>\n<\/MAIN_CODE>/;
             s/<WRAPUP_CODE>/<WRAPUP_CODE>\n<![CDATA[/;
             s/<\/WRAPUP_CODE>/]]>\n<\/WRAPUP_CODE>/;
             s/<INCLUDES>/<INCLUDES>\n<![CDATA[/;
             s/<\/INCLUDES>/]]>\n<\/INCLUDES>/;

             s/<STAR>/<BLOCK>/;
             s/<\/STAR>/<\/BLOCK>/;
             s/<STAR_NAME>/<BLOCK_NAME>/;
             s/<\/STAR_NAME>/<\/BLOCK_NAME>/;

             s/<COMMENTS>/<COMMENTS>\n<![CDATA[/;
             s/<\/COMMENTS>/]]>\n<\/COMMENTS>/;
#+++++++++++++++++++++++++++++


    if (/^<PARAMETERS>|^<PARAMETERS>/ .. /^<\/PARAMETERS>/) {
       if ( /^<\/PARAMETERS>/) { $paramdoit=1; $_="";} else {
      chop;
       @Fld= split(' ',$_, 9999);
	#Throw out the parameter and end lines and blank lines
	if ($Fld[1] eq '<PARAMETERS>' || $Fld[1] eq '<PARAMETERS>' ||

#	  $Fld[1] eq '</PARAMETERS>' || $#Fld == 0) {
	  $Fld[1] eq '</PARAMETERS>' ) {
	    ;
	}

	#Otherwise the line specifies a parameter
	else {
	    s/ += +/=/;
	    #Remove an optional ";" at the end of the line
	    @line1 = split(/;/, $_, 9999);


	    #Split the line to determine if there is a default;
	    $eq_flag = 0;
	    if ((@line2 = split(/=/, $line1[0], 9999)) >= 2) {
		$eq_flag = 1;
	    }
	    $no_words = (@line3 = split(' ', $line2[0]));
	    if ($no_words == 1) {
		if ($eq_flag == 0) {
			(print  "STARGAZE: error in parameter line:\n" .

			  $_);
		    # parameter specification line
		    ;
		}
		if ($line3[0] eq 'param_def') {
		    if ((@line4 = split("\"", $line1[0], 9999)) != 3) {
			    (print 

			      "STARGAZE: missing quotes in parameter line:\n"

			      . $_);
		    }
		    $pdef{$no_param} = $line4[1];
		}
		elsif ($line3[0] eq 'param_min') {
		    $pmin{$no_param} = $line2[1];
		}
		elsif ($line3[0] eq 'param_max') {
		    $pmax{$no_param} = $line2[1];
		}
		else {
			(print 

			  "STARGAZE: unrecognized parameter option in parameter line:\n"

			  . $_);
		}
	    }
	    elsif ($no_words == 2) {
		$ptype{$no_param} = $line3[0];
		$pname{$no_param} = $line3[1];
		if ($line3[0] eq 'int') {
		    $define{$no_define++} = '#define ' . $line3[1] .

		      "   \t(param_P[" . $no_param . ']->value.d)';
		    if ($eq_flag == 1) {
			$pval{$no_param} = $line2[1];
		    }
		}
		elsif ($line3[0] eq 'float') {
		    $define{$no_define++} = '#define ' . $line3[1] .

		      "   \t(param_P[" . $no_param . ']->value.f)';
		    if ($eq_flag == 1) {
			$pval{$no_param} = $line2[1];
		    }
		}
		elsif ($line3[0] eq 'file' || $line3[0] eq 'function') {
		    $define{$no_define++} = '#define ' . $line3[1] .

		      "   \t(param_P[" . $no_param . ']->value.s)';
		    if ($eq_flag == 1) {
			if ((@line4 = split("\"", $line2[1], 9999)) != 3) {
				(print 

				  "STARGAZE: no quotes on string in parameter line:\n"

				  . $_);
			}
			else {
			    $pval{$no_param} = $line4[1];
			}
		    }
		}


		elsif ($line3[0] eq 'string' ) {
		    $define{$no_define++} = '#define ' . $line3[1] .

		      "   \t(param_P[" . $no_param . ']->value.s)';
		    if ($eq_flag == 1) {
			if ((@line4 = split("\"", $line2[1], 9999)) != 3) {
				(print 

				  "STARGAZE: no quotes on string in parameter line:\n"

				  . $_);
			}
			else {
			    $pval{$no_param} = $line4[1];
			}
		    }
		}

		elsif ($line3[1] eq 'array') {
		    if ($eq_flag == 1) {
			    (print  "STARGAZE: error in parameter line:\n"

			      . $_);
			    (print 

			      '(Default values not allowed for arrays)');
		    }
		    $define{$no_define++} = '#define ' . $line3[1] .

		      "   \t((float *)param_P[" . $no_param . ']->value.s)';

		    $define{$no_define++} = '#define n_' . $line3[1] .

		      "   \t(param_P[" . $no_param . ']->array_size)';
		}
		else {
			(print  "STARGAZE: parameter type unknown, line:\n"

			  . $_);
		}

######################################

		$no_param++;
	    }
	    else {
		    (print  "STARGAZE: error in parameter line:\n" . $_);
	    }
	}
        $_=" ";
      }
    }


#+++++++++++++++++++++++++++++
$paramdoit=WriteXMLParams(OUTFILE,$paramdoit);

#-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+





   if (/^<INPUT_BUFFERS>|^<INPUT_BUFFERS>/ .. /^<\/INPUT_BUFFERS>/) {
       if ( /^<\/INPUT_BUFFERS>/) { $inBufdoit=1; } else {
      chop;
       @Fld= split(' ',$_, 9999);
        #Ignore the input_buffer, end, and blank lines
        if ($Fld[1] eq '<INPUT_BUFFERS>' || $Fld[1] eq '<INPUT_BUFFER>') {
        #Set in_buffers to zero to indicate set by user
            $in_buffers = 0;
        }
        elsif ($Fld[1] eq '</INPUT_BUFFERS>' || $#Fld == 0) {
            ;
        }
        else {
	    s/ += +/=/;
            #Remove an optional ";" at the end of the line
            @line1 = split(/;/, $_, 9999);
            $inBuffDelayType{$in_buffers}=$delayType;
            $inBuffDelayValue{$in_buffers}=$delayValue;

            #Check if line includes an equal sign
            $no_fields = (@line2 = split(/=/, $line1[0], 9999));

            #Look first for delay_max and delay_min lines
            if ($no_fields == 2) {
                @line3 = split(' ', $line2[0]);
#print "++++++++++++++++ FOUND DELAY MIN MAX:",$line3[0],":",$line2[0],":",$line2[1],"\n";
                
                if ($line3[0] eq 'delay_min' || $line3[0] eq 'delay_max') {
#print "++++++++++++++++ DELAY TYPE:",$line3[0],":Delay Value:",$line2[1],":","\n";
                    $delayType=$line3[0];
                    $delayValue=$line2[1];
               $inBuffDelayType{$in_buffers}=$delayType;
               $inBuffDelayValue{$in_buffers}=$delayValue;
                    $sysinit{$no_sysinit++} = "\t" . $line3[0] .

                      '(star_P->inBuffer_P[' . $in_buffers . '],' . $line2[1] .

                      ');';
                }
                else {
                        (print  "STARGAZE: error in input_buffer line:\n" .

                          $_);
                }
            }
            elsif ($no_fields == 1) {
                if ((@line3 = split(' ', $line2[0])) != 2) {
                        (print  "STARGAZE: error in input_buffer line:\n" .
 
                          $_);
                }

               $inBuffType{$in_buffers}=$line3[0];
               $inBuffName{$in_buffers}=$line3[1];
               $inBuffDelayType{$in_buffers}=$delayType;
               $inBuffDelayValue{$in_buffers}=$delayValue;
               $delayType="";
               $delayValue="";

                ++$in_buffers;

                #Generate define statements for buffer references
                #The following is the macro for accessing a buffer
                $define{$no_define++} = '#define ' . $line3[2] .

                  "(DELAY)  \t(*((" . $line3[0] . ' *)PIN(' . ($in_buffers -

                  1) . ',DELAY)))';
            }
        }
       }
        $_=" ";
    }


#-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
$inBufdoit=WriteXMLInBuff(OUTFILE,$inBufdoit);

#=======================================
  if (/^<OUTPUT_BUFFERS>|^<OUTPUT_BUFFERS>/ .. /^<\/OUTPUT_BUFFERS>/) {
       if ( /^<\/OUTPUT_BUFFERS>/) { $outBufdoit=1; } else {
      chop;
       @Fld= split(' ',$_, 9999);
        #Ignore the output_buffer, end, and blank lines
        if ($Fld[1] eq '<OUTPUT_BUFFERS>' || $Fld[1] eq '<OUTPUT_BUFFERS>') {
        #Set in_buffers to zero to indicate set by user
            $in_buffers = 0;
        }
        elsif ($Fld[1] eq '</OUTPUT_BUFFERS>' || $#Fld == 0) {
            ;
        }
        else {
	    s/ +=+ /=/;
            #Remove an optional ";" at the end of the line
            @line1 = split(/;/, $_, 9999);
            $outBuffDelayType{$out_buffers}=$delayType;
            $outBuffDelayValue{$out_buffers}=$delayValue;

            #Check if line includes an equal sign
            $no_fields = (@line2 = split(/=/, $line1[0], 9999));

            #Look first for delay_max and delay_min lines
            if ($no_fields == 2) {
                @line3 = split(' ', $line2[0]);
                if ($line3[0] eq 'delay_min' || $line3[0] eq 'delay_max') {
                    $delayType=$line3[0];
                    $delayValue=$line2[1];
               $outBuffDelayType{$out_buffers}=$delayType;
               $outBuffDelayValue{$out_buffers}=$delayValue;
                    $sysinit{$no_sysinit++} = "\t" . $line3[0] .

                      '(star_P->inBuffer_P[' . $in_buffers . '],' . $line2[1] .

                      ');';
                }
                else {
                        (print  "STARGAZE: error in input_buffer line:\n" .

                          $_);
                }
            }
            elsif ($no_fields == 1) {
                if ((@line3 = split(' ', $line2[0])) != 2) {
                        (print  "STARGAZE: error in input_buffer line:\n" .

                          $_);
                }

               $outBuffType{$out_buffers}=$line3[0];
               $outBuffName{$out_buffers}=$line3[1];
               $outBuffDelayType{$out_buffers}=$delayType;
               $outBuffDelayValue{$out_buffers}=$delayValue;
               $delayType="";
               $delayValue="";


                ++$out_buffers;

                #Generate define statements for buffer references
                #The following is the macro for accessing a buffer
                $define{$no_define++} = '#define ' . $line3[2] .

                  "(DELAY)  \t(*((" . $line3[0] . ' *)PIN(' . ($in_buffers -

                  1) . ',DELAY)))';
            }
        }
       }

        $_=" ";
    }

#======================================

$outBufdoit=WriteXMLOutBuff(OUTFILE,$outBufdoit);


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   if (/^<STATES>|^<STATES>/ .. /^<\/STATES>/) {
       if ( /^<\/STATES>/) { $statedoit=1; } else {
      chop;
       @Fld= split(' ',$_, 9999);
        #Ignore the input_buffer, end, and blank lines
        if ($Fld[1] eq '<STATES>' || $Fld[1] eq '<STATES>') {
        #Set in_buffers to zero to indicate set by user
            $numberStates = 0;
        }
        elsif ($Fld[1] eq '</STATES>' || $#Fld == 0) {
            ;
        }
        elsif ($statedoit==0) {
            #Remove an optional ";" at the end of the line
	    s/ += +/=/;
            @line1 = split(/;/, $_, 9999);
            $stateTypeArray{$numberStates}=$stateType;
            $stateValueArray{$numberStates}=$stateValue;
            $stateNameArray{$numberStates}=$stateName;

	    
	    @line4 = split(' ', $line1[0]);
	    
            #Check if line includes an equal sign
            $no_fields = (@line2 = split(/=/, $line4[1], 9999));

             if ($no_fields == 2) {
                @line3 = split(' ', $line2[0]);
                
                    $stateType=$line4[0];
                    $stateName=$line2[0];
		    $stateValue=$line2[1];
		    
               $stateTypeArray{$numberStates}=$stateType;
               $stateNameArray{$numberStates}=$stateName;
               $stateValueArray{$numberStates}=$stateValue;
	       
            }
            else  {
	            @line3 = split(' ', $line1[0]);
                    $stateType=$line3[0];
                    $stateName=$line3[1];
 	    
               $stateTypeArray{$numberStates}=$stateType;
               $stateNameArray{$numberStates}=$stateName	    
	    
            }

 #              $stateTypeArray{$numberStates}=$line3[0];
 #              $stateValueArray{$numberStates}=$stateValue;
               $stateType="";
               $stateValue="";
	       $stateName="";

                ++$numberStates;
            
        }
       }
       $_=" ";
    }


$statedoit=WriteXMLState(OUTFILE,$statedoit);


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
             print (OUTFILE  $_);

	}
   	close (INFILE);
   	close (OUTFILE);

	print "End of script.\n\nDone!\n";

}
exit;


sub WriteXMLParams {
local($fileParam,$doit) = @_;
#-----------------------
if($doit==1) {
   if ($no_param > 0) {
           print ( $fileParam "\n\n");
           print ( $fileParam "<PARAMETERS>\n");
       for ($i = 0; $i < $no_param; ++$i) {
              print ( $fileParam "<PARAM>\n");

               $_=$pdef{$i};
               if(/>/ || /</) {

                    print ( $fileParam "\t<DEF><![CDATA[",$pdef{$i},"]]></DEF>\n");
               } else {
         
                    print ( $fileParam "\t<DEF>",$pdef{$i},"</DEF>\n");
               }
               print ( $fileParam "\t<TYPE>",$ptype{$i},"</TYPE>\n");
               print ( $fileParam "\t<NAME>",$pname{$i},"</NAME>\n");
               print ( $fileParam "\t<VALUE>",$pval{$i},"</VALUE>\n");
           print ( $fileParam "</PARAM>\n");
       }
       print ( $fileParam "</PARAMETERS>\n");
       $_="";
       $done=0;
   }
}
return(0);
#-----------------------

}


sub WriteXMLInBuff {
local($fileParam,$doit) = @_;
#-----------------------
if($doit==1) {
   if ($in_buffers > 0) {
           print ( $fileParam "\n\n");
           print ( $fileParam "<INPUT_BUFFERS>\n");
       for ($i = 0; $i < $in_buffers; ++$i) {
#print ( "+++++-----++++++Delay:",$inBuffDelayType{$i},":",$inBuffDelayValue{$i},":","\n");
              if( $inBuffType{$i} ne '') {
                   print ( $fileParam "\t<BUFFER>\n");
                   print ( $fileParam "\t\t<TYPE>",$inBuffType{$i},"</TYPE>\n");
                   print ( $fileParam "\t\t<NAME>",$inBuffName{$i},"</NAME>\n");
                   if( $inBuffDelayType{$i} ne '') {
                       if($inBuffDelayType{$i} eq 'delay_min') { $typeDelay="min"; } else {$typeDelay="max";}
                       print ( $fileParam "\t\t<DELAY>","<TYPE>",$typeDelay,"</TYPE>",
                            "<VALUE>",$inBuffDelayValue{$i},"</VALUE>","</DELAY>\n");
                      
                   }
                   print ( $fileParam "\t</BUFFER>\n");
              }
       }
       print ( $fileParam "</INPUT_BUFFERS>\n");
       $done=0;
   }
}
return(0);
#-----------------------

}


sub WriteXMLOutBuff {
local($fileParam,$doit) = @_;
#-----------------------
if($doit==1) {
   if ($out_buffers > 0) {
           print ( $fileParam "\n\n");
           print ( $fileParam "<OUTPUT_BUFFERS>\n");
       for ($i = 0; $i < $out_buffers; ++$i) {
              if( $outBuffType{$i} ne "") {
                   print ( $fileParam "\t<BUFFER>\n");
                   print ( $fileParam "\t\t<TYPE>",$outBuffType{$i},"</TYPE>\n");
                   print ( $fileParam "\t\t<NAME>",$outBuffName{$i},"</NAME>\n");
                   if( $outBuffDelayType{$i} ne '') {
                       if($outBuffDelayType{$i} eq 'delay_min') { $typeDelay="min"; } else {$typeDelay="max";}
                       print ( $fileParam "\t\t<DELAY>","<TYPE>",$typeDelay,"</TYPE>",
                            "<VALUE>",$outBuffDelayValue{$i},"</VALUE>","</DELAY>\n");
                      
                   }
                   print ( $fileParam "\t</BUFFER>\n");
              }
       }
       print ( $fileParam "</OUTPUT_BUFFERS>\n");
       $done=0;
   }
}
return(0);
#-----------------------

}


sub WriteXMLState {
local($fileParam,$doit) = @_;
#-----------------------

#print "%%%%%%%%%%%%  number of states =",$numberStates," %%%%%%%%\n";
if($doit==1) {
   if ($numberStates > 0) {
           print ( $fileParam "\n\n");
           print ( $fileParam "<STATES>\n");
       for ($i = 0; $i < $numberStates; ++$i) {
              if( $stateTypeArray{$i} ne "") {
              
                   print ( $fileParam "\t<STATE>\n");
                   print ( $fileParam "\t\t<TYPE>",$stateTypeArray{$i},"</TYPE>\n");
                   print ( $fileParam "\t\t<NAME>",$stateNameArray{$i},"</NAME>\n");
               if( $stateValueArray{$i} ne "") {		   
                   print ( $fileParam "\t\t<VALUE>",$stateValueArray{$i},"</VALUE>\n");
                }
                   print ( $fileParam "\t</STATE>\n");
              }
       }
       print ( $fileParam "</STATES>\n");
       $done=0;
   }
}
return(0);
#-----------------------

}



			


