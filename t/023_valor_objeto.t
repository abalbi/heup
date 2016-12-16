use strict;
use lib 'lib';
use Test::More qw(no_plan);
use Test::More::Behaviour;
use Test::Deep;
use Data::Dumper;
use HEUP;

use Util;

describe "Como desarrollador quiero que los valores en los atributos sean representados por objetos en todos los casos" => sub {
  context "CUANDO instancio un objeto Valor" => sub {
    my $valor = Valor->new({valor => 'aca'});
    it "ENTONCES puedo interpolarlo sin problemas como un string" => sub {
      is 'C'.$valor, 'Caca';
    };
  };
};
