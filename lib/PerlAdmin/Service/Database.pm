package PerlAdmin::Service::Database;
use strict;
use warnings;
use utf8;
use Carp;

use PerlAdmin::DB;

sub select_all_databases {
    my ($class, $c) = @_;

    $c->{dbh} ||= PerlAdmin::DB->build_dbh($c);
    my $dbh = $c->{dbh};

    $dbh->{HandleError} = sub {
        Carp::cluck($_[0]);
        # MyAdmin::Exception->throw($_[0]);
    };
    if ($dbh->{Driver}->{Name} eq 'mysql') {
        $dbh->do(q{SET SESSION sql_mode=STRICT_TRANS_TABLES;});
    }

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
