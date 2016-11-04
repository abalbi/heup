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
      print STDERR Dumper [$atributo_concept->alteraciones];
      cmp_deeply $atributo_concept->alteraciones, [
        {
          si_key => re(qr/\w+/),
          si_valor => re(qr/\w+/),
          entonces_key => re(qr/\w+/),
          entonces_valor => re(qr/\w+/),
        },
      ];
    };
  };
  context "DADO un personaje" => sub {
    my $personaje = Personaje->new;
    context "CUANDO cuando le ejecuto un constructor con un concept" => sub {
      my $constructor = Constructor->new({concept => 'nerd'});
      $constructor->personaje($personaje);
      it "ENTONCES el personaje debe ser de sexo femenino" => sub {
        $constructor->hacer;
        cmp_deeply $personaje->age, any(8..17);
      };
    };
  };

};
