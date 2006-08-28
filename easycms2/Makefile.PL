use inc::Module::Install;

name 'EasyCMS2';
all_from 'lib/EasyCMS2.pm';

requires Catalyst => '5.7';
requires Catalyst::Plugin::HTML::Widget => 0;
requires Catalyst::Model::DBIC::Schema => '0.18';
requires Catalyst::Controller::BindLex => 0;
requires Catalyst::Action::RenderView => 0;

catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
