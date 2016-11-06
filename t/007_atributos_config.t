use strict;
use lib 'lib';
use Data::Dumper;
use Test::More qw(no_plan);
use Test::More::Behaviour;
use Test::Deep;
use HEUP;

$Service::Atributo::logger->level('TRACE');

describe "Como desarrollado quiero crear un archivo de definicion de Atributos usando un lenguaje propio" => sub {
  context "CUANDO ejecuto el init del Servicio de Atributo" => sub {
		Service::Atributo->init;
		my $atributo_name = Service::Atributo->traer('name');
		my $atributo_sex = Service::Atributo->traer('sex');
    it "ENTONCES debo tener el atributo name" => sub {
      is $atributo_name->key, 'name';
      ok $atributo_name->es_requerido;
      ok $atributo_name->posibles;
    };
    it "ENTONCES debo tener el atributo sex" => sub {
      is $atributo_sex->key, 'sex';
      ok $atributo_sex->es_requerido;
      ok $atributo_sex->posibles;
      ok $atributo_sex->validos;
    };
  };
};
