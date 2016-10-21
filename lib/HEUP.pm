package HEUP;
use Data::Dumper;
use lib 'lib';

use Model::Personaje;
use Model::Atributo;
use Service::Atributo;
use Service::Personaje;

our $app_path = $ENV{PWD};
our $bin_path = $app_path.'/bin';
our $heup_path = $bin_path.'/heup';

chmod 0755, $heup_path if ! -X $heup_path;

srand(24170985);

sub ejecutar {
	my $class = shift;
	my $args = {@_};
	my $personaje = Service::Personaje->crear($args);
	return $personaje->detalle;
}

1;