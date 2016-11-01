package Atributo::Name;
use strict; 
use JSON;
use base 'Atributo';
use fields qw();
our $AUTOLOAD;
use Data::Dumper;
use Util;

our $logger = Log::Log4perl->get_logger(__PACKAGE__);

sub posibles {
	my $self = shift;
	my $args = shift;
	my $valores = $self->SUPER::posibles;
	if($args->{sex}) {
		$valores = [grep {$_->{atributos}->{sex} eq $args->{sex}} @$valores];
	}
	return [map {$_->{valor}} @$valores];
}

sub validos {
	my $self = shift;
	my $args = shift;
	my $valores = $self->SUPER::validos;
	if($args->{sex}) {
		$valores = [grep {$_->{atributos}->{sex} eq $args->{sex}} @$valores];
	}
	return [map {$_->{valor}} @$valores];
}

	sub alguno {
		my $self = shift;
		my $propiedad = shift;
		return azar $self->posibles({sex => $propiedad->personaje->sex});
	}


1;