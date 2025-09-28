#
# written by Sasan Ardalan
# Graphical Viewer for Capsim Topologies
#
# (c) 2003 Sasan Ardalan
#

#
# doubly linked list class
#


use Tk;


package double;

# $node = double->new( $val );
#
# Create a new double element with value $val.
sub new {
    my $class = shift;
    $class = ref($class) || $class;
    my $self = { val=>shift };
    bless $self, $class;
    return $self->_link_to( $self );
}

# $elem1->_link_to( $elem2 )
#
# Join this node to another, return self.
# (This is for internal use only, it doesn't not care whether
# the elements linked are linked into any sort of correct
# list order.)
sub _link_to {
    my ( $node, $next ) = @_;

    $node->next( $next );
    return $next->prev( $node );
}

sub destroy {
    my $node = shift;
    while( $node ) {
        my $next = $node->next;
        $node->prev(undef);
        $node->next(undef);
        $node = $next;
    }
}

# $cur = $node->next
# $new = $node->next( $new )
#
#    Get next link, or set (and return) a new value in next link.
sub next {
    my $node = shift;
    return @_ ? ($node->{next} = shift) : $node->{next};
}

# $cur = $node->prev
# $new = $node->prev( $new )
#
#    Get prev link, or set (and return) a new value in prev link.
sub prev {
    my $node = shift;
    return @_ ? ($node->{prev} = shift) : $node->{prev};
}


# this node, return self.
sub append {
    my ( $node, $add ) = @_;
    if ( $add = $add->content ) {
        $add->prev->_link_to( $node->next );
        $node->_link_to( $add );
    }
    return $node;
}

# Insert before this node, return self.
sub prepend {
    my ( $node, $add ) = @_;
    if ( $add = $add->content ) {
        $node->prev->_link_to( $add->next );
        $add->_link_to( $node );
    }
    return $node;
}

# Content of a node is itself unchanged
# (needed because for a list head, content must remove all of
# the elements from the list and return them, leaving the head
# containing an empty list).
sub content {
    return shift;
}

# Remove one or more nodes from their current list and return the
# first of them.
# The caller must ensure that there is still some reference
# to the remaining other elements.
sub remove {
    my $first = shift;
    my $last = shift || $first;

    # Remove it from the old list.
    $first->prev->_link_to( $last->next );

    # Make the extracted nodes a closed circle.
    $last->_link_to( $first );
    return $first;
}

package double_head;

sub new {
    my $class = shift;
    my $info = shift;
    my $dummy = double->new;

    bless [ $dummy, $info ], $class;
}

sub DESTROY {
    my $self = shift;
    my $dummy = $self->[0];

    $dummy->destroy;
}

# Prepend to the dummy header to append to the list.
sub append {
    my $self = shift;
    $self->[0]->prepend( shift );
    return $self;
}

# Append to the dummy header to prepend to the list.
sub prepend {
    my $self = shift;
    $self->[0]->append( shift );
    return $self;
}

sub first {
    my $self = shift;
    my $dummy = $self->[0];
    my $first = $dummy->next;

    return $first == $dummy ? undef : $first;
}

# Return a reference to the last element.
sub last {
    my $self = shift;
    my $dummy = $self->[0];
    my $last = $dummy->prev;

    return $last == $dummy ? undef : $last;
}

# When an append or prepend operation uses this list,
# give it all of the elements (and remove them from this list
# since they are going to be added to the other list).
sub content {
    my $self = shift;
    my $dummy = $self->[0];
    my $first = $dummy->next;
    return undef if $first eq $dummy;
    $dummy->remove;
    return $first;
}

sub ldump {
    my $self = shift;
    my $start = $self->[0];
    my $cur = $start->next;
    print "list($self->[1]) [";
    my $sep = "";

    while( $cur ne $start ) {
        print $sep, $cur->{val};
        $sep = ",";
        $cur = $cur->next;
    }
    print "]\n";
}
sub lhashdump {
    my $self = shift;
    my $start = $self->[0];
    my $cur = $start->next;
    print "list($self->[1]) [";
    my $sep = "";

    while( $cur ne $start ) {
        $hash1_P=$cur->{val};
#        print $sep, $hash1{starName};
         print "HASHREFDUMP:",${%$hash1_P}{starName},":",${%$hash1_P}{starLibName},"\n";
         print "HASHREFDUMP2:",$hash1_P->{starName},":",$hash1_P->{starLibName},"\n";
        print $sep, $hash1,":",$hash1;
        $sep = ",";
        $cur = $cur->next;
    }
    print "]\n";
}

sub searchStar {
    my $self = shift;
    my $start = $self->[0];
    my $cur = $start->next;
    my $starName=shift;
    print "Searchinf for:",$starName,"\n";
    my $sep = "";

    while( $cur ne $start ) {
        $hash1_P=$cur->{val};
#         print "HASHREFDUMP:",${%$hash1_P}{starName},":",${%$hash1_P}{starLibName},"\n";
#         print "HASHREFDUMP2:",$hash1_P->{starName},":",$hash1_P->{starLibName},"\n";
#        print $sep, $hash1,":",$hash1;
#        $sep = ",";
        $_=$hash1_P->{starName};
        if ( /^$starName$/) {
            print "Found star ($_):",$starName,"\n";
            return $cur;
        }
        $cur = $cur->next;
    }
    print "\ndone search\n";
}

sub getOutputConnections {
    my $self = shift;
    my $start = $self->[0];
    my $cur = $start->next;
    my $starName=shift;
    while( $cur ne $start ) {
        $hash1_P=$cur->{val};
        $_=$hash1_P->{starName};
        if ( /^$starName$/) {
            print "Found star in  getOutputConnections ($_):",$starName,"\n";
            
            my $hash2_P=$cur->{val};
            my @toc=@{$hash2_P->{outputConnections}};


            return @toc;
        }
        $cur = $cur->next;
    }
}

sub getInputConnections {
    my $self = shift;
    my $start = $self->[0];
    my $cur = $start->next;
    my $starName=shift;
    while( $cur ne $start ) {
        $hash1_P=$cur->{val};
        $_=$hash1_P->{starName};
        if ( /^$starName$/) {
            print "Found star in  getInputConnections ($_):",$starName,"\n";
            
            my $hash2_P=$cur->{val};
            my @tic=@{$hash2_P->{inputConnections}};
            return @tic;
        }
        $cur = $cur->next;
    }
}

sub getBounds {
    my $self = shift;
    my $start = $self->[0];
    my $cur = $start->next;
    my $xmin=shift;
    my $xmax=shift;
    my $ymin=shift;
    my $ymax=shift;
    print "Traversing for bounding box ($xmin:$xmax:$ymin:$ymax)","\n";
    my $sep = "";
    my @stars;
    
    my $ytmin=100000;
    my $ybmax=0;
    my $numberStars=0;

    while( $cur ne $start ) {
        $hash1_P=$cur->{val};
#         print "HASHREFDUMP:",${%$hash1_P}{starName},":",${%$hash1_P}{starLibName},"\n";
#         print "HASHREFDUMP2:",$hash1_P->{starName},":",$hash1_P->{starLibName},"\n";
#        print $sep, $hash1,":",$hash1;
#        $sep = ",";
        $_=$hash1_P->{starName};
	
	($xl,$yt,$xr,$yb) = $canvas->bbox($_);
#	print "STAR:$_ ($xl,$xr,$yt,$yb)","\n";
	
        if ( inBox($xmin, $xmax, $xl)==1 || inBox($xmin, $xmax, $xr)==1) {
	    push(@stars,$_);
	    if($yb > $ybmax ) {$ybmax=$yb};
	    if($ytmin > $yt) {$ytmin=$yt};
            print "Found star ($_) $yt:$yb   <>  $ytmin:$ybmax","\n";
	    $numberStars=$numberStars+1;
	    
            
        }
	
#    if ( inBox($xmin, $xmax, $xl)==1 || inBox($xmin, $xmax, $xr)==1) {
#	    push(@stars,$_);
#	    if($yb < $ytmin ) {$ytmin=$yb};
#	    if($ybmax < $yt) {$ybmax=$yt};
#            print "Found star ($_) $yt:$yb   <>  $ytmin:$ybmax","\n";
#	    $numberStars=$numberStars+1;
	    
            
#        }	
	
	
        $cur = $cur->next;
    }
    print "\ndone bounding box\n";
 #   my @yb=($numberStars,$ytmin,$ybmax);
     my @yb=($numberStars,$ybmax,$ytmin);
 
    return @yb;
}

sub inBox {
  my $xmin=shift;
  my $xmax=shift;
  my $x=shift;
  
  if($x > $xmin && $x <$xmax) {
      return 1;
  }
  return 0;


}

sub draw {
    my $self = shift;
    my $start = $self->[0];
    my $cur = $start->next;
    
    my $xcur=10;
    my $ycur=100;
    
    my $xcur2=10;
    
    my $width=100;
    my $height=50;
    
    my $thickness=1;
    my $i=0;
    
    $mw->fontCreate('blkfont', -family => 'Arial', -size => 12);

    while( $cur ne $start ) {
    
        $height=50;
    
        $hash1_P=$cur->{val};
        $_=$hash1_P->{starName};
	
      
        my @toc=@{$hash1_P->{outputConnections}};

        my @tic=@{$hash1_P->{inputConnections}};

        my $galFlag =$hash1_P->{galaxy}; 
	
		
#	@toc2= $self->getOutputConnections($_);
	foreach $oc (@toc) {
           print "DRAW GET OUTPUT Connections($_):",$oc->{starName},"\n";
        }
	
	foreach $ic (@tic) {
           print "DRAW GET INPUT Connections($_):",$ic->{starName},"\n";
        }
	
	
	
	$numberOutputConnections=$#toc;
	$numberInputConnections=$#tic;
	
	if($numberOutputConnections > $numberInputConnections) {
	        $maxNumberConnections=$numberOutputConnections;
        }else {
	         $maxNumberConnections=$numberInputConnections;
        }
	
	$height=$height+10*($maxNumberConnections-1);
	
	$delta=$height/($#toc+2);

	print "FONT->",$mw->fontMeasure('blkfont', $hash1_P->{starName}), "\n";
	
	$txtLength=$mw->fontMeasure('blkfont', $hash1_P->{starName});
	$widthBlk=$txtLength+30;
	
	
		
	for ($i=1; $i<$#toc+2; $i=$i+1) {
             $canvas->createLine($xcur+$widthBlk-10, $ycur+$delta*$i-5, $xcur+$widthBlk, $ycur+$delta*$i,
	            $xcur+$widthBlk-10, $ycur+$delta*$i+5,$xcur+$widthBlk-10, $ycur+$delta*$i-5,
                    -width => $thickness, -tags => "outconnect", -arrow =>"none" );
		    
	    my %coord= (
	        x=>$xcur+$widthBlk,
	        y=>$ycur+$delta*$i
	    );	    
	    push (@{$hash1_P->{outputCoord}},\%coord);	    
		    	
	
	}
	
	$delta=$height/($#tic+2)+2;
	$xcur2 = $xcur+10;
	
	for ($i=1; $i<$#tic+2; $i=$i+1) {
             $canvas->createLine($xcur2-10, $ycur+$delta*$i-5, $xcur2, $ycur+$delta*$i,
	            $xcur2-10, $ycur+$delta*$i+5,$xcur2-10, $ycur+$delta*$i-5,
                    -width => $thickness, -tags => "inconnect", -arrow =>"none" );	

	    my %coord= (
	        x=>$xcur,
	        y=>$ycur+$delta*$i
	    );	    
	    push (@{$hash1_P->{inputCoord}},\%coord);	    
		    
		    	
	}
	my $starName=$hash1_P->{starName};
	my @outConn=@{$hash1_P->{outputCoord}};
        my @inConn=@{$hash1_P->{inputCoord}};
	
	print "Output conn. for $starName:","\n";
	foreach $s (@outConn) {
	   print %$s->{'x'}," ",%$s->{'y'},"\n";
	
	}
	print "Input conn. for $starName:","\n";
	foreach $s (@inConn) {
	   print %$s->{'x'}," ",%$s->{'y'},"\n";
	
	}	
       
	
	
       $canvas->createRectangle($xcur, $ycur, $xcur+$widthBlk, $ycur+$height, 
            -width => $thickness, -tags => $hash1_P->{starName});

       if($galFlag ==1) {
           $canvas->createRectangle($xcur+2, $ycur+2, $xcur+$widthBlk-2, $ycur+$height-2, 
            -width => $thickness, -tags => $hash1_P->{starName});


       }
       
#       $canvas->createLine(50, 100, 20, 200, 
#       -width => $thickness, -tags => "drawmenow", -arrow =>"last" );
       $numberOutputConnections=$#toc;
       $canvas->createText($xcur+$widthBlk/2,$ycur+$height/2, -text => $hash1_P->{starName},
                 -font => 'blkfont');
	
	$xcur = $xcur+$widthBlk+40;
	
	if ( $xcur > 2000000) {
	    $xcur=10;
	    $ycur= 200;
	}
	$ycur = $ycur+0;
	
	
        $cur = $cur->next;
    }
    print "\ndone draw block traversal\n";
    
    my $delx=5;
    my $delx2=15;
    my $dx=0;
    my $yindexp=0;
    my $yindexm=0;
    
    $cur = $start->next; 
    while( $cur ne $start ) {
        $hash1_P=$cur->{val};
        $starName=$hash1_P->{starName};
#	print "Draw Connection at: $_","\n";
	
	
        my @toc=@{$hash1_P->{outputConnections}};
        $numberOutputConnections=$#toc;	
	@outConn=@{$hash1_P->{outputCoord}};
	
		
	
        for ($i=0; $i<$#toc+1; $i=$i+1) {	
	   $s=$outConn[$i];
 	
	   my $xbeg=%$s->{'x'};
	   my $ybeg=%$s->{'y'};
	   
	   #
	   # get name of star that this star is connected to
	   #
	   	   
#         my $outputConnection={starName=>$starCT,outBuffer=>$cfBufferNumber,
#	         inBuffer=>$ctBufferNumber};

	   $outConn =$toc[$i];
	   my $starTo= %$outConn->{'starName'};
	   my $bufferNumber = %$outConn->{'inBuffer'};	
	   
	   my $starToBlk= $self->searchStar($starTo);
	   my $hash2_P=$starToBlk->{val};
	   
	   my @inConn=@{$hash2_P->{inputCoord}};
	   
	   $s = $inConn[$bufferNumber];
	   my $xend=%$s->{'x'};
	   my $yend=%$s->{'y'};
	   my $ymid=0;
	   my $xend2=0;
	   my $xbeg2=0;
	   
	   if($xend < $xbeg) {
	       $xend2=$xbeg;
	       $xbeg2=$xend;
	   } else {
	   
	       $xend2=$xend;
	       $xbeg2=$xbeg;
	   
	   }
	   
	   my $xenddel=4*$bufferNumber;
	   
	   
	   
	   @theBounds=$self->getBounds($xbeg2+$dx,$xend2-$dx,0,10000);
	   
	   foreach $zz (@theBounds) {
	      print "zz: $zz","\n";
	   }
	   
	   

	   
	   print "Draw Connection from: $starName to $starTo at $bufferNumber: ",
	                       $i,":",$xbeg,":",$ybeg,"->",$xend,":",$yend,"\n";
			       
#               $canvas->createLine($xbeg, $ybeg, $xend, $yend,
#                    -width => $thickness, -tags => "connect", -arrow =>"last" );

           $dx = $delx*($i+1);

           if($theBounds[0]==0) {

               if($ybeg < $yend){ $ymid=$yend;} else {$ymid=$ybeg}


               $canvas->createLine($xbeg, $ybeg, $xbeg+$dx, $ybeg,
	            $xbeg+$dx,$ymid,
		    $xend-$delx2-$xenddel,$ymid,
	            
	       
	            $xend-$delx2-$xenddel, $yend,
	            $xend, $yend,
                    -width => $thickness, -tags => "connect", -arrow =>"last" );
		    
           } else {
	    if($ybeg < $yend){ 
	         $ymid=$theBounds[1]+5+5*$yindexp;
		 $yindexp=$yindexp+1;
		 
	    } 
	    else {
	            $ymid=$theBounds[2]-5-5*$yindexm;
		     $yindexm=$yindexm+1;
            }
	   
             $canvas->createLine($xbeg, $ybeg, $xbeg+$dx, $ybeg,
	            $xbeg+$dx,$ymid,
		    $xend-$delx2-$xenddel,$ymid,
	            
	       
	            $xend-$delx2-$xenddel, $yend,
	            $xend, $yend,
                    -width => $thickness, -tags => "connect", -arrow =>"last" );	   
	   
	   
	   }	
         	       
			       
        }	
	
	
	

         $cur = $cur->next;
    }
   
    print "\ndone draw connection  traversal\n";
    
    
}

#
# end doubly linked list
#

#
# main program
#

{
$mw = Tk::MainWindow->new;
$mw->title("Topology");
$c = $mw->Scrolled("Canvas")->pack( );
$canvas = $c->Subwidget("canvas");

$canvas->configure( -height =>400, -width =>800);




@starlist= ();

my $topology = double_head->new( "topology" );


foreach $arg (@ARGV) {
     print $arg,"\n";
}

open(topology,$ARGV[0]) || die("Unable to open  file to read\n");

@inputTerminals=();
@outputTerminals=();
while (<topology>) {
     if(/output/) {
        split;
	$bufferNumber=$_[4];
	$outStar="output".$bufferNumber;
	push(@outputTerminals,$outStar);
 
     }
     if(/input/) {
        split;
	$bufferNumber=$_[2];
	$inStar="input".$bufferNumber;
	push(@inputTerminals,$inStar);
 
     }

}
close(topology);

foreach $t (@inputTerminals) {
   print "TERMINAL:$t\n";
         @outputConnections=();
         @inputConnections=();
         
         my %starObj=(starName=>$t,starLibName=>"inputTerminal",inputConnections=>[],outputConnections=>[],inputCoord=>[],outputCoord=>[]);
   
         $starObj_P=\%starObj;  
         my $new = double->new( \%starObj );
         $topology->append($new);
  
   

}

open(topology,$ARGV[0]) || die("Unable to open  file to read\n");


while (<topology>) {
     my $galFlag=0;
     if(/^star/ || /^galaxy/) {
         split;
         $starName=$_[1];
         $starLibName=$_[2];

         if(/^galaxy/) {
            $galFlag=1;
         }
           

         @outputConnections=();
         @inputConnections=();

         
         my %starObj=(starName=>$starName,starLibName=>$starLibName,galaxy=>$galFlag,inputConnections=>[],outputConnections=>[],inputCoord=>[],outputCoord=>[]);
        
#         push (@starlist, %starObj);
         foreach $starprs (@_) {
             print "STAR ",$starprs,"\n";
             
         }
         print "HASH:",$starObj{starName}, "  ", $starObj{starLibName},"\n";

#         my $new = double->new( $starObj{starName} );
         $starObj_P=\%starObj;
         
         print "HASHREF:",${%$starObj_P}{starName}, "  ", $starObj_P=>starLibName,"\n";
         my $new = double->new( \%starObj );
         $topology->append($new);
          
         
     }

}


close(topology);


foreach $t (@outputTerminals) {
   print "TERMINAL:$t\n";
         @outputConnections=();
         @inputConnections=();
         
         my %starObj=(starName=>$t,starLibName=>"outputTerminal",inputConnections=>[],outputConnections=>[],inputCoord=>[],outputCoord=>[]);
   
         $starObj_P=\%starObj;  
         my $new = double->new( \%starObj );
         $topology->append($new);
  
   

}



$topology->lhashdump;


#
# Open the topology to get connections
#
open(topology,$ARGV[0]) || die("Unable to open  file to read\n");
while (<topology>) {
    #  print $_;
     if(/^connect /) {
         split;
         $starCF=$_[1];
         $cfBufferNumber=$_[2];
         $starCT=$_[3];
         $ctBufferNumber=$_[4];
	 
	 if(/output/) {
	     $starCT ="output".$ctBufferNumber;
	     print "OUT ZZZZZZZZZZZZZZZZZZ:",$startCT,"\n";
	 
	 }
	 
	 if(/input/) {
	     $starCF="input".$cfBufferNumber;
	     print "IN ZZZZZZZZZZZZZZZZZZ:",$startCF,"\n";
	 
	 }	 
         print "PARSE CONNECT:",$starCF,":", $cfBufferNumber,":",$starCT,":",$ctBufferNumber,"\n";
         my $outputConnection={starName=>$starCT,outBuffer=>$cfBufferNumber,inBuffer=>$ctBufferNumber};

print "+*+*+*+++++UPDATE OUTPUT CONNECTION:",$outputConnection->{starName},"\n";



         my $inputConnection={starName=>$starCF,outBuffer=>$cfBufferNumber,inBuffer=>$ctBufferNumber};
         $cur=$topology->searchStar($starCF);
         $hash2_P=$cur->{val};
         push (@{$hash2_P->{outputConnections}},$outputConnection);

         $cur=$topology->searchStar($starCT);
         $hash2_P=$cur->{val};

         push (@{$hash2_P->{inputConnections}},$inputConnection);

     }

}         
close(topology);

      $cur=$topology->searchStar("sine0");
      $hash2_P=$cur->{val};
      print "Search Result:",$hash2_P->{starName},":",$hash2_P->{starLibName},"\n";
      @toc=@{$hash2_P->{outputConnections}};
      @tic=@{$hash2_P->{inputConnections}};

     
      print "Search Result Connections:",$tic[0]->{starName},":",$toc[0]->{starName},"\n";

      @toc2=$topology->getOutputConnections("node0");
      foreach $oc (@toc2) {
          print "GET -----Search Result OUTPUT Connections:",$oc->{starName},"\n";
      }

      @tic2=$topology->getInputConnections("mixer0");
      foreach $oc (@tic2) {
          print "GET -----Search Result INPUT Connections:",$oc->{starName},"\n";
      }

      $topology->draw();
      
      @ybound=$topology->getBounds(100,300,0, 1000);
      
      foreach $t (@ybound)  {
         print "Star in Bound:$t","\n";
      
      }


sub print_xy {
  my ($canv, $x, $y) = @_;
  print "(x,y) = ", $canv->canvasx($x), ", ", $canv->canvasy($y), "\n";
}



$canvas->CanvasBind("<Button-1>", [ \&print_xy, Tk::Ev('x'), Tk::Ev('y') ]);

#$thickness=1;
#$canvas->createRectangle(10, 10, 100, 50, 
#       -width => $thickness, -tags => "drawmenow");
#$canvas->createRectangle(400, 10, 100, 50, 
#       -width => $thickness, -tags => "drawmenow");
       
#$canvas->createLine(50, 100, 20, 200, 
#       -width => $thickness, -tags => "drawmenow", -arrow =>"last" );
       
#$canvas->createText(200,100, -text => "origin");


Tk::MainLoop;


print "After TK","\n";

}

