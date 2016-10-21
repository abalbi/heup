package Atributo;
use strict;
use fields qw(_nombre _validos _es_requerido _posibles);
use Data::Dumper;
use Util;

our $instancia;

sub new {
	my $self = shift;
	my $args = shift;
	$self = fields::new($self);
	$self->{_nombre} = $args->{nombre};
	$self->{_es_requerido} = $args->{es_requerido};
	$self->{_posibles} = $args->{posibles};
	return $self;
}

sub nombre {
	my $self = shift;
	my $valor = shift;
	$self->{_nombre} = $valor if defined $valor;
	return $self->{_nombre};
}

sub alguno {
	my $self = shift;
	my $propiedad = shift;
	my $valor = shift;
	return $valor if $propiedad->es_valido($valor);
	$valor = azar $propiedad->validos;
	$valor = azar $propiedad->posibles if not defined $valor;
	return $valor;
}

sub es_valido {
	my $self = shift;
	my $propiedad = shift;
	my $valor = shift;
	if(not defined $valor && $propiedad->es_requerido) {
		return 0;
	}
	if(ref $valor ne '') {
		return 0;
	}
	return 1;
}

sub validos {
	my $self = shift;
	my $propiedad = shift;
	my $valor = shift;
	return $self->{_validos};
}

sub posibles {
	my $self = shift;
	my $propiedad = shift;
	my $valor = shift;
	return &{$self->{_posibles}}($self, $propiedad, $valor) if ref $self->{_posibles} eq 'CODE';
	return $self->{_posibles};
}


sub es_requerido {
	my $self = shift;
	my $propiedad = shift;
	my $valor = shift;
	return $self->{_es_requerido};
}
1;