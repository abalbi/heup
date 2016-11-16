package HEUP;
use Data::Dumper;
use lib 'lib';
use Log::Log4perl;
use Data::Dumper;

Log::Log4perl->init("log.conf");
our $logger = Log::Log4perl->get_logger(__PACKAGE__);
$logger->level('TRACE');

use Factory::Atributo;
use Model::Atributo;
use Model::Atributo::Concept;
use Model::Atributo::Name;
use Model::Historia;
use Model::Personaje;
use Model::Personaje::Propiedad;
use Model::Valor;
use Service::Historia;
use Service::Historia::Constructor;
use Service::Atributo;
use Service::Personaje;
use Service::Personaje::Constructor;

our $app_path = $ENV{PWD};
our $bin_path = $app_path.'/bin';
our $heup_path = $bin_path.'/heup';

chmod 0755, $heup_path if ! -X $heup_path;


our $srand = 24170985;
our $srand_asignado = 0;
our $random = 0;

sub heup_srand {
  my $args = shift;
  $random = $args->{random} if exists $args->{random};
  if($args->{srand}) {
    $srand = $args->{srand};
    srand($srand);    
    $srand_asignado = 1;
  }
  if(!$srand_asignado) {
    $srand = int rand(99999999) if $random;
    srand($srand);
    $srand_asignado = 1;
  }
  return $srand;
}

sub ejecutar {
  my $class = shift;
  my $args = shift;
  Service::Atributo->init;
  $random = 1 if $args->{'random'};
  my $rtn = '';
  my $historia = Service::Historia->crear($args);
  $rtn .= $historia->detalle_personajes;
  $rtn .= "####################################################\n";
  $rtn .= $historia->detalle;
 	return $rtn;
}

1;