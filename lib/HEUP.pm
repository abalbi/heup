package HEUP;
use Data::Dumper;
use lib 'lib';
use Log::Log4perl;

Log::Log4perl->init("log.conf");
our $logger = Log::Log4perl->get_logger(__PACKAGE__);
$logger->level('TRACE');

use Constructor;
use Model::Atributo;
use Model::Atributo::Altera;
use Model::Atributo::Name;
use Model::Personaje;
use Model::Personaje::Propiedad;
use Service::Atributo;
use Service::Personaje;

our $app_path = $ENV{PWD};
our $bin_path = $app_path.'/bin';
our $heup_path = $bin_path.'/heup';

chmod 0755, $heup_path if ! -X $heup_path;

Service::Atributo->init;

srand(24170985);

sub ejecutar {
	my $class = shift;
	my $args = shift;
	my $personaje = Service::Personaje->crear($args);
	return $personaje->detalle;
}

1;