use strict;
use lib 'lib';
use Test::More qw(no_plan);
use Test::More::Behaviour;
use HEUP;

describe "Como usuario quiero que al ejecutar heup me imprima la descripcion de un personaje" => sub {
	context "CUANDO ejecuto heup" => sub {
		my $out = HEUP->ejecutar;
    it "ENTONCES tiene que devolver la descripcion del personaje" => sub {
    	like $out, qr/\:/;
    };
  };
};
