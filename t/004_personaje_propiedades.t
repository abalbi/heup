use strict;
use lib 'lib';
use Data::Dumper;
use Test::More qw(no_plan);
use Test::More::Behaviour;
use HEUP;

$Personaje::logger->level('TRACE');
$Personaje::Propiedad::logger->level('TRACE');

describe "Como desarrollador quiero que mi personaje tenga propiedades" => sub {
  context "CUANDO asigno una propiedad" => sub {
    my $personaje = Personaje->new;
    $personaje->name('Juan');
    it "ENTONCES el personaje tendra ese valor en la propiedad" => sub {
    	is $personaje->name, 'Juan';
    };
    context "Y si pido la propiedad" => sub {
      it "ENTONCES debe devolverme un objeto propiedad con su valor correspondiente" => sub {
        my $propiedad = $personaje->propiedad('name');
        isa_ok $propiedad, 'Personaje::Propiedad';
        is $propiedad->valor, 'Juan';
      };
    };
  };
};
