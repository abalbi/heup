package Service::Atributo;
use strict; 
use JSON;
use base qw(Service);
use fields qw(_atributos);
our $AUTOLOAD;
use Data::Dumper;
use Util;

our $logger = Log::Log4perl->get_logger(__PACKAGE__);
$logger->level('TRACE');
our $stash;
our $instancia;

  sub new {
    my $self = shift;
    my $key = shift;
    $self = fields::new($self);
    $self->{_atributos} = [];
    return $self;
  }

  sub instancia {
    my $class = shift;
    $instancia = $class->new if !$instancia;
    return $instancia;
  }


  sub traer {
    my $class = shift;
    my $self = __PACKAGE__->instancia;
    my $key = shift;
    my $atributo = $self->atributo($key);
    return $atributo;
  }

  sub atributo {
    my $class = shift;
    my $self = __PACKAGE__->instancia;
    my $key = shift;
    return [grep {$_->key eq $key if defined $_} @{$self->atributos}]->[0];
  }

  sub atributos {
    my $class = shift;
    my $self = __PACKAGE__->instancia;
    my $filter = shift;
    my $atributos = [];
    if($filter) {
      foreach my $atributo (@{$self->{_atributos}}) {
        next if not defined $atributo;
        push @$atributos, $atributo if scalar grep { $filter->{$_} eq $atributo->$_} keys %$filter;
      } 
    } else {
      $atributos = $self->{_atributos};
    }
    return $atributos;
  }

  sub init {
    my $self = __PACKAGE__->instancia;
    $logger->info('INIT: inicializando');
    my $factory = Factory::Atributo->new;
    $factory->el_atributo('concept')
      ->tiene_origen('comun.heup')
      ->es_requerido
      ->es('Atributo::Concept')
      ->usa_posibles
      ->de('kid')->heredan(qw(child runaway nerd gang_member street_urchin))
      ->de('criminal')->heredan(qw(jailbird mafioso cat_burglar drug_dealer bandit))
      ->de('dilettante')->heredan(qw(artist writer intellectual gambler student))
      ->de('drifter')->heredan(qw(hobo cowboy prostitute hermit pilgrim))
      ->de('entertainer')->heredan(qw(comic musician movie_star clown))
      ->de('investigator')->heredan(qw(detective cop government_agent inquisitor))
      ->de('nightlifer')->heredan(qw(clubgoer skinhead punk barfly raver substance_abuser))
      ->de('politician')->heredan(qw(judge mayor senator public_official governor))
      ->de('professional')->heredan(qw(engineer doctor mortician scholar sexy_secretary))
      ->de('punk')->heredan(qw(mosher skinhead classic_70s_punk))
      ->de('reporter')->heredan(qw(anchorperson newspaper paparazzo))
      ->de('socialite')->heredan(qw(dilettante host playboy prominent_spouse))
      ->de('soldier')->heredan(qw(bodyguard mercenary knight))
      ->de('worker')->heredan(qw(trucker farmer wage_slave servant))
      ->alteracion('sexy_secretary' => {sex => 'f'})
      ->alteracion('prostitute' => {sex => 'f'})
      ->alteracion('prominent_spouse' => {sex => 'f'})
      ->alteracion('playboy' => {sex => 'm'})
      ->alteracion('kid' => {age => [8..17]})
      ->alteracion('student' => {age => [19..28]})
      ->alteracion('scholar' => {age => [19..28]})
      ->alteracion('politician' => {age => [35..60]})
      ->alteracion('investigator' => {age => [25..50]})
      ->alteracion('professional' => {age => [25..50]})
    ;
    $factory->hacer;
    my $factory = Factory::Atributo->new;
    $factory->el_atributo('nature')
      ->tiene_origen('comun.heup')
      ->es_requerido
      ->usa_validos
      ->tiene_estos_valores(qw(addict adherent adjudicator advisor analyst architect artist autocrat autist avant_garde barbarian believer bon_vivant bravo caregiver cavalier child celebrant competitor confidant conformist conniver critic crusader curmudgeon defender demagogue deviant director dreamer eccentric engine explorer evangelist fanatic gallant healer honest_abe jester jobsworth judge loner manipulator martyr masochist meddler mediator monger monster non_partisan optimist paragon pedagogue penitent perfectionist plotter poltroon praise_seeker provider rebel rogue soldier stoic survivor sycophant traditionalist thrill_seeker trickster vigilante visionary));
    $factory->hacer;
    my $factory = Factory::Atributo->new;
    $factory->el_atributo('demeanor')
      ->tiene_origen('comun.heup')
      ->es_requerido
      ->usa_validos
      ->tiene_estos_valores(qw(addict adherent adjudicator advisor analyst architect artist autocrat autist avant_garde barbarian believer bon_vivant bravo caregiver cavalier child celebrant competitor confidant conformist conniver critic crusader curmudgeon defender demagogue deviant director dreamer eccentric engine explorer evangelist fanatic gallant healer honest_abe jester jobsworth judge loner manipulator martyr masochist meddler mediator monger monster non_partisan optimist paragon pedagogue penitent perfectionist plotter poltroon praise_seeker provider rebel rogue soldier stoic survivor sycophant traditionalist thrill_seeker trickster vigilante visionary));
    $factory->hacer;
    my $factory = Factory::Atributo->new;
    $factory->el_atributo('sex')
      ->tiene_origen('comun.heup')
      ->es_requerido
      ->usa_validos
      ->tiene_estos_valores(qw[f m]);
    $factory->hacer;
    my $factory = Factory::Atributo->new;
    my $valores_f = [qw(Lucia Maria Martina Paula Daniela Sofia Valeria Carla Sara Alba Julia Noa Emma Claudia Carmen Marta Valentina Irene Adriana Ana Laura Elena Alejandra Ines Marina Vera Candela Laia Ariadna Lola Andrea Rocio Angela Vega Nora Jimena Blanca Alicia Clara Olivia Celia Alma Eva Elsa Leyre Natalia Victoria Isabel Cristina Lara Abril Triana Nuria Aroa Carolina Manuela Chloe Mia Mar Gabriela Mara Africa Iria Naia Helena Paola Noelia Nahia Miriam Salma)];
    my $valores_m = [qw(Hugo Daniel Pablo Alejandro Alvaro Adrian David Martin Mario Diego Javier Manuel Lucas Nicolas Marcos Leo Sergio Mateo Izan Alex Iker Marc Jorge Carlos Miguel Antonio Angel Gonzalo Juan Ivan Eric Ruben Samuel Hector Victor Enzo Jose Gabriel Bruno Dario Raul Adam Guillermo Francisco Aaron Jesus Oliver Joel Aitor Pedro Rodrigo Erik Marco Alberto Pau Jaime Asier Luis Rafael Mohamed Dylan Marti Ian Pol Ismael Oscar Andres Alonso Biel Rayan Jan Fernando Thiago Arnau Cristian Gael Ignacio Joan)];
    $factory->el_atributo('name')
      ->tiene_origen('comun.heup')
      ->es_requerido
      ->es('Atributo::Name')
      ->para({sex => 'f'})->tiene_estos_valores(@{$valores_f})
      ->para({sex => 'm'})->tiene_estos_valores(@{$valores_m});
    $factory->hacer;
    my $factory = Factory::Atributo->new;
    $factory->el_atributo('age')
      ->tiene_origen('comun.heup')
      ->es_requerido
      ->tiene_estos_valores(21..40);
    $factory->hacer;
    my $factory = Factory::Atributo->new;
    $factory->el_atributo('hair_color')
      ->tiene_origen('comun.heup')
      ->es_requerido
      ->usa_validos
      ->tiene_estos_valores(qw(black_hair natural_black_hair deepest_brunette_hair dark_brown_hair medium_brown_hair lightest_brown_hair natural_brown_hair light_brown_hair chestnut_brown_hair light_chestnut_brown_hair auburn_hair copper_hair red_hair titian_hair strawberry_blond_hair light_blonde_hair dark_blond_hair golden_blond_hair medium_blond_hair grey_hair white_hair white_hair_albinism));
    $factory->hacer;
    my $factory = Factory::Atributo->new;
    $factory->el_atributo('hair_type')
      ->tiene_origen('comun.heup')
      ->es_requerido
      ->usa_validos
      ->tiene_estos_valores(qw(straight_hair wavy_hair curly_hair kinky_hair));
    $factory->hacer;
    my $factory = Factory::Atributo->new;
    $factory->el_atributo('eyes_color')
      ->tiene_origen('comun.heup')
      ->es_requerido
      ->usa_validos
      ->tiene_estos_valores(qw(amber_eyes blue_eyes brown_eyes gray_eyes green_eyes hazel_eyes red_eyes violet_eyes));
    $factory->hacer;
  }
  sub traer_o_crear {
    my $class = shift;
    my $self = __PACKAGE__->instancia;
    my $key = shift;
    my $atributo;
    eval {
      $atributo = $self->traer($key);
    };
    if ($@) {
      $self->crear({ key => $key }) if !$atributo;
    }
    return $atributo;
  }

  sub crear {
    my $class = shift;
    my $self = __PACKAGE__->instancia;
    my $args = shift;
    my $clase = $args->{clase};
    delete $args->{clase};
    $clase = 'Atributo' if !$clase;
    return undef if not defined $args->{key};
    if(not defined $self->traer($args->{key})) {
      my $atributo = $clase->new($args);
      push @{$self->atributos}, $atributo;
      return $atributo;
    }
  }


1;