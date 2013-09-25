package PerlAdmin::DB;
use strict;
use warnings;
use utf8;

use DBI;

sub build_dbh {
    # my @config = @{$c->config->{database}};

    my $dsn = 'dbi:mysql:';
    # if (defined $dbhost) {
    #     $dsn .= "host=$dbhost;";
    # }
    # if (defined $dbport) {
    #     $dsn .= "port=$dbport;";
    # }
    my $username = 'root';
    my $password = '';

    my $database = [
        $dsn,
        $username,
        $password,
    ];

    my @config = @$database;

    $config[3]->{mysql_enable_utf8} ||= 1;
    $config[3]->{ShowErrorStatement} ||= 1;
    $config[3]->{RaiseError} = 1;
    my $dbh = DBI->connect(
        @config
    );# or MyAdmin::Exception->throw($DBI::errstr);
}

1;
