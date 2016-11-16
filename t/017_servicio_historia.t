use strict;
use lib 'lib';
use Data::Dumper;
use Test::More qw(no_plan);
use Test::More::Behaviour;
use HEUP;

describe "Como usuario quiero que cuando pida una historia, el sistema me arme un resumen del argumento" => sub {
  context "CUANDO pido crear una Historia al Servicio de Historia" => sub {
		my $historia = Service::Historia->crear;
    it "ENTONCES tengo una Historia" => sub {
      isa_ok $historia, 'Historia';
    };
  };
};
