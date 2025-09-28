#!/usr/bin/perl
#
#
# Copyright (C) 1989-2017 Silicon DSP Corporation
#
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
# http://www.silicondsp.com
#
#

##eval "exec /usr/bin/perl -S $0 $*"
##    if $running_under_some_shell;
			# this emulates #! processing on NIH machines.
			# (remove #! line above if indigestible)

##eval '$'.$1.'$2;' while $argv2[0] =~ /^([A-Za-z_]+=)(.*)/ && shift;
			# process any FOO=bar switches




foreach $f (@ARGV) {

$theStar=$f;
$argv2=$theStar;
 
print $theStar,"\n";
print $argv2,"\n";

$[ = 1;			# set array base to 1
$, = ' ';		# set output field separator
$\ = "\n";		# set output record separator

#
#Set operating system here, either UNIX or VMS or MACOS
$op_sys = 'MACOS';

$no_state = 0;
$no_statelines=0;
$no_param = 0;
$no_define = 0;
$no_user_define = 0;
# number of user defines
$no_include = 0;
$no_decl = 0;
$no_init = 0;
$no_sysinit = 0;
$no_main = 0;
$no_wrapup = 0;
$no_comment = 0;



$paramdoit=0;
$inBufdoit=0;
$outBufdoit=0;
$statedoit=0;




#Set no_buffers negative so we can recognize if set
$in_buffers = -1;
$out_buffers = -1;

#Star return codes will start at 200
$return_code = 200;

print 'Input File Name=' . $argv2;
#Check for .s suffix, strip; create starname, output file name
$n = (@array = split(/\./, $argv2, 9999));
if ($array[$n] ne 's') {
    # &Pick('>', 'sg.error') &&
	print  "Star2XML: file name must end with \".s\"";
    $ExitValue = (0); last line;
}
$argv2 = substr($argv2, 1, length($argv2) - 2);
if ($op_sys eq 'VMS') {
    $n = (@line1 = split(/\]/, $argv2, 9999));
}
elsif ($op_sys eq 'UNIX') {
    $n = (@line1 = split(/\//, $argv2, 9999));
}
elsif ($op_sys eq 'MACOS') {
	  $n = (@line1 = split(/:/, $argv2, 9999));
#	   foreach $file (@line1) {
#        	print "$file\n";
#       }

}
if ($n > 0) {
    $star_name = $line1[$n];
}
else {
    $star_name = $argv2;
}
$out_file = "XML_STARS/".$star_name . '.s';
$theStar =  $star_name . '.s';
print 'Input File Name:' . $theStar;
print 'Output File Name:' . $out_file;

    $no_comments=0;
    $no_inputbuffers=0;
    $no_outputbuffers=0;
    $no_parameterlines=0;

    open(theInputFile,$theStar) || die "could not open input file  $theStar";
	open (OUTFILE, ">$out_file") || die "could not open outfile $file";
	
while (<theInputFile>) {
	
#
# convert old style lower case MACROs to new style all caps
#

	s/input_buffers/input_buffer/;
	s/output_buffers/output_buffer/;
	

     s/min_avail\(/MIN_AVAIL\(/;
	 s/avail\(/AVAIL\(/;
     s/it_in\(/IT_IN\(/;
     s/it_out\(/IT_OUT\(/;
     s/pin\(/PIN\(/;
     s/inf\(/INF\(/;
     s/ini\(/INI\(/;
     s/inc\(/INC\(/;
     s/ind\(/IND\(/;
     s/incx\(/INCX\(/;
     s/indi\(/INDI\(/;
     s/inimage\(/INIMAGE\(/;
     s/pout\(/POUT\(/;
     s/outf\(/OUTF\(/;
     s/outi\(/OUTI\(/;
     s/outc\(/OUTC\(/;
     s/outd\(/OUTD\(/;
     s/outcx\(/OUTCX\(/;
     s/outdi\(/OUTDI\(/;
     s/outimage\(/OUTIMAGE\(/;
     s/sname\(/SNAME\(/;
     s/set_dmin_in/SET_DMIN_IN/;
     s/set_dmax_in/SET_DMAX_IN/;
     s/set_dmin_out/SET_DMIN_OUT/;
     s/set_dmax_out/SET_DMAX_OUT/;
     s/set_cell_size_in/SET_CELL_SIZE_IN/;
     s/set_cell_size_out/SET_CELL_SIZE_OUT/;
     s/set_cellsize_in/SET_CELL_SIZE_IN/;
     s/set_cellsize_out/SET_CELL_SIZE_OUT/;


     s/no_output_buffers/NO_OUTPUT_BUFFERS/g;
	 s/no_output_buffer/NO_OUTPUT_BUFFERS/g;
     s/no_input_buffers/NO_INPUT_BUFFERS/g;
	 s/no_input_buffer/NO_INPUT_BUFFERS/g;
     s/NOSAMPLES/NUMBER_SAMPLES_PER_VISIT/;

#
# convert cs_consoleBuffer to stderr and PrintConsole(); to empty and sprintf to fprintf
#

    s/sprintf\(cs_consoleBuffer/fprintf\(stderr/;
    s/PrintConsole\(\);//;

    $theLine=$_;


    chop;	# strip record separator
    @Fld = split(' ', $_, 9999);
    if ($Fld[1] eq '#include') {
	       #find all user include lines

	       $include{$no_include} = $_;
	       ++$no_include;
    }

    if ($Fld[1] eq '#define') {
        	#find all user define lines

	     $define{$no_define} = $_;
	     ++$no_define;
	     ++$no_user_define;
    }
    if (/^comments$/ .. /^end$/) {
	    if ($Fld[1] ne 'comments' && $Fld[1] ne 'end' && $#Fld != 0) {
	           $commentcode{$no_comments++} = $_;
	    }
    }


#    if (/^input_buffer$|^input_buffers$/ .. /^end$/) {
#	    if ($Fld[1] ne 'input_buffer' && $Fld[1] ne 'input_buffers' && $Fld[1] ne 'end' && $#Fld != 0) {
#	          $inputbuffercode{$no_inputbuffers++} = $_;
#	    }
#    }


   if (/^input_buffer$|^input_buffers$/ .. /^end$/) {
       if ( /^end/) { $inBufdoit=1; } else {
      chop;
       @Fld= split(' ',$_, 9999);
        #Ignore the input_buffer, end, and blank lines
        if ($Fld[1] eq 'input_buffer' || $Fld[1] eq 'input_buffers') {
        #Set in_buffers to zero to indicate set by user
            $in_buffers = 0;
        }
        elsif ($Fld[1] eq 'end' || $#Fld == 0) {
            ;
        }
        else {
	    s/ += +/=/;
            #Remove an optional ";" at the end of the line
            @line1 = split(/;/, $_, 9999);
            $inBuffDelayType{$in_buffers}=$delayType;
            $inBuffDelayValue{$in_buffers}=$delayValue;

            #Check if line includes an equal sign
            $no_fields = (@line2 = split(/=/, $line1[1], 9999));

            #Look first for delay_max and delay_min lines
            if ($no_fields == 2) {
                @line3 = split(' ', $line2[1]);
#print "++++++++++++++++ FOUND DELAY MIN MAX:",$line3[0],":",$line2[0],":",$line2[1],"\n";
                
                if ($line3[1] eq 'delay_min' || $line3[1] eq 'delay_max') {
#print "++++++++++++++++ DELAY TYPE:",$line3[0],":Delay Value:",$line2[1],":","\n";
                    $delayType=$line3[1];
                    $delayValue=$line2[2];
               $inBuffDelayType{$in_buffers}=$delayType;
               $inBuffDelayValue{$in_buffers}=$delayValue;
                    $sysinit{$no_sysinit++} = "\t" . $line3[1] .

                      '(star_P->inBuffer_P[' . $in_buffers . '],' . $line2[2] .

                      ');';
                }
                else {
                        (print  "STARGAZE: error in input_buffer line:\n" .

                          $_);
                }
            }
            elsif ($no_fields == 1) {
                if ((@line3 = split(' ', $line2[1])) != 2) {
                        (print  "STARGAZE: error in input_buffer line:\n" .
 
                          $_);
                }

               $inBuffType{$in_buffers}=$line3[1];
               $inBuffName{$in_buffers}=$line3[2];
               $inBuffDelayType{$in_buffers}=$delayType;
               $inBuffDelayValue{$in_buffers}=$delayValue;
               $delayType="";
               $delayValue="";

                ++$in_buffers;

                #Generate define statements for buffer references
                #The following is the macro for accessing a buffer
                $define{$no_define++} = '#define ' . $line3[3] .

                  "(DELAY)  \t(*((" . $line3[1] . ' *)PIN(' . ($in_buffers -

                  1) . ',DELAY)))';
            }
        }
       }
        $_=" ";
    }


#-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+






#    if (/^output_buffer$|^output_buffers$/ .. /^end$/) {
#	    if ($Fld[1] ne 'output_buffer' && $Fld[1] ne 'output_buffers' && $Fld[1] ne 'end' && $#Fld != 0) {
#	           $outputbuffercode{$no_outputbuffers++} = $_;
#	    }
#    }


  if (/^output_buffers$|^output_buffer$/ .. /^end$/) {
       if ( /^end/) { $outBufdoit=1; } else {
      chop;
       @Fld= split(' ',$_, 9999);
        #Ignore the output_buffer, end, and blank lines
        if ($Fld[1] eq 'output_buffer' || $Fld[1] eq 'output_buffers') {
        #Set in_buffers to zero to indicate set by user
            $in_buffers = 0;
        }
        elsif ($Fld[1] eq 'end' || $#Fld == 0) {
            ;
        }
        else {
	    s/ +=+ /=/;
            #Remove an optional ";" at the end of the line
            @line1 = split(/;/, $_, 9999);
            $outBuffDelayType{$out_buffers}=$delayType;
            $outBuffDelayValue{$out_buffers}=$delayValue;

            #Check if line includes an equal sign
            $no_fields = (@line2 = split(/=/, $line1[1], 9999));

            #Look first for delay_max and delay_min lines
            if ($no_fields == 2) {
                @line3 = split(' ', $line2[1]);
                if ($line3[1] eq 'delay_min' || $line3[1] eq 'delay_max') {
                    $delayType=$line3[1];
                    $delayValue=$line2[2];
               $outBuffDelayType{$out_buffers}=$delayType;
               $outBuffDelayValue{$out_buffers}=$delayValue;
                    $sysinit{$no_sysinit++} = "\t" . $line3[1] .

                      '(star_P->inBuffer_P[' . $in_buffers . '],' . $line2[2] .

                      ');';
                }
                else {
                        (print  "STARGAZE: error in input_buffer line:\n" .

                          $_);
                }
            }
            elsif ($no_fields == 1) {
                if ((@line3 = split(' ', $line2[1])) != 2) {
                        (print  "STARGAZE: error in input_buffer line:\n" .

                          $_);
                }

               $outBuffType{$out_buffers}=$line3[1];
               $outBuffName{$out_buffers}=$line3[2];
               $outBuffDelayType{$out_buffers}=$delayType;
               $outBuffDelayValue{$out_buffers}=$delayValue;
               $delayType="";
               $delayValue="";


                ++$out_buffers;

                #Generate define statements for buffer references
                #The following is the macro for accessing a buffer
                $define{$no_define++} = '#define ' . $line3[3] .

                  "(DELAY)  \t(*((" . $line3[1] . ' *)PIN(' . ($in_buffers -

                  1) . ',DELAY)))';
            }
        }
       }

        $_=" ";
    }

#======================================





	
#Parameters

    if (/^parameters|^parameters/ .. /^end/) {
       if ( /^end/) { $paramdoit=1; $_="";} else {
      chop;
       @Fld= split(' ',$_, 9999);
	#Throw out the parameter and end lines and blank lines
	if ($Fld[1] eq 'parameters' || $Fld[1] eq 'parameters' ||

#	  $Fld[1] eq '</PARAMETERS>' || $#Fld == 0) {
	  $Fld[1] eq 'end' ) {
	    ;
	}

	#Otherwise the line specifies a parameter
	else {
	    s/ += +/=/;
	    #Remove an optional ";" at the end of the line
	    @line1 = split(/;/, $_, 9999);


	    #Split the line to determine if there is a default;
	    $eq_flag = 0;
	    if ((@line2 = split(/=/, $line1[1], 9999)) >= 2) {
		$eq_flag = 1;
	    }
	    $no_words = (@line3 = split(' ', $line2[1]));
	    if ($no_words == 1) {
		if ($eq_flag == 0) {
			(print  "STARGAZE: error in parameter line:\n" .

			  $_);
		    # parameter specification line
		    ;
		}
		if ($line3[1] eq 'param_def') {
		    if ((@line4 = split("\"", $line1[1], 9999)) != 3) {
			    (print 

			      "STARGAZE: missing quotes in parameter line:\n"

			      . $_);
		    }
		    $pdef{$no_param} = $line4[2];
		}
		elsif ($line3[1] eq 'param_min') {
		    $pmin{$no_param} = $line2[2];
		}
		elsif ($line3[1] eq 'param_max') {
		    $pmax{$no_param} = $line2[2];
		}
		else {
			(print 

			  "STARGAZE: unrecognized parameter option in parameter line:\n"

			  . $_);
		}
	    }
	    elsif ($no_words == 2) {
		$ptype{$no_param} = $line3[1];
		$pname{$no_param} = $line3[2];
		if ($line3[1] eq 'int') {
		    $define{$no_define++} = '#define ' . $line3[2] .

		      "   \t(param_P[" . $no_param . ']->value.d)';
		    if ($eq_flag == 1) {
			$pval{$no_param} = $line2[2];
		    }
		}
		elsif ($line3[1] eq 'float') {
		    $define{$no_define++} = '#define ' . $line3[2] .

		      "   \t(param_P[" . $no_param . ']->value.f)';
		    if ($eq_flag == 1) {
			$pval{$no_param} = $line2[2];
		    }
		}
		elsif ($line3[1] eq 'file' || $line3[1] eq 'function') {
		    $define{$no_define++} = '#define ' . $line3[2] .

		      "   \t(param_P[" . $no_param . ']->value.s)';
		    if ($eq_flag == 1) {
			if ((@line4 = split("\"", $line2[2], 9999)) != 3) {
				(print 

				  "STARGAZE: no quotes on string in parameter line:\n"

				  . $_);
			}
			else {
			    $pval{$no_param} = $line4[2];
			}
		    }
		}


		elsif ($line3[1] eq 'string' ) {
		    $define{$no_define++} = '#define ' . $line3[2] .

		      "   \t(param_P[" . $no_param . ']->value.s)';
		    if ($eq_flag == 1) {
			if ((@line4 = split("\"", $line2[2], 9999)) != 3) {
				(print 

				  "STARGAZE: no quotes on string in parameter line:\n"

				  . $_);
			}
			else {
			    $pval{$no_param} = $line4[2];
			}
		    }
		}

		elsif ($line3[2] eq 'array') {
		    if ($eq_flag == 1) {
			    (print  "STARGAZE: error in parameter line:\n"

			      . $_);
			    (print 

			      '(Default values not allowed for arrays)');
		    }
		    $define{$no_define++} = '#define ' . $line3[2] .

		      "   \t((float *)param_P[" . $no_param . ']->value.s)';

		    $define{$no_define++} = '#define n_' . $line3[2] .

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
  
#end of parameters


#States


    if (/^state$|^states$/ .. /^end$/) {
	    if ( /^end$/) { $statedoit=1; } else {
            chop;
            @Fld= split(' ',$_, 9999);
            #Ignore the states, end, and blank lines
            if ($Fld[1] eq 'state' || $Fld[1] eq 'states') {
                #Set numberStates to zero to indicate set by user
				$numberStates = 0;
            }
            elsif ($Fld[1] eq 'end' || $#Fld == 0) {
                      ;
            }
            elsif ($statedoit==0) {
               #Remove an optional ";" at the end of the line
	           s/ += +/=/;
			   
               @line1 = split(/;/, $_, 9999);
               $stateTypeArray{$numberStates}=$stateType;
               $stateValueArray{$numberStates}=$stateValue;
               $stateNameArray{$numberStates}=$stateName;
	          
	           @line4 = split(' ', $line1[1]);
	    
               #Check if line includes an equal sign
               $no_fields = (@line2 = split(/=/, $line4[2], 9999));

print "STATES-> \$_=",$_,"fields=",$no_fields," line1[1]=",$line1[1]," line4[1]=",$line4[1]," line4[2]=",$line4[2],"\n";

               if ($no_fields == 2) {
                    @line3 = split(' ', $line2[1]);
                
                    $stateType=$line4[1];
                    $stateName=$line2[1];
		            $stateValue=$line2[2];
					
print "EQUAL",$stateType,$stateName,$stateValue,"\n";
		    
					$stateTypeArray{$numberStates}=$stateType;
                    $stateNameArray{$numberStates}=$stateName;
                    $stateValueArray{$numberStates}=$stateValue;
	       
				}
                else  {
	                @line3 = split(' ', $line1[1]);
                    $stateType=$line3[1];
                    $stateName=$line3[2];
					
	    
					$stateTypeArray{$numberStates}=$stateType;
                    $stateNameArray{$numberStates}=$stateName	    
	    
                 }

 #              $stateTypeArray{$numberStates}=$line3[0];
 #              $stateValueArray{$numberStates}=$stateValue;
                 $stateType="";
                 $stateValue="";
	             $stateName="";

                 ++$numberStates;
			
	        } #end elsif  ($statedoit==0)
			
#	if ($Fld[1] ne 'states' && $Fld[1] ne 'state' && $Fld[1] ne 'end' && $#Fld != 0) {
#	    $statecode{$no_statelines++} = $_;
#	}

      }
       $_=" ";
    }   #end states


#SSSSSTTTTTTAAAATTTTTEEEES

 


    if (/^declaration$|^declarations$/ .. /^end$/) {
	    if ($Fld[1] ne 'declarations' && $Fld[1] ne 'declaration' &&
          	  $Fld[1] ne 'end' && $#Fld != 0) {

	           $declaration{$no_decl++} = $_;
	    }
    }

    if (/^initialization_code$/ .. /^end$/) {
	    if ($Fld[1] ne 'initialization_code' && $Fld[1] ne 'end' &&
	            $#Fld != 0) {
	         $initcode{$no_init++} = $_;
	    }
    }

    if (/^main_code$/ .. /^end$/) {
	    if ($Fld[1] ne 'main_code' && $Fld[1] ne 'end') {
	          $mcode{$no_main++} = $_;
	    }
    }
    if (/^wrapup_code$/ .. /^end$/) {
	    if ($Fld[1] ne 'wrapup_code' && $Fld[1] ne 'end' && $#Fld != 0) {
	         $wcode{$no_wrapup++} = $_;
	    }
    }

    #
    # Finally write the program
    #
	
	#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#    print (OUTFILE  $_);

}  #end while each line

#++++++++++++++++++++++++++
open (LICENSE,"lgpl.txt") || die "Could not open lgpl.txt\n";

print ( OUTFILE  "<BLOCK>");
    
    

   print (OUTFILE "<LICENSE>");
    
while (<LICENSE>) {
    chop;

  
    print ( OUTFILE $_);

} 

close LICENSE;   
    


    print ( OUTFILE "</LICENSE>");
   
    
    
    
    print ( OUTFILE "<BLOCK_NAME>");
    print ( OUTFILE $star_name);
    print ( OUTFILE '</BLOCK_NAME>',"\n");
    
#print comments  
   
	print ( OUTFILE "<COMMENTS>\n<![CDATA[","\n");
    for ($i = 0; $i < $no_comments; ++$i) {
   
	         print ( OUTFILE $commentcode{$i});
    }
    
	print ( OUTFILE "]]>\n</COMMENTS>","\n");


	if($no_include >0) {
#Print the include statements

	      print ( OUTFILE "<INCLUDES>\n<![CDATA[","\n");

          for ($i = 0; $i < $no_include; ++$i) {
	                print ( OUTFILE $include{$i});

                     #Print the user define statements
                    ;
           }

	        print ( OUTFILE "\n]]>\n</INCLUDES>","\n");
	}


	 if($no_user_define>0) {
	          print ( OUTFILE "<DEFINES>","\n");

              for ($i = 0; $i < $no_user_define; ++$i) {
   
	                 print ( OUTFILE $define{$i});

                     #Print the state structure
                     ;
              }
     
	          print ( OUTFILE "\n</DEFINES>","\n");
	 }

	
#   $statedoit=WriteXMLState(OUTFILE,$statedoit);
	
#if ($no_statelines > 0) {
#    &Pick('>', $out_file) &&
#	(print $fh '<STATES>',"\n");
#    for ($i = 0; $i < $no_statelines; ++$i) {
#	&Pick('>', $out_file) &&
#	    (print $fh  $statecode{$i} );
#    }
#    &Pick('>', $out_file) &&
#	(print $fh "</STATES>\n");
#}








#Print declarations
	print ( OUTFILE "<DECLARATIONS>","\n");
    for ($i = 0; $i < $no_decl; $i++) {
   
	         print ( OUTFILE $declaration{$i});
    }
	print ( OUTFILE "\n</DECLARATIONS>","\n");
	
	

$statedoit=WriteXMLState(OUTFILE,$statedoit);

#print parameters 
$paramdoit=WriteXMLParams(OUTFILE,$paramdoit);


 
#    &Pick('>', $out_file) &&
#	(print $fh "<PARAMETERS>","\n");
#for ($i = 0; $i < $no_parameterlines; ++$i) {
#    &Pick('>', $out_file) &&
#	(print $fh $parametercode{$i});
#}
#    &Pick('>', $out_file) &&
#	(print $fh "\n</PARAMETERS>","\n");


#print input buffers  
#if($no_inputbuffers>0) {
    
#	print ( OUTFILE "<INPUT_BUFFERS>","\n");
#    for ($i = 0; $i < $no_inputbuffers; ++$i) {
#   	           print  (OUTFILE $inputbuffercode{$i});
#    }
    
#	print ( OUTFILE "\n</INPUT_BUFFERS>","\n");
#}

$inBufdoit=WriteXMLInBuff(OUTFILE,$inBufdoit);


#print output buffers  
#if($no_outputbuffers >0) {
    
#	print ( OUTFILE "<OUTPUT_BUFFERS>","\n");
#    for ($i = 0; $i < $no_outputbuffers; ++$i) {
    
#	           print ( OUTFILE $outputbuffercode{$i});
#    }
    
#	print ( OUTFILE "\n</OUTPUT_BUFFERS>","\n");
#}

$outBufdoit=WriteXMLOutBuff(OUTFILE,$outBufdoit);
 

#print initialization code  
  
	print ( OUTFILE "<INIT_CODE>\n<![CDATA[","\n");
    for ($i = 0; $i < $no_init; ++$i) {
    
	        print ( OUTFILE $initcode{$i});
	
	
    }
    
	print ( OUTFILE "\n]]>\n<\/INIT_CODE>","\n");


#print main code  
   
	 print ( OUTFILE "\n<MAIN_CODE>\n<![CDATA[","\n");
     for ($i = 0; $i < $no_main; ++$i) {
    
	          print (  OUTFILE $mcode{$i});
     }
   
	print ( OUTFILE "\n]]>\n</MAIN_CODE>","\n");



#print wrapup code  
   
	print ( OUTFILE "<WRAPUP_CODE>\n<![CDATA[","\n");
    for ($i = 0; $i < $no_wrapup; ++$i) {
    
	        print ( OUTFILE $wcode{$i});
    }
     
	print ( OUTFILE "\n]]>\n<\/WRAPUP_CODE>","\n\n");
 

    
	print ( OUTFILE "\n</BLOCK>","\n");


#++++++++++++++++++++++++++

    close (theInputFile);
    close (OUTFILE);

	print "End of processing: $theStar.\n";

} # end each file

print "End of script.\nDone!\n"; 
exit;





sub WriteXMLParams {
local($fileParam,$doit) = @_;
#-----------------------
if($doit==1) {
   if ($no_param > 0) {
           print ( $fileParam "\n");
           print ( $fileParam "<PARAMETERS>");
       for ($i = 0; $i < $no_param; ++$i) {
              print ( $fileParam "\t<PARAM>");

               $_=$pdef{$i};
               if(/>/ || /</) {

                    print ( $fileParam "\t\t<DEF><![CDATA[",$pdef{$i},"]]></DEF>");
               } else {
         
                    print ( $fileParam "\t\t<DEF>",$pdef{$i},"</DEF>");
               }
               print ( $fileParam "\t\t<TYPE>",$ptype{$i},"</TYPE>");
               print ( $fileParam "\t\t<NAME>",$pname{$i},"</NAME>");
               print ( $fileParam "\t\t<VALUE>",$pval{$i},"</VALUE>");
           print ( $fileParam "\t</PARAM>");
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
           print ( $fileParam "\n");
           print ( $fileParam "<INPUT_BUFFERS>");
       for ($i = 0; $i < $in_buffers; ++$i) {
#print ( "+++++-----++++++Delay:",$inBuffDelayType{$i},":",$inBuffDelayValue{$i},":","\n");
              if( $inBuffType{$i} ne '') {
                   print ( $fileParam "\t<BUFFER>");
                   print ( $fileParam "\t\t<TYPE>",$inBuffType{$i},"</TYPE>");
                   print ( $fileParam "\t\t<NAME>",$inBuffName{$i},"</NAME>");
                   if( $inBuffDelayType{$i} ne '') {
                       if($inBuffDelayType{$i} eq 'delay_min') { $typeDelay="min"; } else {$typeDelay="max";}
                       print ( $fileParam "\t\t<DELAY>","<TYPE>",$typeDelay,"</TYPE>",
                            "<VALUE>",$inBuffDelayValue{$i},"</VALUE>","</DELAY>");
                      
                   }
                   print ( $fileParam "\t</BUFFER>");
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
           print ( $fileParam "\n");
           print ( $fileParam "<OUTPUT_BUFFERS>");
       for ($i = 0; $i < $out_buffers; ++$i) {
              if( $outBuffType{$i} ne "") {
                   print ( $fileParam "\t<BUFFER>");
                   print ( $fileParam "\t\t<TYPE>",$outBuffType{$i},"</TYPE>");
                   print ( $fileParam "\t\t<NAME>",$outBuffName{$i},"</NAME>");
                   if( $outBuffDelayType{$i} ne '') {
                       if($outBuffDelayType{$i} eq 'delay_min') { $typeDelay="min"; } else {$typeDelay="max";}
                       print ( $fileParam "\t\t<DELAY>","<TYPE>",$typeDelay,"</TYPE>",
                            "<VALUE>",$outBuffDelayValue{$i},"</VALUE>","</DELAY>");
                      
                   }
                   print ( $fileParam "\t</BUFFER>");
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
           print ( $fileParam "<STATES>");
       for ($i = 0; $i < $numberStates; ++$i) {
              if( $stateTypeArray{$i} ne "") {
              
                   print ( $fileParam "\t<STATE>");
                   print ( $fileParam "\t\t<TYPE>",$stateTypeArray{$i},"</TYPE>");
                   print ( $fileParam "\t\t<NAME>",$stateNameArray{$i},"</NAME>");
               if( $stateValueArray{$i} ne "") {		   
                   print ( $fileParam "\t\t<VALUE>",$stateValueArray{$i},"</VALUE>");
                }
                   print ( $fileParam "\t</STATE>");
              }
       }
       print ( $fileParam "</STATES>\n");
       $done=0;
   }
}
return(0);
#-----------------------

}




