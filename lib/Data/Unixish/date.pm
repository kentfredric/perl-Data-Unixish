package Data::Unixish::date;

use 5.010;
use feature::each_on_array; # for Perl < 5.12
use strict;
use warnings;
use Log::Any '$log';
use POSIX qw(strftime);
use Scalar::Util qw(looks_like_number blessed);

# VERSION

our %SPEC;

$SPEC{date} = {
    v => 1.1,
    summary => 'Format date',
    description => <<'_',

_
    args => {
        in  => {schema=>'any'},
        out => {schema=>'any'},
        format => {
            summary => 'Format',
            schema=>[str => {default=>0}],
            cmdline_aliases => { f=>{} },
        },
        # tz?
    },
    tags => [qw/sorting/],
};
sub date {
    my %args = @_;
    my ($in, $out) = ($args{in}, $args{out});
    my $format  = $args{format} // '%Y-%m-%d %H:%M:%S';

    my $required;

    while (my ($index, $item) = each @$in) {
        my @lt;
        if (looks_like_number($item) &&
                $item >= 0 && $item <= 2**31) { # XXX Y2038-bug
            @lt = localtime($item);
        } elsif (blessed($item) && $item->isa('DateTime')) {
            # XXX timezone!
            @lt = localtime($item->epoch);
        } else {
            goto OUT_ITEM;
        }

        $item = strftime $format, @lt;

      OUT_ITEM:
        push @$out, $item;
    }

    [200, "OK"];
}

1;
# ABSTRACT: Format date
