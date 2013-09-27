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

    my $records_info   = $dbh->selectall_arrayref("DESCRIBE $database_name.$table_name");
    my $primary_column = do {
        my ($primary_record) = grep { $_->[3] eq 'PRI' } @$records_info;
        $primary_record->[0];
    }; # TODO now, it doesn't support for multiple primary columns.

    my $query = sprintf("SELECT * FROM %s.%s LIMIT %d OFFSET %d", $database_name, $table_name, RECORDS_PER_PAGE, $page * RECORDS_PER_PAGE );
    my $records = $dbh->selectall_hashref($query, $primary_column);

    my @records;
    for my $key (keys %$records) {
        my $data = $records->{$key};
        push @records, PerlAdmin::Model::Record->new({
            fields  => $data,
            primary => $data->{$primary_column},
        });
    }

    return +{
        records          => \@records,
        primary_column   => $primary_column,
        num_of_pages     => $num_of_pages,
        page             => $page,
        records_per_page => RECORDS_PER_PAGE,
    }
}

sub single_record {
    my ($class, $c, $args) = @_;

    my $database_name = $args->{database_name};
    my $table_name    = $args->{table_name};
    my $primary       = $args->{primary};

    $c->{dbh} ||= PerlAdmin::DB->build_dbh($c);
    my $dbh = $c->{dbh};

    my $primary_column = $class->_fetch_primary_column($dbh, $database_name, $table_name);

    my $query = sprintf("SELECT * FROM %s.%s WHERE %s = '%s'", $database_name, $table_name, $primary_column, $primary);
    my $record = $dbh->selectall_hashref($query, $primary_column);

    if ($record) {
        $record = $record->{$primary};
    }

    return $record;
}

sub _fetch_primary_column {
    my ($class, $dbh, $database_name, $table_name) = @_;

    my $records_info   = $dbh->selectall_arrayref("DESCRIBE $database_name.$table_name");
    my ($primary_record) = grep { $_->[3] eq 'PRI' } @$records_info;
    $primary_record->[0]; # TODO now, it doesn't support for multiple primary columns.
}
1;
