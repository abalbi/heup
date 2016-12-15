use strict;
use lib 'lib';
use Data::Dumper;
use Test::More qw(no_plan);
use Test::More::Behaviour;
use HEUP;

Service::Atributo->init;

describe "Como desarrollador quiero un Servicio de Personajes que se ocupe de crear los personajes" => sub {
  context "CUANDO pido crear un Personaje al Servicio de Personaje" => sub {
		my $personaje = Service::Personaje->crear;
    it "ENTONCES tengo un Personaje" => sub {
      isa_ok $personaje, 'Personaje';
    };
  };
};
