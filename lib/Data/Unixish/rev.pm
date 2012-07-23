package Data::Unixish::rev;

use 5.010;
use strict;
use warnings;
use Log::Any '$log';

# VERSION

our %SPEC;

$SPEC{rev} = {
    v => 1.1,
    summary => 'Reverse items',
    args => {
        in  => {schema=>'any'},
        out => {schema=>'any'},
    },
    tags => [qw/ordering/],
};
sub rev {
    my %args = @_;
    my ($in, $out) = ($args{in}, $args{out});
    my $n = $args{items} // 10;

    my @tmp;
    while (my ($index, $item) = each @$in) {
        push @tmp, $item;
    }

    push @$out, pop @tmp while @tmp;
    [200, "OK"];
}

1;
# ABSTRACT: Reverse items