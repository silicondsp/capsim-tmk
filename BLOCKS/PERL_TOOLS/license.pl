
my $startLic=0;
my $outputLic=0;

while(<>) {

if(/<LICENSE>/) {

#	print "Found LICENCE BEGIN \n";
	$startLic=1;
	$outputLic=1;


} 
if (/<\/LICENSE>/) {
	 $startLic=0;
#	print "Found LICENCE END \n";
	
}


if($startLic==1) {

	#print $_;


} else {

     print $_;


}

if ($outputLic==1) {
	print "<LICENSE>\n";

      
      $outputLic=0;
      
    print "/*  Capsim (r) Text Mode Kernel (TMK) Star Library (Blocks)\n";
print "    Copyright (C) 1989-2017  Silicon DSP Corporation\n"; 
print "\n";
print "    This library is free software; you can redistribute it and/or\n";
print "    modify it under the terms of the GNU Lesser General Public\n";
print "    License as published by the Free Software Foundation; either\n";
print "    version 2.1 of the License, or (at your option) any later version.\n";
print "\n";
print "    This library is distributed in the hope that it will be useful,\n";
print "    but WITHOUT ANY WARRANTY; without even the implied warranty of\n";
print "    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU\n";
print "    Lesser General Public License for more details.\n";
print "\n";
print "    You should have received a copy of the GNU Lesser General Public\n";
print "    License along with this library; if not, write to the Free Software\n";
print "    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA\n";
print "\n";
print "    http://www.silicondsp.com\n";
print "    Silicon DSP  Corporation\n";
print "    Las Vegas, Nevada\n"; 
print "*/\n";  
      
      
      
      
      
      
      
}



}
