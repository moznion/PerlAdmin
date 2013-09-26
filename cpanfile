requires 'perl', '5.008001';
requires 'Amon2', '4.03';
requires 'Text::Xslate', '1.6001';
requires 'DBD::SQLite'                    , '1.33';
requires 'HTML::FillInForm::Lite'         , '1.11';
requires 'JSON'                           , '2.50';
requires 'Module::Functions'              , '2';
requires 'Plack::Middleware::ReverseProxy', '0.09';
requires 'Plack::Middleware::Session'     , '0';
requires 'Plack::Session'                 , '0.14';
requires 'Teng'                           , '0.18';
requires 'Test::WWW::Mechanize::PSGI'     , '0';
requires 'Time::Piece'                    , '1.20';
requires 'Amon2::Web';
requires 'Amon2::Web::Dispatcher::Lite';
requires 'Class::Accessor::Lite';
requires 'DBI';
requires 'Plack::Builder';
requires 'Plack::Session::State::Cookie';
requires 'Plack::Session::Store::File';
requires 'Teng::Row';
requires 'Teng::Schema::Declare';
requires 'Time::Piece::Plus';
requires 'URI::Escape';
requires 'parent';

on 'configure' => sub {
   requires 'Module::Build', '0.38';
   requires 'Module::CPANfile', '0.9010';
};

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'Plack::Test';
    requires 'Plack::Util';
    requires 'Test::Requires';
};

on develop => sub {
    requires 'Perl::Critic', '1.105';
    requires 'Test::Perl::Critic', '1.02';
};
