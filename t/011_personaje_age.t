use strict;
use lib 'lib';
use Test::More qw(no_plan);
use Test::More::Behaviour;
use Test::Deep;
use Data::Dumper;
use HEUP;

use Util;
$Constructor::logger->level('TRACE');
describe "Como usuario quiero que el personaje tenga una edad, definido por mi o al random" => sub {
  context "CUANDO ejecuto el init del Servicio de Atributo" => sub {
    Service::Atributo->init;
    my $atributo_age = Service::Atributo->traer('age');
    it "ENTONCES el atributo age debe tener valores entre un numero y otro" => sub {
      cmp_deeply $atributo_age->posibles, array_each(methods('valor', any(21..40)));
    };
  };
  context "DADO un personaje" => sub {
    my $personaje = Personaje->new;
    context "CUANDO cuando le ejecuto un constructor" => sub {
      my $constructor = Constructor->new({concept => 'criminal'});
      $constructor->personaje($personaje);
      my $atributo_age = Service::Atributo->traer('age');
      it "ENTONCES el hacer me debe devolver un personaje con una edad posibles" => sub {
        my $per = $constructor->hacer;
        cmp_deeply $personaje->age, any(@{$atributo_age->posibles});
      };
    };
    context "CUANDO cuando le ejecuto un constructor con una edad" => sub {
      my $constructor = Constructor->new({age => 19});
      $constructor->personaje($personaje);
      my $atributo_age = Service::Atributo->traer('age');
      it "ENTONCES el hacer me debe devolver un personaje con esa edad" => sub {
        my $per = $constructor->hacer;
        is $personaje->age, 19;
      };
    };
  };

};
