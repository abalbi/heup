use strict;
use lib 'lib';
use Test::More qw(no_plan);
use Test::More::Behaviour;
use Test::Deep;
use HEUP;

use Util;

describe "Como usuario quiero que el personaje tenga un nombre, definido por mi o al random, segun la configuracion" => sub {
	context "CUANDO ejecuto heup con un nombre para el personaje" => sub {
		my $out = HEUP->ejecutar({name => 'Aldo'});
    it "ENTONCES tiene que devolver la descripcion del personaje" => sub {
    	like $out, qr/Aldo\:/;
    };
  };
  context "DADO un personaje" => sub {
    my $personaje = Personaje->new;
    context "CUANDO le defino valor a un argumento que sea un atributo en el constructor" => sub {
      my $constructor = Constructor->new({name => 'Aldo'});
      $constructor->personaje($personaje);
      my $atributo_sex = Service::Atributo->traer('sex');
      it "ENTONCES el hacer me debe devolver un personaje con un atributo con ese valor" => sub {
        my $per = $constructor->hacer;
        is $per->name, 'Aldo';
        is $personaje->name, 'Aldo';
        cmp_deeply $personaje->sex,  any(@{$atributo_sex->posibles});

      };
    };

    context "CUANDO pido al Service::Atributo con un filtro de src" => sub {
      my $filtro = { src => 'comun.heup'};
      my $atributos = Service::Atributo->atributos($filtro);
      it "ENTONCES todos los atributos tiene que tener el src selecionado" => sub {
        is $atributos->[0]->src, 'comun.heup';
      };
    };

    context "CUANDO le no defino valor en el constructor" => sub {
      my $constructor = Constructor->new;
      $constructor->personaje($personaje);
      my $atributo_name = Service::Atributo->traer('name');
      my $atributo_sex = Service::Atributo->traer('sex');
      it "ENTONCES el hacer me debe asignar valores al random en los atributos que estan en el comun.heup" => sub {
        $constructor->hacer;
        cmp_deeply $personaje->name, any(@{$atributo_name->posibles});
        cmp_deeply $personaje->sex,  any(@{$atributo_sex->posibles});
      };
    };

    context "CUANDO ejecuto el azar de Util con un numero" => sub {
      my $valor = azar(10);
      it "ENTONCES el hacer me debe devolver un numero mejor o igual al enviado" => sub {
        cmp_ok $valor, '<=', 10;
      };
    };

    context "CUANDO ejecuto el azar de Util con una ref a un array" => sub {
      my $valor = azar([qw(a b c)]);
      it "ENTONCES el hacer me debe devolver un elemento del array" => sub {
        cmp_deeply $valor, any(qw(a b c));
      };
    };
  };
};
