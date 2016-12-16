package Factory::Atributo;
use strict; 
use JSON;
use fields qw(_atributo _stash);
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

  sub atributo {
    my $self = shift;
    my $args = shift;
    $self->{_atributo} = $args if defined $args;
    return $self->{_atributo};
  }

  sub stash {
    my $self = shift;
    $self->{_stash} = {} if !$self->{_stash};
    return $self->{_stash};
  }


  sub el_atributo {
    my $self = shift;
    my $key = shift;
    $self->atributo({key => $key});
    $self->stash->{lista_valores} = 'posibles';
    return $self;
  }

  sub es {
    my $self = shift;
    my $string = shift;
    my $res;
    eval "\$res = \{\%\{$string\:\:\}\}";
    if(keys %$res) {
      $self->atributo->{clase} = $string;
    }
    return $self;
  }

  sub es_requerido {
    my $self = shift;
    my $res;
    $self->atributo->{es_requerido} = 1;
    return $self;
  }

  sub tiene_origen {
    my $self = shift;
    my $src = shift;
    $self->atributo->{src} = $src;
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
    $self->atributo->{herencias} = {} if not exists $self->atributo->{herencias};
    foreach my $heredero (@$herederos) {
      $self->atributo->{herencias}->{$heredero} = [] if not exists $self->atributo->{herencias}->{$heredero};
      push @{$self->atributo->{herencias}->{$heredero}}, $heredan_de;
    }
    return $self;
  }

  sub alteracion {
    my $self = shift;
    my $si_valor = shift;
    my $entonces_hash = shift;
    $self->atributo->{alteraciones} = [] if not exists $self->atributo->{alteraciones};
    foreach my $entonces_key (keys %{$entonces_hash}) {
      my $entonces_valor = $entonces_hash->{$entonces_key};
      push @{$self->atributo->{alteraciones}}, {
        si_key => lc $self->atributo->{key},
        si_valor => $si_valor,
        entonces_key => lc $entonces_key,
        entonces_valor => $entonces_valor,
      };                  
    }    
    return $self;
  }

  sub lista {
    my $self = shift;
    my $valores = shift;
    my $lista = $self->stash->{lista_valores};
    $self->atributo->{$lista} = [] if not exists $self->atributo->{$lista};
      my $para = {};
      $para = $self->stash->{para} if keys %{$self->stash->{para}};
      push @{$self->atributo->{$lista}}, map {Valor->new({ valor => $_ , para_atributos => {%$para}})} @$valores;
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
    my $args = $self->atributo;
    my $clase = $args->{clase};
    delete $args->{clase};
    $clase = 'Atributo' if !$clase;
    return undef if not defined $args->{key};
    my $atributo = $clase->new($args);
    $logger->trace('New Atributo key=', $atributo->key, ' clase=', ref($atributo));
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
    $logger->debug(Dumper $self->atributo);
    return $atributo;
  }
1;