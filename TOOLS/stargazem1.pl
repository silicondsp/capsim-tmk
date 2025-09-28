#!/usr/bin/perl
#
# Copyright (C) 1989 XCAD Corporation
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

# STARGAZE/awk.stargaze
#****************************************************************
#
#			STARGAZE
#
#****************************************************************
#
# This is an awk program which implements the STARGAZE
# preprocessor for user STAR functions in BLOSIM
#
# Programmer: D.G.Messerschmitt
# Date: September 30, 1982
# Modified for V2.0 of BLOSIM: Jan. 10, 1985
#
# Mod 11/13/86 ljfaber: several format mods for '.c' output 
# Mod 11/14/86 ljfaber: allow arrays and labeled structures in
#	state variables; make user 'define' statements print early
#	so they can be used in states, etc.
# Mod 11/87 ljfaber: debug for arrays in parameter variables; also,
#	automatically declare variable (int) 'n_name' initialized
#	to size of array 'name'.
# Mod 4/88 ljfaber: add include for math.h
# Mod 7/88 ljfaber: add error message printing in system initialization,
#	rather than just error returns.
# Mod 3/89 ljfaber: implement new parameter system, with parameter
#	definition string inside star code; simplify star call.
# Mod 3/89 ljfaber: new filename split method, for UNIX or VMS.
# Mod 4/89 ljfaber: improve buffer error message.
# Modified Sasan Ardalan Bug fixes and conversion to PERL using awk to Perl tool
# Modified Sasan Ardalan multiple files, also strips .s from file name usefull for Makefiles
#
$[ = 1;			# set array base to 1
$, = ' ';		# set output field separator
$\ = "\n";		# set output record separator

#
#Set operating system here, either UNIX or VMS or MACOS
$op_sys = 'MACOS';

$no_state = 0;
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
	(print $fh "STARGAZE: file name must end with \".s\"");
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
$out_file = $star_name . '.c';
$theStar =  $star_name . '.s';
print 'Input File Name:' . $theStar;
print 'Output File Name:' . $out_file;

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
	#Ignore the input_buffer, end, and blank lines
	if ($Fld[1] eq 'input_buffers' || $Fld[1] eq 'input_buffer') {
	#Set in_buffers to zero to indicate set by user
	    $in_buffers = 0;
	}
	elsif ($Fld[1] eq 'end' || $#Fld == 0) {
	    ;
	}
	else {
	    #Remove an optional ";" at the end of the line
	    @line1 = split(/;/, $_, 9999);

	    #Check if line includes an equal sign
	    $no_fields = (@line2 = split(/=/, $line1[1], 9999));

	    #Look first for delay_max and delay_min lines
	    if ($no_fields == 2) {
		@line3 = split(' ', $line2[1]);
		if ($line3[1] eq 'delay_min' || $line3[1] eq 'delay_max') {
		    $sysinit{$no_sysinit++} = "\t" . $line3[1] .

		      '(star_P->inBuffer_P[' . $in_buffers . '],' . $line2[2] .

		      ');';
		}
		else {
		    &Pick('>', 'sg.error') &&
			(print $fh "STARGAZE: error in input_buffer line:\n" .

			  $_);
		}
	    }
	    elsif ($no_fields == 1) {
		if ((@line3 = split(' ', $line2[1])) != 2) {
		    &Pick('>', 'sg.error') &&
			(print $fh "STARGAZE: error in input_buffer line:\n" .

			  $_);
		}
		++$in_buffers;

		#Generate define statements for buffer references
		#The following is the macro for accessing a buffer
		$define{$no_define++} = '#define ' . $line3[2] .

		  "(DELAY)  \t(*((" . $line3[1] . ' *)PIN(' . ($in_buffers -

		  1) . ',DELAY)))';
	    }
	}
    }

    if (/^output_buffer$|^output_buffers$/ .. /^end$/) {
	#Ignore the output_buffer, end, and blank lines
	if ($Fld[1] eq 'output_buffers' || $Fld[1] eq 'output_buffer') {
	#Set out_buffers to zero to indicate set to 'no buffers'
	    $out_buffers = 0;
	}
	elsif ($Fld[1] eq 'end' || $#Fld == 0) {
	    ;
	}
	else {
	    #Remove an optional ";" at the end of the line
	    @line1 = split(/;/, $_, 9999);

	    #Check if line includes an equal sign
	    $no_fields = (@line2 = split(/=/, $line1[1], 9999));

	    #First check for delay_max line
	    if ($no_fields == 2) {
		@line3 = split(' ', $line2[1]);
		if ($line3[1] eq 'delay_max') {
		    $sysinit{$no_sysinit++} =

		      "\tdelay_max(star_P->outBuffer_P[" . $out_buffers . '],'

		      . $line2[2] . ');';
		}
		else {
		    &Pick('>', 'sg.error') &&
			(print $fh "STARGAZE: error on output_buffer line:\n"

			  . $_);
		}
	    }
	    elsif ($no_fields == 1) {
		#Split the line into fields with standard delimiter
		if ((@line3 = split(' ', $line2[1])) != 2) {
		    &Pick('>', 'sg.error') &&
			(print $fh "STARGAZE: error on output_buffer line:\n"

			  . $_);
		}
		++$out_buffers;

		#Generate define statements for buffer references
		#The following is the macro for accessing a buffer
		$define{$no_define++} = '#define ' . $line3[2] . '(delay) *('

		  . $line3[1] . ' *)POUT(' . ($out_buffers - 1) . ',delay)';
	    }
	}
    }

    if (/^parameter$|^parameters$/ .. /^end$/) {
	#Throw out the parameter and end lines and blank lines
	if ($Fld[1] eq 'parameter' || $Fld[1] eq 'parameters' ||

	  $Fld[1] eq 'end' || $#Fld == 0) {
	    ;
	}

	#Otherwise the line specifies a parameter
	else {
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
		    &Pick('>', 'sg.error') &&
			(print $fh "STARGAZE: error in parameter line:\n" .

			  $_);
		    # parameter specification line
		    ;
		}
		if ($line3[1] eq 'param_def') {
		    if ((@line4 = split("\"", $line1[1], 9999)) != 3) {
			&Pick('>', 'sg.error') &&
			    (print $fh

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
		    &Pick('>', 'sg.error') &&
			(print $fh

			  "STARGAZE: unrecognized parameter option in parameter line:\n"

			  . $_);
		}
	    }
	    elsif ($no_words == 2) {
		$ptype{$no_param} = $line3[1];
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
			    &Pick('>', 'sg.error') &&
				(print $fh

				  "STARGAZE: no quotes on string in parameter line:\n"

				  . $_);
			}
			else {
			    $pval{$no_param} = $line4[2];
			}
		    }
		}
		elsif ($line3[1] eq 'array') {
		    if ($eq_flag == 1) {
			&Pick('>', 'sg.error') &&
			    (print $fh "STARGAZE: error in parameter line:\n"

			      . $_);
			&Pick('>', 'sg.error') &&
			    (print $fh

			      '(Default values not allowed for arrays)');
		    }
		    $define{$no_define++} = '#define ' . $line3[2] .

		      "   \t((float *)param_P[" . $no_param . ']->value.s)';

		    $define{$no_define++} = '#define n_' . $line3[2] .

		      "   \t(param_P[" . $no_param . ']->array_size)';
		}
		else {
		    &Pick('>', 'sg.error') &&
			(print $fh "STARGAZE: parameter type unknown, line:\n"

			  . $_);
		}
		$no_param++;
	    }
	    else {
		&Pick('>', 'sg.error') &&
		    (print $fh "STARGAZE: error in parameter line:\n" . $_);
	    }
	}
    }

    if (/^state$|^states$/ .. /^end$/) {
	#Throw out the state and end line and blank lines
	if ($Fld[1] eq 'states' || $Fld[1] eq 'state' || $Fld[1] eq 'end' ||

	  $#Fld == 0) {
	    ;
	}
	else {
	    #Remove an optional ";" at the end of the line
	    @line1 = split(/;/, $_, 9999);

	    #Determine if state variable is initialized
	    # by looking for a "=" in the line
	    if ((@line2 = split(/=/, $line1[1], 9999)) == 2) {
		$initialize = 1;
	    }
	    else {
		$initialize = 0;

		#Split the first part of the line using blank separator
		;
	    }
	    if ((@line3 = split(' ', $line2[1])) != 2) {
		# allow labeled structures
		if ($line3[1] eq 'struct') {
		    $line3[1] = $line3[1] . ' ' . $line3[2];
		    $line3[2] = $line3[3];
		}
		else {
		    &Pick('>', 'sg.error') &&
			(print $fh "STARGAZE: error in state line:\n" . $_);
		}
	    }

	    #Generate initialization code
	    if ($initialize == 0) {
		$sv_init{$no_state} = '';
	    }
	    else {
		$sv_init{$no_state} = $line3[2] . ' =' . $line2[2];

		#To avoid macro recursion, generate a new name for the
		#state variable in the structure by prefixing "__"
		#to the original name
		;
	    }
	    $new = '__' . $line3[2];

	    #Generate code to go in state structure
	    $state{$no_state++} = $line3[1] . ' ' . $new;

	    # detect state variable arrays (ljf)
	    if ((@line4 = split(/\[/, $line3[2], 9999)) == 2) {
		$line3[2] = $line4[1];
		$new = '__' . $line3[2];
	    }
	    #Generate define statement
	    $define{$no_define++} = '#define ' . $line3[2] . "   \t(state_P->"

	      . $new . ')';
	}
    }

# dsd support
    if (/^dynamic_shared_data$|^dsd$/ .. /^end$/) {
	#Throw out the dsd and end line and blank lines
	if ($Fld[1] eq 'dynamic_shared_data' || $Fld[1] eq 'dsd' || $Fld[1] eq 'end' ||

	  $#Fld == 0) {
	    ;
	}
	else {
	    #Remove an optional ";" at the end of the line
	    @line1 = split(/;/, $_, 9999);

	    #Determine if dsd variable is initialized
	    # by looking for a "=" in the line
	    if ((@line2 = split(/=/, $line1[1], 9999)) == 2) {
		$initialize = 1;
	    }
	    else {
		$initialize = 0;

		#Split the first part of the line using blank separator
		;
	    }
	    if ((@line3 = split(' ', $line2[1])) != 2) {
		# allow labeled structures
		if ($line3[1] eq 'struct') {
		    $line3[1] = $line3[1] . ' ' . $line3[2];
		    $line3[2] = $line3[3];
		}
		else {
		    &Pick('>', 'sg.error') &&
			(print $fh "STARGAZE: error in dsd line:\n" . $_);
		}
	    }

	    #Generate initialization code
	    if ($initialize == 0) {
		$dsdv_init{$no_dsd} = '';
	    }
	    else {
		$dsdv_init{$no_dsd} = $line3[2] . ' =' . $line2[2];

		#To avoid macro recursion, generate a new name for the
		#dsd variable in the structure by prefixing "__"
		#to the original name
		;
	    }
	    $new = '__' . $line3[2];

	    #Generate code to go in state structure
	    $dsd{$no_dsd++} = $line3[1] . ' ' . $new;

	    # detect dsd variable arrays (ljf)
	    if ((@line4 = split(/\[/, $line3[2], 9999)) == 2) {
		$line3[2] = $line4[1];
		$new = '__' . $line3[2];
	    }
	    #Generate define statement
# FIX	    $define{$no_define++} = '#define ' . $line3[2] . "   \t(dsd_P->"
# FIX
# FIX	      . $new . ')';
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

&Pick('>', $out_file) &&
    (print $fh "/***************************************************\n");
&Pick('>', $out_file) &&
    (print $fh "\t\t\t" . $star_name . "()\n");
&Pick('>', $out_file) &&
    (print $fh '****************************************************');
&Pick('>', $out_file) &&
    (print $fh "This program was generated by STARGAZE\n*/\n");

#Print the include statements
&Pick('>', $out_file) &&
    (print $fh '#include <stdio.h>');
&Pick('>', $out_file) &&
    (print $fh '#include <math.h>');

&Pick('>', $out_file) &&
    (print $fh "\n/* Note: these paths are installation dependent! */");
&Pick('>', $out_file) &&
    (print $fh "#include \"/usr/local/CAPSIM/include/capsim.h\"");
&Pick('>', $out_file) &&
    (print $fh "#include \"/usr/local/CAPSIM/include/stars.h\"");
&Pick('>', $out_file) &&
    (print $fh '');

for ($i = 0; $i < $no_include; ++$i) {
    &Pick('>', $out_file) &&
	(print $fh $include{$i});

    #Print the user define statements
    ;
}
for ($i = 0; $i < $no_user_define; ++$i) {
    &Pick('>', $out_file) &&
	(print $fh $define{$i});

    #Print the state structure
    ;
}
if ($no_state > 0) {
    &Pick('>', $out_file) &&
	(print $fh 'typedef struct {');
    for ($i = 0; $i < $no_state; ++$i) {
	&Pick('>', $out_file) &&
	    (print $fh "\t" . $state{$i} . ';');
    }
    &Pick('>', $out_file) &&
	(print $fh "\t} state_t,*state_Pt;");
}

if ($no_dsd > 0) {
    &Pick('>', $out_file) &&
	(print $fh 'typedef struct {');
    for ($i = 0; $i < $no_dsd; ++$i) {
	&Pick('>', $out_file) &&
	    (print $fh "\t" . $dsd{$i} . ';');
    }
    &Pick('>', $out_file) &&
	(print $fh "\t} dsd_t,*dsd_Pt;");
}



#Print the define statements
for ($i = $no_user_define; $i < $no_define; ++$i) {
    &Pick('>', $out_file) &&
	(print $fh $define{$i});

    #Print the program header statements
    ;
}
#print comments  
for ($i = 0; $i < $no_comments; ++$i) {
    &Pick('>', $out_file) &&
	(print $fh $commentcode{$i});
}


&Pick('>', $out_file) &&
    (print $fh '');
&Pick('>', $out_file) &&
    (print $fh $star_name . '(run_state,block_P)');
&Pick('>', $out_file) &&
    (print $fh "\tint run_state;");
&Pick('>', $out_file) &&
    (print $fh "\tblock_Pt block_P;");
&Pick('>', $out_file) &&
    (print $fh '{');
&Pick('>', $out_file) &&
    (print $fh "\tparam_Pt *param_P = block_P->param_AP;");
&Pick('>', $out_file) &&
    (print $fh "\tstar_Pt star_P = block_P->star_P;");
if ($no_state > 0) {
    &Pick('>', $out_file) &&
	(print $fh "\tstate_Pt state_P = (state_Pt)star_P->state_P;");

    #Print declarations
    ;
}
for ($i = 0; $i < $no_decl; $i++) {
    &Pick('>', $out_file) &&
	(print $fh $declaration{$i});
}

if ($no_dsd > 0) {
    #Print dsd variable allocation

    &Pick('>', $out_file) &&
	(print $fh "\tdsd_Pt  dsd_P; ");

    &Pick('>', $out_file) &&
	(print $fh "\tif(block_P->dsdBlock_P) dsd_P = (dsd_Pt)block_P->dsdBlock_P->dsd_P;");

    #Print state variable initialization
    for ($i = 0; $i < $no_dsd; ++$i) {
	if ($dsdv_init{$i} ne '') {
	    &Pick('>', $out_file) &&
		(print $fh "\t" . $dsdv_init{$i} . ';');
	}
    }
}




&Pick('>', $out_file) &&
    (print $fh '');

&Pick('>', $out_file) &&
    (print $fh "switch (run_state) {\n");

if ($no_dsd > 0) {
&Pick('>', $out_file) &&
    (print $fh '/********* DSD INITIALIZATION CODE ************/');
&Pick('>', $out_file) &&
    (print $fh 'case DSD_INIT:');
&Pick('>', $out_file) &&
    (print $fh "\nreturn(sizeof(dsd_t));");

}
&Pick('>', $out_file) &&
    (print $fh "\nbreak;");



&Pick('>', $out_file) &&
    (print $fh '/********* PARAMETER INITIALIZATION CODE ************/');
&Pick('>', $out_file) &&
    (print $fh 'case PARAM_INIT:');
if ($no_param == 0) {
    &Pick('>', $out_file) &&
	(print $fh "\n\t{");
    &Pick('>', $out_file) &&
	(print $fh "\tint index = block_P->model_index;");
    &Pick('>', $out_file) &&
	(print $fh '');
    &Pick('>', $out_file) &&
	(print $fh "\tKrnModelParam(index,-1,\"\",\"\",\"\");");
    &Pick('>', $out_file) &&
	(print $fh "\t}");
}
if ($no_param > 0) {
    &Pick('>', $out_file) &&
	(print $fh "\n\t{");
    &Pick('>', $out_file) &&
	(print $fh "\tint index = block_P->model_index;");
    for ($i = 0; $i < $no_param; ++$i) {
	&Pick('>', $out_file) &&
	    (print $fh "\tchar *pdef" . $i . " = \"" . $pdef{$i} . "\";");
	&Pick('>', $out_file) &&
	    (print $fh "\tchar *ptype" . $i . " = \"" . $ptype{$i} . "\";");
	&Pick('>', $out_file) &&
	    (print $fh "\tchar *pval" . $i . " = \"" . $pval{$i} . "\";");
    }
    &Pick('>', $out_file) &&
	(print $fh '');
    for ($i = 0; $i < $no_param; ++$i) {
	&Pick('>', $out_file) &&
	    (print $fh "\tKrnModelParam(index," . $i . ',pdef' . $i . ',ptype' .

	      $i . ',pval' . $i . ');');
    }
    &Pick('>', $out_file) &&
	(print $fh "\t}");
}
&Pick('>', $out_file) &&
    (print $fh "\nbreak;");

&Pick('>', $out_file) &&
    (print $fh '/*********** SYSTEM INITIALIZATION CODE *************/');
&Pick('>', $out_file) &&
    (print $fh 'case SYSTEM_INIT:');

if ($no_state > 0) {
    #Print state variable allocation
    &Pick('>', $out_file) &&
	(print $fh

	  "\tstar_P->state_P = (char*)calloc(1,sizeof(state_t));");
    &Pick('>', $out_file) &&
	(print $fh "\tstate_P = (state_Pt)star_P->state_P;");

    #Print state variable initialization
    for ($i = 0; $i < $no_state; ++$i) {
	if ($sv_init{$i} ne '') {
	    &Pick('>', $out_file) &&
		(print $fh "\t" . $sv_init{$i} . ';');
	}
    }
}






#Print number of buffer checks
if ($in_buffers >= 0) {
    &Pick('>', $out_file) &&
	(print $fh "\tif(NO_INPUT_BUFFERS() != " . $in_buffers . ') {');
    &Pick('>', $out_file) &&
	(print $fh "\t\tfprintf(stdout,\n\t\t\t\"" . $star_name . ': ' .

	  $in_buffers .

	  " inputs expected; %d connected\\n\",\n\t\t\t\tNO_INPUT_BUFFERS()); ");
    &Pick('>', $out_file) &&
	(print $fh "\t\treturn(" . $return_code . ");\n\t}");
    ++$return_code;
}
if ($out_buffers >= 0) {
    &Pick('>', $out_file) &&
	(print $fh "\tif(NO_OUTPUT_BUFFERS() != " . $out_buffers . ') {');
    &Pick('>', $out_file) &&
	(print $fh "\t\tfprintf(stdout,\n\t\t\t\"" . $star_name . ': ' .

	  $out_buffers .

	  " outputs expected; %d connected\\n\",\n\t\t\t\tNO_OUTPUT_BUFFERS()); ");
    &Pick('>', $out_file) &&
	(print $fh "\t\treturn(" . $return_code . ");\n\t}");
    ++$return_code;
}

&Pick('>', $out_file) &&
    (print $fh "\nbreak;");

&Pick('>', $out_file) &&
    (print $fh '/************ USER INITIALIZATION CODE **************/');
&Pick('>', $out_file) &&
    (print $fh 'case USER_INIT:');
for ($i = 0; $i < $no_init; ++$i) {
    &Pick('>', $out_file) &&
	(print $fh $initcode{$i});
    #Print delay initializations
    ;
}
for ($i = 0; $i < $no_sysinit; $i++) {
    &Pick('>', $out_file) &&
	(print $fh $sysinit{$i});
}
&Pick('>', $out_file) &&
    (print $fh "\nbreak;");

&Pick('>', $out_file) &&
    (print $fh '/******************** MAIN CODE *********************/');
&Pick('>', $out_file) &&
    (print $fh 'case MAIN_CODE:');
for ($i = 0; $i < $no_main; ++$i) {
    &Pick('>', $out_file) &&
	(print $fh $mcode{$i});
}
&Pick('>', $out_file) &&
    (print $fh "\nbreak;");

&Pick('>', $out_file) &&
    (print $fh '/******************* WRAPUP CODE ********************/');
&Pick('>', $out_file) &&
    (print $fh 'case WRAPUP:');
for ($i = 0; $i < $no_wrapup; ++$i) {
    &Pick('>', $out_file) &&
	(print $fh $wcode{$i});
}
&Pick('>', $out_file) &&
    (print $fh "\nbreak;");

#Print remaining braces
&Pick('>', $out_file) &&
    (print $fh "\n}\nreturn(0);\n}");

#&MacPerl'SetFileInfo("ttxt","TEXT",$out_file); 

#exit $ExitValue;
}
sub Pick {
    local($mode,$name,$pipe) = @_;
    $fh = $name;
    open($name,$mode.$name.$pipe) unless $opened{$name}++;
}

