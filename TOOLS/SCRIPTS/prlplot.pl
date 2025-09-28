#
# PERL Plotting Package for DSP and Communications (prlplot.pl)
# http://www.xcad.com
#
# Copyright (C) 1989-2003  XCAD Corporation
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
#


use GD;
use Tk;
use Tk::PNG;
use strict;


my $PI=3.141592653589793 ;

my $NUMBER_OF_MARKERS=8;

my $IIP_AXIS_LOG=2;

my $PLOT_SCATTER=2;
my $PLOT_REGULAR_LINE=1;
my $PLOT_BARS=3;
my $PLOT_EYE_DIAGRAM=4;
my $PLOT_MULTI_COLUMN=5;
my $PLOT_POLE_ZERO=6;
my $PLOT_POLAR_LINEAR=7;
my $PLOT_POLAR_DB=8;

my $MAX_MULTI_COLUMNS=15;


my $TICKSIZE=10;
my $TACSIZE=4;
my $IIP_TYPE_POLAR=99;
my $IIP_FORMAT_FIX=1;




my $height=400;
my $width=400;

my $theme=1;

my @userEndPoints_A=(0, 0);
my %axisAdjx;
my %axisAdjy;

my @endPoints=(0,0);
my $axisAdjx_P=\%axisAdjx;
my $axisAdjy_P=\%axisAdjy;

my $xlogFlag=0;
my $ylogFlag=0;

my $xmax=233.0;
my $xmin=-88.0;

my $ymax=432;
my $ymin=-986;

my $xprev;
my $yprev;
my $i;

my $doZoomFlag=0;

my @x_A=();
my @y_A=();
my $yy;
my $xx;
my $xval;
my $yval;
my %curve=(width=>100,height=>100,xType=>0,plotType=>0,yType=>0,points=>0,decimFlag=>0,
     numberColumns=>0,
     xUserEndpoint0=>0,xUserEndpoint1=>0,
     yUserEndpoint0=>0,yUserEndpoint1=>0,
     xFXP=>1,yFXP=>1,xFMT=>2,yFMT=>2,
     xGrid=>0,yGrid=>0,
     marker=>0,
     title=>"",xLabel=>"",yLabel=>"",xUnit=>"",yUnit=>"",subTitle=>"",
     yOffsetLeft=>0,yOffsetRight=>0,xOffsetBottom=>0,xOffsetTop=>0,
     decimInterval=>8,decimWidth=>8,offset=>0,
     zoomFlag=>0,
     fixedFlag=>0,
     minMaxAdj0=>0,minMaxAdj1=>0,minMaxAdj2=>0,minMaxAdj3=>0,
     minMaxFixed0=>0,minMaxFixed1=>0,minMaxFixed2=>0,minMaxFixed3=>0,
     minMaxZoom0=>0,minMaxZoom1=>0,minMaxZoom2=>0,minMaxZoom3=>0,
     minMax0=>0,minMax1=>0,minMax2=>0,minMax3=>0,
     dev0=>0,dev1=>0,dev2=>0,dev3=>0,
     gridColor=>0,axisColor=>0, curveColor=>0,titleColor=>0, labelColor=>0,
     xendPointsMin=>0,xendPointsMax=>0,xtickNum=>0,
     polarPlotMin=>0,polarPlotMax=>0);


my $curve_P=\%curve;
my $yd;
my $xd;
my $points;

my $xAnchor;
my $yAnchor;
my $anchorSet=0;

my $xRelease;
my $yRelease;
my $anchorSet=0;



# pole zero arrays
my $pztype=0;
my $numberPoles=0;
my $numberZeroes=0;
my $REAL_ZERO=0;
my $CMPLX_ZERO=1;
my $REAL_POLE=2;
my $CMPLX_POLE=3;

my @zeros_A=();
my @poles_A=();
my @pz_A=();
my @pzLinkedList=();

my @yc_A=();
my @xc_A=();
my @mcTitles_A=();
my @mc_A=();
my $j;
my $firstLine;
my $yc;
my $xc;

my @yc1=();
my @yc2=();
my @yc3=();
my @yc4=();
my @yc5=();
my @yc6=();
my @yc7=();
my @yc8=();
my @yc9=();
my @yc10=();
my @yc11=();
my @yc12=();
my @yc13=();
my @yc14=();
my @yc15=();

push(@mc_A,\@yc1);
push(@mc_A,\@yc2);
push(@mc_A,\@yc3);
push(@mc_A,\@yc4);
push(@mc_A,\@yc5);
push(@mc_A,\@yc6);
push(@mc_A,\@yc7);
push(@mc_A,\@yc8);
push(@mc_A,\@yc9);
push(@mc_A,\@yc10);
push(@mc_A,\@yc11);
push(@mc_A,\@yc12);
push(@mc_A,\@yc13);
push(@mc_A,\@yc14);
push(@mc_A,\@yc15);


my $decimPoints;
my $numOverlays;

my $legendw=20;
my $legendd=12;
my $legendx=80;
my $legendy=80;
      
     
$curve{'yOffsetLeft'}=50;
$curve{'yOffsetRight'}=50;
$curve{'xOffsetBottom'}=50;
$curve{'xOffsetTop'}=50;

$curve{'decimInterval'}=16;
$curve{'decimWidth'}=16;
$curve{'offset'}=0;

$curve{'width'}=400;
$curve{'height'}=400;

$curve{'xFXP'}=0;
$curve{'yFXP'}=0;

$curve{'yFMT'}=2;
$curve{'xFMT'}=2;

$curve_P->{'xGrid'}=0;
$curve_P->{'yGrid'}=0;

$curve_P->{'marker'}=0;

$curve{'plotType'}=  $PLOT_REGULAR_LINE;

$curve_P->{'zoomFlag'}=0;

$curve_P->{'polarPlotMin'}=-10;
$curve_P->{'polarPlotMax'}=100;

my $plotType; 
my $arg; 


     
$xmax=233.0;
$xmin=-88.0;


$points=0;

foreach $arg (@ARGV) {
     $_=$arg;
     if ( /-scatter/) {
        $curve_P->{'plotType'}=$PLOT_SCATTER;
     }
     
     if ( /-pz/) {
        $curve_P->{'plotType'}=$PLOT_POLE_ZERO;
     }
   
     
     
     if ( /-xlog/) {
        $xlogFlag=1;
     }
     if ( /-ylog/) {
        $ylogFlag=1;
     }
     if ( /-bar/) {
        $curve_P->{'plotType'}=$PLOT_BARS;
     }
     if ( /-eye/) {
        $curve_P->{'plotType'}=$PLOT_EYE_DIAGRAM;
	$curve_P->{'decimFlag'}=1;
     }
   
     if ( /-mc/) {
        $curve_P->{'plotType'}=$PLOT_MULTI_COLUMN;
	
     }
     
     if ( /-polar/) {
        $curve_P->{'plotType'}=$PLOT_POLAR_LINEAR;
	
     }    
     
     if ( /-polardb/) {
        $curve_P->{'plotType'}=$PLOT_POLAR_DB;
	
     }     
      if ( /-xfix/) {
        # -xfix=1:2 
	s/-xfix=//;
	split(":");
	$curve_P->{'xUserEndpoint0'}=$_[0];
	$curve_P->{'xUserEndpoint1'}=$_[1];
	
     }
      if ( /-yfix/) {
        # -yfix=1:2 
	s/-yfix=//;
	split(":");
	$curve_P->{'yUserEndpoint0'}=$_[0];
	$curve_P->{'yUserEndpoint1'}=$_[1];
	
     }
     if ( /-xfxp/) {
  	$curve_P->{'xFXP'}=1;
     }     
     if ( /-yfxp/) {
  	$curve_P->{'yFXP'}=1;
     }     
      if ( /-yfmt/) {
        # -yfmt=2 
	s/-yfmt=//;

	$curve_P->{'yFMT'}=$_;
     }
      if ( /-xfmt/) {
        # -xfmt=2 
	s/-xfmt=//;

	$curve_P->{'xFMT'}=$_;
     }
      if ( /-xgrid/) {
  
	$curve_P->{'xGrid'}=1;
     }    
      if ( /-ygrid/) {
  
	$curve_P->{'yGrid'}=1;
     }  
     if ( /-title/) {
        s/-title=//;
	s/_/ /g;
	$curve_P->{'title'}=$_;
     }       
    if ( /-subtitle/) {
        s/-subtitle=//;
	s/_/ /g;
	$curve_P->{'subTitle'}=$_;
     }      
     if ( /-xlabel/) {
        s/-xlabel=//;
	s/_/ /g;
	$curve_P->{'xLabel'}=$_;
     }    
      if ( /-ylabel/) {
        s/-ylabel=//;
	s/_/ /g;
	$curve_P->{'yLabel'}=$_;
     }    
      if ( /-xunit/) {
        s/-xunit=//;
	s/_/ /g;
	$curve_P->{'xUnit'}=$_;
     }        
       if ( /-yunit/) {
        s/-yunit=//;
	s/_/ /g;
	$curve_P->{'yUnit'}=$_;
     }    
     if ( /-marker/) {
        s/-marker=//;
	
	$curve_P->{'marker'}=$_;
     }   
     if ( /-width/) {
        s/-width=//;
	
	$curve_P->{'width'}=$_;
     }     
     if ( /-height/) {
        s/-height=//;
	
	$curve_P->{'height'}=$_;
     }     
     if ( /-theme/) {
        s/-theme=//;
	$theme=$_;
     }        
     if ( /-legx/) {
        s/-legx=//;
	$legendx=$_;
     }        
    if ( /-legy/) {
        s/-legy=//;
	$legendy=$_;
     }  
    if ( /-xoffb/) {
        s/-xoffb=//;
	$curve_P->{'xOffsetBottom'}=$_;
     }   
     if ( /-xofft/) {
        s/-xofft=//;
	$curve_P->{'xOffsetTop'}=$_;
     }  
     if ( /-yoffl/) {
        s/-yoffl=//;
	$curve_P->{'yOffsetLeft'}=$_;
     }    
     if ( /-yoffr/) {
        s/-yoffr=//;
	$curve_P->{'yOffsetRight'}=$_;
     }     

     if ( /-deciminterval/) {
        s/-deciminterval=//;
	$curve_P->{'decimInterval'}=$_;
     } 
     if ( /-decimwidth/) {
        s/-decimwidth=//;
	$curve_P->{'decimWidth'}=$_;
     }     
     if ( /-offset/) {
        s/-offset=//;
	$curve_P->{'offset'}=$_;
     }          
   
      if ( /-polarmin/) {
        
	s/-polarmin=//;

	$curve_P->{'polarPlotMin'}=$_;
     }    
      if ( /-polarmax/) {
        
	s/-polarmax=//;

	$curve_P->{'polarPlotMax'}=$_;
     }      
                            
}


if ($curve_P->{'plotType'}==$PLOT_POLE_ZERO) {
	$curve_P->{'xUserEndpoint0'}=-1.2;
	$curve_P->{'xUserEndpoint1'}= 1.2;
   
	$curve_P->{'yUserEndpoint0'}= -1.2;
	$curve_P->{'yUserEndpoint1'}= 1.2;
	
        $curve_P->{'xFXP'}=1;	
	$curve_P->{'yFXP'}=1;
	
	
}



my $X_AXIS_SIZE=$curve_P->{'width'} - $curve{'yOffsetLeft'}-$curve{'yOffsetRight'};
my $Y_AXIS_SIZE=$curve_P->{'height'} - $curve{'xOffsetTop'}-$curve{'xOffsetBottom'}; 

$curve{'dev0'}=$curve{'yOffsetLeft'};
$curve{'dev1'}=$X_AXIS_SIZE;
$curve{'dev2'}=$curve{'height'}-$curve{'xOffsetBottom'};
$curve{'dev3'}=$Y_AXIS_SIZE;

#
# Create IMAGE
#
my $image = new GD::Image($curve_P->{'width'},$curve_P->{'height'});

my @colors_A= (
             $image->colorAllocate(0, 0, 0), #black 0
	     $image->colorAllocate(0, 0, 255), #blue 1
	     $image->colorAllocate(0, 255, 0), #green 2
	     $image->colorAllocate(0, 255, 255),   #cyan 3
	     $image->colorAllocate(255, 0, 0), #red 4
	     $image->colorAllocate(255, 0, 255), #magenta 5
	     $image->colorAllocate(162, 42, 42), #brown 6
	     $image->colorAllocate(255, 255, 255), #white 7
	     $image->colorAllocate(211, 211, 211), #lightgray 8
	     $image->colorAllocate(70, 130, 180), #steelblue 9
	     $image->colorAllocate(255, 165, 0), #orange 10 
	     $image->colorAllocate(255, 192, 203), #pink, 11
	     $image->colorAllocate(240, 230, 140), #khaki 12
	     $image->colorAllocate(64, 224, 208), #turquoise 13
	     $image->colorAllocate(255, 255, 0), #yellow 14
	     $image->colorAllocate(245, 222, 179), #wheet  15
	     $image->colorAllocate(135, 206, 235), #skyblue  16
	     $image->colorAllocate(176, 48, 96), #maroon   17
	     $image->colorAllocate(238, 130, 238), #violet  18
	     $image->colorAllocate(255, 215, 0) #gold   19
);

$image->trueColor();
my $gray = $image->colorAllocate(200, 200, 200);

my $grayl = $image->colorAllocate(220, 220, 220);

my $red = $image->colorAllocate(255, 0, 0);
my $black = $image->colorAllocate(0, 0, 0);
my $white = $image->colorAllocate(255, 255, 255);

my $gridColor = $image->colorAllocate(255, 255, 255);


my $plotExterior=$white;
my $plotInterrior=$grayl;

if($theme ==1 ) {
     $plotExterior=$white;
     $plotInterrior=$grayl;
     $curve_P->{'gridColor'}= $black;
     
     $curve_P->{'titleColor'}=$black;
     $curve_P->{'labelColor'}=$black;
     $curve_P->{'axisColor'}=$black;
     $curve_P->{'curveColor'}=$black;
     
     
} elsif ($theme ==2) {

     $plotExterior=$black;
     $plotInterrior=$black;
     $curve_P->{'gridColor'}= $colors_A[19];
     
     $curve_P->{'titleColor'}=$colors_A[12];
     $curve_P->{'labelColor'}=$colors_A[12];
     $curve_P->{'axisColor'}=$colors_A[19];
     $curve_P->{'curveColor'}=$colors_A[3];


} else {

    $plotExterior=$black;
     $plotInterrior=$black;
     $curve_P->{'gridColor'}= $colors_A[19];
     
     $curve_P->{'titleColor'}=$colors_A[12];
     $curve_P->{'labelColor'}=$colors_A[12];
     $curve_P->{'axisColor'}=$colors_A[19];
     $curve_P->{'curveColor'}=$colors_A[19];



}

$image->filledRectangle($curve{'yOffsetLeft'}, $curve{'xOffsetTop'},$curve{'width'}-$curve{'yOffsetRight'},$curve{'height'}-$curve{'xOffsetBottom'},$plotInterrior);

	      
	
if($#ARGV==0) {

}

ReadDataFromFile($ARGV[$#ARGV]);

FindMinMax();

GetAxisEndPoints();
PlotCurves();
DrawAxisTitleLabels($curve_P);
	    
	    
	    	
open OUT, ">xplot.png" or die "Couldn't open for output: $!";
binmode(OUT);
print OUT $image->png();
close OUT;

#
# On LINUX if you do not have PERL::PNG you can use convert
#system("convert xplot.png xplot.gif");


my $mw = Tk::MainWindow->new;






my $plotImage = $mw->Photo(-file => "xplot.png", '-format' => 'png');


$mw->title($curve_P->{'title'});
my $c = $mw->Scrolled("Canvas")->pack( );
my $canvas = $c->Subwidget("canvas");

$canvas->configure( -height =>$curve_P->{'height'}, -width =>$curve_P->{'width'});


$canvas->CanvasBind("<Button-1>", [ \&BtnPressed, Tk::Ev('x'), Tk::Ev('y') ]);
$canvas->CanvasBind("<Motion>", [ \&BtnMotion, Tk::Ev('x'), Tk::Ev('y') ]);
$canvas->CanvasBind("<ButtonRelease>", [ \&BtnRelease, Tk::Ev('x'), Tk::Ev('y') ]);


my $imageID = $canvas->createImage($curve_P->{'width'}/2, $curve_P->{'height'}/2, -image => $plotImage, -tag=>"plotImage");

my $tl = $mw->Toplevel( );
    $tl->title("Tools");
    $tl->Button(-text => "Zoom Out", 
                -command => \&ZoomOut)->pack;
    $tl->Button(-text => "Zoom In", 
                -command => \&ZoomIn)->pack;
		
MainLoop;




#`konqueror xplot.jpg;`

#*********************************************************
# end of main
#*********************************************************
sub DrawPlot {
my $curve_P=shift;

$image->filledRectangle($curve{'yOffsetLeft'}, $curve{'xOffsetTop'},$curve{'width'}-$curve{'yOffsetRight'},$curve{'height'}-$curve{'xOffsetBottom'},$plotInterrior);


GetAxisEndPoints();
PlotCurves();
DrawAxisTitleLabels($curve_P);

open OUT, ">xplot.png" or die "Couldn't open for output: $!";
binmode(OUT);
print OUT $image->png();
close OUT;

$plotImage = $mw->Photo(-file => "xplot.png", '-format' => 'png');

$canvas->delete("plotImage",$imageID);

$imageID = $canvas->createImage($curve_P->{'width'}/2, $curve_P->{'height'}/2, -image => $plotImage, -tag=>"plotImage");



}
sub BtnPressed {
  
  my ($canv, $x, $y) = @_;
  my @coord;
  my $xw;
  my $yw;
  
  @coord=IIPBound($curve_P,$x,$y);
  $x=$coord[0];
  $y=$coord[1];
  $xw=IIPDevToWx($curve_P,$x);
  $yw=IIPDevToWy($curve_P,$y);
  print "World (x,y) = ", $xw, ", ", $yw, "\n";
  
  $xAnchor=$x;
  $yAnchor=$y;
  $anchorSet=1;
 
  
  
  
}


sub BtnMotion {
  
  my ($canv, $x, $y) = @_;
  my @coord;
  my $xw;
  my $yw;
  
  
  
  
  if($anchorSet==1 && $doZoomFlag ==1 ) {
      $canv->delete("rbb");
      $canv->createRectangle($xAnchor,$yAnchor,$x,$y, -outline=>'gray', -tag=>"rbb");
  }
  
 }
 
sub BtnRelease {
  
  my ($canv, $x, $y) = @_;
  my @coord;
  my $xw;
  my $yw;
  
  my $x1;
  my $x2;
  my $y1;
  my $y2;
  
  my $xw1;
  my $xw2;
  my $yw1;
  my $yw2;
  
  my $temp;
 
  
  $anchorSet=0;
  
  if($doZoomFlag==0) { return;}
  
  if($xAnchor > $x) {
           $x2=$xAnchor;
	   $x1=$x;
  } else {
           $x2=$x;
	   $x1=$xAnchor;
  }
   if($yAnchor < $y) {
           $y1=$yAnchor;
	   $y2=$y;
  } else {
           $y2=$yAnchor;
	   $y1=$y;
  } 
  $xw1=IIPDevToWx($curve_P,$x1);
  $yw1=IIPDevToWy($curve_P,$y1);
 
  $xw2=IIPDevToWx($curve_P,$x2);
  $yw2=IIPDevToWy($curve_P,$y2);
  
  
  
  if($xw1 > $xw2) { $temp=$xw2; $xw2=$xw1; $xw1=$temp}; 
  if($yw1 > $yw2) { $temp=$yw2; $yw2=$yw1; $yw1=$temp}; 

  
  $curve_P->{'minMaxZoom0'}=$xw1;
  $curve_P->{'minMaxZoom1'}=$yw1;

  $curve_P->{'minMaxZoom2'}=$xw2;
  $curve_P->{'minMaxZoom3'}=$yw2;
  
  $curve_P->{'zoomFlag'}=1;
  
  
  
  
  $doZoomFlag=0;
 
  
  DrawPlot($curve_P);
  
  
 } 
 
 
 sub ZoomOut {
  
  $curve_P->{'zoomFlag'}=0;
  $doZoomFlag=0;
  
  
  $xmin=$curve_P->{'minMax0'};
  $ymin=  $curve_P->{'minMax1'};
    
  $xmax=  $curve_P->{'minMax2'} ;
  $ymax=  $curve_P->{'minMax3'} ;
  
  
  
  DrawPlot($curve_P);
 
 }
 
 sub ZoomIn {
  
  $doZoomFlag=1;
 
 }
 
sub IIPBound() {
$curve_P=shift;
my 	$x=shift;;
my	$y=shift;
my @coord=(0,0);


	if($x < $curve_P->{'yOffsetLeft'}) { $x=$curve_P->{'yOffsetLeft'}; }
	if($x > $curve_P->{'width'}-$curve_P->{'yOffsetRight'}) {$x= $curve_P->{'width'}-$curve_P->{'yOffsetRight'}; }
	if($y > $curve_P->{'height'}-$curve_P->{'xOffsetBottom'}) { $y=$curve_P->{'height'}-$curve_P->{'xOffsetBottom'}; }
	if($y < $curve_P->{'xOffsetTop'}) {$y=$curve_P->{'xOffsetTop'};}

@coord=($x, $y);

}

sub CursorValue {
$curve_P=shift;
my 	$x=shift;;
my	$y=shift;
my @coord=(0,0);

my $xw;
my $yw;

my $xsci;
my $ysci;

my $strBuf;

	$xw = IIPDevToWx($curve_P, $x);
	$yw = IIPDevToWy($curve_P, $y);


        $xsci=$ysci=0;
        if(fabs($xw)<1.0 || fabs($xw) >100000.0) { $xsci=1; }
   	if(fabs($yw)<1.0 || fabs($yw) >100000.0) { $ysci=1; }
	if($xsci && $ysci) {
		$strBuf= sprintf("%e   %e",$xw,$yw);
	}
	if(!$xsci && $ysci) {
		$strBuf= sprintf("%10.2f   %e",$xw,$yw);
	}
	if($xsci && !$ysci) {
		$strBuf= sprintf("%e   %10.2f",$xw,$yw);
	}
	if(!$xsci && !$ysci) {
		$strBuf= sprintf("%10.2f   %10.2f",$xw,$yw);
	}

        print "CURSOR=> $strBuf","\n";
}


sub IIPDevToWx() {
my $curve_P=shift;
my $xd=shift;


my $xmin;
my $xmax;
my $xw;

if ($curve_P->{'zoomFlag'}==1) {
              $xmin = $curve_P->{'minMaxZoom0'};
              $xmax = $curve_P->{'minMaxZoom1'};

} elsif($curve_P->{'fixedFlag'}==1) {
              $xmin = $curve_P->{'minMaxFixed0'};
              $xmax = $curve_P->{'minMaxFixed1'};
} else {
	$xmin=$curve_P->{'minMaxAdj0'};
	$xmax=$curve_P->{'minMaxAdj1'};
}

$xw= ($xd-$curve_P->{'dev0'})*($xmax-$xmin)/($curve_P->{'dev1'}) + $xmin;


return($xw);
}


#/********************************************************************
# * Convert from device (x window) coordinates to world coordinates  *
# ********************************************************************/

sub IIPDevToWy() {
my 	$curve_P=shift;
my	$yd=shift;

my  $ymin;
my  $ymax;
my  $yw;

if ($curve_P->{'zoomFlag'}) {
              $ymin = $curve_P->{'minMaxZoom2'};
              $ymax = $curve_P->{'minMaxZoom3'};

} elsif($curve_P->{'fixedFlag'}) {
              $ymin = $curve_P->{'minMaxFixed2'};
              $ymax = $curve_P->{'minMaxFixed3'};
} else {
	$ymin=$curve_P->{'minMaxAdj2'};
	$ymax=$curve_P->{'minMaxAdj3'};
}

$yw= ($curve_P->{'dev2'}-$yd)*($ymax-$ymin)/($curve_P->{'dev3'}) + $ymin;

return($yw);

}

sub PlotCurves() {

my $ydconj;
my $radial;

	
if($curve_P->{'plotType'}==$PLOT_REGULAR_LINE || $curve_P->{'plotType'}==$PLOT_POLAR_LINEAR || $curve_P->{'plotType'}==$PLOT_POLAR_DB) {

        if($curve_P->{'plotType'}== $PLOT_POLAR_LINEAR) {
	    $xval=$x_A[$i]*cos($y_A[0]);
	    $yval=$x_A[$i]*sin($y_A[0]);

	    $yprev=IIPwToDevy($curve_P,$xval);
	    $xprev=IIPwToDevx($curve_P,$yval);

	
	} elsif($curve_P->{'plotType'}== $PLOT_POLAR_DB) {
	 
			$radial=$x_A[0];
			if($radial < $curve_P->{'polarPlotMin'}) { $radial=$curve_P->{'polarPlotMin'};}
			     ($xprev,$yprev)=IIPwToDevPolarDB($curve_P,$radial,$y_A[0]);
			       
	 
	 
	}else{
            $yprev=IIPwToDevy($curve_P,$y_A[0]);
	    $xprev=IIPwToDevx($curve_P,$x_A[0]);
	}

    for($i=1; $i <$curve{'points'}; $i++) {
    
        if($curve_P->{'plotType'}== $PLOT_POLAR_LINEAR) {
	    $xval=$x_A[$i]*cos($y_A[$i]);
	    $yval=$x_A[$i]*sin($y_A[$i]);

	    $yd=IIPwToDevy($curve_P,$xval);
	    $xd=IIPwToDevx($curve_P,$yval);

	
	} elsif($curve_P->{'plotType'}== $PLOT_POLAR_DB) {
	 
			$radial=$x_A[$i];
			if($radial < $curve_P->{'polarPlotMin'}) { $radial=$curve_P->{'polarPlotMin'};}
			     ($xd,$yd)=IIPwToDevPolarDB($curve_P,$radial,$y_A[$i]);
			       
	 
	 
	} else {
            $yd=IIPwToDevy($curve_P,$y_A[$i]);
	    $xd=IIPwToDevx($curve_P,$x_A[$i]);
	}
	XDrawLine($image,$xprev,$yprev,$xd,$yd,$curve_P->{'curveColor'});
	if($curve_P->{'marker'} > 0) {
	    XDrawMarker($image,$xd,$yd,$curve_P->{'marker'} ,$curve_P->{'curveColor'});
	}
	
	$xprev=$xd;
	$yprev=$yd;
	

    }

}elsif ($curve_P->{'plotType'}==$PLOT_SCATTER) {
     $yprev=IIPwToDevy($curve_P,$y_A[0]);
     $xprev=IIPwToDevx($curve_P,$x_A[0]);


    for($i=0; $i <$curve{'points'}; $i++) {
        $yd=IIPwToDevy($curve_P,$y_A[$i]);
	$xd=IIPwToDevx($curve_P,$x_A[$i]);
	$image->rectangle($xd,$yd,$xd+1,$yd+1,$curve_P->{'curveColor'});
	

    }

}elsif ($curve_P->{'plotType'}==$PLOT_BARS) {
     $yprev=IIPwToDevy($curve_P,$y_A[0]);
     $xprev=IIPwToDevx($curve_P,$x_A[0]);


    my $yZero = IIPwToDevy($curve_P,0.0);
    my $rectHeight;
    my $rectWidth=1;
    
    XDrawLine($image,$curve_P->{'yOffsetLeft'},$yZero,$curve_P->{'width'}-$curve_P->{'yOffsetRight'},$yZero, $curve_P->{'curveColor'});

    for($i=0; $i <$curve{'points'}; $i++) {
    
        $yd=IIPwToDevy($curve_P,$y_A[$i]);
	$xd=IIPwToDevx($curve_P,$x_A[$i]);
   
    
        $rectHeight=abs($yZero-$yd);
	if ($yd > $yZero) { $yd=$yZero; };
 	$image->filledRectangle($xd,$yd,$xd+$rectWidth,$yd+$rectHeight,$curve_P->{'curveColor'});
	

    }
}elsif ($curve_P->{'plotType'}==$PLOT_EYE_DIAGRAM) {
     $yprev=IIPwToDevy($curve_P,$y_A[0]);
     $xprev=IIPwToDevx($curve_P,$x_A[0]);


    for($i=1; $i <$curve{'points'}; $i++) {
        $yd=IIPwToDevy($curve_P,$y_A[$i]);
	

        $xval=$x_A[$i]% $curve_P->{'decimInterval'};
	
	$xd=IIPwToDevx($curve_P,$xval);
        if($i % 	$decimPoints) {		
	   XDrawLine($image,$xprev,$yprev,$xd,$yd,$curve_P->{'curveColor'});
	   $xprev=$xd;
	   $yprev=$yd;
        } else {	$xprev=$xd;$yprev=$yd;}
	

    }


}elsif ($curve_P->{'plotType'} == $PLOT_MULTI_COLUMN) {
	$xc=$mc_A[0];
        @xc_A=@$xc;

   
   for($i=1; $i<$curve_P->{'numberColumns'}; $i++) {
           $yc=$mc_A[$i];
           @yc_A=@$yc;
        $xval=$xc_A[0];
	$yval=$yc_A[0];
	
	$yprev=IIPwToDevy($curve_P,$yval);
	$xprev=IIPwToDevx($curve_P,$xval);

        for($j=1; $j<$points; $j++) {
	    $yval=$yc_A[$j];
	    $xval=$xc_A[$j];
	    $yd=IIPwToDevy($curve_P,$yval);
	    $xd=IIPwToDevx($curve_P,$xval);
	    XDrawLine($image,$xprev,$yprev,$xd,$yd,$colors_A[$i % $MAX_MULTI_COLUMNS +1]);
	    
            if($curve_P->{'marker'} > 0) {
	        XDrawMarker($image,$xd,$yd,($i % $NUMBER_OF_MARKERS)+1 ,$colors_A[$i % $MAX_MULTI_COLUMNS +1]);
	    }
    
	    
	    $xprev=$xd;
	    $yprev=$yd;
	
	}
 
   }
} elsif ($curve_P->{'plotType'} == $PLOT_POLE_ZERO) {

     IIP_DrawCircle($curve_P,$image,0.0,0.0,1.0, $red);
     for ($i=0; $i<=$#pzLinkedList; $i++) {
        my $pz1=$pzLinkedList[$i];
	my %pz=%$pz1;
	    $xd=IIPwToDevx($curve_P,%pz->{'realPart'});
	    $yd=IIPwToDevy($curve_P,%pz->{'imagPart'});
	    $ydconj=IIPwToDevy($curve_P,-%pz->{'imagPart'});
	    if(%pz->{'typeFlag'}==$CMPLX_POLE || %pz->{'typeFlag'}== $REAL_POLE) {
	    
	          DrawPole($image,$xd,$yd,$curve_P->{'curveColor'});
		  if(%pz->{'typeFlag'}==$CMPLX_POLE) { DrawPole($image,$xd,$ydconj,$curve_P->{'curveColor'});}
	    
	    } else {
	    
	          DrawZero($image,$xd,$yd,$curve_P->{'curveColor'});
	          if(%pz->{'typeFlag'}==$CMPLX_ZERO) {DrawZero($image,$xd,$ydconj,$curve_P->{'curveColor'});}
	    }
	    
	    
	    
	
        
   
     }    
     
     
     
     



}elsif ($curve_P->{'plotType'} == $PLOT_POLAR_DB) {





}


}


sub GetAxisEndPoints() {

if($curve_P->{'plotType'}== $PLOT_POLAR_DB) { return; }

if($curve_P->{'zoomFlag'}==1) {

         $xmin=$curve_P->{'minMaxZoom0'};
	 $ymin=$curve_P->{'minMaxZoom1'};
	 
	 $xmax=$curve_P->{'minMaxZoom2'};
	 $ymax=$curve_P->{'minMaxZoom3'};
	 


} else {

        $xmin=$curve_P->{'minMax0'};
	 $ymin=$curve_P->{'minMax1'};
	 
	 $xmax=$curve_P->{'minMax2'};
	 $ymax=$curve_P->{'minMax3'};


}


$axisAdjx_P= AxisEndPoints($xmin,$xmax,$xlogFlag,$curve_P->{'xUserEndpoint0'},$curve_P->{'xUserEndpoint1'},$curve_P->{'zoomFlag'});


%axisAdjx=%$axisAdjx_P;

@endPoints= ($axisAdjx{'endPointBegin'},$axisAdjx{'endPointEnd'});
$curve_P->{'xendPointsMax'}=$axisAdjx{'endPointEnd'};
$curve_P->{'xtickNum'}=$axisAdjx{'tickNum'};





$endPoints[0]= $endPoints[0]*$axisAdjx{'adjust'};
$endPoints[1]= $endPoints[1]*$axisAdjx{'adjust'};


	$curve_P->{'minMaxAdj0'}=$endPoints[0];
	$curve_P->{'minMaxAdj1'}=$endPoints[1];





$axisAdjy_P= AxisEndPoints($ymin,$ymax,$ylogFlag,$curve_P->{'yUserEndpoint0'},$curve_P->{'yUserEndpoint1'},$curve_P->{'zoomFlag'});


%axisAdjy=%$axisAdjy_P;

@endPoints= ($axisAdjy{'endPointBegin'},$axisAdjy{'endPointEnd'});



$endPoints[0]= $endPoints[0]*$axisAdjy{'adjust'};
$endPoints[1]= $endPoints[1]*$axisAdjy{'adjust'};

	$curve_P->{'minMaxAdj2'}=$endPoints[0];
	$curve_P->{'minMaxAdj3'}=$endPoints[1];


}



sub FindMinMax() {

if($curve_P->{'zoomFlag'}==1) {

         $xmin=$curve_P->{'minMaxZoom0'};
	 $ymin=$curve_P->{'minMaxZoom1'};
	 
	 $xmax=$curve_P->{'minMaxZoom2'};
	 $ymax=$curve_P->{'minMaxZoom3'};
	 
	 return;


}

$xmax=-1e22;
$xmin=1e22;

$ymax=-1e22;
$ymin=1e22;

if($curve_P->{'plotType'} == $PLOT_MULTI_COLUMN) {
   for($j=0; $j<$points; $j++) {
        for($i=1; $i<$curve_P->{'numberColumns'}; $i++) {
             $yc=$mc_A[$i];
            @yc_A=@$yc;
	    if($yc_A[$j] > $ymax) { $ymax=$yc_A[$j];}
	    if($yc_A[$j] < $ymin) { $ymin=$yc_A[$j]}
	    
        }
	$yc=$mc_A[0];
        @yc_A=@$yc;

	$xx=$yc_A[$j];
        if($xx > $xmax) { $xmax=$xx;}
        if($xx < $xmin ) {$xmin=$xx; }
     
       
      
   }
} else {


   foreach $yy (@y_A) {
      if($yy > $ymax) { $ymax=$yy;}
      if($yy < $ymin ) {$ymin=$yy; }
 
   }

   foreach $xx (@x_A) {
       if($xx > $xmax) { $xmax=$xx;}
       if($xx < $xmin ) {$xmin=$xx; }
 

   }
}
if($curve_P->{'decimFlag'} ==1 ) {
     $decimPoints=$curve_P->{'points'}/($xmax -$xmin)*$curve_P->{'decimInterval'};
     $numOverlays= $curve_P->{'points'}/$decimPoints-1;
     
     $userEndPoints_A[0]=0.0;
     $userEndPoints_A[1]=0.0;
     
     $xmin=0.0;
     $xmax=$curve_P->{'decimWidth'};


}


if($xlogFlag == 1) {

$curve_P->{'xType'} =$IIP_AXIS_LOG;
  $xmax = log10($xmax);
  $xmin=log10($xmin);

}


if($ylogFlag == 1) {


$curve_P->{'yType'} =$IIP_AXIS_LOG;

  $ymax = log10($ymax);
  $ymin=log10($ymin);

}
if ($curve_P->{'plotType'}==$PLOT_POLAR_DB) {

    $curve_P->{'minMax0'} = $curve_P->{'polarPlotMin'};
    $curve_P->{'minMax1'} = $curve_P->{'polarPlotMax'};
    
    $curve_P->{'minMax2'} = $curve_P->{'minMax0'};
    $curve_P->{'minMax3'} = $curve_P->{'minMax1'};
    
    
    



} elsif ($curve_P->{'plotType'}==$PLOT_POLAR_LINEAR) {
   $curve_P->{'minMax0'} = - $xmax;
    $curve_P->{'minMax1'} = -$xmax;
    
    $curve_P->{'minMax2'} = $xmax;
    $curve_P->{'minMax3'} = $xmax;
    
    $curve_P->{'polarPlotMin'} = 0.0;
    $curve_P->{'polarPlotMax'} = $xmax;
   

} else {

    $curve_P->{'minMax0'} = $xmin;
    $curve_P->{'minMax1'} = $ymin;
    
    $curve_P->{'minMax2'} = $xmax;
    $curve_P->{'minMax3'} = $ymax;
    
}  

}



sub ReadDataFromFile() {

my $fileName=shift;


open DATA, $fileName or die "Couldn't open: $!";



if($curve_P->{'plotType'} == $PLOT_REGULAR_LINE || $curve_P->{'plotType'} == $PLOT_SCATTER ||
                          $curve_P->{'plotType'} == $PLOT_EYE_DIAGRAM || 
			  $curve_P->{'plotType'} == $PLOT_BARS || 
			  $curve_P->{'plotType'} == $PLOT_POLAR_LINEAR ||
			  $curve_P->{'plotType'} == $PLOT_POLAR_DB  ) {
   while(<DATA>) {
      split;
      if($#_ == 1) { push(@x_A,$_[0]);push(@y_A,$_[1]);} else {push(@x_A,$points);push(@y_A,$_[0]);};
   
      $points++;
   
   }
   $curve{'points'}=$points;
} elsif($curve_P->{'plotType'} == $PLOT_MULTI_COLUMN) {
   $firstLine=1;
   $points=0;
   while(<DATA>) {
      if($firstLine ==1) {
          $firstLine=0;
	  split;
	  $curve_P->{'numberColumns'}=$#_+1;
	  for($i=0; $i<$curve_P->{'numberColumns'}; $i++) {
	       push(@mcTitles_A,$_[$i]);
	  }
	  
      
      } else {
         split;
	 for($i=0; $i<$curve_P->{'numberColumns'}; $i++) {
	     if($i==0) {push(@yc1, $_[$i]);}
	     elsif($i==1) {push(@yc2, $_[$i]);}
	     elsif($i==2) {push(@yc3, $_[$i]);}
	     elsif($i==3) {push(@yc4, $_[$i]);}
	     elsif($i==4) {push(@yc5, $_[$i]);}
	     elsif($i==5) {push(@yc6, $_[$i]);}
	     elsif($i==6) {push(@yc7, $_[$i]);}
	     elsif($i==7) {push(@yc8, $_[$i]);}
	     elsif($i==8) {push(@yc9, $_[$i]);}
	     elsif($i==9) {push(@yc10, $_[$i]);}
	     elsif($i==10) {push(@yc11, $_[$i]);}
	     elsif($i==11) {push(@yc12, $_[$i]);}
	     elsif($i==12) {push(@yc13, $_[$i]);}
	     elsif($i==13) {push(@yc14, $_[$i]);}
	     elsif($i==14) {push(@yc15, $_[$i]);}
	     	  
	     
	     
	     
	    
	 }
             
	 
   
         $points++;
      }
   
   }
   for($i=0; $i<$curve_P->{'numberColumns'}; $i++) {
#       print $mcTitles_A[$i],"\t";
   }
#   print "\n";
   for($j=0; $j<$points; $j++) {
        for($i=0; $i<$curve_P->{'numberColumns'}; $i++) {
       
            $yc=$mc_A[$i];
            @yc_A=@$yc;
#	    print $yc_A[$j],"\t";
       }
#       print "\n";
       
      
   }
   $curve{'points'}=$points;

}elsif($curve_P->{'plotType'} == $PLOT_POLE_ZERO) {
   my $first=0;
   $_=<DATA>;
   split;
   $numberZeroes=$_[0];
   $numberPoles=$_[1];
   
   for($i=0; $i<$numberZeroes; $i++) {
       
       $_=<DATA>;
       split; 
       if($_[1] <0 ) {$_[1]= - $_[1]; }
       if($_[1]!=0) { $pztype=$CMPLX_ZERO; } else { $pztype=$REAL_ZERO; }
       my %pzel=(realPart=>$_[0],imagPart=>$_[1], typeFlag=>$pztype);
       push(@pzLinkedList,\%pzel);
       
   }
   for($i=0; $i<$numberPoles; $i++) {
       
       $_=<DATA>;
       split; 
       if($_[1] <0 ) {$_[1]= - $_[1]; }
       if($_[1]!=0) { $pztype=$CMPLX_POLE; } else { $pztype=$REAL_POLE; }

       my %pzel=(realPart=>$_[0],imagPart=>$_[1],typeFlag=>$pztype);
       push(@pzLinkedList,\%pzel);
       
   }   
  # print "CHECKING POLE-ZEROES  total=$#pzLinkedList zeroes=$numberZeroes  poles=$numberPoles","\n";
   for ($i=0; $i<=$#pzLinkedList; $i++) {
        my $pz1=$pzLinkedList[$i];
	my %pz=%$pz1;
  #      print "type=",%pz->{'typeFlag'}," real=",%pz->{'realPart'},  "imag=",%pz->{'imagPart'},"\n";
        
   
   }
}

close(DATA);



}



 #
 # Draw Axis, Title and Labels
 #
 
 sub DrawAxisTitleLabels() {
 
 my $curve_P=shift;
 
 my $angle;
 my $xrgrid;
 my $yrgrid;
 my $xdev;
 my $ydev;
 my $xcenter;
 my $ycenter;
 my @dev_A=(0,0);
 my @center_A=(0,0);
 my $ytickNum;
 my $xtickNum;
 
 my $delta;


 
 
	


$image->filledRectangle(0,0,$curve{'yOffsetLeft'},$curve{'height'},$plotExterior);
$image->filledRectangle($curve{'width'}-$curve{'yOffsetRight'},0,$curve{'width'},$curve{'height'},$plotExterior);
$image->filledRectangle(0,0,$curve{'width'}-$curve{'yOffsetRight'},$curve{'xOffsetTop'},$plotExterior);
$image->filledRectangle(0,$curve{'height'}-$curve{'xOffsetBottom'},$curve{'width'},$curve{'height'},$plotExterior);	

# $curve_P=shift;
# $image=shift;
# $yendPointBegin=shift;
# $yendPointEnd=shift;
# $adjust=shift;
# $tickNum=shift;
# $height=shift;
# $width=shift;
# $showRight=shift;
# $majFWidth=shift;
# $gridFlag=shift;
# $gridColor=shift;
# $format=shift;
# $type=shift;
# $ylogFlag=shift;

if($curve_P->{'plotType'}== $PLOT_POLAR_DB) {
      DrawAxisLabelsPolarDB($curve_P,$image);

}else {	
   DrawXAxis($curve_P,$image,$axisAdjx{'endPointBegin'},$axisAdjx{'endPointEnd'},
            $axisAdjx{'adjust'},$axisAdjx{'tickNum'} ,$curve_P->{'height'},$curve_P->{'width'},
	    1,$curve_P->{'xFMT'},$curve_P->{'xGrid'},$curve_P->{'gridColor'},$curve_P->{'xFXP'}, 1,$xlogFlag);

   DrawYAxis($curve_P,$image,$axisAdjy{'endPointBegin'},$axisAdjy{'endPointEnd'},
            $axisAdjy{'adjust'},$axisAdjy{'tickNum'} ,$curve_P->{'height'},$curve_P->{'width'},
	    1,$curve_P->{'yFMT'},$curve_P->{'yGrid'},$curve_P->{'gridColor'},$curve_P->{'yFXP'}, 1,$ylogFlag);

}
	    
			    
my $legTxtWidth=0;
my $len;
my $legLenMax=0;
my $fontw=gdSmallFont->width;
			    	    
if ($curve_P->{'plotType'} == $PLOT_MULTI_COLUMN) {
     for($i=1; $i<$curve_P->{'numberColumns'}; $i++) {
         $legTxtWidth=length($mcTitles_A[$i])*$fontw;
	 if($legLenMax < $legTxtWidth) { $legLenMax=$legTxtWidth; }
     }

	    $image->filledRectangle($curve_P->{'width'}-$legendx-5,$legendy-10,
	                    $curve_P->{'width'}-$legendx+$legendw+$legLenMax+5,
			    $legendy+$legendd*$curve_P->{'numberColumns'}-10,$plotExterior);

	    $image->rectangle($curve_P->{'width'}-$legendx-5,$legendy-10,
	                    $curve_P->{'width'}-$legendx+$legendw+$legLenMax+5,
			    $legendy+$legendd*$curve_P->{'numberColumns'}-10,$curve_P->{'axisColor'});



  for($i=1; $i<$curve_P->{'numberColumns'}; $i++) {
	    XDrawLine($image,$curve_P->{'width'}-$legendx,$legendy+$legendd*($i-1),
	                    $curve_P->{'width'}-$legendx+$legendw,$legendy+$legendd*($i-1),$colors_A[$i % $MAX_MULTI_COLUMNS +1]);
	    
            if($curve_P->{'marker'} > 0) {
	        XDrawMarker($image,$curve_P->{'width'}-$legendx+$legendw/2,$legendy+$legendd*($i-1),($i % $NUMBER_OF_MARKERS)+1 ,$colors_A[$i % $MAX_MULTI_COLUMNS +1]);
	    }
	    
	    XDrawString($image,$curve_P->{'width'}-$legendx+$legendw+2,$legendy+$legendd*($i-1)-5,$mcTitles_A[$i],$curve_P->{'labelColor'});
	    
 
  }
 
}
#
# Draw the Title
#
my $length;
$length=length($curve_P->{'title'});
$length=$length*gdSmallFont->width;
	    XDrawString($image,$curve_P->{'width'}/2-$length/2,$curve_P->{'xOffsetTop'}/2,$curve_P->{'title'},$curve_P->{'titleColor'});
#
# Draw x axis label 
#

$length=length($curve_P->{'xLabel'});
$length=$length*gdSmallFont->width;
	    XDrawString($image,$curve_P->{'width'}/2-$length/2,$curve_P->{'height'}-$curve_P->{'xOffsetBottom'}/2,
	                               $curve_P->{'xLabel'},$curve_P->{'labelColor'});
	    

				       #
# Draw y axis label 
#

$length=length($curve_P->{'yLabel'});
$length=$length*gdSmallFont->width;
	    XDrawStringUp($image,$curve_P->{'yOffsetLeft'}/2-20,($curve_P->{'height'}-$curve_P->{'xOffsetBottom'}-$curve_P->{'xOffsetTop'})/2 +$curve_P->{'xOffsetTop'}+$length,
	                               $curve_P->{'yLabel'},$curve_P->{'labelColor'});

				       
				       
	#
	# do grids for linear polar plots
	# note: the user end points depends on the values calculated for the
	# x axis which is the radial coordinate. Also the number of ticks was derived from x axis
	#
   if($curve_P->{'plotType'}== $PLOT_POLAR_LINEAR ) {
	for ($i = 0 ; $i < $curve_P->{'xtickNum'} ; $i++) {
	     IIP_DrawCircle($curve_P,$image,0.0,0.0,$curve_P->{'xendPointsMax'}/$curve_P->{'xtickNum'}*($i+1),$curve_P->{'axisColor'});
	}
	if ($curve_P->{'polarTicks'} > 0) {
		$ytickNum = $curve_P->{'polarTicks'};
	} else {
		$ytickNum=8;
	}
	for ($i = 0 ; $i < $ytickNum+1 ; $i++) {
		$angle=360.0*$i/$ytickNum*$PI/180.0;
		$xrgrid=$curve_P->{'xendPointsMax'}*cos($angle);
		$yrgrid=$curve_P->{'xendPointsMax'}*sin($angle);
		$xdev= IIPwToDevx($curve_P,$xrgrid);
		$ydev= IIPwToDevy($curve_P,$yrgrid);
		$xcenter= IIPwToDevx($curve_P,0.0);
		$ycenter= IIPwToDevy($curve_P,0.0);
   	        XDrawLine($image,$xcenter,$ycenter,$xdev,$ydev,$curve_P->{'axisColor'});
		


	}
  } elsif ($curve_P->{'plotType'}== $PLOT_POLAR_DB) {
  	#
	# do grids for db polar plots
	# note: the user end points depends on the values calculated for the
	# x axis which is the radial coordinate. Also the number of ticks was derived from x axis
	#
	
	
	if($curve_P->{'polarTicksx'}>0) {
		$xtickNum=$curve_P->{'polarTicksx'};
	} else {
		$xtickNum=5;
		
	}
	$delta=($curve_P->{'polarPlotMax'}-$curve_P->{'polarPlotMin'})/$xtickNum;
	for ($i = 0 ; $i < $xtickNum ; $i++) {
		 IIP_DrawCircleDB($curve_P,$image,$xtickNum,($i+1));
	}
	if ($curve_P->{'polarTicks'}>0) { 
		$ytickNum = $curve_P->{'polarTicks'};
	} else {
		$ytickNum=8;
	}
	
	for ($i = 0 ; $i < $ytickNum+1 ; $i++) {
		$angle=2*$i/$ytickNum*$PI;
		@dev_A=IIPwToDevPolarDB($curve_P,$curve_P->{'polarPlotMax'},$angle);
		@center_A=IIPwToDevPolarDB($curve_P,$curve_P->{'polarPlotMin'},$angle);
   	        XDrawLine($image,$center_A[0],$center_A[1],$dev_A[0],$dev_A[1],$curve_P->{'axisColor'});

	}
	
	

  }

				       
				       
				       
				       
 }
 
 
     
      
#
#  AxisEndPoints()
#
#  description:
#    Calculate endpoints and tickspacing for axis.
#
#
sub AxisEndPoints()
			    
{

my $DR_GKS_ZERO_LEVEL=1e-14;
my $DR_GKS_DENSE_LOG=15;
my $MAXPTS=5;
my $FALSE=0;
my $TRUE=1;

			    
my $xmin=shift;
my $xmax=shift;
my $axisType=shift;


my  $userEndPts0=shift;
my  $userEndPts1=shift;

my $zoomFlag=shift;


my  $adjust=0.0;
my  $offset=0.0;
my  @endPoints_A= (0.0,0.0);
my  $tackFlag=0;
my  $tickNum=0;
my  @minMax_A=($xmin, $xmax);
my $sw;


    my $i=0;			

    my $x=0.0;
    my $y=0.0;
    my $z=0.0;
    my $tickSpacing=0.0; #tick spacing
    my $fudge=0.0;   #amt to fudge axis by
    my $default=0;	
    
     
 
    #
    #  First adjust for range insignificance.
    #
    if (($xmax - $xmin) <= $DR_GKS_ZERO_LEVEL) {
        if ($xmin != 0)
        {
            $fudge = pow(10.0, float(int(log($xmin)/log(10.0))));
            $xmin -= $fudge;
            $xmax += $fudge;
        }
        else
        {
            $xmin = -1.0;
            $xmax = 1.0;
        }

    }

    #
    #  First check axis type flag to see if it is linear or log.
    #
    if ($axisType==1)
    {
        #
        #  Log axis.
        #
        #  Round log axis ends to the nearest integer multiple.
        #  Set tack marks true only if range of ticks falls below the
        #  too dense boundary DR_GKS_DENSE_LOG.
        #

        for ($i = 0; $i < 2; $i++) {
            $endPoints_A[$i] = (int( $minMax_A[$i]) == $minMax_A[$i] ?
                              $minMax_A[$i] : int ($minMax_A[$i]) + $i);
	}

        $tackFlag = ($endPoints_A[1] - $endPoints_A[0] < $DR_GKS_DENSE_LOG) ?
                     $TRUE : $FALSE;

        $adjust = 1.0;
        $offset = 0.0;
	$tickNum = int((($endPoints_A[1] - $endPoints_A[0]) + 0.5));
	
    }
    else
    {
        #
        #  Linear axis.  Default to no tack marks.
        #  User specified end points override automatic endpoint calculation.
        #
        $tackFlag = $FALSE;

        if ( $zoomFlag==1  ) {
            $x = $xmax - $xmin;
	    
	} elsif($userEndPts0== $userEndPts1) {
	     $x = $xmax - $xmin;
	     
	}
        else
        {
            $endPoints_A[0] = $userEndPts0;
            $endPoints_A[1] = $userEndPts1;
            $x = $userEndPts1 - $userEndPts0;
        }

        $y = log($x)/log(10.0);
        if ($y == float((int($y))) || $y >= 0) {
            $adjust = pow(10.0, float(int($y)));
	}
        else {
            $adjust = pow(10.0, float(int(($y - 1.0))));
        }
	
	
	
	
        #
        #  Calculate linear tick spacing to be either by 1's, 2's or 5's.
        #
	$default=1;
        $sw=int(($x / ($adjust)));
	if($sw==1) {$tickSpacing = .2 * ($adjust); $default=0;}
	if($sw==2) {$tickSpacing = .5 * ($adjust);$default=0;}
	if($sw==3) {$tickSpacing = .5 * ($adjust);$default=0;}
	if($sw==4) {$tickSpacing = .5 * ($adjust);$default=0;}
	if($sw==5) {$tickSpacing = .5 * ($adjust);$default=0;}
	
	if($default ==1 ) {
                $tickSpacing = $adjust;
	}
     

        if ($userEndPts0 == $userEndPts1 || $zoomFlag==1)
        {
            #
            #  Round linear axis ends to the nearest integer multiple of the
            #  tick spacing.
            #
            $x = $xmin / $tickSpacing;
            $y = $xmax / $tickSpacing;

            $endPoints_A[0] = ($x == int($x) ? $xmin :
                           ($tickSpacing * ($xmin >= 0 ?
                           int($x) : (int($x) - 1))));
            $endPoints_A[1] = ($y == int($y) ? $xmax :
                           ($tickSpacing * ($xmax >= 0 ?
                           (int($y) + 1) : int($y))));
        }
        #
        #  Set number of ticks as length of axis / tick spacing.
        #  Use a rounding function to avoid small data representation errors.
        #
        $z = $endPoints_A[1] - $endPoints_A[0];
        $tickNum = int((($z / $tickSpacing) + 0.5));

        #
        #  Adjust endpoints.  (Manual normalization.)
        #
        $endPoints_A[0] /= $adjust;
        $endPoints_A[1] /= $adjust;
        #
        #  Calculate offset value if necessary.
        #
 #       $offset = CalculateOffset(@endPoints_A);
	#
	# ignore for now
	#
	$offset =0.0;

        $endPoints_A[0] -= $offset;
        $endPoints_A[1] -= $offset;
    	if ($tickNum > $MAXPTS) {
		$tickNum = $MAXPTS;
	}
    }

my %axisAdj=(endPointBegin=>$endPoints_A[0],endPointEnd=>$endPoints_A[1],adjust=>$adjust,tackFlag=>$tackFlag,tickNum=>$tickNum,tickSpacing=>$tickSpacing);


$axisAdj{'endPointBegin'}= $endPoints_A[0];
$axisAdj{'endPointEnd'}= $endPoints_A[1];
$axisAdj{'adjust'}= $adjust;
$axisAdj{'tackFlag'}= $tackFlag;
$axisAdj{'tickNum'}= $tickNum;

 
my @endPoints2= $axisAdj{'endPoints'};
my $tackFlag2=$axisAdj{'tackFlag'};
my $tickNum2=$axisAdj{'tickNum'};
my $tickSpacing=$axisAdj{'tickSpacing'};

 
   
     
   return \%axisAdj;     
  

}    

sub float { my $x=shift; return $x};
sub pow { my $base=shift; my $power=shift; return $base ** $power; }
sub log10 { my $x=shift; return log($x)/log(10.0)};

#
# Draw X Axis
#

sub DrawXAxis {


my $curve_P=shift;
my $image=shift;
my $xendPointBegin=shift;
my $xendPointEnd=shift;
my $adjust=shift;
my $tickNum=shift;
my $height=shift;
my $width=shift;
my $showTop=shift;
my $majFWidth=shift;
my $gridFlag=shift;
my $gridColor=shift;
my $format=shift;
my $type=shift;
my $xlogFlag=shift;

my $i=0;
my $j=0;
my $xt=0.0;
my $temp=0.0;
my $yOffsetLeft=$curve_P->{'yOffsetLeft'};
my $xOffsetBottom=$curve_P->{'xOffsetBottom'};
my $xOffsetTop=$curve_P->{'xOffsetTop'};

my $yOffsetRight=$curve_P->{'yOffsetRight'};

my $bottomMargin=$xOffsetBottom;


my $xText=0.0;
my $yText=0.0;
my $fontAscent=10;

my $tt=0;
my $xdiff=0.0;
my $spacing=0.0;

my $strBuf="";
my $s="";

my $textWidth=0;
my $textHeight=0;

   


my @axTac_A=(0,0,0,0,0,0,0,0,0,0,0,0,0,0);

my @endPoints_A= ($xendPointBegin,$xendPointEnd);
my %curve=%$curve_P;

$yOffsetLeft=$curve{'yOffsetLeft'};
$yOffsetRight=$curve{'OffsetRight'};
$xOffsetBottom=$curve{'xOffsetBottom'};
$yOffsetRight=$curve{'yOffsetRight'};
my $X_AXIS_SIZE=$curve{'width'} - $yOffsetLeft-$yOffsetRight;


        #
	# draw line for axis
	#
	     XDrawLine($image,
			   $yOffsetLeft,
                           $curve_P->{'height'} -$xOffsetBottom,
			   $curve_P->{'width'} -$yOffsetRight,
                           $curve_P->{'height'}-$xOffsetBottom,$curve_P->{'axisColor'});
			   
	     if($showTop==1) {
	           XDrawLine($image,
			   $yOffsetLeft,
                           $xOffsetTop,
			   $curve_P->{'width'}-$yOffsetRight,
                           $xOffsetTop,$curve_P->{'axisColor'});
             }



        # 
	# calculate spacing between tic marks is x window coordinates
	#
	$temp = ($X_AXIS_SIZE) / $tickNum;
	#
	# if too small set tic marks to two
	#
	if($temp < 40) {
		$tickNum = 2;
		$temp = ($X_AXIS_SIZE)/$tickNum;
	}
	#
	# for log axis tic spacing is 1.0
	#
	if($xlogFlag) { $spacing = 1.0; }
	else {
		$spacing = ($endPoints_A[1] - $endPoints_A[0]) / $tickNum;
		my $t0=$endPoints_A[0];
		my $t1=$endPoints_A[1];
		
	}
#	$tt = $endPoints_A[1] - $xmax;
#	$xdiff = int(($tt*$temp) / $spacing);
 


	for ($i = 0 ; $i < $tickNum + 1; $i++)
	{
		#
		# draw tic mark lower axis
		#
		$xt=int($temp * $i + $yOffsetLeft);
		
		XDrawLine($image,$xt,$height-$xOffsetBottom,$xt,$height-$xOffsetBottom-$TICKSIZE, $curve_P->{'axisColor'} );
		
		

		#
		# draw tic mark upper axis
		#
		if($showTop==1) {
		    XDrawLine($image,$xt, 
			$xOffsetTop, $xt, 
			$xOffsetTop + $TICKSIZE, $curve_P->{'axisColor'});
		}
		if($xlogFlag==1 && $i < $tickNum) {
		   #
		   # for log axis display tach marks. Store in an array
		   # to use later in drawing grids
		   #
		   #
		   for($j=2; $j<10; $j++) {
			$axTac_A[$j-2] = int(log10($j)*$temp+ $temp*$i);
			$xt = $axTac_A[$j-2] + $yOffsetLeft;

		       XDrawLine($image,$xt,
			    $height-$xOffsetBottom, $xt, 
				$height-$xOffsetBottom -$TACSIZE, $curve_P->{'axisColor'} );

		    if($showTop==1) {
		       XDrawLine($image, $xt, $xOffsetTop, 
				$xt, $xOffsetTop + $TACSIZE, $curve_P->{'axisColor'});
		     }
		   }
		}
		elsif($xlogFlag==0  && $i< $tickNum) {
		   #
		   # 
		   # Minor divisions 
		   #
		   #
		   for($j=1; $j<5; $j++) {
			$axTac_A[$j-1] = int ($j*$temp/5.0+ $temp*$i);
			$xt=$axTac_A[$j-1] + $yOffsetLeft;

		       XDrawLine($image,$xt,
			    $height-$xOffsetBottom, $xt, 
				$height-$xOffsetBottom -$TACSIZE , $curve_P->{'axisColor'});

		       if($showTop==1) {
		            XDrawLine($image, 
				$xt, 
				$xOffsetTop, 
				$xt, 
				$xOffsetTop + $TACSIZE, $curve_P->{'axisColor'});
		       }
		   }
		}
		#
		# get major label floating point width
		#
		if($xlogFlag==1) { $majFWidth = 0; }
		if($majFWidth >= 0) { 
			$strBuf="%.".$majFWidth."f";
			$strBuf =~ s/ //;
		}
		else {
		        $strBuf="%.2f";
			
		}
	
	        if ($format == $IIP_FORMAT_FIX) {
			$s= sprintf($strBuf,($endPoints_A[0]*$adjust + ($spacing *$adjust* $i)));
		}
		else {
			$s=sprintf("%9.2e",($endPoints_A[0]*$adjust + ($spacing *$adjust* $i)));
		}

		if($xlogFlag==1) {
			XDrawString($image,
				int($temp * $i + $yOffsetLeft-15),
				$height-23,"10",$curve_P->{'labelColor'});
			XDrawString($image,
				int($temp * $i + $yOffsetLeft-3),
				$height-30,$s,$curve_P->{'labelColor'});
		}
		else {
			($textWidth, $textHeight)=(gdTinyFont->width,gdTinyFont->height);
			$textWidth=$textWidth*length($s);
			$xText=int($temp * $i + $yOffsetLeft- $textWidth/2); #-textWidth/2
			$yText= $height-$bottomMargin+$fontAscent+4;


						
			XDrawString($image,$xText,$yText,$s,$curve_P->{'labelColor'});
		}
	        if($gridFlag==1 && ($i<$tickNum)) {
		    #
		    # Draw the x axis grids
		    #
		    #SetColor($image,$gridColor);
		    if($type == $IIP_TYPE_POLAR) {
		    } else {
			 $xt=int($temp * $i + $yOffsetLeft);
		         XDrawLineDash($image,
                       		$xt,
				$xOffsetTop ,$xt,
                                $height-$xOffsetBottom, $curve_P->{'gridColor'});
		         #
		         # Draw the x axis log tach grids
		         #
		         if ($xlogFlag==1) {
			     for($j=0; $j< 8; $j++ ) { 
		               XDrawLineDash($image,
                       		     $axTac_A[$j] + $yOffsetLeft,$xOffsetTop ,
				     $axTac_A[$j] + $yOffsetLeft,
                                     $height-$xOffsetBottom, $curve_P->{'gridColor'});
		              }
		         }
		    }
		    #
		    # end of x axis grid
		    # 

                }
	
       }# end draw x axis 

}

#==============================

#
# Draw Y Axis
#

sub DrawYAxis {


my $TICKSIZE=10;
my $TACSIZE=5;
my $IIP_TYPE_POLAR=99;
my $IIP_FORMAT_FIX=1;

my $curve_P=shift;
my $image=shift;
my $yendPointBegin=shift;
my $yendPointEnd=shift;
my $adjust=shift;
my $tickNum=shift;
my $height=shift;
my $width=shift;
my $showRight=shift;
my $majFWidth=shift;
my $gridFlag=shift;
my $gridColor=shift;
my $format=shift;
my $type=shift;
my $ylogFlag=shift;

my $i=0;
my $j=0;
my $yt=0.0;
my $temp=0.0;
my $yOffsetLeft=$curve_P->{'yOffsetLeft'};
my $xOffsetBottom=$curve_P->{'xOffsetBottom'};
my $xOffsetTop=$curve_P->{'xOffsetTop'};

my $yOffsetRight=$curve_P->{'yOffsetRight'};



my $xText=0.0;
my $yText=0.0;
#my $bottomMargin=50;
#my $leftMargin=100;

my $bottomMargin=$xOffsetBottom;
my $leftMargin=$yOffsetLeft;




my $fontAscent=10;

my $tt=0;
my $xdiff=0.0;
my $spacing=0.0;

my $strBuf="";
my $s="";

my $textWidth=0;
my $textHeight=0;

my $Y_AXIS_SIZE=$height - $xOffsetTop-$xOffsetBottom;   
 

my @axTac_A=(0,0,0,0,0,0,0,0,0,0,0,0,0,0);

my @endPoints_A= ($yendPointBegin,$yendPointEnd);
my %curve=%$curve_P;

$yOffsetLeft=$curve{'yOffsetLeft'};
$yOffsetRight=$curve{'OffsetRight'};
$xOffsetBottom=$curve{'xOffsetBottom'};
$yOffsetRight=$curve{'yOffsetRight'};



	     XDrawLine($image,
			   $yOffsetLeft,
                           $height-$xOffsetBottom,
			   $yOffsetLeft,
                           $xOffsetTop,$curve_P->{'axisColor'});
	     if($showRight ==1) {
	           XDrawLine($image,
			   $width-$yOffsetRight,
                           $height-$xOffsetBottom,
			   $width-$yOffsetRight,
                           $xOffsetTop,$curve_P->{'axisColor'});

             }



        # 
	# calculate spacing between tic marks is x window coordinates
	#
	$temp = ($Y_AXIS_SIZE) / $tickNum;
	#
	# if too small set tic marks to two
	#
	if($temp < 40) {
		$tickNum = 2;
		$temp = ($Y_AXIS_SIZE)/$tickNum;
	}
	#
	# for log axis tic spacing is 1.0
	#
	if($ylogFlag) { $spacing = 1.0; }
	else {
		$spacing = ($endPoints_A[1] - $endPoints_A[0]) / $tickNum;
		my $t0=$endPoints_A[0];
		my $t1=$endPoints_A[1];
		
	}
 


	for ($i = 0 ; $i < $tickNum + 1; $i++)
	{
		#
		# draw tic mark lower axis
		#
		$yt=int($temp * $i + $xOffsetTop);
		
		XDrawLine($image,$yOffsetLeft,$yt,$yOffsetLeft+$TICKSIZE,$yt, $curve_P->{'axisColor'} );
		
		

		#
		# draw tic mark upper axis
		#
		if($showRight==1) {
		    XDrawLine($image,$width - $yOffsetRight -$TICKSIZE, 
			$yt, $width- $yOffsetRight, 
			$yt, $curve_P->{'axisColor'});
		}
		if($ylogFlag==1 && $i < $tickNum) {
		   #
		   # for log axis display tach marks. Store in an array
		   # to use later in drawing grids
		   #
		   #
		   for($j=2; $j<10; $j++) {
			$axTac_A[$j-2] = int(1.0- log10(11-$j)*$temp+ $temp*($i+1));
			

		       XDrawLine($image,
			    $yOffsetLeft, $axTac_A[$j-2] + $xOffsetTop, 
				$yOffsetLeft+$TACSIZE, $axTac_A[$j-2] + $xOffsetTop,$curve_P->{'axisColor'} );

		    if($showRight==1) {
		       XDrawLine($image, $width - $yOffsetRight -$TACSIZE,
				$axTac_A[$j-2] + $xOffsetTop,
				$width-$yOffsetRight,
				$axTac_A[$j-2] + $xOffsetTop,$curve_P->{'axisColor'});

		     }
		   }
		}
		elsif($ylogFlag==0  && $i< $tickNum) {
		   #
		   # 
		   # Minor divisions 
		   #
		   #
		   for($j=1; $j<5; $j++) {
			$axTac_A[$j-1] = int ($j*$temp/5.0+ $temp*$i);
			

		       XDrawLine($image,$yOffsetLeft,
				$axTac_A[$j-1] + $xOffsetTop,
				$yOffsetLeft+$TACSIZE,$axTac_A[$j-1] + $xOffsetTop , $curve_P->{'axisColor'});

		       if($showRight==1) {
		            XDrawLine($image, 
				$width - $yOffsetRight -$TACSIZE,
				$axTac_A[$j-1] + $xOffsetTop,
				$width-$yOffsetRight,
				$axTac_A[$j-1] + $xOffsetTop, $curve_P->{'axisColor'});
		       }
		   }
		}
		#
		# get major label floating point width
		#
		if($ylogFlag==1) { $majFWidth = 0; }
		if($majFWidth >= 0) { 
			$strBuf="%.".$majFWidth."f";
			$strBuf =~ s/ //;
		}
		else {
		        $strBuf="%.2f";
			
		}
	
	        if ($format == $IIP_FORMAT_FIX) {
			$s= sprintf($strBuf,($endPoints_A[1]*$adjust - ($spacing *$adjust* $i)));
		}
		else {
			$s=sprintf("%9.2e",($endPoints_A[1]*$adjust - ($spacing *$adjust* $i)));
		}

		if($ylogFlag==1) {
		        $yt=int($temp * $i + $xOffsetTop);
			XDrawString($image,
				$yOffsetLeft-34,
				$yt+4,"10",$curve_P->{'labelColor'});
			XDrawString($image,
				$yOffsetLeft-22,
				$yt-3,$s,$curve_P->{'labelColor'});
		}
		else {
		        $yt=int($temp * $i + $xOffsetTop);
			($textWidth, $textHeight)=(gdTinyFont->width,gdTinyFont->height);
			$textWidth=$textWidth*length($s);
			$xText=$leftMargin-10-$textWidth;
			#$yText= $yt-$leftMargin+$textHeight/2+4;
			$yText= $yt-10+$textHeight/2+4;


						
			XDrawString($image,$xText,$yText,$s,$curve_P->{'labelColor'});
		}
	        if($gridFlag==1 && ($i<$tickNum)) {
		    #
		    # Draw the y axis grids
		    #
		    if($type == $IIP_TYPE_POLAR) {
		    } else {
			 $yt=int($temp * $i +$xOffsetTop);
		         XDrawLineDash($image,
                       		$width- $yOffsetRight, $yt,
				$yOffsetLeft, $yt, $curve_P->{'gridColor'});
		         #
		         # Draw the x axis log tach grids
		         #
		         if ($ylogFlag==1) {
			     for($j=0; $j< 8; $j++ ) { 
		               XDrawLineDash($image,
                       		     $width-$yOffsetRight,
				      $axTac_A[$j] + $xOffsetTop ,
				      $yOffsetLeft,
				      $axTac_A[$j] + $xOffsetTop, $curve_P->{'gridColor'});
		              }
		         }
		    }
		    #
		    # end of y axis grid
		    # 

                }
	
       }# end draw y axis 

}


sub IIPwToDevy {
my $IIP_AXIS_LOG=2;
my $TRUE=1;
my $FALSE=0;

my	$curve_P=shift;
my	$yw=shift;

my      $yNorm;
my 	$yd;
my 	$ylogFlag;
my	$alpha;
my      $beta;
my 	$delta;
my      $rdevMax;
my	$tickNum;
my	$offset;


	if($curve_P->{'yType'} == $IIP_AXIS_LOG) { 
		$ylogFlag= $TRUE;
	} else {
       	 	$ylogFlag = $FALSE;
        }
	$yNorm = (($ylogFlag ? log10($yw): $yw) -
                        $curve_P->{'minMaxAdj2'})/
                        ($curve_P->{'minMaxAdj3'}-
                        $curve_P->{'minMaxAdj2'});
	$yd=int( $curve_P->{'height'} - ($yNorm * ($curve_P->{'height'}-$curve_P->{'xOffsetTop'} -$curve_P->{'xOffsetBottom'} ) 
				+ $curve_P->{'xOffsetBottom'} +.5));

return $yd;
}


 
sub IIPwToDevx() {

my $IIP_AXIS_LOG=2;
my $TRUE=1;
my $FALSE=0;

my 	$curve_P=shift;
my	$xw=shift;

my      $xNorm;
my	$xd;
my	$xlogFlag;
my	$alpha;
my      $beta;
my	$delta;
my      $rdevMax;
my	$tickNum;
my	$offset;

	if($curve_P->{'xType'} == $IIP_AXIS_LOG) {
		$xlogFlag= $TRUE;
	}else{
	        $xlogFlag = $FALSE;
        }
	$xNorm = (($xlogFlag ? log10($xw): $xw) -
                        $curve_P->{'minMaxAdj0'})/
                        ($curve_P->{'minMaxAdj1'}-
                        $curve_P->{'minMaxAdj0'});
	$xd=int(($xNorm * ($curve_P->{'width'}-$curve_P->{'yOffsetLeft'} - $curve_P->{'yOffsetRight'} ) 
				+ $curve_P->{'yOffsetLeft'} +.5));

return $xd;

}








sub XDrawLine {

my $image=shift;
my $x1=shift;
my $y1=shift;
my $x2=shift;
my $y2=shift;
my $color=shift;

   $image->line($x1,$y1,$x2,$y2,$color);

}

sub XDrawLineDash {

my $image=shift;
my $x1=shift;
my $y1=shift;
my $x2=shift;
my $y2=shift;
my $color=shift;

my @lineStyle=($color,$color,gdTransparent,gdTransparent);
$image->setStyle(@lineStyle);

   $image->line($x1,$y1,$x2,$y2,gdStyled);


}

sub XDrawString {
my $image=shift;
my $x=shift;
my $y=shift;
my $text=shift;
my $color=shift;


#   $image->string(gdTinyFont,$x,$y,$text,$color);
$image->string(gdSmallFont,$x,$y,$text,$color);


}

sub XDrawStringUp {
my $image=shift;
my $x=shift;
my $y=shift;
my $text=shift;
my $color=shift;


#   $image->string(gdTinyFont,$x,$y,$text,$color);
$image->stringUp(gdSmallFont,$x,$y,$text,$color);


}

sub XDrawMarker {

my $MARKER_DOT=0;
my $MARKER_X=1;
my $MARKER_PLUS=2;
my $MARKER_ASTERISK=3;
my $MARKER_DIAMOND=4;
my $MARKER_SQUARE=5;
my $MARKER_TRIANGLE=6;
my $MARKER_TRIANGLE_INVERTED=7;
my $DX=4;
my $DY=4;


my $image=shift;
my $xx=shift;
my $yy=shift;
my $type=shift;
my $color=shift;

if($type== $MARKER_DOT) {

} elsif ($type==$MARKER_X) {

  $image->line($xx-$DX,$yy+$DY,$xx+$DX,$yy-$DY,$color);
  $image->line($xx-$DX,$yy-$DY,$xx+$DX,$yy+$DY,$color);
  
  
} elsif ($type==$MARKER_PLUS) {
  $image->line($xx-$DX,$yy,$xx+$DX,$yy,$color);
  $image->line($xx,$yy-$DY,$xx,$yy+$DY,$color);
  
} elsif ($type==$MARKER_ASTERISK) {

  $image->line(($xx-$DX), ($yy), ($xx+$DX), ($yy),$color);
   $image->line(($xx), ($yy-$DY), ($xx), $yy+$DY,$color);
   $image->line(($xx-$DX), ($yy+$DY), ($xx+$DX), $yy-$DY,$color);
   $image->line(($xx-$DX), ($yy-$DY), ($xx+$DX), $yy+$DY,$color);
  
} elsif ($type == $MARKER_DIAMOND) {
     $image->line(($xx), ($yy-$DY), ($xx+$DX), ($yy),$color);
     $image->line(($xx), ($yy-$DY), ($xx-$DX), ($yy),$color);
     $image->line(($xx), ($yy+$DY), ($xx-$DX), ($yy),$color);
     $image->line(($xx), ($yy+$DY), ($xx+$DX), ($yy),$color);
    
    
} elsif ($type == $MARKER_SQUARE) {
     $image->line(($xx-$DX), ($yy-$DY), ($xx+$DX), ($yy-$DY),$color);
     $image->line(($xx-$DX), ($yy+$DY), ($xx+$DX), ($yy+$DY),$color);
     $image->line(($xx-$DX), ($yy+$DY), ($xx-$DX), ($yy-$DY),$color);
     $image->line(($xx+$DX), ($yy+$DY), ($xx+$DX), ($yy-$DY),$color);
    
} elsif ($type == $MARKER_TRIANGLE) {
     $image->line(($xx-$DX), ($yy+$DY), ($xx+$DX), ($yy+$DY),$color);
     $image->line(($xx-$DX), ($yy+$DY), ($xx), ($yy-$DY),$color);
     $image->line(($xx+$DX), ($yy+$DY), ($xx), ($yy-$DY),$color);
    
    

} elsif ($type == $MARKER_TRIANGLE_INVERTED) {
    $image->line(($xx-$DX), ($yy-$DY), ($xx+$DX), ($yy-$DY),$color);
    $image->line(($xx-$DX), ($yy-$DY), ($xx), $yy+$DY,$color);
    $image->line(($xx+$DX), ($yy-$DY), ($xx), ($yy+$DY),$color);
   
}

}


sub  IIP_DrawCircle()
{
my $curve_P=shift;
my $image=shift;
my $xx=shift;
my $y=shift;
my $radius=shift;
my $color=shift;




my 	$circCornerulX;
my      $circCornerulY;
my      $circCornerlrX;
my      $circCornerlrY;
	
my $xulCirc;
my $yulCirc;
my $xlrCirc;
my $ylrCirc;

my 	$xwul;
my      $ywul;
my      $xwlr;
my      $ywlr;

$xulCirc= IIPwToDevxx($curve_P,$xx-$radius);
$yulCirc =  IIPwToDevy($curve_P,$y+$radius);
$xlrCirc= IIPwToDevxx($curve_P,$xx+$radius);
$ylrCirc = IIPwToDevy($curve_P,$y-$radius);

$image->arc(($xulCirc+$xlrCirc)/2,($yulCirc+$ylrCirc)/2,
		$xlrCirc-$xulCirc,($ylrCirc-$yulCirc),0,360*64,$color);

}


 
sub IIPwToDevxx() {

my $IIP_AXIS_LOG=2;
my $TRUE=1;
my $FALSE=0;

my 	$curve_P=shift;
my	$xw=shift;

my      $xNorm;
my	$xd;
my	$xlogFlag;
my	$alpha;
my      $beta;
my	$delta;
my      $rdevMax;
my	$tickNum;
my	$offset;

	if($curve_P->{'xType'} == $IIP_AXIS_LOG) {
		$xlogFlag= $TRUE;
	}else{
	        $xlogFlag = $FALSE;
        }
	$xNorm = (($xlogFlag ? log10($xw): $xw) -
                        $curve_P->{'minMaxAdj0'})/
                        ($curve_P->{'minMaxAdj1'}-
                        $curve_P->{'minMaxAdj0'});
	$xd=int(($xNorm * ($curve_P->{'width'}-$curve_P->{'yOffsetLeft'} - $curve_P->{'yOffsetRight'} ) 
				+ $curve_P->{'yOffsetLeft'} +.5));

return $xd;

}



sub DrawZero {

my $DX=4;
my $DY=4;


my $image=shift;
my $xx=shift;
my $yy=shift;
my $color=shift;


  $image->line($xx-$DX,$yy+$DY,$xx+$DX,$yy-$DY,$color);
  $image->line($xx-$DX,$yy-$DY,$xx+$DX,$yy+$DY,$color);

}

sub DrawPole {

my $DX=8;
my $DY=8;


my $image=shift;
my $xx=shift;
my $yy=shift;
my $color=shift;

  
  $image->arc($xx,$yy,$DX,$DY,0,360,$color);

}


 
sub  IIPwToDevPolarDB {



my $IIP_AXIS_LOG=2;
my $TRUE=1;
my $FALSE=0;

my 	$curve_P=shift;
my	$r=shift;
my	$theta=shift;

my      $xNorm;
my	$xd;
my	$xlogFlag;
my	$alpha;
my      $beta;
my	$delta;
my      $rdevMax;
my	$tickNum;
my	$offset;
my      $rr;
my      $ycorrection;
my      @dev1_A=(0,0);

my $rdevMaxY;
my $rdev;
my $xdev;
my $ydev;



if($curve_P->{'plotType'} != $PLOT_POLAR_DB) {
	print "Bad news not a polar db plot ","\n";
	return;
} 


if($curve_P->{'polarTicksx'}) {
	$tickNum=$curve_P->{'polarTicksx'};
} else {
	$tickNum=5;
}


$rdevMax= ($curve_P->{'width'} - $curve_P->{'yOffsetLeft'} - $curve_P->{'yOffsetRight'})/2.0;
$rdevMaxY= ($curve_P->{'height'} - $curve_P->{'xOffsetTop'} - $curve_P->{'xOffsetBottom'})/2.0;
$delta=$rdevMax/$tickNum;
$alpha=$delta*($tickNum-1)/($curve_P->{'polarPlotMax'}-$curve_P->{'polarPlotMin'}); 
$beta= $delta-($curve_P->{'polarPlotMin'})*$alpha;
$rdev=(($r)*$alpha+$beta);
$ycorrection= $rdevMaxY/$rdevMax;
$xdev = int($rdev*cos($theta)+$rdevMax+$curve_P->{'yOffsetLeft'});
$ydev = int($rdev*sin($theta)*$ycorrection+$rdevMaxY+$curve_P->{'xOffsetTop'});

@dev1_A=($xdev,$ydev);

return(@dev1_A);

}

sub IIP_DrawCircleDB()
{

my $curve_P=shift;
my $image=shift;
my 	$tickNum=shift;
my 	$i=shift;
my      $color=shift;


my 	$circCornerulX;
my      $circCornerulY;
my      $circCornerlrX;
my      $circCornerlrY;

my 	$xulCirc;
my      $yulCirc;
my      $xlrCirc;
my      $ylrCirc;


my 	$xwul;
my      $ywul;
my      $xwlr;
my      $ywlr;
my      $deltaX;
my      $rdevMaxX;
my 	$radiusX;
my      $deltaY;
my      $rdevMaxY;
my	$radiusY;

$rdevMaxX= ($X_AXIS_SIZE)/2.0;
$deltaX=$rdevMaxX/$tickNum;
$radiusX= $i*$deltaX;
$rdevMaxY= ($Y_AXIS_SIZE)/2.0;
$deltaY=$rdevMaxY/$tickNum;
$radiusY= $i*$deltaY;
#
# Draw circle 
#
$xulCirc= $rdevMaxX+$curve_P->{'yOffsetLeft'}-$radiusX;
$yulCirc =  $curve_P->{'height'}-($rdevMaxY+$curve_P->{'xOffsetBottom'}+$radiusY);
$xlrCirc= $rdevMaxX+$curve_P->{'yOffsetLeft'}+$radiusX;
$ylrCirc = $curve_P->{'height'}-($rdevMaxY+$curve_P->{'xOffsetBottom'}-$radiusY);



$image->arc(($xulCirc+$xlrCirc)/2,($yulCirc+$ylrCirc)/2,
		$xlrCirc-$xulCirc,($ylrCirc-$yulCirc),0,360,$curve_P->{'axisColor'});

}



sub DrawAxisLabelsPolarDB() {

my $curve_P=shift;
my $image=shift;


my  $circCornerulX;
my  $circCornerulY;
my  $circCornerlrX;
my  $circCornerlrY;
my  $xulCirc;
my  $yulCirc;
my  $xlrCirc;
my  $ylrCirc;
my  $xwul;
my  $ywul;
my  $xwlr;
my  $ywlr;

my   $deltaX;
my   $rdevMaxX;
my   $radiusX;
my    $deltaY;
my   $rdevMaxY;
my   $radiusY;
my 	$delta;
my	$i;
my	$tickNum;
my	$s="";
my	$strBuf="";
my	$majFWidth;
my	$xText;
my      $yText;

my    $yt;
my    $textWidth;
my    $textHeight;



my $yOffsetLeft=$curve_P->{'yOffsetLeft'};
my $xOffsetBottom=$curve_P->{'xOffsetBottom'};
my $xOffsetTop=$curve_P->{'xOffsetTop'};

my $yOffsetRight=$curve_P->{'yOffsetRight'};
my $bottomMargin=$xOffsetBottom;
my $leftMargin=$yOffsetLeft;

my $fontAscent=10;
#
# Draw y axis ticks and labels
#

if($curve_P->{'xtickNum'} >0 ) {
	$tickNum=$curve_P->{'xtickNum'};
} else {
	$tickNum=5;
}
$delta=($curve_P->{'polarPlotMax'} - $curve_P->{'polarPlotMin'})/($tickNum-1);
$curve_P->{'xtickNum'}=$tickNum;

for ($i = 1 ; $i <= $tickNum ; $i++) {

	$rdevMaxX= ($X_AXIS_SIZE)/2.0;
	$deltaX=$rdevMaxX/$tickNum;
	$radiusX= $i*$deltaX;
	$rdevMaxY= ($Y_AXIS_SIZE)/2.0;
	$deltaY=$rdevMaxY/$tickNum;
	$radiusY= $i*$deltaY;
	
	
	
	#
	# Draw circle 
	#
	$xulCirc= $rdevMaxX+$curve_P->{'yOffsetLeft'}-$radiusX;
	$yulCirc =  $curve_P->{'height'}-($rdevMaxY+$curve_P->{'xOffsetBottom'}+$radiusY);
	$xlrCirc= $rdevMaxX+$curve_P->{'yOffsetLeft'}+$radiusX;
	$ylrCirc = $curve_P->{'height'}-($rdevMaxY+$curve_P->{'xOffsetBottom'}-$radiusY);


	XDrawLine($image,$curve_P->{'yOffsetLeft'},
		$yulCirc,$curve_P->{'yOffsetLeft'}+$TICKSIZE,
		$yulCirc,$curve_P->{'axisColor'});
		
	XDrawLine($image,$curve_P->{'width'} - $curve_P->{'yOffsetRight'} -$TICKSIZE,
		$yulCirc,$curve_P->{'width'}- $curve_P->{'yOffsetRight'},
		$yulCirc,$curve_P->{'axisColor'});
		
	XDrawLine($image,$curve_P->{'yOffsetLeft'},
		$ylrCirc,$curve_P->{'yOffsetLeft'}+$TICKSIZE,
		$ylrCirc,$curve_P->{'axisColor'});
		
	XDrawLine($image,$curve_P->{'width'} - $curve_P->{'yOffsetRight'} -$TICKSIZE,
		$ylrCirc,$curve_P->{'width'}- $curve_P->{'yOffsetRight'},
		$ylrCirc,$curve_P->{'axisColor'});
	#
	# draw tic mark lower axis
	#
	XDrawLine($image,$xulCirc, $curve_P->{'height'}-$curve_P->{'xOffsetBottom'}, 
			$xulCirc, $curve_P->{'height'}-$curve_P->{'xOffsetBottom'} -$TICKSIZE,$curve_P->{'axisColor'} );
			
	XDrawLine($image,$xlrCirc, $curve_P->{'height'}-$curve_P->{'xOffsetBottom'}, 
			$xlrCirc, $curve_P->{'height'}-$curve_P->{'xOffsetBottom'} -$TICKSIZE, $curve_P->{'axisColor'});
	#
	# draw tic mark upper axis
	#
	XDrawLine($image,$xlrCirc, 
			$curve_P->{'xOffsetTop'},$xlrCirc, $curve_P->{'xOffsetTop'} + $TICKSIZE,$curve_P->{'axisColor'} ); 
	XDrawLine($image,$xulCirc, $curve_P->{'xOffsetTop'},$xulCirc, $curve_P->{'xOffsetTop'} + $TICKSIZE,$curve_P->{'axisColor'}); 

	$strBuf="%.1f";

	$s=sprintf($strBuf,($curve_P->{'polarPlotMin'} + ($delta * ($i-1))));
	#
  	# Draw y axis tick labels
 	#
#	IIPCalcAlignFont(curveLayout_P,s,font_P,TEXT_ITEM_Y_AXIS_MAJOR,
#		1,yulCirc,&xText,&yText);
		
	
	
		        $yt=int($yulCirc + $xOffsetTop);
			($textWidth, $textHeight)=(gdTinyFont->width,gdTinyFont->height);
			$textWidth=$textWidth*length($s);
			$xText=$leftMargin-10-$textWidth;
			#$yText= $yt-$leftMargin+$textHeight/2+4;
			$yText= $yulCirc-$fontAscent/2;
			


						
			XDrawString($image,$xText,$yText,$s,$curve_P->{'labelColor'});
	
#	IIPCalcAlignFont(curveLayout_P,s,font_P,TEXT_ITEM_Y_AXIS_MAJOR,
#		1,ylrCirc,&xText,&yText);

	
		        $yt=int($ylrCirc+ $xOffsetTop);
#			($textWidth, $textHeight)=(gdTinyFont->width,gdTinyFont->height);
#			$textWidth=$textWidth*length($s);
			$xText=$leftMargin-10-$textWidth;
			#$yText= $yt-$leftMargin+$textHeight/2+4;
			
			$yText= $ylrCirc-$fontAscent/2;


						
			XDrawString($image,$xText,$yText,$s,$curve_P->{'labelColor'});
		
		
				
		
	#
  	# Draw x axis tick labels
 	#
#	IIPCalcAlignFont(curveLayout_P,s,font_P,TEXT_ITEM_X_AXIS_MAJOR,
#		xulCirc,0,&xText,&yText);
#		
			
			
			$xText=$xulCirc-$textWidth/2;
			$yText= $curve_P->{'height'}-$bottomMargin+$fontAscent+4;


						
			XDrawString($image,$xText,$yText,$s,$curve_P->{'labelColor'});
		
		
			$xText=int($xulCirc  + $yOffsetLeft- $textWidth/2); #-textWidth/2
			
			$xText=$xlrCirc-$textWidth/2;
			
			$yText= $curve_P->{'height'}-$bottomMargin+$fontAscent+4;


						
			XDrawString($image,$xText,$yText,$s,$curve_P->{'labelColor'});
		
		
#	IIPCalcAlignFont(curveLayout_P,s,font_P,TEXT_ITEM_X_AXIS_MAJOR,
#		xlrCirc,0,&xText,&yText);
		
			$xText=$xlrCirc-$textWidth/2;
			
			$yText= $curve_P->{'height'}-$bottomMargin+$fontAscent+4;


						




}

	$image->rectangle($curve_P->{'yOffsetLeft'},$curve_P->{'xOffsetTop'}, 
			$curve_P->{'yOffsetLeft'}+$X_AXIS_SIZE, $curve_P->{'xOffsetTop'}+$Y_AXIS_SIZE,$curve_P->{'axisColor'});
	#
	# set up device coord range for world to device transformations
	#
	$curve_P->{'dev0'} = $curve_P->{'yOffsetLeft'};
	$curve_P->{'dev1'} = $X_AXIS_SIZE;
	$curve_P->{'dev2'}= $curve_P->{'height'}-$curve_P->{'xOffsetBottom'};
	$curve_P->{'dev3'} = $Y_AXIS_SIZE;

}
