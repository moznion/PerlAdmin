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
    my $dbh = DBI->connect(
        @config
    ); # or PerlAdmin::Exception->throw($DBI::errstr);

    $dbh->{HandleError} = sub {
        Carp::cluck($_[0]);
        # MyAdmin::Exception->throw($_[0]);
    };
    if ($dbh->{Driver}->{Name} eq 'mysql') {
        $dbh->do(q{SET SESSION sql_mode=STRICT_TRANS_TABLES;});
    }

    return $dbh;
}

1;
