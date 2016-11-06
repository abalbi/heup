package Constructor;
use strict; 
use JSON;
use fields qw(_personaje _argumentos _atributos);
our $AUTOLOAD;
use Data::Dumper;

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

	sub hacer {
		my $self = shift;
		my $personaje = $self->personaje;
		my $atributos = $self->atributos;
		foreach my $atributo (@$atributos){
			my $key = $atributo->key;
      my $valor = $self->argumentos->{$key};
      $valor = $personaje->propiedad($key)->preasignado if not defined $valor;
      $valor = $personaje->propiedad($key)->alguno($personaje) if not defined $valor;
			$personaje->$key($valor);
      if($atributo->can('alteraciones')) {
        foreach my $alter (@{$atributo->alteraciones}) {
          my $si_key = $alter->{si_key};
          my $si_valor = $alter->{si_valor};
          my $entonces_key = $alter->{entonces_key};
          my $entonces_valor = $alter->{entonces_valor};
          if($personaje->$si_key eq $si_valor) {
            $personaje->propiedad($entonces_key)->preasignado($entonces_valor);
          }
        }
      }
		}
		return $personaje;
	}
1;