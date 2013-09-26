package PerlAdmin::Service::Record;
use strict;
use warnings;
use utf8;

use PerlAdmin::DB;
use PerlAdmin::Model::Record;

use constant RECORDS_PER_PAGE => 25;

sub select_records {
    my ($class, $c, $args) = @_;

    my $database_name = $args->{database_name};
    my $table_name    = $args->{table_name};
    my $page          = $args->{page} || 0;

    $c->{dbh} ||= PerlAdmin::DB->build_dbh($c);
    my $dbh = $c->{dbh};

    my $driver = $dbh->{Driver}->{Name};
    if ($driver eq 'mysql') {
        my @columns = map { $_->[0] } @{$dbh->selectall_arrayref("DESCRIBE $database_name.$table_name")};
        my $query = sprintf("SELECT * FROM %s.%s LIMIT %d OFFSET %d", $database_name, $table_name, RECORDS_PER_PAGE, $page * RECORDS_PER_PAGE );
        my $records = $dbh->selectall_arrayref($query);

        my @records;
        for my $record (@$records) {
            my $fields = [];
            my $i = 0;
            for my $column (@columns) {
                $fields->[$i] = $record->[$i];
                $i++;
            }
            push @records, PerlAdmin::Model::Record->new({
                fields => $fields,
            });
        }
        return +{
            records => \@records,
            columns => \@columns,
        }
    } elsif ($driver eq 'SQLite') {
        return 'main';
    } else {
        die "This method is not supported for $driver";
    }
}
1;
