use strict;
use lib 'lib';
use Data::Dumper;
use Test::More qw(no_plan);
use Test::More::Behaviour;
use HEUP;

describe "Como desarrollador quiero crear un constructor de personajes para definir diferentes estrategias de creacion de estos" => sub {
  context "CUANDO le paso un personaje al constructor del servicio de personajes" => sub {
	my $personaje = Personaje->new;
	my $constructor = Constructor->new;
	$constructor->personaje($personaje);
    it "ENTONCES debe devolverme el personaje que le pase al ejecutar hacer" => sub {
      is $constructor->hacer, $personaje;
    };
  };
};
