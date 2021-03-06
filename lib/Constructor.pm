package Constructor;
use strict; 
use JSON;
use fields qw(_personaje _argumentos _atributos);
our $AUTOLOAD;
use Data::Dumper;
use Util;

our $logger = Log::Log4perl->get_logger(__PACKAGE__);

  sub new {
    my $self = shift;
    my $args = shift;
    $self = fields::new($self);
    $self->argumentos($args);
    return $self;
  }

  sub argumentos {
    my $self = shift;
    my $argumentos = shift;
    $self->{_argumentos} = $argumentos if defined $argumentos;
    $self->{_argumentos} = {} if not defined $self->{_argumentos};
    return $self->{_argumentos};
  }

  sub personaje {
    my $self = shift;
    my $personaje = shift;
    $self->{_personaje} = $personaje if defined $personaje;
    return $self->{_personaje};
  }

  sub atributos {
    my $self = shift;
    $self->{_atributos} = Service::Atributo->atributos({src => 'comun.heup'}) if not defined $self->{_atributos};
    return $self->{_atributos};
  }


  # argumento -> preasignado -> propiedad -> alguno -> defecto

  sub hacer {
    my $self = shift;
    $logger->trace('Hacer personaje');
    my $personaje = $self->personaje;
    my $atributos = $self->atributos;
    foreach my $atributo (@$atributos){
      my $key = $atributo->key;
      $logger->trace("Aplicando $key");
      my $valor;
      if(not defined $valor) {
        my $argumento = $self->argumentos->{$key};
        $argumento = azar $argumento if ref $argumento eq 'ARRAY';
        $valor = $argumento;
        $logger->trace("Se busco valor para $key por argumento: '$valor'");
      }
      if(not defined $valor) {
        my $preasignado = $personaje->propiedad($key)->preasignado;
        $preasignado = azar $preasignado if ref $preasignado eq 'ARRAY';
        $valor = $preasignado;
        $logger->trace("Se busco valor para $key por preasignado: '$valor'");
      }
      if(not defined $valor) {
        $valor = $personaje->propiedad($key)->alguno($personaje);
        $logger->trace("Se busco algun valor para $key: '$valor'");
      }
      if($personaje->propiedad($key)->es_valido($valor)) {
        $personaje->$key($valor);
        $logger->trace("El valor para $key es valido: '$valor'");
      } else {
        $logger->trace("El valor para $key NO es valido: '$valor'");
      }
      if($atributo->can('alteraciones')) {
        foreach my $alter (@{$atributo->alteraciones}) {
          my $si_key = $alter->{si_key};
          my $si_valor = $alter->{si_valor};
          my $entonces_key = $alter->{entonces_key};
          my $entonces_valor = $alter->{entonces_valor};
          if($personaje->es($si_key, $si_valor)) {
            $personaje->propiedad($entonces_key)->preasignado($entonces_valor);
          }
        }
      }
    }
    return $personaje;
  }
1;