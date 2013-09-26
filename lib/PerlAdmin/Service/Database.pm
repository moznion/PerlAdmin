package PerlAdmin::Service::Database;
use strict;
use warnings;
use utf8;
use Carp;
use Time::Piece::Plus;

use PerlAdmin::DB;
use PerlAdmin::Model::Database;

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
        my @database_names = map { @$_ } @{
            $dbh->selectall_arrayref(q{SHOW DATABASES});
        };

        my @databases;
        for my $database_name (@database_names) {
            my $num_of_table  = scalar @{$dbh->selectall_arrayref(qq{SHOW TABLES FROM $database_name})};

            my $updated_times = $dbh->selectall_arrayref(qq{SELECT UPDATE_TIME FROM information_schema.TABLES WHERE TABLE_SCHEMA = '$database_name'});
            my @updated_times = grep { defined($_->[0]) } @$updated_times;

            my $last_updated_at;
            if (scalar @updated_times == 0) {
                $last_updated_at = 'N/A';
            }
            else {
                my $latest_epoch = 0;
                for my $time (@updated_times) {
                    my $epoch = Time::Piece::Plus->parse_mysql_datetime(str => $time->[0])->epoch;
                    if ($epoch > $latest_epoch) {
                        $latest_epoch = $epoch;
                    }
                }

                $last_updated_at = Time::Piece::Plus->localtime($latest_epoch)->mysql_datetime;
            }

            push @databases, PerlAdmin::Model::Database->new(
                name            => $database_name,
                num_of_tables   => $num_of_table,
                last_updated_at => $last_updated_at,
            );
        }
        return @databases;
    } elsif ($driver eq 'SQLite') {
        return 'main';
    } else {
        die "This method is not supported for $driver";
    }
}

1;
