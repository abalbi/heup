package Service::Entorno;
use strict; 
use JSON;
use base qw(Service);
use fields qw(_entornos );
our $AUTOLOAD;
use Data::Dumper;
use Util;

our $logger = Log::Log4perl->get_logger(__PACKAGE__);
our $instancia;

  sub new {
    my $self = shift;
    my $key = shift;
    $self = fields::new($self);
    return $self;
  }

  sub instancia {
    my $class = shift;
    $instancia = $class->new if !$instancia;
    return $instancia;
  }

  sub entornos {
    my $class = shift;
    my $self = __PACKAGE__->instancia;
    $self->{_entornos} = [] if !$self->{_entornos};
    return $self->{_entornos};
  } 

  sub traer {
    my $class = shift;
    my $self = __PACKAGE__->instancia;
    my $id = shift;
    return [grep {$_->id eq $id} @{$self->entornos}]->[0];    
  }

  sub crear {
    my $class = shift;
    my $self = __PACKAGE__->instancia;
    my $args = shift;
    my $constructor = Service::Entorno::Constructor->new($args);
    my $entorno = Entorno->new;
    $constructor->entorno($entorno);
    $entorno = $constructor->hacer;
    push @{$self->entornos}, $entorno;
    return $entorno;
  }

  sub hacer_incidentes {
    my $self = shift;
    my $entorno = shift;
    my $personaje = shift;
    my $cantidad_incidentes = $entorno->personaje_cantidad_incidentes;
    for (1..$cantidad_incidentes) {
      my $incidente = Service::Incidente->crear;
      push @{$personaje->incidentes}, $incidente;
      push @{$entorno->incidentes}, $incidente;
    }
    return $self;
  }

1;