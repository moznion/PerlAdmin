package PerlAdmin::Service::Database;
use strict;
use warnings;
use utf8;

use Carp;
use DBI;

sub select_all_databases {
    # my $c = shift;
    my $class = shift;

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
    $dbh->{HandleError} = sub {
        Carp::cluck($_[0]);
        # MyAdmin::Exception->throw($_[0]);
    };
    if ($dbh->{Driver}->{Name} eq 'mysql') {
        $dbh->do(q{SET SESSION sql_mode=STRICT_TRANS_TABLES;});
    }

    # my $driver = $c->dbh->{Driver}->{Name};
    my $driver = $dbh->{Driver}->{Name};
    if ($driver eq 'mysql') {
        my @databases = map { @$_ } @{
            $dbh->selectall_arrayref(q{SHOW DATABASES});
        };
        return @databases;
    } elsif ($driver eq 'SQLite') {
        return 'main';
    } else {
        die "This method is not supported for $driver";
    }
}

1;
