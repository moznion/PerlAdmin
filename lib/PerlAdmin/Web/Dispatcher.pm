package PerlAdmin::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::Lite;

use PerlAdmin::Service::Database;
use PerlAdmin::Service::Table;

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
1;
