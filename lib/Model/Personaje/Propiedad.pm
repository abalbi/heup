package Personaje::Propiedad;
use strict; 
use JSON;
use fields qw(_valor);
our $AUTOLOAD;
use Data::Dumper;

our $logger = Log::Log4perl->get_logger(__PACKAGE__);

	sub new {
		my $self = shift;
		my $args = shift;
		$self = fields::new($self);
		return $self;
	}

	sub valor {
		my $self = shift;
		my $valor = shift;
		$self->{_valor} = $valor if defined $valor;
		return $self->{_valor};		
	}
1;