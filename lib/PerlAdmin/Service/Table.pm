package PerlAdmin::Service::Table;
use strict;
use warnings;
use utf8;

use PerlAdmin::Model::Table;

sub select_all_tables {
    my ($class, $c, $args) = @_;

    my $database_name = $args->{database_name};

    $c->{dbh} ||= PerlAdmin::DB->build_dbh($c);
    my $dbh = $c->{dbh};

    my @table_names = map { @$_ } @{
        $dbh->selectall_arrayref(qq{SHOW TABLES FROM $database_name});
    };

    my @tables;
    for my $table_name (@table_names) {
        my $num_of_records = $dbh->selectall_arrayref(qq{SELECT COUNT(*) FROM $database_name.$table_name})->[0]->[0];
        my $table_info     = $dbh->selectall_hashref(qq{SHOW TABLE STATUS FROM $database_name LIKE '$table_name'}, 'Name')->{$table_name};

        my $updated_at = $table_info->{Update_time} || '-';
        my $created_at = $table_info->{Create_time};

        my $table = PerlAdmin::Model::Table->new({
            name           => $table_name,
            num_of_records => $num_of_records,
            updated_at     => $updated_at,
            created_at     => $created_at,
        });
        push @tables, $table;
    }
    return @tables;
}

sub single_schema {
    my ($class, $c, $args) = @_;

    my $database_name = $args->{database_name};
    my $table_name    = $args->{table_name};

    $c->{dbh} ||= PerlAdmin::DB->build_dbh($c);
    my $dbh = $c->{dbh};

    return join("\n", @{$dbh->selectall_arrayref(qq{SHOW CREATE TABLE $database_name.$table_name})->[0]});
}
1;
