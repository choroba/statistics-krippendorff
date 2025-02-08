requires 'Moo' => 0;
requires 'namespace::clean' => 0;
requires 'List::Util' => 0;
requires 'strict' => 0;
requires 'warnings' => 0;
requires 'experimental' => 0;

on configure => sub { requires 'ExtUtils::MakeMaker' => 0 };

on test => sub {
    requires 'Test2::V0' => '0.000098';  # Support precision in float().
    requires 'FindBin' => 0;
};
