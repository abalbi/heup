package Factory::Atributo;
use strict; 
use JSON;
use fields qw(_atributos _stash);
use List::MoreUtils qw(uniq);
our $AUTOLOAD;
use Data::Dumper;
use Util;
use Symbol;

our $logger = Log::Log4perl->get_logger(__PACKAGE__);

  sub new {
    my $self = shift;
    my $args = shift;
    $self  = fields::new($self);
    return $self;
  }

  sub atributos {
    my $self = shift;
    $self->{_atributos} = {} if !$self->{_atributos};
    return $self->{_atributos};
  }

  sub stash {
    my $self = shift;
    $self->{_stash} = [] if !$self->{_stash};
    return $self->{_stash};
  }

  sub stash_limpiar {
    my $self = shift;
    $self->{_stash} = { 
      este => []
    };    
  }

  sub este {
    my $self = shift;
    my $key = shift;
    if(not exists $self->atributos->{$key}) {
      $self->atributos->{$key} = {key => $key}
    }
    $self->stash_limpiar;
    push @{$self->stash->{este}}, $key;
    $self->stash->{lista_valores} = 'posibles';
    return $self;
  }

  sub es {
    my $self = shift;
    my $string = shift;
    my $res;
    eval "\$res = \{\%\{$string\:\:\}\}";
    if(keys %$res) {
      foreach my $key (@{$self->stash->{este}}) {
        $self->atributos->{$key}->{clase} = $string;
      }
    }
    return $self;
  }

  sub es_requerido {
    my $self = shift;
    my $res;
    foreach my $key (@{$self->stash->{este}}) {
      $self->atributos->{$key}->{es_requerido} = 1;
    }
    return $self;
  }

  sub tiene_origen {
    my $self = shift;
    my $src = shift;
    foreach my $key (@{$self->stash->{este}}) {
      $self->atributos->{$key}->{src} = $src;
    }
    return $self;

  }

  sub tiene_estos_valores {
    my $self = shift;
    my $valores = [@_];
    $self->lista($valores);
    return $self;
  }

  sub usa_posibles {
    my $self = shift;
    $self->stash->{lista_valores} = 'posibles';
    return $self;
  }

  sub usa_validos {
    my $self = shift;
    $self->stash->{lista_valores} = 'validos';
    return $self;
  }

  sub de {
    my $self = shift;
    my $heredan_de = shift;
    $self->stash->{heredan_de} = $heredan_de;
    return $self;
  }

  sub heredan {
    my $self = shift;
    my $herederos = [@_];
    my $heredan_de = $self->stash->{heredan_de};
    $self->lista([$heredan_de]);
    $self->lista($herederos);
    foreach my $key (@{$self->stash->{este}}) {
      $self->atributos->{$key}->{herencias} = {} if not exists $self->atributos->{$key}->{herencias};
      foreach my $heredero (@$herederos) {
        $self->atributos->{$key}->{herencias}->{$heredero} = [] if not exists $self->atributos->{$key}->{herencias}->{$heredero};
        push @{$self->atributos->{$key}->{herencias}->{$heredero}}, $heredan_de;
      }
    }
    return $self;
  }

  sub alteracion {
    my $self = shift;
    my $si_valor = shift;
    my $entonces_hash = shift;
    foreach my $key (@{$self->stash->{este}}) {
      $self->atributos->{$key}->{alteraciones} = [] if not exists $self->atributos->{$key}->{alteraciones};
      foreach my $entonces_key (keys %{$entonces_hash}) {
        my $entonces_valor = $entonces_hash->{$entonces_key};
        push @{$self->atributos->{$key}->{alteraciones}}, {
          si_key => lc $key,
          si_valor => $si_valor,
          entonces_key => lc $entonces_key,
          entonces_valor => $entonces_valor,
        };                  
      }
    }    
    return $self;
  }

  sub lista {
    my $self = shift;
    my $valores = shift;
    my $lista = $self->stash->{lista_valores};
    foreach my $key (@{$self->stash->{este}}) {
      if($self->stash->{para}) {
        my $para = $self->stash->{para};
        push @{$self->atributos->{$key}->{$lista}}, map {{ valor => $_ , atributos => {%$para}}} @$valores;
      } else {
        $self->atributos->{$key}->{$lista} = [] if not exists $self->atributos->{$key}->{$lista};
        push @{$self->atributos->{$key}->{$lista}}, @$valores;
      }
    }
  }

  sub para {
    my $self = shift;
    $self->stash->{para} = shift;
    return $self;
  }

  sub hacer {
    my $self = shift;
    my $atributos = [];
    $logger->trace('Hacer Atributo');

    foreach my $key (sort keys %{$self->atributos}) {
      my $args = $self->atributos->{$key};
      my $clase = $args->{clase};
      delete $args->{clase};
      $clase = 'Atributo' if !$clase;
      return undef if not defined $args->{key};
      my $atributo = $clase->new($args);
      $logger->trace('New Atributo key=', $atributo->key, ' clase=', ref($atributo));

      push @$atributos, $atributo;
      if(defined Service::Atributo->traer($args->{key})) {
        my $index = -1;
        my $i = 0;
        foreach my $item (@{Service::Atributo->atributos}) {
          if(defined $item && $item->key eq $atributo->key) {
            $index = $i;
            last;
          }
          $i++;
        }
        Service::Atributo->atributos->[$index] = $atributo;
      } else {
        push @{Service::Atributo->atributos}, $atributo;
      }
    }
    $logger->debug(Dumper $self->atributos);
    return $atributos;
  }
1;