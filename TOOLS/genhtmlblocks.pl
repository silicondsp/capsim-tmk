
$HTML_PATH="BLOCKS_HTML";

$count=0;
$file=">generateHTML.sh";

open(GEN_HTML_SH,$file) || die "Could not open $file \n";


#print GEN_HTML_SH "\$CAPSIM=\$(CAPSIM)\n\n";

$XSL= "\tjava -jar saxon.jar ";
$XSL= "\t\$(CAPSIM)/BIN/Xalan ";


@starHTMLs= ();
foreach $i (@ARGV) {


  @starA= split /\./, $i;
  $starName = $starA[0];

  $starHTML=$starName.".htm";

  push(@starHTMLs, $starHTML);

  print $starName,"\n";

  print GEN_HTML_SH "echo Processing: ",$starName, "\n\n";

  print GEN_HTML_SH "\tjava -jar \$CAPSIM/TOOLS/saxon.jar ",$starName,".s"," \$CAPSIM/TOOLS/blockhtml.xsl",">",$HTML_PATH,"/",$starName,".htm", "\n";
  
  print GEN_HTML_SH "\n";


} 
print GEN_HTML_SH "\n";
close GEN_HTML_SH;
   
