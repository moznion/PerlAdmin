package PerlAdmin::Model::Record;
use strict;
use warnings;
use utf8;

use Class::Accessor::Lite(
    new => 1,
    ro  => [qw(
        fields
        primary
    )],
);

1;
