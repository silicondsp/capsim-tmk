
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

$htmlPath="BLOCKS_HTML/";

$start=0;

$pageCount=0;

$totalPages= $#ARGV/20;

print "Total Pages=",$totalPages,"\n";



$count=0;

    $theFile=">".$htmlPath;
     $theFile=$theFile."blocklist_";
     $file=$theFile;
$file=$file.$pageCount.".html";

open(HTML,$file) || die "Could not open $file \n";

print HTML "<HTML>\n";
print HTML "<BODY>\n";

open(HTML_HEADER,"blocklist_header.html") || die "Could not open $file \n";
while (<HTML_HEADER>) {
   print HTML $_;

}
close HTML_HEADER;
   
   
$file="blocklist_";
$file=$file."1".".html";
   
print HTML "<A HREF=\"",$file,"\">","Next </A><P>","\n"; 
 




print HTML "<TABLE BORDER=0>";
  print HTML "<TR><td><B>Name</B></td><td><B>Description</B></td></TR>\n";
  


#print $i,"\n";

foreach $i (@ARGV) {

  open(STAR,$i) || die "Could not open $i \n";
  #print $i,"\n";

  @starA= split /\./, $i;
  $starName = $starA[0];
  #print $starName,"\n";


  print HTML "<TR>\n";
  while (<STAR>) {

     if(m/<\/DESC_SHORT>/) {
          $start=0;
     }
     if ($start==1  && /[a-zA-Z]/ ) {
         print HTML "<td>";
         print HTML "<A HREF=\"",$starName,".htm","\">",$starName,"</A>","</td><td>\n";
         print HTML $_,"</td>\n";
     }
     if(m/<DESC_SHORT>/) {
         $start=1;
     }
  

  } 
  print HTML "</TR>\n";

  if($count == 20) {
  
     print HTML "</TABLE>\n";
     open(HTML_FOOTER,"blocklist_footer.html") || die "Could not open $file \n";
     while (<HTML_FOOTER>) {
          print HTML $_;

     }
     close HTML_FOOTER;  
  
    
     print HTML "</BODY>\n";
     print HTML "</HTML>\n";

     
   
     close HTML;
   
     $pageCount++;
     $theFile=">".$htmlPath;
     $theFile=$theFile."blocklist_";
     $file=$theFile;
     $file=$file.$pageCount.".html";



     open(HTML,$file) || die "Could not open $file \n";
   
     print HTML "<HTML>\n";
     print HTML "<BODY>\n";
   
     open(HTML_HEADER,"blocklist_header.html") || die "Could not open $file \n";
     while (<HTML_HEADER>) {
        print HTML $_;

     }
     close HTML_HEADER;

     $filePrev="blocklist_";
     $pageCountPrev=$pageCount-1;
   
     $filePrev=$filePrev.$pageCountPrev.".html";
   
     $pageCountNext=$pageCount+1;
   
   
     $file="blocklist_";
     $file=$file.$pageCountNext.".html";
   

     if($pageCountNext < $totalPages) {
          print HTML "<A HREF=\"",$filePrev,"\">","Prev </A>","","<A HREF=\"",$file,"\">","Next </A><P>","\n"; 
 
     } else {
          print HTML "<A HREF=\"",$filePrev,"\">","Prev </A>","\n"; 
     
     }


     print HTML "<TABLE BORDER=0>";
   
     print HTML "<TR>\n";
     print HTML "<td><B>Name</B></td><td><B>Description</B></td></TR>\n";
     print HTML "<TR>\n";

   
     $count=0;

  }


  $count++;
}
if($count) {
    print HTML "</TABLE>\n";
    open(HTML_FOOTER,"blocklist_footer.html") || die "Could not open $file \n";
    while (<HTML_FOOTER>) {
      print HTML $_;

    }
    close HTML_FOOTER;
    
    print HTML "</BODY>\n";
    print HTML "</HTML>\n";
    close HTML;
}
