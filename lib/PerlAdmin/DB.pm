package PerlAdmin::DB;
use strict;
use warnings;
use utf8;

use DBI;

sub build_dbh {
    my ($self, $c) = @_;

    my @config = @{$c->config->{DBI}};

    $config[3]->{mysql_enable_utf8} ||= 1;
    $config[3]->{ShowErrorStatement} ||= 1;
    $config[3]->{RaiseError} = 1;
    DBI->connect(
        @config
    );# or MyAdmin::Exception->throw($DBI::errstr);
}

1;
