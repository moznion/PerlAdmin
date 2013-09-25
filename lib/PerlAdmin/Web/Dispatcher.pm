package PerlAdmin::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::Lite;

use PerlAdmin::Service::Database;

any '/' => sub {
    my $c = shift;
    my @databases = PerlAdmin::Service::Database->select_all_databases($c);
    return $c->render('index.tt' => { databases => \@databases, });
};

get '/:database_name' => sub {
    my $c = shift;

    # TODO

    return $c->render('database.tt');
};
1;
