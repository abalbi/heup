use strict;
use Test::More qw(no_plan);
use Test::More::Behaviour;

describe "Como usuario quiero tener un comando de linea de comando que me permita ejecutar las acciones del sistema." => sub {
	context "CUANDO ejecuto por prompt heup" => sub {
    my $out = `bin/heup`;
    it "ENTONCES tiene que devolver un 'Hello HEUP'" => sub {
      like $out, qr/Hello HEUP/;
    };
  };
};
