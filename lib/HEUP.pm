package HEUP;
use Data::Dumper;
use lib 'lib';
use Log::Log4perl;
use Data::Dumper;

Log::Log4perl->init("log.conf");
our $logger = Log::Log4perl->get_logger(__PACKAGE__);
$logger->level('TRACE');

<<<<<<< HEAD
use Factory::Atributo;
=======
>>>>>>> 3a17a97b9d5d3dce774d02aeaa1192860d7eb1ab
use Model::Atributo;
use Model::Atributo::Concept;
use Model::Atributo::Name;
use Model::Entorno;
use Model::Historia;
<<<<<<< HEAD
use Model::Historia::Tipo;
use Model::Incidente;
use Model::Incidente::Tipo;
use Model::Personaje;
use Model::Personaje::Propiedad;
use Model::Valor;
=======
use Model::Tipo;
use Model::Personaje;
use Model::Personaje::Propiedad;
use Service::Entorno;
use Service::Entorno::Constructor;
use Service::Historia;
use Service::Historia::Constructor;
>>>>>>> 3a17a97b9d5d3dce774d02aeaa1192860d7eb1ab
use Service::Atributo;
use Service::Entorno;
use Service::Entorno::Constructor;
use Service::Historia;
use Service::Historia::Constructor;
use Service::Incidente;
use Service::Personaje;
use Service::Personaje::Constructor;

our $app_path = $ENV{PWD};
our $bin_path = $app_path.'/bin';
our $heup_path = $bin_path.'/heup';

chmod 0755, $heup_path if ! -X $heup_path;

<<<<<<< HEAD
=======
Service::Atributo->init;
Service::Historia->init;
>>>>>>> 3a17a97b9d5d3dce774d02aeaa1192860d7eb1ab

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
  Service::Historia->init;
  Service::Incidente->init;
  $random = 1 if $args->{'random'};
  my $rtn = '';
  my $historia = Service::Historia->crear($args);
  $rtn .= $historia->detalle_personajes;
  $rtn .= "####################################################\n";
  $rtn .= $historia->detalle;
 	return $rtn;
}

1;