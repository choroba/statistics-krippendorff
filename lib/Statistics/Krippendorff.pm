=head1 NAME

Statistics::Krippendorff - Calculate Krippendorff's alpha

=head1 VERSION

Version 0.01

=cut

package Statistics::Krippendorff;

use 5.026;
use warnings;
use experimental qw( signatures );

our $VERSION = '0.01';

use Exporter qw{ import };
our @EXPORT_OK = qw{ alpha jaccard_index delta_nominal delta_interval };

use List::Util qw{ sum };

sub alpha($units, $delta = \&delta_nominal) {
    if (ref [] eq ref $units->[0]) {
        $units = [map {
            my $unit = $_;
            +{map +($_ => $unit->[$_]),
              grep defined $unit->[$_],
              0 .. $#$unit}
        } @$units];
    }
    my %subf;
    @subf{ map values %$_, @$units } = ();
    my @s = sort keys %subf;

    my %coinc;
    my %exp;
    for my $v (@s) {
        for my $v_ (@s) {
            $coinc{$v}{$v_} = sum(map {
                my $unit = $_;
                my @k = keys %$unit;
                sum(0,
                    map {
                        my $i = $_;
                        scalar grep $unit->{$_} eq $v_,
                        grep $i ne $_, @k
                    } grep $unit->{$_} eq $v, @k
                ) / (@k - 1)
            } @$units);
        }
    }
    my %n;
    @n{ sort keys %coinc } = map sum(values %{ $coinc{$_} }), sort keys %coinc;
    my $n = sum(values %n);
    for my $v (sort keys %subf) {
        for my $v_ (sort keys %subf) {
            $exp{$v}{$v_} = ($v eq $v_
                             ? $n{$v} * ($n{$v} - 1)
                             : $n{$v} * $n{$v_}) / ($n - 1);
        }
    }

    my $d_o = sum(map {
        my $v = $_;
        map {
            $coinc{$v}{$_} * $delta->($v, $_)
        } sort keys %coinc
    } sort keys %coinc);
    my $d_e = sum(map {
        my $v = $_;
        map {
            $exp{$v}{$_} * $delta->($v, $_)
        } sort keys %exp
    } sort keys %exp);
    my $alpha = 1 - $d_o / $d_e;
    return $alpha
}

sub delta_nominal($s1, $s2) { $s1 eq $s2 ? 0 : 1 }

sub delta_interval($v0, $v1) { ($v0 - $v1) ** 2 }

sub jaccard_index($s1, $s2) {
    my @s1 = split /,/, $s1;
    my @s2 = split /,/, $s2;

    my %union;
    @union{ @s1, @s2 } = ();

    my %intersection;
    @intersection{@s1} = ();

    return 1 - (grep exists $intersection{$_}, @s2) / keys %union
}

=head1 SYNOPSIS

  use Statistics::Krippendorff qw{ alpha delta_nominal };

  my @units = ({rater1 => 1, rater2 => 1},
               {rater1 => 2, rater2 => 2, rater3 => 1},
               {rater2 => 3, rater3 => 2});
  my $alpha1 = alpha(\@units, \&delta_nominal);
  my $alpha2 = alpha(\@units);  # Same as above, default delta function.

  my $alpha_interval = alpha([[1, 1], [2,2,1], [undef,3,2]],
                             sub ($v0, $v1) { ($v0 - $v1) ** 2 });

=head1 EXPORT

All the following subroutines can be exported, nothing is exported by default.

=head1 SUBROUTINES

=head2 alpha($units, $delta)

Returns Krippendorff's alpha for the given units.

The first argument must be an array reference. There are two supported types
of units (all the units must be of the same type).

=over

=item 1.

Each unit is a hash reference of the form

  { referer1 => 'value1', referer3 => 'value2', ... }

=item 2.

Each unit is an array reference of the form

  ['value1', undef, 'value2']

=back

In both the cases, there must be at least two values in each unit.

The second argument is optional, defaults to delta_nominal (see below).

=head2 delta_nominal

=head2 delta_interval

=head2 jaccard_index

=head1 AUTHOR

E. Choroba, C<< <choroba at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-statistics-krippendorff at rt.cpan.org>, or through
the web interface at L<https://rt.cpan.org/NoAuth/ReportBug.html?Queue=Statistics-Krippendorff>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Statistics::Krippendorff


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<https://rt.cpan.org/NoAuth/Bugs.html?Dist=Statistics-Krippendorff>

=item * CPAN Ratings

L<https://cpanratings.perl.org/d/Statistics-Krippendorff>

=item * Search CPAN

L<https://metacpan.org/release/Statistics-Krippendorff>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2025 by E. Choroba.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)


=cut

__PACKAGE__
