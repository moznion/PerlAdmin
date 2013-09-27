package PerlAdmin::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::Lite;

use PerlAdmin::Service::Database;
use PerlAdmin::Service::Table;
use PerlAdmin::Service::Record;

any '/' => sub {
    my $c = shift;
    my @databases = PerlAdmin::Service::Database->select_all_databases($c);
    return $c->render('index.tt' => { databases => \@databases, });
};

get '/:database_name' => sub {
    my ($c, $args) = @_;
    my @tables = PerlAdmin::Service::Table->select_all_tables($c, $args);
    return $c->render('database.tt' => {
        tables        => \@tables,
        database_name => $args->{database_name},
    });
};

get '/:database_name/:table_name/record' => sub {
    my ($c, $args) = @_;

    use Data::Dumper::Concise; warn Dumper($c->session->get('perladmin.records')->[$c->request->param('index')]);
    return $c->render('index.tt');
};

get '/:database_name/:table_name' => sub {
    my ($c, $args) = @_;

    my $records = PerlAdmin::Service::Record->select_records($c, $args);
    my @columns = sort { $a cmp $b } keys %{$records->{records}->[0]->fields};

    return $c->render('table.tt' => {
        database_name    => $args->{database_name},
        table_name       => $args->{table_name},
        columns          => \@columns,
        records          => $records->{records},
        num_of_pages     => $records->{num_of_pages},
        page             => $records->{page},
        records_per_page => $records->{records_per_page},
    });
};

get '/:database_name/:table_name/:page' => sub {
    my ($c, $args) = @_;

    my $records = PerlAdmin::Service::Record->select_records($c, $args);
    my @columns = sort { $a cmp $b } keys %{$records->{records}->[0]->fields};

    return $c->render('table.tt' => {
        database_name    => $args->{database_name},
        table_name       => $args->{table_name},
        columns          => \@columns,
        records          => $records->{records},
        num_of_pages     => $records->{num_of_pages},
        page             => $records->{page},
        records_per_page => $records->{records_per_page},
    });
};

1;
