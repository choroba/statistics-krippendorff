#!/usr/bin/perl
use warnings;
use strict;

use Statistics::Krippendorff qw{ delta_nominal jaccard_index };

use Test2::V0;
plan 16;

is delta_nominal('a', 'a'), 0, 'nominal a-a';
is delta_nominal('a', 'b'), 1, 'nominal a-b';

is jaccard_index('a', 'a'), 0, 'a a';
is jaccard_index('a', 'b'), 1, 'a b';

is jaccard_index('a', 'a,b'), 0.5, 'a ab';
is jaccard_index('a', 'b,a'), 0.5, 'a ba';
is jaccard_index('a,b', 'a'), 0.5, 'ab a';
is jaccard_index('b,a', 'a'), 0.5, 'ba a';

is jaccard_index('a,b', 'c,d'), 1, 'ab cd';
is jaccard_index('a,b', 'a,b'), 0, 'ab ab';
is jaccard_index('a,b', 'b,a'), 0, 'ab ba';
is jaccard_index('a,b', 'a,c'), 2/3, 'ab ac';
is jaccard_index('a,b', 'c,a'), 2/3, 'ab ca';
is jaccard_index('b,a', 'c,a'), 2/3, 'ba ca';
is jaccard_index('b,a', 'a,c'), 2/3, 'ba ac';

is jaccard_index('a,b,c', 'b,c,d,e'), 3/5, 'abc bcde';
