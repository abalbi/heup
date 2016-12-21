use strict;
use lib 'lib';
use Data::Dumper;
use Test::More qw(no_plan);
use Test::More::Behaviour;
use Test::Deep;
use HEUP;

$Service::Historia::logger->level('TRACE');
Service::Historia->init;
describe "Como desarrollador quiero tener un entorno donde se registren los personajes de las historias que creo" => sub {
  context "CUANDO el crear del Servicio de Entornos" => sub {
    my $entorno = Service::Entorno->crear;
    it "ENTONCES debo tener un Entorno" => sub {
      isa_ok $entorno, 'Entorno';
    };
    it "ENTONCES debo tener en el Entorno un id de entorno" => sub {
      like $entorno->id, qr/[A-Z1-9]+/;
    };
  };
  context "CUANDO registro un personaje en un entorno" => sub {
    my $entorno = Service::Entorno->crear;
    my $personaje = Personaje->new;
    $personaje->name('Alcatraz');
    $entorno->agregar($personaje);
    it "ENTONCES puedo obtener el personaje si lo buscon en el entorno" => sub {
      is $entorno->personaje('Alcatraz'), $personaje;
      cmp_deeply $entorno->personajes, [$personaje];
    };
  };
  context "CUANDO le pido al servicio de historias una historia" => sub {
    my $entorno = Service::Entorno->crear;
    my $historia = Service::Historia->crear({entorno => $entorno->id});
    it "ENTONCES la historia debe tener un entorno definido" => sub {
      is $historia->entorno, $entorno;
      isa_ok $historia->entorno, 'Entorno';
    };
  };
  context "CUANDO cuando pido el detalle de un entorno " => sub {
    my $entorno = Service::Entorno->crear;
    my $personaje = Personaje->new;
    $personaje->name('Alcatraz');
    $entorno->agregar($personaje);
    $personaje = Personaje->new;
    $personaje->name('Bastille');
    $entorno->agregar($personaje);
    $personaje = Personaje->new;
    $personaje->name('Australia');
    $entorno->agregar($personaje);
    it "ENTONCES debe devolverme una lista de personajes" => sub {
      like $entorno->detalle, qr/Australia/;
      like $entorno->detalle, qr/Bastille/;
    };
  };
};
