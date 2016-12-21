use strict;
use lib 'lib';
use Data::Dumper;
use Test::More qw(no_plan);
use Test::More::Behaviour;
use Test::Deep;
use HEUP;

Service::Incidente->init;

describe "Como usuario quiero que mis personajes se les genere una historia que genere Incidentes en el entorno" => sub {
  context "CUANDO pido al servicio de entornos que cree el transfondo de un personaje en un entorno" => sub {
    my $personaje = Service::Personaje->crear;
    my $entorno = Service::Entorno->crear;
    $entorno->agregar($personaje);
    Service::Entorno->hacer_incidentes($entorno, $personaje);
    it "ENTONCES el personaje debe tener una lista de incidentes" => sub {
      ok $personaje->incidentes;
    };
  };
};
