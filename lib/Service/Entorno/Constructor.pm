package Service::Entorno::Constructor;
use strict; 
use JSON;
use fields qw(_argumentos _entorno);
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

  sub entorno {
    my $self = shift;
    my $entorno = shift;
    $self->{_entorno} = $entorno if defined $entorno;
    return $self->{_entorno};
  }

  sub hacer {
    my $self = shift;
    my $entorno = $self->entorno;

  	return $entorno;
  }
1;