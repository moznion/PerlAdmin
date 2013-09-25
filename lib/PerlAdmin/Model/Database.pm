package PerlAdmin::Model::Database;
use strict;
use warnings;
use utf8;

use Class::Accessor::Lite (
    new => 1,
    ro  => [qw(
        name
        num_of_tables
        last_updated_at
    )],
);

1;
