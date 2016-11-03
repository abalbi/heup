use strict;
use lib 'lib';
use Test::More qw(no_plan);
use Test::More::Behaviour;
use Test::Deep;
use Data::Dumper;
use HEUP;

use Util;

describe "Como usuario quiero que el personaje tenga una concept, definido por mi o al random" => sub {
  context "CUANDO ejecuto el init del Servicio de Atributo" => sub {
    Service::Atributo->init;
    my $atributo_concept = Service::Atributo->traer('concept');
    it "ENTONCES el atributo concept debe tener valores posibles" => sub {
      ok scalar @{$atributo_concept->posibles};
    };
  };
  context "DADO un personaje" => sub {
    my $personaje = Personaje->new;
    context "CUANDO cuando le ejecuto un constructor" => sub {
      my $constructor = Constructor->new;
      $constructor->personaje($personaje);
      my $atributo_concept = Service::Atributo->traer('concept');
      it "ENTONCES el hacer me debe devolver un personaje con un concept posible" => sub {
        my $per = $constructor->hacer;
        cmp_deeply $personaje->concept, any(@{$atributo_concept->posibles});
      };
    };
    context "CUANDO cuando le ejecuto un constructor con un concept" => sub {
      my $constructor = Constructor->new({concept => 'social_hacker'});
      $constructor->personaje($personaje);
      it "ENTONCES el hacer me debe devolver un personaje con ese concept" => sub {
        my $per = $constructor->hacer;
        is $personaje->concept, 'social_hacker';
      };
    };
  };

};
