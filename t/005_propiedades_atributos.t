use strict;
use lib 'lib';
use Data::Dumper;
use Test::More qw(no_plan);
use Test::More::Behaviour;
use HEUP;

describe "Como desarrollador quiero que las propiedades esten relacionadas a atributos" => sub {
  context "CUANDO tengo una propiedad a la que le paso nombre en el constructor" => sub {
		my $propiedad = Personaje::Propiedad->new('name');
    it "ENTONCES el personaje tendra el nombre asignado" => sub {
      is $propiedad->key, 'name';
    };
    it "ENTONCES tendra un atributo correspondiente" => sub {
      isa_ok $propiedad->atributo, 'Atributo';
      is $propiedad->atributo->key, 'name';
    };
  };
};
