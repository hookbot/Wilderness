package Item::Axe;

use strict;
use warnings;

use base qw(Item);

sub desc {
    return "It looks a bit crude, but the handle gives it leverage\n"
        .  "\tmaking it more capable of chopping larger things";
}

sub get_ingredients { return qw{handaxe stick cord} }

sub weight { return 5 }
sub sharpness { return 10 }

sub process {
    return "You place the handaxe on one end of the stick\n"
        .  "\tand fasten them together with the cord";
}

1;
