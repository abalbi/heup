package HEUP;
use Data::Dumper;
use lib 'lib';
use Log::Log4perl;

Log::Log4perl->init("log.conf");
our $logger = Log::Log4perl->get_logger(__PACKAGE__);
$logger->level('TRACE');

use Model::Personaje;
use Model::Personaje::Propiedad;

our $app_path = $ENV{PWD};
our $bin_path = $app_path.'/bin';
our $heup_path = $bin_path.'/heup';

chmod 0755, $heup_path if ! -X $heup_path;

sub ejecutar {
	return ':';
}

1;