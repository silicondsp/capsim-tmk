
#!/usr/bin/perl
#
# Copyright (C) 1989-2017 Silicon DSP Corporation
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
# Script for adding stars to database sm.dat and to generate krn_starlib.c
#
#
# In MacPerl, save as droplet. Drag files or dirs onto the script.
# Requires the 'ssUtilities.pl' in the MacPerl lib folder to work.
# 
# File drag and drop  script by Sandra Silcot, Jan 1995, ssilcot@www.unimelb.edu.au
#
# Written by Sasan Ardalan, Dec.2, 1997
#

#require 'ssUtilities.pl';



# print "\n$0\n$DateTime\nCapsim Star Maintenance!\n==============================================\n";


$listFlag=0;
$genFlag=0;
$flagTrue=0;
$flag="a";
foreach $f (@ARGV) {

#    if (-d $f) {
#        print "A directory: $f\n";
#        @fileList =&get_recursive_filelist ($f);

								
#        foreach $file (@fileList) {
#        $fileFlag=1;
#		&addDatabase;
    
#       }

#$flag = substr $f,1,1;

if($flagTrue ==0)  {
     $flag=$f;
}



if( $flagTrue == 0 && ($flag eq "a" ||  $flag eq "d" || $flag eq "l" || $flag eq "g")) {        
    
#    print "Detected flag=",$flag,"\n";
    $flagTrue=1;
     
   } else {
	#
	# Here we process an individual file
	#
	$file=$f;
	$f="";
	
	$fileFlag=1;

	if( $flag eq "a") {
               &addDatabase;
        }


  }
}


if($flagTrue ==0  || $flag eq "a") {
#	print "End of starmaint script.\n\nDone!\n";

	exit;
}

			
if($fileFlag == 1) {
        	#print "star is: $file\n";
			$starname="$f$file";
			# strip the .s at the end of the file
			$starname =~ s/\.s//;
			@PATHS=split(/\\/,$starname);
			$starname=$PATHS[$#PATHS];
#                print "star name is: $file\n";
}


 $listFlag=0;
#$action = MacPerl::Pick("Select Action", "Add", "Delete", "List");

if($flag eq "l") {
#     print "Listing ... \n";
     $listFlag=1;
     &addDatabase;


} elsif ( $flag eq "d") {

#	$starname=MacPerl::Ask("Enter star name to delete");
#        $starname=$f;
        print "Deleting $starname ...\n";
	&DeleteStar;



} elsif ($flag eq "g") {
    $genFlag=1;
    &addDatabase;

}


#print "End of starmaint script.\n\nDone!\n";






#
# Delete Database Star
#
sub DeleteStar {


			$doit=0;

			open (INFILE, "sm.dat") || die "could not open infile $f";
#   			print "\nProcessing $f\n"; # print a message to the STDOUT default output window


    		
    		#
    		# Create the new sm.dat file
    		#
    		
 			open(dataBaseFile,">sm.dat.gen") || die("Unable to open  file to write\n");



    		$linenum = 0;
    		# now read each line - it will go into $_ / add <P> tag to all linebreaks
    		
    		$flag=0;
    		#   @STARS=("");
    		@COMMENTS=("");
    		while (<INFILE>) {
    			
     							
       	  		
      							
       	  		if($_ =~ /\n/) {
       	  			@theWords=split(/ /,$_);
 
       	  			if($_ =~ /\*END/) {
 #    	  			    print "found end\n";
       	  			    $_="\n";
       	  				$flag=1;
       	  			}
       	  			if($flag ==1 && ($_ =~ /\*FUNCDECL/)) {
       	  			   $flag=2;
       	  			
       	  			}
 
					if($#theWords==2 && $flag ==0) {
							if($theWords[0] eq $starname) {
								print "Found:";print $starname; print "\n"; 
								$doit=1;
														
							} else {
							  
								push @STARS,($theWords[0]);
							}
		
					}
					if($flag == 1) {
						push @COMMENTS,$_;
					
					
					}
				
		  		}  # we would say 'chop;' to get rid of it
        	  	$linenum++;  # increment our counter
   			}
    		# close it
    		close (INFILE);


			if($doit == 0) {
					return;
			}
			
			rename "sm.dat","sm_old.dat";

    		
    		@sortedStars=sort (@STARS);
    		
    		
    		#
    		# Create the new sm.dat file
    		#
    		
 			open(dataBaseFile,">sm.dat") || die("Unable to open  file to write\n");
 			
 			print (dataBaseFile "! This is the core library data\n!\n");
 			
    		$kk=0;
    		foreach $star (@sortedStars) {
    		         print(dataBaseFile  $star," ");print(dataBaseFile  $star," "); print(dataBaseFile  substr($star,0,7),"\n");
    		             		
    		}   		
    		print(dataBaseFile  "*END\n\n");
    		
    		foreach $commline (@COMMENTS) {
    			print(dataBaseFile $commline);
    		
    		}    		
    		print(dataBaseFile  "*FUNCDECL\n\n");
    		print(dataBaseFile  "/* model table Definition */\n");
    		print(dataBaseFile  "*MODTABL\n*END\n");
    		
    		
			close(dataBaseFile); 

}



#
# add dropped stars to database "sm.dat"
#
sub addDatabase {
		
			
			
if($fileFlag == 1) {
        	print "$file\n";
			$starname="$f$file";
			# strip the .s at the end of the file
			$starname =~ s/\.s//;
			@PATHS=split(/:/,$starname);
			$starname=$PATHS[$#PATHS];
}
		
#			print "The starname  is ==> $starname","\n";
		


			open (INFILE, "sm.dat") || die "could not open infile $f";
#   			print "\nProcessing $f\n"; # print a message to the STDOUT default output window

    		$linenum = 0;
    		# now read each line - it will go into $_ / add <P> tag to all linebreaks
    		
    		$flag=0;
    		#   @STARS=("");
    		@COMMENTS=("");
    		while (<INFILE>) {
#             print $_;
    			
     							
       	  		if($_ =~ /\n/) {
       	  			@theWords=split(/ /,$_);
 
       	  			if($_ =~ /\*END/) {
       	 # 			    print "found end\n";
       	  			    $_="\n";
       	  				$flag=1;
       	  			}
       	  			if($flag ==1 && ($_ =~ /\*FUNCDECL/)) {
       	  			   $flag=2;
       	  			
       	  			}
 
					if($#theWords==2 && $flag ==0) {
							if($theWords[0] eq $starname) {
								print "STAR ALREADY EXITS:";print $starname; print "\n"; 
								return;							
							}

 #      print $theWords[0];print "\n";
							  
							push @STARS,($theWords[0]);
		
					}
					if($flag == 1) {
						push @COMMENTS,$_;
					
					
					}
				
		  		}  # we would say 'chop;' to get rid of it
        	  	$linenum++;  # increment our counter
   			}
    		# close it
    		close (INFILE);
    		
    		if($listFlag ==1) {
    		    @sortedStars=sort (@STARS);
    		    foreach $star (@sortedStars) {
    		    	print $star; print "\n";
    		    }
				return;
    		}   		
    		
			

    		
    		if($genFlag == 0) {
    		     rename "sm.dat","sm_old.dat";
    		     push  @STARS, ($starname);
    		
    		
    		     @sortedStars=sort (@STARS);
    		
    		
    		    # Create the new sm.dat file
    		    #
    		
 			    open(dataBaseFile,">sm.dat") || die("Unable to open  file to write\n");
 			
 			    print (dataBaseFile "! This is the core library data\n!\n");
 			
    		    $kk=0;
    		    foreach $star (@sortedStars) {
    		         print(dataBaseFile  $star," ");print(dataBaseFile  $star," "); print(dataBaseFile  substr($star,0,7),"\n");
    		             		
    		    }   		
    		    print(dataBaseFile  "*END\n\n");
    		
    		    foreach $commline (@COMMENTS) {
    		 	     print(dataBaseFile $commline);
    		
    		    }    		
    		    print(dataBaseFile  "*FUNCDECL\n\n");
    		    print(dataBaseFile  "/* model table Definition */\n");
    		    print(dataBaseFile  "*MODTABL\n*END\n");
    		
    		
			    close(dataBaseFile);
			    print "Star Added:",$starname,"\n";
			
			} else {
			    @sortedStars=sort (@STARS);
			
			}
			
			#
			# Generate the C code for krn_starlib.c
			#
    		open(CCODE,">krn_starlib.c") || die("Unable to open  file to write\n");

    		
    		
    		foreach $commline (@COMMENTS) {
    			print(CCODE $commline);
    		
    		}   		
    		
    		print(CCODE  "extern ");
    		$kk=0;
    		$jj=0;
    		foreach $star (@sortedStars) {
    		         print(CCODE  $star); print(CCODE  "()"); 
    		    if($kk != $#sortedStars) {
    		    			print(CCODE  ",");
    		    } else {
    		    
    		          print (CCODE ";");
    		    }
    		    if($jj==4) {
    		       print(CCODE  "\n\t");
    		       $jj=0;
    		    
    		    }
    		    $jj++;
    		    $kk++;
    			
    		
    		}


			print (CCODE "\n/* model table Definition */\n");
			print (CCODE "int model_count = "); print(CCODE  $#sortedStars+1); print(CCODE  ";\n");
			print (CCODE  "modelEntry_t model[MAX_MODELS] = {\n");
			print (CCODE "\n/* function, name, icon_id */\n");
			

    		$kk=0;
    		
    		foreach $star (@sortedStars) {
    		    print(CCODE  "{ "); print(CCODE  $star); print(CCODE  ","); print(CCODE  "\""); print(CCODE  $star); print(CCODE  "\"");
    		    print (CCODE ","); print (CCODE  "\""); print (CCODE substr($star,0,7)); print (CCODE "\""); print(CCODE  "}");
    		    if($kk != $#sortedStars) {
    		    			print (CCODE ",\n");
    		    } else {
    		    
    		          print (CCODE "\n};");
    		    }

    		    $kk++;
    			
    		
    		}    		
    		


			$file =~ s/://; # get rid of : at beginning of file name


                        print (CCODE "\n");			
			close(CCODE);
			
			$fil = "sm.dat";
#			&MacPerl'SetFileInfo("ttxt","TEXT",$fil);    
			
			
			$fil = "krn_starlib.c";
#		&MacPerl'SetFileInfo("ttxt","TEXT",$fil);    
}




#
# prints a file in variable $file line by line
#
sub printFile {
    	open (INFILE, "$file") || die "could not open infile $f";
#    	print "\nProcessing $f\n"; # print a message to the STDOUT default output window
    	$linenum = 0;
    	# now read each line - it will go into $_
    	while (<INFILE>) {
        	print "line $linenum => $_";  # note $_ will includes a return at the end
                                      # we would say 'chop;' to get rid of it
        	$linenum++;  # increment our counter
    	}
    	# close it
    	close (INFILE);
}
__END__

