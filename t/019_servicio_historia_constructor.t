use strict;
use lib 'lib';
use Data::Dumper;
use Test::More qw(no_plan);
use Test::More::Behaviour;
use HEUP;


$Service::Historia::logger->level('TRACE');
Service::Historia->init;
describe "Como desarrollador quiero que el constructor de historia cree las historias basado en tipos" => sub {
  context "CUANDO ejecuto el init del Servicio de Historia" => sub {
    my $tipo_overcoming_the_monster = Service::Historia->traer('overcoming_the_monster');
    it "ENTONCES debo tener el tipo historia overcoming the monster" => sub {
      is $tipo_overcoming_the_monster->key, 'overcoming_the_monster';
      is scalar @{$tipo_overcoming_the_monster->pasos}, 5;
    };
  };
  context "CUANDO le paso una historia al constructor del servicio de historias" => sub {
    my $tipo_overcoming_the_monster = Service::Historia->traer('overcoming_the_monster');
    my $historia = Historia->new;
    my $constructor = Service::Historia::Constructor->new;
    $constructor->historia($historia);
    it "ENTONCES debe devolverme la historia que le pase al ejecutar hacer y con los pasos correspondientes" => sub {
      is $constructor->hacer, $historia;
      is scalar @{$historia->pasos}, scalar @{$tipo_overcoming_the_monster->pasos};
    };
  };
  context "CUANDO le paso una historia con un tipo al constructor del servicio de historias" => sub {
    my $tipo_overcoming_the_monster = Service::Historia->traer('overcoming_the_monster');
    my $historia = Historia->new;
    $historia->tipo($tipo_overcoming_the_monster);
    my $constructor = Service::Historia::Constructor->new;
    $constructor->historia($historia);
    it "ENTONCES debe devolverme la historia del tipo seleccionado" => sub {
      is $constructor->hacer, $historia;
      is $historia->tipo, $tipo_overcoming_the_monster;
      is scalar @{$historia->pasos}, scalar @{$tipo_overcoming_the_monster->pasos};
    };
  };
  context "CUANDO le paso una historia al constructor del servicio de historias y defino el arg tipo" => sub {
    my $tipo_overcoming_the_monster = Service::Historia->traer('rags_to_riches');
    my $historia = Historia->new;
    my $constructor = Service::Historia::Constructor->new;
    $constructor->argumentos->{tipo} = 'rags_to_riches';
    $constructor->historia($historia);
    it "ENTONCES debe devolverme la historia del tipo seleccionado" => sub {
      is $constructor->hacer, $historia;
      is $historia->tipo, $tipo_overcoming_the_monster;
      is scalar @{$historia->pasos}, scalar @{$tipo_overcoming_the_monster->pasos};
    };
  };
};
