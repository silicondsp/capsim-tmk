

while(<>) {

	#print $_;

        @values= split /\./;

        #print $values[0]," : ",$values[1],"\n";
        print "mv ",$values[0].".cpp ".$values[0].".c","\n";



}
