package Atributo;
use strict; 
use JSON;
use fields qw(_key _es_requerido _posibles _validos);
our $AUTOLOAD;
use Data::Dumper;

our $logger = Log::Log4perl->get_logger(__PACKAGE__);

	sub new {
		my $self = shift;
		my $args = shift;
		$self = fields::new($self);
		foreach my $key (keys %$args) {
			$self->{'_'.$key} = $args->{$key};
		}
		return $self;
	}

	sub key {return shift->{_key}}

	sub es_requerido {
		my $self = shift;
		return $self->{_es_requerido}
	}

	sub posibles {
		my $self = shift;
		return $self->validos if not defined $self->{_posibles};
		return $self->{_posibles}
	}

	sub validos {
		my $self = shift;
		return $self->{_validos}
	}


1;