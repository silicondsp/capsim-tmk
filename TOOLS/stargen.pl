
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
# Generate star from specs using templates
#

  open(STAR_SPEC, "stargen.dat") || die "Could not open stargen.dat!\n";

  $starParams=0;
  while (<STAR_SPEC>) {
    print ;
    #get star name

    if(m/star=/) {
      print "Found star name\n";
      @starName= split("=");
      $star=$starName[1];
      print "STAR_NAME=",$star,"\n";
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

       $startParams=1;
       $paramCount=readline STAR_SPEC;
       print "param count=",$paramCount;

       for($i=0; $i<$paramCount; $i++) {
          $param=readline (STAR_SPEC);
          chop($param);
          print "PARAM=",$param;
          @params=split(";",$param);

          push @paramTypes, ($params[0]);
          push @paramNames, ($params[1]);
          push @paramValues, ($params[2]);
          push @paramPrompts, ($params[3]);



       }



    }
   }  # done reading and processing of star specs

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

       $template = $template."source.tmpl";


   } elsif ($type eq "processor") {
       $template = $template."processor.tmpl";


   } elsif ($type eq "term") {

       $template = $template."terminator.tmpl";

   } elsif ($type eq "probe") {

       $template = $template."probe.tmpl";

   };





   foreach $prompt (@paramPrompts) {
      print "EXTRACTED PROMPTS=", $prompt, "\n";

   }

   foreach $value (@paramValues) {
      print "EXTRACTED VALUES=", $value, "\n";

   }

   #$templateFile = "C:\\capsim\\files\\TEMPLATES\\";
   $templateFile = $ENV{'CAPSIM'}."/TEMPLATES/";
   $templateFile = $templateFile.$template;

   print  "TEMPLATE file name=",$templateFile,"\n";

   open(TEMPLATE,$templateFile) || die "could not open template\n";

   chop($star);

   $starFile=">".$star.".s";

   open(STAR,$starFile) || die "could not open star file for write\n";


   
   while (<TEMPLATE>) {
  print $_; 
      s/STAR_NAME/$star/g;
      if(m/PLACE_PARAMETERS/) {
           for($i=0; $i <$paramCount; $i++) {
               print STAR "    ","param_def=","\"",$paramPrompts[$i],"\"",";\n";
               print STAR "    ",$paramTypes[$i]," ",$paramNames[$i],"=",$paramValues[$i],";\n";
           }
      } else { 
           print STAR;
      }
   
   }  
   



    
