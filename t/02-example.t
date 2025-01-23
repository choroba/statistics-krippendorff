#!/usr/bin/perl
use warnings;
use strict;

use Statistics::Krippendorff;

use Test2::V0;
plan 3;

{   my @units = ({B=>2, C=>2}, {B=>1, C=>1}, {B=>3, C=>3}, {A=>3, B=>3, C=>4},
                 {A=>4, B=>4, C=>4}, {A=>1, B=>3}, {A=>2, C=>2}, {A=>1, C=>1},
                 {A=>1, C=>1}, {A=>3, C=>3}, {A=>3, C=>3}, {A=>3, C=>4});
    my $sk = 'Statistics::Krippendorff'->new(
        units => \@units,
        delta => \&Statistics::Krippendorff::delta_nominal);

    is $sk->alpha, float(0.691, precision => 3),
        'Wikipedia example hashes';
}

{   my @units = ([undef, 2, 2],
                 [undef, 1, 1],
                 [undef, 3, 3],
                 [3, 3, 4],
                 [4, 4, 4],
                 [1, 3],
                 [2, undef, 2],
                 [1, undef, 1],
                 [1, undef, 1],
                 [3, undef, 3],
                 [3, undef, 3],
                 [3, undef, 4]);

    my $sk = 'Statistics::Krippendorff'->new(units => \@units);
    is $sk->alpha, float(0.691, precision => 3),
        'Wikipedia example array, default delta';

    $sk->delta(\&Statistics::Krippendorff::delta_interval);
    is $sk->alpha, float(0.811, precision => 3),
        'Wikipedia example interval';
}
