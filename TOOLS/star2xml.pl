#!/usr/bin/perl
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

eval "exec /usr/bin/perl -S $0 $*"
    if $running_under_some_shell;
			# this emulates #! processing on NIH machines.
			# (remove #! line above if indigestible)

eval '$'.$1.'$2;' while $argv2[0] =~ /^([A-Za-z_]+=)(.*)/ && shift;
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
$no_dsd=0;


#Set no_buffers negative so we can recognize if set
$in_buffers = -1;
$out_buffers = -1;

#Star return codes will start at 200
$return_code = 200;

print 'Input File Name=' . $argv2;
#Check for .s suffix, strip; create starname, output file name
$n = (@array = split(/\./, $argv2, 9999));
if ($array[$n] ne 's') {
    &Pick('>', 'sg.error') &&
	(print $fh "Star2XML: file name must end with \".s\"");
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

open(theInputFile,$theStar);

line: while (<theInputFile>) {
#	print $_;
#
# convert old style lower case MACROs to new style all caps
#

     s/min_avail\(/MIN_AVAIL\(/;
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
     s/no_input_buffers/NO_INPUT_BUFFERS/g;
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


    if (/^input_buffer$|^input_buffers$/ .. /^end$/) {
	if ($Fld[1] ne 'input_buffer' && $Fld[1] ne 'input_buffers' && $Fld[1] ne 'end' && $#Fld != 0) {
	    $inputbuffercode{$no_inputbuffers++} = $_;
	}
    }
    if (/^output_buffer$|^output_buffers$/ .. /^end$/) {
	if ($Fld[1] ne 'output_buffer' && $Fld[1] ne 'output_buffers' && $Fld[1] ne 'end' && $#Fld != 0) {
	    $outputbuffercode{$no_outputbuffers++} = $_;
	}
    }

    if (/^parameter$|^parameters$/ .. /^end$/) {
	#Throw out the parameter and end lines and blank lines
	if ($Fld[1] ne 'parameter' && $Fld[1] ne 'parameters' && $Fld[1] ne 'end' && $#Fld != 0) {
	    $parametercode{$no_parameterlines++} = $_;
	}
    }

    if (/^state$|^states$/ .. /^end$/) {
	if ($Fld[1] ne 'states' && $Fld[1] ne 'state' && $Fld[1] ne 'end' && $#Fld != 0) {
	    $statecode{$no_statelines++} = $_;
	}
    }

# dsd support
    if (/^dynamic_shared_data$|^dsd$/ .. /^end$/) {
	if ($Fld[1] ne 'states' && $Fld[1] ne 'state' && $Fld[1] ne 'end' && $#Fld != 0) {
	    $dynamic_shared_data{$no_dsdlines++} = $_;
	}
    }


#end dsd



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
}

open (LICENSE,"lgpl.txt") || die "Could not open lgpl.txt\n";

&Pick('>', $out_file) &&
    (print $fh "<STAR>");
    
    
&Pick('>', $out_file) &&
    (print $fh "<LICENSE>");
    
while (<LICENSE>) {
    chop;

    &Pick('>', $out_file) &&
    (print $fh $_);

} 

close LICENSE;   
    

&Pick('>', $out_file) &&
    (print $fh "</LICENSE>");
   
    
    
    
    (print $fh "<STAR_NAME>\n");
&Pick('>', $out_file) &&
    (print $fh $star_name,"\n");
&Pick('>', $out_file) &&
    (print $fh '</STAR_NAME>',"\n");
    
#print comments  
    &Pick('>', $out_file) &&
	(print $fh "<COMMENTS>","\n");
for ($i = 0; $i < $no_comments; ++$i) {
    &Pick('>', $out_file) &&
	(print $fh $commentcode{$i});
}
    &Pick('>', $out_file) &&
	(print $fh "\n</COMMENTS>","\n");


if($no_include >0) {
#Print the include statements
&Pick('>', $out_file) &&
	(print $fh "<INCLUDES>","\n");

for ($i = 0; $i < $no_include; ++$i) {
    &Pick('>', $out_file) &&
	(print $fh $include{$i});

    #Print the user define statements
    ;
}
&Pick('>', $out_file) &&
	(print $fh "\n</INCLUDES>","\n");
}


if($no_user_define>0) {
&Pick('>', $out_file) &&
	(print $fh "<DEFINES>","\n");

for ($i = 0; $i < $no_user_define; ++$i) {
    &Pick('>', $out_file) &&
	(print $fh $define{$i});

    #Print the state structure
    ;
}
    &Pick('>', $out_file) &&
	(print $fh "\n</DEFINES>","\n");
}

	
	
if ($no_statelines > 0) {
    &Pick('>', $out_file) &&
	(print $fh '<STATES>',"\n");
    for ($i = 0; $i < $no_statelines; ++$i) {
	&Pick('>', $out_file) &&
	    (print $fh  $statecode{$i} );
    }
    &Pick('>', $out_file) &&
	(print $fh "</STATES>\n");
}

 

if ($no_dsd > 0) {
    &Pick('>', $out_file) &&
	(print $fh '<DSD>\n');
    for ($i = 0; $i < $no_dsd; ++$i) {
	&Pick('>', $out_file) &&
	    (print $fh $dsd{$i},"\n" );
    }
    &Pick('>', $out_file) &&
	(print $fh "</DSD>","\n");
}








#Print declarations
&Pick('>', $out_file) &&
	(print $fh "<DECLARATIONS>","\n");
for ($i = 0; $i < $no_decl; $i++) {
    &Pick('>', $out_file) &&
	(print $fh $declaration{$i});
}
    &Pick('>', $out_file) &&
	(print $fh "\n</DECLARATIONS>","\n");



#print parameters  
    &Pick('>', $out_file) &&
	(print $fh "<PARAMETERS>","\n");
for ($i = 0; $i < $no_parameterlines; ++$i) {
    &Pick('>', $out_file) &&
	(print $fh $parametercode{$i});
}
    &Pick('>', $out_file) &&
	(print $fh "\n</PARAMETERS>","\n");


#print input buffers  
if($no_inputbuffers>0) {
    &Pick('>', $out_file) &&
	(print $fh "<INPUT_BUFFERS>","\n");
for ($i = 0; $i < $no_inputbuffers; ++$i) {
    &Pick('>', $out_file) &&
	(print $fh $inputbuffercode{$i});
}
    &Pick('>', $out_file) &&
	(print $fh "\n</INPUT_BUFFERS>","\n");
}

#print output buffers  
if($no_outputbuffers >0) {
    &Pick('>', $out_file) &&
	(print $fh "<OUTPUT_BUFFERS>","\n");
for ($i = 0; $i < $no_outputbuffers; ++$i) {
    &Pick('>', $out_file) &&
	(print $fh $outputbuffercode{$i});
}
    &Pick('>', $out_file) &&
	(print $fh "\n</OUTPUT_BUFFERS>","\n");
} 

#print initialization code  
    &Pick('>', $out_file) &&
	(print $fh "<INIT_CODE>","\n");
for ($i = 0; $i < $no_init; ++$i) {
    &Pick('>', $out_file) &&
	(print $fh $initcode{$i});
	
	
}
    &Pick('>', $out_file) &&
	(print $fh "\n</INIT_CODE>","\n");


#print main code  
    &Pick('>', $out_file) &&
	(print $fh "\n<MAIN_CODE>","\n");
for ($i = 0; $i < $no_main; ++$i) {
    &Pick('>', $out_file) &&
	(print $fh $mcode{$i});
}
    &Pick('>', $out_file) &&
	(print $fh "\n</MAIN_CODE>","\n");



#print wrapup code  
    &Pick('>', $out_file) &&
	(print $fh "<WRAPUP_CODE>","\n");
for ($i = 0; $i < $no_wrapup; ++$i) {
    &Pick('>', $out_file) &&
	(print $fh $wcode{$i});
}
    &Pick('>', $out_file) &&
	(print $fh "\n</WRAPUP_CODE>","\n\n");
 

    &Pick('>', $out_file) &&
	(print $fh "\n</STAR>","\n");

}

sub Pick {
    local($mode,$name,$pipe) = @_;
    $fh = $name;
    open($name,$mode.$name.$pipe) unless $opened{$name}++;
}

