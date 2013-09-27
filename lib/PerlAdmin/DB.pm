package PerlAdmin::DB;
use strict;
use warnings;
use utf8;

use parent qw/Teng/;
use Teng::Schema::Loader;
use DBI;

sub build_dbh {
    my ($class, $c) = @_;

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

    my $driver = $dbh->{Driver}->{Name};
    if ($driver eq 'mysql') {
        $dbh->do(q{SET SESSION sql_mode=STRICT_TRANS_TABLES;});
    }
    else {
        die "This method is not supported for $driver";
    }

    return $dbh;
}

sub build_teng {
    my ($class, $c) = @_;

    Teng::Schema::Loader->new({
        dbh       => $class->build_dbh($c),
        namespace => 'PerlAdmin::DB',
    });
}
1;
