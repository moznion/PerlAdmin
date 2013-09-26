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

    my $num_of_records = $dbh->selectall_arrayref(qq{SELECT COUNT(*) FROM $database_name.$table_name})->[0]->[0];
    my $num_of_pages   = $num_of_records / RECORDS_PER_PAGE;
    $num_of_pages++ unless ($num_of_pages =~ /^[0-9]+$/);

    my @columns = map { $_->[0] } @{$dbh->selectall_arrayref("DESCRIBE $database_name.$table_name")};
    my $query = sprintf("SELECT * FROM %s.%s LIMIT %d OFFSET %d", $database_name, $table_name, RECORDS_PER_PAGE, $page * RECORDS_PER_PAGE );
    my $records = $dbh->selectall_arrayref($query);

    my $i = 0;
    my @records;
    for my $record (@$records) {
        my $fields = [];
        my $j = 0;
        for my $column (@columns) {
            $fields->[$j] = $record->[$j];
            $j++;
        }
        $records[$i + $page * RECORDS_PER_PAGE] = PerlAdmin::Model::Record->new({
            fields => $fields,
        });
        $i++;
    }

    return +{
        records          => \@records,
        columns          => \@columns,
        num_of_pages     => $num_of_pages,
        page             => $page,
        records_per_page => RECORDS_PER_PAGE,
    }
}
1;
