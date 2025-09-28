
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
# Generate block from specs using templates
#

  open(BLOCK_SPEC, "blockgen.dat") || die "Could not open blockgen.dat!\n";

  $blockParams=0;
  while (<BLOCK_SPEC>) {
    print ;
    #get block name

    if(m/block=/) {
      print "Found block name\n";
      @blockName= split("=");
      $block=$blockName[1];
      print "BLOCK_NAME=",$block,"\n";
    }
    if(m/type=/) {
      print "Found type \n";
      @type1= split("=");
      $type=$type1[1];
      print "TYPE=",$type,"\n";
    }
    if(m/buffer=/) {
      print "Found buffer\n";
      @buff1= split("=");
      $buffer=$buff1[1];
      print "BUFFER=",$buffer,"\n";
    }
    if(m/parameters/) {

       $blocktParams=1;
       $paramCount=readline BLOCK_SPEC;
       print "param count=",$paramCount;

       for($i=0; $i<$paramCount; $i++) {
          $param=readline (BLOCK_SPEC);
          chop($param);
          print "PARAM=",$param;
          @params=split(";",$param);

          push @paramTypes, ($params[0]);
          push @paramNames, ($params[1]);
          push @paramValues, ($params[2]);
          push @paramPrompts, ($params[3]);



       }



    }
   }  # done reading and processing of block specs

   print "\ntype=",$type," buffer=",$buffer,"\n";

   #
   # generate the template file name
   # based on the type and buffer
   #
   $template ="";
   chop($buffer);
   chop($type);

   if($buffer eq "float") {

       $template = "float_";


   } elsif ($buffer eq "int") {

       $template = "int_";

   } elsif ($buffer eq "complex") {

       print "COMPLEX DETERMINED\n";

       $template = "complex_";

   } elsif ($buffer eq "image") {

       $template = "img_";

   } elsif ($buffer eq "fx") {

       $template = "fx_";

   };

   print "TEMPLATE FIRST STAGE=",$template, "\n";

   if($type eq "source") {

       $template = $template."source.tpl";


   } elsif ($type eq "processor") {
       $template = $template."processor.tpl";


   } elsif ($type eq "term") {

       $template = $template."terminator.tpl";

   } elsif ($type eq "probe") {

       $template = $template."probe.tpl";

   };





   foreach $prompt (@paramPrompts) {
      print "EXTRACTED PROMPTS=", $prompt, "\n";

   }

   foreach $value (@paramValues) {
      print "EXTRACTED VALUES=", $value, "\n";

   }

   #$templateFile = "C:\\capsim\\files\\TEMPLATES\\";
   $templateFile = $ENV{'CAPSIM'}."/TOOLS/BLOCK_TEMPLATES/";
   $templateFile = $templateFile.$template;

   print  "TEMPLATE file name=",$templateFile,"\n";

   open(TEMPLATE,$templateFile) || die "could not open template\n";

   chop($block);

   $blockFile=">".$block.".s";

   open(BLOCK,$blockFile) || die "could not open block file for write\n";

   
   while (<TEMPLATE>) {
  print $_; 
          s/BLOCK_NAME_REPLACE/$block/g;
      if(m/<PARAMETERS>/) {
      print BLOCK  "<PARAMETERS>","\n" ;
           for($i=0; $i <$paramCount; $i++) {
	       print BLOCK "        <PARAM>\n";
               print BLOCK "               ","<DEF> ",$paramPrompts[$i]," </DEF>","\n";
               print BLOCK "               ","<TYPE> ", $paramTypes[$i]," </TYPE>","\n";
	       print BLOCK "               ","<NAME> ", $paramNames[$i]," </NAME>","\n";
	       print BLOCK "               ","<VALUE> ", $paramValues[$i]," </VALUE>","\n";
	       print BLOCK "        </PARAM>\n";
           }
      } else { 
           print BLOCK;
      }
   
   }  
   



    
