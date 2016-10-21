use strict;
use lib 'lib';
use Test::More qw(no_plan);
use Test::More::Behaviour;

use HEUP;
use Data::Dumper;

describe "Como usuario quiero que el personaje tenga un nombre, definido por mi o al random" => sub {
	context "CUANDO crear en el Servicio de Personaje" => sub {
		context "Y cuando le paso un nombre para el personaje" => sub {
			my $args = {name => 'Juan'};
			my $personaje = Service::Personaje->crear($args);
			it "ENTONCES el personaje debe tener el name 'Juan'" => sub {
				is $personaje->name, 'Juan';
			}
		};
		context "Y no le paso un nombre para el personaje" => sub {
			my $args = {};
			my $personaje = Service::Personaje->crear($args);
			it "ENTONCES el personaje debe tener un name random" => sub {
				like $personaje->name, qr/\w+/;
			}
		};
		context "Y le paso un personaje" => sub {
			my $args = {personaje => Personaje->new};
			my $personaje = Service::Personaje->crear($args);
			it "ENTONCES el personaje devuelto debe ser el mismo" => sub {
				is "$args->{personaje}", "$personaje";
			}
		};
	};
	context "CUANDO asigno a en el Servicio de Atributo" => sub {
		context "Y el personaje tiene la propiedad name" => sub {
			my $key = 'name';
			my $valor = 'Jose';
			my $personaje = Personaje->new;
			my $propiedad = $personaje->prop($key);
			Service::Atributo->asignar_a($personaje, $key, $valor);
		};
	};

	context "CUANDO ejecuto heup" => sub {
		context "Y le paso un nombre para el personaje" => sub {
			my $out = HEUP->ejecutar(name => 'Juan');
   		it "ENTONCES tiene que devolver la descripcion del personaje con el nombre de personaje" => sub {
    		like $out, qr/Juan\:/;
    	};
    };
		context "Y no le paso un nombre para el personaje" => sub {
			my $out = HEUP->ejecutar;
   		it "ENTONCES tiene que devolver la descripcion del personaje con un nombre random" => sub {
    		like $out, qr/\w+\:/;
    	};
    };
  };
};
describe "Model::Personaje" => sub {
	my $personaje = Personaje->new;
	context "CUANDO un metodo no declarado" => sub {
		context "Y el metodo es un atributo" => sub {
		};
	};
};
