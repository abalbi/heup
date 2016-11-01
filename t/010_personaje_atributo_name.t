use strict;
use lib 'lib';
use Test::More qw(no_plan);
use Test::More::Behaviour;
use Test::Deep;
use Data::Dumper;
use HEUP;

use Util;

describe "Como usuario quiero que el personaje tenga un nombre acorde con su sexo " => sub {
  context "CUANDO ejecuto el init del Servicio de Atributo" => sub {
    Service::Atributo->init;
    my $atributo_name = Service::Atributo->traer('name');
    it "ENTONCES el atributo name debe ser un Atributo::Name" => sub {
      isa_ok $atributo_name, 'Atributo::Name';
    };
    it "ENTONCES el atributo name posibles debe devolver strings segun el sexo que le pase" => sub {
      like $atributo_name->posibles({sex => 'f'}), qr/\w+/;
    };
  };
  context "DADO un personaje" => sub {
    my $personaje = Personaje->new;
    context "CUANDO le defino valor para sex en el constructor y no un name" => sub {
      my $constructor = Constructor->new({sex => 'f'});
      $constructor->personaje($personaje);
      my $atributo_name = Service::Atributo->traer('name');
      it "ENTONCES el hacer me debe devolver un personaje con un name para el sex" => sub {
        my $per = $constructor->hacer;
        is $personaje->sex, 'f';
        cmp_deeply $personaje->name,  any(@{$atributo_name->posibles({sex => 'f'})});
      };
    };
  };
};
