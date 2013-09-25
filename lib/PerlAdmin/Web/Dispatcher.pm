package PerlAdmin::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::Lite;

use PerlAdmin::Service::Database;

any '/' => sub {
    my ($c) = @_;

    my @databases = PerlAdmin::Service::Database->select_all_databases;

    return $c->render('index.tt' => { databases => \@databases, });
};

post '/account/logout' => sub {
    my ($c) = @_;
    $c->session->expire();
    return $c->redirect('/');
};

1;
