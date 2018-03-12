#!/usr/bin/perl

use strict;
use Math::Trig;

use lib "/home/ivan/Mol_on_Fe/task_pool";
use vaspSTRUCT;
use MyUseful;

print("\n");

my $vs = vaspSTRUCT->new();
$vs->read_poscar("POSCAR");
my $nAtoms = $vs->nAtoms();

print($nAtoms, "  \n");
print_v(@{$vs->atomTypeNames()});
print_v(@{$vs->atomTypeNums()});

#my @arrR = @{$vs->ainfC()};
#for (my $i=0; $i<$nAtoms; $i++){
#  print_v($arrR[$i][0],$arrR[$i][1],$arrR[$i][2]);
#  ##print_v(@arrR[$i]);
#}

$vs->write_poscar("POSCAR_rewrite");

#$vs->ainfD(\@arr);
#$vs->ainfD(@arr);  ## No Problems with References!!!



print("\n");

                  
                  
  
  













                  
##
