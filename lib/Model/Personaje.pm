package Personaje;
use strict; 
use JSON;
use fields qw(_propiedades);
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
    return $self->propiedad($propiedad)->valor;
    $logger->logconfess("No existe el metodo o atributo '$method'");
  }

  sub propiedad {
    my $self = shift;
    my $key = shift;
    my $valor = shift;
    if(not exists $self->{_propiedades}->{$key}) {
      $self->{_propiedades}->{$key} = Personaje::Propiedad->new($key);
    }
    my $propiedad = $self->{_propiedades}->{$key};
    $propiedad->valor($valor) if defined $valor; 
    return $propiedad;
  }

  sub detalle {
    my $self = shift;
    return $self->name .':';    
  }
1;