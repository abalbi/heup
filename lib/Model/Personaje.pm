package Personaje;
use strict; 
use JSON;
use fields qw(_propiedades _incidentes);
our $AUTOLOAD;
use Data::Dumper;
use Util;

our $logger = Log::Log4perl->get_logger(__PACKAGE__);

  sub new {
    my $self = shift;
    my $args = shift;
    $self = fields::new($self);
    return $self;
  }

	sub AUTOLOAD {
    my $method = $AUTOLOAD;
    my $self = shift;
    my $valor = shift;
    $method =~ s/.*:://;
    my $propiedad = $method;
    $logger->trace('Buscando metodo ', $method, ' valor: ', l $valor);
    $logger->logconfess("No existe el metodo o atributo '$_[0]'") if $propiedad eq 'propiedad';
    $self->propiedad($propiedad, $valor) if defined $valor;
    if(ref $self->propiedad($propiedad)->valor eq 'HASH' && exists $self->propiedad($propiedad)->valor->{valor} ) {
      return $self->propiedad($propiedad)->valor->{valor};
    }
    return $self->propiedad($propiedad)->valor;
    $logger->logconfess("No existe el metodo o atributo '$method'");
  }

  sub propiedad {
    my $self = shift;
    my $key = shift;
    die "key es requerido" if not defined $key;
    my $valor = shift;
    if(not exists $self->{_propiedades}->{$key}) {
      $self->{_propiedades}->{$key} = Personaje::Propiedad->new($key);
      $self->{_propiedades}->{$key}->personaje($self);
    }
    my $propiedad = $self->{_propiedades}->{$key};
    $propiedad->valor($valor) if defined $valor; 
    return $propiedad;
  }

  sub detalle {
    my $self = shift;
    my $str = '';
    $str .= $self->name;
    $str .= ': ';
    $str .= t([$self->concept . ' ' . $self->demeanor . ' (' . $self->nature . ')', $self->age . ' years_old', $self->hair_color, $self->hair_type, $self->eyes_color], $self->sex);
    return $str;    
  }

  sub es {
    my $self = shift;
    my $propiedad = shift;
    my $valor_es = shift;
    my $valor = $self->$propiedad;
    return 1 if $valor_es eq $valor;
    if ($self->propiedad($propiedad)->atributo->can('herencia')) {
      my $herencia = $self->propiedad($propiedad)->atributo->herencia;
      return 1 if scalar grep {$valor_es eq $_} @{$herencia->{$valor}};
    }
    return 0;    
  }

  sub incidentes {
    my $self = shift;
    $self->{_incidentes} = [] if not defined $self->{_incidentes};
    return $self->{_incidentes};    
  }
1;