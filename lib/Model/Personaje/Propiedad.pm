package Personaje::Propiedad;
use strict; 
use JSON;
use fields qw(_valor _key _atributo);
our $AUTOLOAD;
use Data::Dumper;

our $logger = Log::Log4perl->get_logger(__PACKAGE__);

	sub new {
		my $self = shift;
		my $key = shift;
		$self = fields::new($self);
		$self->key($key) if defined $key;
		$self->atributo(Service::Atributo->traer($key));
		return $self;
	}

	sub atributo {
		my $self = shift;
		my $atributo = shift;
		$self->{_atributo} = $atributo if defined $atributo;
		return $self->{_atributo};
	}

	sub key {
		my $self = shift;
		my $key = shift;
		$self->{_key} = $key if defined $key;
		return $self->{_key};		
	}

	sub valor {
		my $self = shift;
		my $valor = shift;
		$self->{_valor} = $valor if defined $valor;
		return $self->{_valor};		
	}

	sub alguno {
		my $self = shift;
		return $self->atributo->alguno;		
	}
1;