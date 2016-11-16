use strict;
use lib 'lib';
use Test::More qw(no_plan);
use Test::More::Behaviour;
use Test::Deep;
use Data::Dumper;
use HEUP;

use Util;

describe "Como desarrollador quiero crear relaciones de herencia entre concepts para que se hereden las alteraciones" => sub {
  context "DADO un personaje" => sub {
    my $personaje = Personaje->new;
    context "CUANDO cuando le ejecuto un constructor" => sub {
      my $constructor = Service::Personaje::Constructor->new;
      $constructor->personaje($personaje);
      it "ENTONCES el hacer me debe devolver un personaje debe tener descripciones fisicas validas" => sub {
        my $per = $constructor->hacer;
        my $atributo_hair_color = Service::Atributo->traer('hair_color');
        cmp_deeply $personaje->hair_color, any(@{$atributo_hair_color->validos});
        my $atributo_hair_type = Service::Atributo->traer('hair_type');
        cmp_deeply $personaje->hair_type, any(@{$atributo_hair_type->validos});
        my $atributo_eyes_color = Service::Atributo->traer('eyes_color');
        cmp_deeply $personaje->eyes_color, any(@{$atributo_eyes_color->validos});
      };
    };
    context "CUANDO cuando le ejecuto un constructor con parametros de descripciones fisicas" => sub {
      my $constructor = Service::Personaje::Constructor->new({hair_color => 'natural_black_hair', hair_type => 'straight_hair', eyes_color => 'brown_eyes'});
      $constructor->personaje($personaje);
      it "ENTONCES el hacer me debe devolver un personaje con esas descripciones" => sub {
        my $per = $constructor->hacer;
        
        my $atributo_hair_color = Service::Atributo->traer('hair_color');
        is $personaje->hair_color, 'natural_black_hair';
        my $hair_color = t($personaje->hair_color);
        like $personaje->detalle, qr/$hair_color/;

        my $atributo_hair_type = Service::Atributo->traer('hair_type');
        is $personaje->hair_type, 'straight_hair';
        my $hair_type = t($personaje->hair_type);
        like $personaje->detalle, qr/$hair_type/;

        my $atributo_eyes_color = Service::Atributo->traer('eyes_color');
        is $personaje->eyes_color, 'brown_eyes';
        my $eyes_color = t($personaje->eyes_color);
        like $personaje->detalle, qr/$eyes_color/;
      };
    };
  };
};
