use strict;
use lib 'lib';
use Test::More qw(no_plan);
use Test::More::Behaviour;
use Test::Deep;
use Data::Dumper;

use HEUP;

use Util;


$Service::Atributo::logger->level('WARN');
Service::Atributo->init;
describe "Como desarrollador quiero implementar una forma de traducir los tokens que uso" => sub {
  context "CUANDO traduzco un string" => sub {
    my $t = t('Ut in brown_eyes fermentum, vestibulum nulla eget, bibendum enim. Morbi ullamcorper sit amet nunc sit amet accumsan. Nunc tempor augue et ligula sollicitudin, ac imperdiet turpis egestas. Curabitur nisi libero, dignissim sed ipsum non, imperdiet pharetra ligula.');
    it "ENTONCES entonces debo recibir la traduccion" => sub {
      is $t, 'Ut in ojos marrones fermentum, vestibulum nulla eget, bibendum enim. Morbi ullamcorper sit amet nunc sit amet accumsan. Nunc tempor augue et ligula sollicitudin, ac imperdiet turpis egestas. Curabitur nisi libero, dignissim sed ipsum non, imperdiet pharetra ligula.';
    };
  };
  context "CUANDO traduzco una palabra string" => sub {
    my $t = t('brown_eyes');
    it "ENTONCES entonces debo recibir la traduccion" => sub {
      is $t, 'ojos marrones';
    };
  };

};
