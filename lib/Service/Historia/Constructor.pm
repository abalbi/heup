package Service::Historia::Constructor;
use strict; 
use JSON;
use fields qw(_argumentos _historia);
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

  sub historia {
    my $self = shift;
    my $historia = shift;
    $self->{_historia} = $historia if defined $historia;
    return $self->{_historia};
  }

  sub hacer {
    my $self = shift;
    my $historia = $self->historia;
    my $tipos = Service::Historia->tipos;
    my $tipo = $self->argumentos->{tipo};
    my $entorno = $self->argumentos->{entorno};
    $tipo = $historia->tipo if not defined $tipo;
    $tipo = azar $tipos if not defined $tipo;
    $tipo = Service::Historia->traer($tipo) if not ref $tipo;
    $historia->tipo($tipo);

    $entorno = $historia->entorno if not defined $entorno;
    $entorno = Service::Entorno->traer($entorno) if not ref $entorno;
    $historia->entorno($entorno);


    foreach my $paso (@{$tipo->pasos}) {
      push @{$historia->pasos}, $paso;
    }
    foreach my $paso (@{$historia->pasos}) {
      my $roles = [$paso =~ /\<\w+\>/g];
      foreach my $rol (@$roles) {
        $rol =~ /\<(\w+)\>/;
        $historia->roles->{$1} = {};
      }
    }
    foreach my $rol (sort keys %{$historia->roles}) {
      $historia->roles->{$rol} = Service::Personaje->crear;
    }
  	return $historia;
  }
1;