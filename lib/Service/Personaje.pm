package Service::Personaje;
use strict;
use fields qw(_args _personaje);
use Data::Dumper;

sub new {
	my $self = shift;
	my $args = shift;
	$self = fields::new($self);
	return $self;
}

sub crear {
	my $class = shift;
	my $args = shift;
	my $self = $class->new;
	my $personaje = $args->{personaje} ? $args->{personaje} : Personaje->new;
  $self->personaje($personaje);
	$self->args($args);
	$self->hacer;
	$self->personaje;
}

sub args {
	my $self = shift;
	my $args = shift;
	$self->{_args} = {} if not exists $self->{_args};
	$self->{_args} = $args if defined $args;
	return $self->{_args};
}

sub personaje {
	my $self = shift;
	my $valor = shift;
	$self->{_personaje} = $valor if defined $valor;
	return $self->{_personaje};
}

sub hacer {
	my $self = shift;
	my $personaje = $self->personaje;
	foreach my $key (@{Service::Atributo->atributos}) {
		my $valor = $self->args->{$key};
		Service::Atributo->asignar_a($personaje, $key, $valor);
	}

}
1;