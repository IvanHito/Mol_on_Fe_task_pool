#!/usr/bin/perl

package vaspSTRUCT;
use Class::Accessor 'antlers';
use strict;
use Math::Trig;
use MyUseful;

#### ================================= ####
####             Attributes            ####
#### ================================= ####

has isDefined        => ( is => "ro", isa => "Str" ); ## "OK" means it is defined
has sourceFile       => ( is => "rw", isa => "Str" );
has infoLine         => ( is => "rw", isa => "Str" );
has factor           => ( is => "rw" );
has baseVs           => ( is => "rw" );
has baseAvs          => ( is => "rw" );
has atomTypeNames    => ( is => "rw" );
has atomTypeNums     => ( is => "rw" );
has nAtoms           => ( is => "rw" );
has dynType          => ( is => "rw" );
has aPosType         => ( is => "rw" );
has fixedNums        => ( is => "rw" );
has nCellsArr        => ( is => "rw" );
has ainfD            => ( is => "rw" );
has ainfC            => ( is => "rw" );


#### ================================= ####
####          Inner variables          ####
#### ================================= ####

my $VALUNDEF  = "undefined";
my $VALOK     = "OK";
my $FNPOSCAR  = "POSCAR";
my $FNXSF     = "COORDS.xsf";
my $PRINTDBG  = 0;
my @aRefNames = ( "baseVs",         # array of names which can be recopied
                  "baseAvs",
                  "atomTypeNames",
                  "atomTypeNums",
                  "ainfD",
                  "ainfC" );


<<q=~q>>;
Functions "declarations" (not necessary part)
sub test_func {
sub my_default_vals {
sub recopy_arr {
sub set_array_fromRef {
sub maxXYZ {
sub test_shift {
sub add_atoms_vSTR {
sub read_poscar {
sub new_struct_hcp_Mg {
sub new_struct_hcp {
sub new_struct_hcp_v {
sub new_struct_fcc {
sub new_struct_bcc {
sub new_struct_diamond {
sub new_struct_sc {
sub new_struct_single {
sub new_struct_gre {
sub struct_base {
sub write_poscar {
sub write_xsf {
sub get_atom_type {
sub distort_bvs {
sub distort_pos {
sub mat3_mult {
q

#### ================================= ####
####            Subroutines            ####
#### ================================= ####

#sub dummy {
#  my $self = shift;
  ##   <<<   Input parameters   >>>   ##
  ##   <<<   ----------------   >>>   ##
#}

sub test_func {
  my $self = shift;
  ##   <<<   Input parameters   >>>   ##
  my $farg = shift // "NA";
  ##   <<<   ----------------   >>>   ##
  print "\ntest_func: argument is $farg\n\n";
}

sub my_default_vals {
  my $self = shift;
  $self->set("isDefined",$VALUNDEF);
  ##print "Me: $self. State: $VALUNDEF \n";
  ##print "\n";
  $self->sourceFile($VALUNDEF);
  $self->infoLine($VALUNDEF);
  $self->factor(1.0);
  my @arrArr1 = ([0,0,0], [0,0,0], [0,0,0]);
  $self->baseVs(@arrArr1);
  my @arr1;
  $self->atomTypeNames(@arr1);
  my @arr2;
  $self->atomTypeNums(@arr2);
  $self->nAtoms(0);
  $self->dynType("S");
  $self->aPosType("Direct");
  my @arr0 = (0,0,0);
  $self->nCellsArr(@arr0);
  my @arr3;
  $self->ainfD(@arr3);
  my @arr4;
  $self->ainfC(@arr4);
  my @arr5;
  $self->fixedNums(@arr5);
  my @arr6;
  $self->baseAvs(@arr6);
}

sub recopy_arr {
  my $self = shift;
  my $nm = shift // $VALUNDEF;
  if ( $nm ~~ @aRefNames ){
    ##print "Recopy $nm \n";
    my @newArray = @{$self->SUPER::get($nm)};
    $self->SUPER::set($nm, \@newArray);
  } else { print "WARNING!!! Illigal recopy $nm \n"; }
}

sub set_array_fromRef {
  my $self = shift;
  my $nm = shift // $VALUNDEF;
  my $arrRef = shift;
  if ( $nm ~~ @aRefNames ){
    my @newArray = @{ $arrRef };
    $self->SUPER::set($nm, \@newArray);
  } else { print "WARNING!!! Illigal array set of $nm \n"; }
}

sub maxXYZ {
  my $self = shift;
  my @arrR = @{ $self->ainfC };
  my @maxXYZ = (0,0,0);
  my $i;
  my $refR;
  ##print "@arrR\n";
  foreach $refR (@arrR){
    ##print "$refR\n";
    for ($i=0; $i<3; $i++){
      if ($maxXYZ[$i]<$refR->[$i]){$maxXYZ[$i]=$refR->[$i]}
    }
  }
  return @maxXYZ;
}

sub test_shift {
  my $self = shift;
}

sub add_atoms_vSTR {
  my $self     = shift;
  my $vaspSTR2 = $_[0];
  my @str2off;
  if (@_ > 1) {@str2off  = @{ $_[1] };}
  else {@str2off  = (0,0,0);}
  #print_v(@str2off);
  if ($vaspSTR2->isDefined ne $VALOK){
    print "Error!!! Nothing to add!!! \n";
    return -1;
  }
  if ($self->isDefined ne $VALOK){
    $self->my_default_vals();
  }
  my $addAtomsN = $vaspSTR2->nAtoms();
  my $nAtoms = $self->nAtoms();
  my @arrR = @{$self->ainfC()};
  my @arrX = @{$self->ainfD()};
  my @arrAddR = @{$vaspSTR2->ainfC()};
  my @mInv = m3_Invert($self->baseVs());
  ##my @arrAddX = @{$vaspSTR2->ainfD()};
  ##
  ##my @maxBox = ();  ## May be Need to make automatic
  ##
  for (my $i=0; $i<$addAtomsN; $i++){
    my @cR = (0,0,0);
    for (my $j=0; $j<3; $j++) {
      $cR[$j] = $arrAddR[$i][$j] + $str2off[$j];
    }
    ##print($arrAddR[$i], "  \n");
    my @cX = v3_m3_mult(\@cR,\@mInv);
    for (my $j=0; $j<3; $j++) {
      $arrR[$nAtoms+$i][$j] = $cR[$j];
      $arrX[$nAtoms+$i][$j] = $cX[$j];
    }
    #print_v(@{$arrR[$nAtoms+$i]});
    # @arrR[$nAtoms+$i] = ($cR[0],$cR[1],$cR[2]);
    # @arrX[$nAtoms+$i] = ($cX[0],$cX[1],$cX[2]);
    # push(@arrR, \@arrAddR[$i]);
    # push(@arrX, \@cX);
  }
  $nAtoms += $addAtomsN;
  $self->nAtoms($nAtoms);
  $self->ainfC(@arrR);
  $self->ainfD(@arrX);
  ## atoms types
  my @aTnames = @{$self->atomTypeNames()};
  my @aTnums = @{$self->atomTypeNums()};
  my @addNames = @{$vaspSTR2->atomTypeNames()};
  my @addNums = @{$vaspSTR2->atomTypeNums()};
  my $nAdd = @addNames;
  for (my $i=0; $i<$nAdd; $i++){
    push(@aTnames,$addNames[$i]);
    push(@aTnums,$addNums[$i]);
  }
  $self->atomTypeNames(@aTnames);
  $self->atomTypeNums(@aTnums);
  ##
  if ($self->isDefined ne $VALOK){
    $self->set("isDefined",$VALOK);
  }
} ## end add_atoms_vSTR

sub read_poscar {
  my $self = shift;
  if ($self->isDefined eq $VALOK){
    print "Warning!!! Previous structure will be destroyed\n";
  }
  ##   <<<   Input parameters   >>>   ##
  my $fnPscr = $_[0];
  ##   <<<   ----------------   >>>   ##
  my $cl; my $i; my $j; my @arrLine; my $nn;
  $self->my_default_vals();
  open(FPSCR, "<$fnPscr") or die "Could not open $fnPscr: $!";
  $self->sourceFile($fnPscr);
  $cl = <FPSCR>;
  chomp $cl;
  $self->infoLine($cl);
  $cl = <FPSCR>;
  ##$cl =~ /^.*([0-9]+\.[0-9]*|[0-9]+).*/;
  ##my ( $fact ) = $cl =~ /^\s*(\w+)/;
  chomp $cl; $cl =~ s/^\s+//;
  @arrLine = split /\s+/, $cl;
  my $fact = $arrLine[0];
  $self->factor($fact);
  ## Base Vectors
  my @arrBVs = ([0,0,0], [0,0,0], [0,0,0]);
  for ($i=0; $i<3; $i++){
    $cl = <FPSCR>;
    chomp $cl; $cl =~ s/^\s+//;
    @arrLine = split /\s+/, $cl;
    for ($j=0; $j<3; $j++){ $arrBVs[$i][$j] = $arrLine[$j]; }
  }
  $self->baseVs(@arrBVs);
  # print("\n");
  # print_m(@arrBVs);
  my @mInv = m3_Invert(\@arrBVs);
  ## Atoms types
  $cl = <FPSCR>;
  chomp $cl; $cl =~ s/^\s+//;
  @arrLine = split /\s+/, $cl;
  ##$self->atomTypeNames(@arrLine);
  $self->set_array_fromRef("atomTypeNames",\@arrLine);
  ## Atoms numbers
  $cl = <FPSCR>;
  chomp $cl; $cl =~ s/^\s+//;
  @arrLine = split /\s+/, $cl;
  ##$self->atomTypeNums(@arrLine);
  $self->set_array_fromRef("atomTypeNums",\@arrLine);
  my $nAtoms = 0;
  foreach $nn (@arrLine) { $nAtoms += $nn; }
  $self->nAtoms($nAtoms);
  ## Search for positions
  my $posType = "D";
  while ($cl = <FPSCR>) {
    if ((substr($cl,0,1) eq "D") or (substr($cl,0,1) eq "d")) { last; }
    if ((substr($cl,0,1) eq "C") or (substr($cl,0,1) eq "c")) {
      $posType = "C";
      $self->aPosType("Cartesian");
      last;
    }
  }
  my @arrD; my @arrC;
  for ($i=0; $i<$nAtoms; $i++){
    $cl = <FPSCR>;
    chomp $cl; $cl =~ s/^\s+//;
    @arrLine = split /\s+/, $cl;
    my @cD = (0,0,0); my @cC = (0,0,0);
    if ($posType eq "D") {
      for ($j=0; $j<3; $j++){ $cD[$j] = $arrLine[$j]; }
      @cC = v3_m3_mult(\@cD,\@arrBVs);
    }
    if ($posType eq "C") {
      for ($j=0; $j<3; $j++){ $cC[$j] = $arrLine[$j]; }
      @cD = v3_m3_mult(\@cC,\@mInv);
    }
    push(@arrD,\@cD);
    push(@arrC,\@cC);
  }
  close FPSCR;
  $self->ainfD(@arrD);
  $self->ainfC(@arrC);
  $self->nCellsArr([1,1,1]);
  $self->set("isDefined",$VALOK);
} ##end read_poscar


sub new_struct_hcp_Mg {
  my $self = shift;
  ##   <<<   Input parameters   >>>   ##
  my $hcpA = $_[0];         ## hcp parameter a
  my $nCells1 = $_[3];      ## number of cells in direction of vector 1
  my $nCells2 = $_[4];      ## number of cells in direction of vector 2
  my $nCells3 = $_[5];      ## number of cells in direction of vector 3
  ##   <<<   ----------------   >>>   ##
  my $hcpC = $hcpA*1.633;   ## hcp parameter c
  my $hcpG = 120*pi/180;    ## hcp angle (initially in degrees)
  my $tp = "Mg";            ## atom type
  $self->new_struct_hcp($hcpA,$hcpC,$hcpG,$nCells1,$nCells2,$nCells3,$tp);
}

sub new_struct_hcp {
  my $self = shift;
  ##   <<<   Input parameters   >>>   ##
  my $hcpA = $_[0];         ## hcp parameter a
  my $hcpC = $_[1];         ## hcp parameter c
  my $hcpG = $_[2]*pi/180;  ## hcp angle (initially in degrees)
  my $nCells1 = $_[3];      ## number of cells in direction of vector 1
  my $nCells2 = $_[4];      ## number of cells in direction of vector 2
  my $nCells3 = $_[5];      ## number of cells in direction of vector 3
  my $tp = $_[6];           ## atom type
  ##   <<<   ----------------   >>>   ##
  my $cg = cos($hcpG);
  my $sg = sin($hcpG);
  my @baseVectors = ([$hcpA,0,0], [$hcpA*$cg,$hcpA*$sg,0], [0,0,$hcpC]);
  my @bvAtoms = ([0,0,0], [1/3, 2/3, 0.5]);
  $self->set("isDefined",$VALOK);
  $self->infoLine("Pure $tp hcp structure");
  $self->baseVs(@baseVectors);
  $self->baseAvs(@bvAtoms);
  $self->atomTypeNames([$tp]);
  $self->nCellsArr([$nCells1,$nCells2,$nCells3]);
  $self->struct_base();
}

## <<<<<<<<<<<<<<<<<<<<<<<============================================= !!!
## TODO: finish the function !!!
## <<<<<<<<<<<<<<<<<<<<<<<============================================= !!!
sub new_struct_hcp_v {
  my $self = shift;
  ##   <<<   Input parameters   >>>   ##
  my $hcpA = $_[0];         ## hcp parameter a
  my $hcpC = $_[1];         ## hcp parameter c
  my $hcpG = $_[2]*pi/180;  ## hcp angle (initially in degrees)
  my $nCells1 = $_[3];      ## number of cells in direction of vector 1
  my $nCells2 = $_[4];      ## number of cells in direction of vector 2
  my $nCells3 = $_[5];      ## number of cells in direction of vector 3
  my $tp = $_[6];           ## atom type
  ##   <<<   ----------------   >>>   ##
  my $cg = cos($hcpG);
  my $sg = sin($hcpG);
  my @baseVectors = ([$hcpA,0,0], [$hcpA*$cg,$hcpA*$sg,0], [0,0,$hcpC]);
  my @bvAtoms = ([0,0,0], [1/3, 2/3, 0.5]);
  $self->set("isDefined",$VALOK);
  $self->infoLine("Pure $tp hcp structure");
  $self->baseVs(@baseVectors);
  $self->baseAvs(@bvAtoms);
  $self->atomTypeNames([$tp]);
  $self->nCellsArr([$nCells1,$nCells2,$nCells3]);
  $self->struct_base();
}

sub new_struct_fcc {
  my $self = shift;
  ##   <<<   Input parameters   >>>   ##
  my $hcpA = $_[0];         ## hcp parameter a
  my $hcpB = $_[1];         ## hcp parameter b
  my $hcpC = $_[2];         ## hcp parameter c
  my $nCells1 = $_[3];      ## number of cells in direction of vector 1
  my $nCells2 = $_[4];      ## number of cells in direction of vector 2
  my $nCells3 = $_[5];      ## number of cells in direction of vector 3
  my $tp = $_[6];           ## atom type
  ##   <<<   ----------------   >>>   ##
  my @baseVectors = ([$hcpA,0,0], [0,$hcpB,0], [0,0,$hcpC]);
  my @bvAtoms = ([0,0,0], [1/2, 1/2, 0], [1/2, 0, 1/2], [0, 1/2, 1/2]);
  $self->set("isDefined",$VALOK);
  $self->infoLine("Pure $tp fcc structure");
  $self->baseVs(@baseVectors);
  $self->baseAvs(@bvAtoms);
  $self->atomTypeNames([$tp]);
  $self->nCellsArr([$nCells1,$nCells2,$nCells3]);
  $self->struct_base();
}

sub new_struct_bcc {
  my $self = shift;
  ##   <<<   Input parameters   >>>   ##
  my $hcpA = $_[0];         ## hcp parameter a
  my $hcpB = $_[1];         ## hcp parameter b
  my $hcpC = $_[2];         ## hcp parameter c
  my $nCells1 = $_[3];      ## number of cells in direction of vector 1
  my $nCells2 = $_[4];      ## number of cells in direction of vector 2
  my $nCells3 = $_[5];      ## number of cells in direction of vector 3
  my $tp = $_[6];           ## atom type
  ##   <<<   ----------------   >>>   ##
  my @baseVectors = ([$hcpA,0,0], [0,$hcpB,0], [0,0,$hcpC]);
  my @bvAtoms = ([0,0,0], [1/2, 1/2, 1/2]);
  $self->set("isDefined",$VALOK);
  $self->infoLine("Pure $tp fcc structure");
  $self->baseVs(@baseVectors);
  $self->baseAvs(@bvAtoms);
  $self->atomTypeNames([$tp]);
  $self->nCellsArr([$nCells1,$nCells2,$nCells3]);
  $self->struct_base();
}

sub new_struct_diamond {
  my $self = shift;
  ##   <<<   Input parameters   >>>   ##
  my $diaA = $_[0];         ## dia parameter a
  my $diaB = $_[1];         ## dia parameter b
  my $diaC = $_[2];         ## dia parameter c
  my $nCells1 = $_[3];      ## number of cells in direction of vector 1
  my $nCells2 = $_[4];      ## number of cells in direction of vector 2
  my $nCells3 = $_[5];      ## number of cells in direction of vector 3
  my $tp = $_[6];           ## atom type
  ##   <<<   ----------------   >>>   ##
  my @baseVectors = ([$diaA,0,0], [0,$diaB,0], [0,0,$diaC]);
  my @bvAtoms = ([0,0,0], [1/2, 1/2, 0], [1/2, 0, 1/2], [0, 1/2, 1/2],
      [1/4, 1/4, 1/4], [3/4, 3/4, 1/4], [3/4, 1/4, 3/4], [1/4, 3/4, 3/4]);
  $self->set("isDefined",$VALOK);
  $self->infoLine("Pure $tp diamond structure");
  $self->baseVs(@baseVectors);
  $self->baseAvs(@bvAtoms);
  $self->atomTypeNames([$tp]);
  $self->nCellsArr([$nCells1,$nCells2,$nCells3]);
  $self->struct_base();
}

sub new_struct_sc {
  my $self = shift;
  ##   <<<   Input parameters   >>>   ##
  my $diaA = $_[0];         ## dia parameter a
  my $diaB = $_[1];         ## dia parameter b
  my $diaC = $_[2];         ## dia parameter c
  my $nCells1 = $_[3];      ## number of cells in direction of vector 1
  my $nCells2 = $_[4];      ## number of cells in direction of vector 2
  my $nCells3 = $_[5];      ## number of cells in direction of vector 3
  my $tp = $_[6];           ## atom type
  ##   <<<   ----------------   >>>   ##
  my @baseVectors = ([$diaA,0,0], [0,$diaB,0], [0,0,$diaC]);
  my @bvAtoms = ([1/2, 1/2, 1/2]);
  $self->set("isDefined",$VALOK);
  $self->infoLine("Simple cubic $tp structure");
  $self->baseVs(@baseVectors);
  $self->baseAvs(\@bvAtoms);
  $self->atomTypeNames([$tp]);
  $self->nCellsArr([$nCells1,$nCells2,$nCells3]);
  $self->struct_base();
}

sub new_struct_single {
  my $self = shift;
  $self->new_struct_sc(@_);
}

sub new_struct_gre {
  my $self = shift;
  ##   <<<   Input parameters   >>>   ##
  my $greA = $_[0];         ## gre parameter a
  my $greG = $_[1]*pi/180;  ## angle (originaly 60 degrees)
  my $greC = $_[2];         ## gre parameter c
  my $nCells1 = $_[3];      ## number of cells in direction of vector 1
  my $nCells2 = $_[4];      ## number of cells in direction of vector 2
  my $nCells3 = $_[5];      ## number of cells in direction of vector 3
  my $tp = $_[6];           ## atom type
  ##   <<<   ----------------   >>>   ##
  my $cg = cos($greG);
  my $sg = sin($greG);
  my @baseVectors = ([$greA,0,0], [$greA*$cg,$greA*$sg,0], [0,0,$greC]);
  my @bvAtoms = ([0, 0, 1/2], [1/3, 1/3, 1/2]);
  $self->set("isDefined",$VALOK);
  $self->infoLine(" $tp in graphene structure");
  $self->baseVs(@baseVectors);
  $self->baseAvs(\@bvAtoms);
  $self->atomTypeNames([$tp]);
  $self->nCellsArr([$nCells1,$nCells2,$nCells3]);
  $self->struct_base();
}

sub struct_base {
  my $self = shift;
  if ($self->isDefined ne $VALOK){
    print "ERROR!!! Illigal call for <vaspSTRUCT.struct_base>\n";
    return -1;
  }
  $self->factor(1.0);
  my @baseVectors = @{$self->baseVs()};
  my @bvAtoms = @{$self->baseAvs()};
  my @nCellsArr = @{$self->nCellsArr()};
  my @vNcs = @{$self->nCellsArr};
  my $nCells1 = $nCellsArr[0];
  my $nCells2 = $nCellsArr[1];
  my $nCells3 = $nCellsArr[2];
  my $i = 0; my $j = 0; my $k = 0; my $ii = 0; my $ia; my $ix; my $iy;
  my $nbaseAtoms = @bvAtoms;
  ##print "Number of atoms in the unit cell $nbaseAtoms \n";
  my $nAtoms = $nCells1*$nCells2*$nCells3*$nbaseAtoms;
  my @newAinfC;
  my @newAinfD;
  $ia = 0;
  for ($i = 0; $i<$nCells1; $i++){
    for ($j = 0; $j<$nCells2; $j++){
      for ($k = 0; $k<$nCells3; $k++){
        my @cvA = map {[0,0,0]} 1..$nbaseAtoms;
        my @cvAC = map {[0,0,0]} 1..$nbaseAtoms;
        for ($ii = 0; $ii<$nbaseAtoms; $ii++){
          $ia++;
          $cvA[$ii][0] = $bvAtoms[$ii][0]/$nCells1 + $i/$nCells1;
          $cvA[$ii][1] = $bvAtoms[$ii][1]/$nCells2 + $j/$nCells2;
          $cvA[$ii][2] = $bvAtoms[$ii][2]/$nCells3 + $k/$nCells3;
          ##print $cvA[$ii][0], "\n";
          push(@newAinfD, @cvA[$ii]);
          for ($ix = 0; $ix<3; $ix++){
            for ($iy = 0; $iy<3; $iy++){
              $cvAC[$ii][$ix] += $cvA[$ii][$iy]*$baseVectors[$iy][$ix]*$vNcs[$iy];
            }
          }
          push(@newAinfC, @cvAC[$ii]);
        }
      }
    }
  } ## end of unit cells cicles
  ## setting object values
  $self->ainfC(\@newAinfC);
  $self->ainfD(\@newAinfD);
  $self->atomTypeNums([$nAtoms]);
  $self->nAtoms($nAtoms);
  my $strInfo = $self->infoLine;
  if ($PRINTDBG) {
    print "Structure info = <$strInfo>\n";
    for ($i = 0; $i<$ia; $i++){
      print "$i  [ ";
      for ($j = 0; $j<3; $j++){printf "%9.5f, ", $newAinfC[$i][$j];}
      print " ]    [ ";
      for ($j = 0; $j<3; $j++){printf "%9.5f, ", $newAinfD[$i][$j];}
      print " ] \n";
    }
  }
}## end struct_base

sub write_poscar {
  my $self = shift;
  if ($self->isDefined ne $VALOK){
    print "ERROR!!! Illigal call for <vaspSTRUCT.write_poscar>\n";
    return -1;
  }
  ##   <<<   Input parameters   >>>   ##
  my $fn = $_[0] // $FNPOSCAR;
  ##   <<<   ----------------   >>>   ##
  my $i = 0; my $j = 0;
  my @baseVectors = @{$self->baseVs};
  my @vNcs = @{$self->nCellsArr};
  my @atpNames = @{$self->atomTypeNames};
  my @atpNums = @{$self->atomTypeNums};
  my $nAtomTypes = @atpNames;
  my $fixStyle = " T  T  T";
  my @ainfD = @{$self->ainfD};
  my @ainfC = @{$self->ainfC};
  open(FPSCR, ">$fn") or die "Could not open $fn: $!";
  print FPSCR $self->infoLine, "\n";
  print FPSCR $self->factor ," \n";
  for ($i = 0; $i<3; $i++){
    printf FPSCR '   ';
    for ($j = 0; $j<3; $j++){printf FPSCR '%20.14f  ', $baseVectors[$i][$j]*$vNcs[$i];}
    print FPSCR "\n";
  }
  print FPSCR '   ';
  for ($i=0; $i<=$nAtomTypes; $i++){print FPSCR $atpNames[$i],'   ';}
  print FPSCR '   ', "\n";
  print FPSCR '   ';
  for ($i=0; $i<=$nAtomTypes; $i++){print FPSCR $atpNums[$i],'   ';}
  print FPSCR '   ', "\n";
  print FPSCR "Selective dynamics \n";
  my $posType = $self->aPosType();
  print FPSCR "$posType \n";
  for ($i = 0; $i<$self->nAtoms; $i++){
    if ($posType eq "Cartesian"){
      printf FPSCR ' %15.12f %15.12f %15.12f', $ainfC[$i][0], $ainfC[$i][1], $ainfC[$i][2];
    } else {
      printf FPSCR ' %15.12f %15.12f %15.12f', $ainfD[$i][0], $ainfD[$i][1], $ainfD[$i][2];
    }
    printf FPSCR ' %s',$fixStyle;
    print FPSCR "\n";
  }
  close FPSCR;
} ## write_poscar

sub write_xsf {
  my $self = shift;
  if ($self->isDefined ne $VALOK){
    print "ERROR!!! Illigal call for <vaspSTRUCT.write_xsf>\n";
    return -1;
  }
  ##   <<<   Input parameters   >>>   ##
  my $fn = $_[0] // $FNXSF;
  ##   <<<   ----------------   >>>   ##
  my $i = 0; my $j = 0;
  my @baseVectors = @{$self->baseVs};
  my @vNcs = @{$self->nCellsArr};
  my @atpNames = @{$self->atomTypeNames};
  my @atpNums = @{$self->atomTypeNums};
  my $nAtomTypes = @atpNames;
  my @ainfC = @{$self->ainfC};
  my $type;
  open(FOUT, ">$fn") or die "Could not open $fn: $!";
  print FOUT "## ", $self->infoLine, "\n";
  print FOUT "CRYSTAL\n";
  print FOUT "PRIMVEC\n";
  for ($i = 0; $i<3; $i++){
    for ($j = 0; $j<3; $j++){printf FOUT '   %20.14f ', $baseVectors[$i][$j]*$vNcs[$i];}
    print FOUT "\n";
  }
  print FOUT "PRIMCOORD\n";
  print FOUT $self->nAtoms," 1 \n";
  for ($i = 0; $i<$self->nAtoms; $i++){
    $type = $self->get_atom_type($i+1);
    print FOUT "  $type    ";
    for ($j = 0; $j<3; $j++){printf FOUT '%20.14f  ', $ainfC[$i][$j];}
    print FOUT "\n";
  }
  close FOUT;
} ## end write_xsf

## na starts from 1 !!!
sub get_atom_type {
  my $self = shift;
  if ($self->isDefined ne $VALOK){
    print "ERROR!!! Illigal call for vaspSTRUCT.get_type \n";
    return 0;
  }
  ##   <<<   Input parameters   >>>   ##
  my $na = $_[0] // 1;
  ##   <<<   ----------------   >>>   ##
  my $ct = 0;
  my $atBord = 0;
  my @atomTypeNums = @{$self->atomTypeNums};
  my @atomTypeNames = @{$self->atomTypeNames};
  while($na > $atBord){
    $atBord += $atomTypeNums[$ct];
    $ct += 1;
  }
  my $tp = $atomTypeNames[$ct-1];
  return $tp;
}

sub distort_bvs {
  my $self = shift;
  if ($self->isDefined ne $VALOK){
    print "ERROR!!! Illigal call for vaspSTRUCT.distort_bvs \n";
    return 0;
  }
  ##   <<<   Input parameters   >>>   ##
  my $dType = $_[0] // "C11";
  my $dAmp  = $_[1] // 0.0;   ## in base vectors coordinates
  my $dAx   = $_[2] // 0;     ## 0 - x,  1 - y,  2 - z
  ##   <<<   ----------------   >>>   ##
  my @T = ([1,0,0],[0,1,0],[0,0,1]);
  my @HD;
  my @bVs = @{$self->baseVs};
  my $i = 0; my $j = 0; my $ix; my $iy;
  my @ainfD = @{$self->ainfD};
  my @ainfC = @{$self->ainfC};
  my @vNcs = @{$self->nCellsArr};
  my @bVMods = (0,0,0);
  for($j=0;$j<3;$j++) { $bVMods[$j] = sqrt($bVs[$j][0]**2+$bVs[$j][1]**2+$bVs[$j][2]**2); }
  ##$dAmp *= $bVMods[$dAx];    ## !!! CAREFULL HERE !!!
  ##print "Actual amp = ", $dAmp*$bVMods[$dAx] ,"\n";
  if ($dType eq "C11"){
    @T = map {[0,0,0]} 1..3;
    $T[$dAx][$dAx] = 1;
  }
  if ($dType eq "C44"){
    @T = map {[0.5,0.5,0.5]} 1..3;
    $T[0][0] = 0;
    $T[1][1] = 0;
    $T[2][2] = 0;
  }
  if ($dType eq "CP"){
    $T[1][1] = -0.5;
    $T[2][2] = -0.5;
  }
  ## V0 is default
  @HD = $self->mat3_mult($self->baseVs,\@T);
  for($i=0; $i<3; $i++){
    for($j=0; $j<3; $j++){$HD[$i][$j] = $bVs[$i][$j] + $HD[$i][$j]*$dAmp}
  }
  $self->baseVs(@HD);

  #my @bvs = @{$self->baseVs}; my $cx;
  #print "Vectors \n";
  #foreach $cx (@{$bvs[0]}){printf("  %9.5f  ",$cx) } print "\n";
  #foreach $cx (@{$bvs[1]}){printf("  %9.5f  ",$cx) } print "\n";
  #foreach $cx (@{$bvs[2]}){printf("  %9.5f  ",$cx) } print "\n";

  for ($i = 0; $i<$self->nAtoms; $i++){
    for ($ix = 0; $ix<3; $ix++){
      $ainfC[$i][$ix] = 0.0;
      for ($iy = 0; $iy<3; $iy++){
        $ainfC[$i][$ix] += $ainfD[$i][$iy]*$HD[$iy][$ix]*$vNcs[$iy];
      }
    }
  }
} ## distort_bvs

sub distort_pos {
  my $self = shift;
  if ($self->isDefined ne $VALOK){
    print "ERROR!!! Illigal call for vaspSTRUCT.distort_pos \n";
    return 0;
  }
  ##   <<<   Input parameters   >>>   ##
  my $dAmp  = $_[0] // 0.0;  ## in Angstroms
  ##   <<<   ----------------   >>>   ##
  my @bVs = @{$self->baseVs};
  my $j; my $ix; my $iy;
  my @bVMods = (0,0,0);
  my @vNcs = @{$self->nCellsArr};
  for($j=0;$j<3;$j++) { $bVMods[$j] = sqrt($bVs[$j][0]**2+$bVs[$j][1]**2+$bVs[$j][2]**2); }
  #print "Base vectors mods : @bVMods \n";
  my @ainfD = @{$self->ainfD};
  my @ainfC = @{$self->ainfC};
  for (my $i=0; $i<$self->nAtoms; $i++){
    for ($j=0; $j<3; $j++)
    {
      $ainfD[$i][$j] += 2*(rand() - 0.5)*$dAmp/$bVMods[$j];
      ##$ainfD[$i][$j] += 2*(rand() - 0.5)*$dAmp;
      if ($ainfD[$i][$j] > 1.0) { $ainfD[$i][$j] -= 1.0; }
      if ($ainfD[$i][$j] < 0.0) { $ainfD[$i][$j] += 1.0; }
      $ainfD[$i][$j] = sprintf("%20.17f",$ainfD[$i][$j]);
    }
    for ($ix = 0; $ix<3; $ix++){
      $ainfC[$i][$ix] = 0.0;
      for ($iy = 0; $iy<3; $iy++){
        $ainfC[$i][$ix] += $ainfD[$i][$iy]*$bVs[$iy][$ix]*$vNcs[$iy];
      }
    }
    ##print "$i Pos vector : ",$ainfD[$i][0]," ",$ainfD[$i][1]," ",$ainfD[$i][2],"\n";
  }
}

## multiplication
sub mat3_mult {
  my $self = shift;
  ##   <<<   Input parameters   >>>   ##
  my @m1 = @{$_[0]};
  my @m2 = @{$_[1]};
  ##   <<<   ----------------   >>>   ##
  my $i = 0; my $j = 0; my $k = 0;
  my @m = map {[0,0,0]} 1..3;
  for ($i=0; $i < 3; $i++){
    for ($j=0; $j < 3; $j++){
      for ($k=0; $k < 3; $k++){$m[$i][$j] += $m1[$i][$k]*$m2[$k][$j]}
    }
  }
  return @m;
}
























##
