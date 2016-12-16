use strict;
use lib 'lib';
use Test::More qw(no_plan);
use Test::More::Behaviour;
use Test::Deep;
use Data::Dumper;

use HEUP;

use Util;

describe "Como desarrollador quiero un constructor de atributos que cree todos los atributos con su key" => sub {
  context "CUANDO defino el key de un atributo y doy hacer" => sub {
    my $factory = Factory::Atributo->new;
    $factory->el_atributo('name')->es('Atributo::Name');
    it "ENTONCES recibo un atributo de esa clase" => sub {
      my $atributo = $factory->hacer;
      isa_ok $atributo, 'Atributo';
      isa_ok $atributo, 'Atributo::Name';
    };
  };
  context "CUANDO defino defino valores validos a un atributo" => sub {
    my $valores = [qw(addict adherent adjudicator advisor analyst architect artist autocrat autist avant_garde barbarian believer bon_vivant bravo caregiver cavalier child celebrant competitor confidant conformist conniver critic crusader curmudgeon defender demagogue deviant director dreamer eccentric engine explorer evangelist fanatic gallant healer honest_abe jester jobsworth judge loner manipulator martyr masochist meddler mediator monger monster non_partisan optimist paragon pedagogue penitent perfectionist plotter poltroon praise_seeker provider rebel rogue soldier stoic survivor sycophant traditionalist thrill_seeker trickster vigilante visionary)];
    my $factory = Factory::Atributo->new;
    $factory->el_atributo('nature')->usa_validos->tiene_estos_valores(@{$valores});
    it "ENTONCES recibo un atributo con esos valres validos" => sub {
      my $atributo = $factory->hacer;
      isa_ok $atributo, 'Atributo';
      is $atributo->key, 'nature';
      cmp_deeply $atributo->validos, array_each(methods('valor', any(@{$valores})));
    };
  };
  context "CUANDO defino defino valores posibles a un atributo" => sub {
    my $valores = [qw(addict adherent adjudicator advisor analyst architect artist autocrat autist avant_garde barbarian believer bon_vivant bravo caregiver cavalier child celebrant competitor confidant conformist conniver critic crusader curmudgeon defender demagogue deviant director dreamer eccentric engine explorer evangelist fanatic gallant healer honest_abe jester jobsworth judge loner manipulator martyr masochist meddler mediator monger monster non_partisan optimist paragon pedagogue penitent perfectionist plotter poltroon praise_seeker provider rebel rogue soldier stoic survivor sycophant traditionalist thrill_seeker trickster vigilante visionary)];
    my $factory = Factory::Atributo->new;
    $factory->el_atributo('demeanor')->tiene_estos_valores(@{$valores});
    it "ENTONCES recibo un atributo con esos valores posibles" => sub {
      my $atributo = $factory->hacer;
      isa_ok $atributo, 'Atributo';
      is $atributo->key, 'demeanor';
      cmp_deeply $atributo->posibles, array_each(methods 'valor', any @{$valores});
    };
  };
  context "CUANDO defino defino valores posibles a un atributo filtrando por valores de un atributo" => sub {
    my $valores = [qw(Lucia Maria Martina Paula Daniela Sofia Valeria Carla Sara Alba Julia Noa Emma Claudia Carmen Marta Valentina Irene Adriana Ana Laura Elena Alejandra Ines Marina Vera Candela Laia Ariadna Lola Andrea Rocio Angela Vega Nora Jimena Blanca Alicia Clara Olivia Celia Alma Eva Elsa Leyre Natalia Victoria Isabel Cristina Lara Abril Triana Nuria Aroa Carolina Manuela Chloe Mia Mar Gabriela Mara Africa Iria Naia Helena Paola Noelia Nahia Miriam Salma)];
    my $factory = Factory::Atributo->new;
    $factory->el_atributo('name')->para({sex => 'f'})->tiene_estos_valores(@{$valores});
    it "ENTONCES recibo un atributo con esos valores posibles" => sub {
      my $atributos = $factory->hacer;
    };
  };
  context "CUANDO defino el atributo name" => sub {
    my $factory = Factory::Atributo->new;
    my $valores_f = [qw(Lucia Maria Martina Paula Daniela Sofia Valeria Carla Sara Alba Julia Noa Emma Claudia Carmen Marta Valentina Irene Adriana Ana Laura Elena Alejandra Ines Marina Vera Candela Laia Ariadna Lola Andrea Rocio Angela Vega Nora Jimena Blanca Alicia Clara Olivia Celia Alma Eva Elsa Leyre Natalia Victoria Isabel Cristina Lara Abril Triana Nuria Aroa Carolina Manuela Chloe Mia Mar Gabriela Mara Africa Iria Naia Helena Paola Noelia Nahia Miriam Salma)];
    my $valores_m = [qw(Hugo Daniel Pablo Alejandro Alvaro Adrian David Martin Mario Diego Javier Manuel Lucas Nicolas Marcos Leo Sergio Mateo Izan Alex Iker Marc Jorge Carlos Miguel Antonio Angel Gonzalo Juan Ivan Eric Ruben Samuel Hector Victor Enzo Jose Gabriel Bruno Dario Raul Adam Guillermo Francisco Aaron Jesus Oliver Joel Aitor Pedro Rodrigo Erik Marco Alberto Pau Jaime Asier Luis Rafael Mohamed Dylan Marti Ian Pol Ismael Oscar Andres Alonso Biel Rayan Jan Fernando Thiago Arnau Cristian Gael Ignacio Joan)];
    $factory->el_atributo('name')
      ->tiene_origen('comun.heup')
      ->es_requerido
      ->es('Atributo::Name')
      ->para({sex => 'f'})->tiene_estos_valores(@{$valores_f})
      ->para({sex => 'm'})->tiene_estos_valores(@{$valores_m});
    it "ENTONCES recibo un atributo de esa clase" => sub {
      my $atributo = $factory->hacer;
      isa_ok $atributo, 'Atributo::Name';
      is $atributo->key, 'name';
      ok $atributo->es_requerido;
      is scalar @{$atributo->posibles}, (scalar @$valores_m + scalar @$valores_f);
    };
  };

};
