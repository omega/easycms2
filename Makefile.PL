use inc::Module::Install;

name 'EasyCMS2';
all_from 'lib/EasyCMS2.pm';

requires 'Catalyst::Runtime' => '5.7';
requires 'Catalyst::Controller::HTML::FormFu' => 0;
requires 'Catalyst::Plugin::I18N' => 0;

requires 'Catalyst::Model::DBIC::Schema' => '0.18';
requires 'Catalyst::Controller::BindLex' => 0;
requires 'Catalyst::Action::RenderView' => 0;
requires 'Catalyst::Plugin::Static::Simple' => 0;

requires 'Catalyst::Plugin::Session' => 0;
requires 'Catalyst::Plugin::Session::Store::FastMmap' => 0;
requires 'Catalyst::Plugin::Session::State::Cookie' => 0;
requires 'Catalyst::Plugin::StackTrace' => 0;

requires 'Catalyst::Plugin::Server::XMLRPC' => 0;

requires 'Catalyst::Plugin::Session::State::Cookie' => 0;
requires 'Catalyst::Plugin::Authentication' => '0.10000';
requires 'Catalyst::Authentication::Store::DBIx::Class' => 0;
requires 'Catalyst::Plugin::ConfigLoader' => 0;
requires 'Data::Dumper::Simple' => 0;

requires 'Moose' => 0;
requires 'MIME::Types' => 0;
requires 'Imager' => 0;
requires 'Text::Textile' => 0;
requires 'Digest::SHA1' => 0;
requires 'Catalyst::View::TT' => 0;
requires 'Catalyst::View::JSON' => 0;

requires 'CatalystX::RoleApplicator';
requires 'Catalyst::TraitFor::Request::ProxyBase';

requires 'Calendar::Calendar' => 0;


requires 'DBIx::Class' => 0.08003;
requires 'DBIx::Class::TimeStamp';
requires 'DateTime::Format::DBI' => 0.031;

requires 'HTML::FormFu';
requires 'HTML::FormFu::Model::DBIC';

requires 'XML::Atom';

requires 'SQL::Translator' => '0.08';

catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
