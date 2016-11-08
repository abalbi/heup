use strict;
use lib 'lib';
use Test::More qw(no_plan);
use Test::More::Behaviour;
use Test::Deep;
use Data::Dumper;
use HEUP;

use Util;

describe "Como desarrollador quiero crear relaciones de herencia entre concepts para que se hereden las alteraciones" => sub {
  context "CUANDO ejecuto el init del Servicio de Atributo" => sub {
    Service::Atributo->init;
    my $atributo_concept = Service::Atributo->traer('concept');
    it "ENTONCES el atributo concept sera del tipo Atributo::Concept" => sub {
      isa_ok $atributo_concept, 'Atributo::Concept'
    };
    it "ENTONCES el atributo tendran alteraciones" => sub {
      is scalar(grep {$_->{si_valor} eq 'kid'} @{$atributo_concept->alteraciones}), 1;
    };
  };
  context "DADO un personaje" => sub {
    my $personaje = Personaje->new;
    context "CUANDO cuando le ejecuto un constructor con un concept" => sub {
      my $constructor = Constructor->new({concept => 'nerd'});
      $constructor->personaje($personaje);
      it "ENTONCES el personaje debe tener valores acorde a las alteraciones correspondientes" => sub {
        $constructor->hacer;
        $Data::Dumper::Maxdepth = 4;
        cmp_deeply $personaje->age, any(8..17);
      };
    };
  };

};
