use inc::Module::Install;

name 'EasyCMS2';
all_from 'lib/EasyCMS2.pm';

requires Catalyst => '5.64';
requires Catalyst::Plugin::HTML::Widget => 0;
requires Catalyst::Model::DBIC::Schema => '0.18';

catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
