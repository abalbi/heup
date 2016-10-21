package Personaje;
use strict;
use fields qw(_props);
use Data::Dumper;
use Carp qw(cluck);
our $AUTOLOAD;
use Carp;

sub new {
	my $self = shift;
	my $args = shift;
	$self = fields::new($self);
	map {$self->$_($args->{$_})} keys %$args;
	return $self;
}

sub AUTOLOAD {
  my $method = $AUTOLOAD;
  my $self = shift;
  my $valor = shift;
  $method =~ s/.*:://;
  my $prop = $method;
  my $propiedad = $self->propiedad($prop);
	$propiedad->valor($valor) if defined $valor;
  return $propiedad->valor;
} 

sub propiedad {
	my $self = shift;
	my $key = shift;
	if(!$self->{_props}->{$key}) {
	  my $atributo = Service::Atributo->traer($key);
		$self->{_props}->{$key} = Personaje::Propiedad->new($atributo) if defined $atributo;
	}
	return $self->{_props}->{$key};
}

sub detalle {
	my $self = shift;
	return $self->name . ":";
}

1;
 
package Personaje::Propiedad;
use strict;
use fields qw(_atributo _valor);
use Data::Dumper;

sub new {
	my $self = shift;
	my $args = shift;
	$self = fields::new($self);
	$self->atributo($args);
	return $self;
}

sub atributo {
	my $self = shift;
	my $atributo = shift;
	$self->{_atributo} = $atributo if defined $atributo;
	$self->{_atributo};
}

sub valor {
	my $self = shift;
	my $valor = shift;
	$self->{_valor} = $valor if defined $valor;
	$self->{_valor};
}

sub alguno {
	my $self = shift;
	my $valor = shift;
	return $self->atributo->alguno($self, $valor);	
}

sub es_valido {
	my $self = shift;
	my $valor = shift;
	return $self->atributo->es_valido($self, $valor);	
}

sub es_requerido {
	my $self = shift;
	my $valor = shift;
	return $self->atributo->es_requerido($self, $valor);	
}

sub validos {
	my $self = shift;
	my $valor = shift;
	return $self->atributo->validos($self, $valor);	
}

sub posibles {
	my $self = shift;
	my $valor = shift;
	return $self->atributo->posibles($self, $valor);	
}


1;