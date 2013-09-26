package PerlAdmin::Model::Table;
use strict;
use warnings;
use utf8;

use Class::Accessor::Lite (
    new => 1,
    ro  => [qw(
        name
        num_of_records
        data
        created_at
        updated_at
    )],
);

1;
