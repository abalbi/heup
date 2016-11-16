use strict;
use lib 'lib';
use Test::More qw(no_plan);
use Test::More::Behaviour;
use Test::Deep;
use HEUP;

use Util;
Service::Atributo->init;

describe "Como usuario quiero que el personaje tenga un sex, definido por mi o al random, segun la configuracion" => sub {
  context "DADO un personaje" => sub {
    my $personaje = Personaje->new;
    context "CUANDO le defino valor a un argumento que sea un atributo en el constructor" => sub {
      my $constructor = Service::Personaje::Constructor->new({sex => 'f'});
      $constructor->personaje($personaje);
      my $atributo_name = Service::Atributo->traer('name');
      it "ENTONCES el hacer me debe devolver un personaje con un atributo con ese valor" => sub {
        my $per = $constructor->hacer;
        is $per->sex, 'f';
        is $personaje->sex, 'f';
        cmp_deeply $personaje->name,  any(@{$atributo_name->posibles});
      };
    };

    context "CUANDO le no defino valor en el constructor" => sub {
      my $constructor = Service::Personaje::Constructor->new;
      $constructor->personaje($personaje);
      my $atributo_name = Service::Atributo->traer('name');
      my $atributo_sex = Service::Atributo->traer('sex');
      it "ENTONCES el hacer me debe asignar valores al random en los atributos que estan en el comun.heup" => sub {
        $constructor->hacer;
        cmp_deeply $personaje->name, any(@{$atributo_name->posibles});
        cmp_deeply $personaje->sex,  any(@{$atributo_sex->posibles});
      };
    };
  };
};
