package Constructor;
use strict; 
use JSON;
use fields qw(_personaje);
our $AUTOLOAD;
use Data::Dumper;

our $logger = Log::Log4perl->get_logger(__PACKAGE__);

	sub new {
		my $self = shift;
		my $key = shift;
		$self = fields::new($self);
		return $self;
	}

	sub personaje {
		my $self = shift;
		my $personaje = shift;
		$self->{_personaje} = $personaje if defined $personaje;
		return $self->{_personaje};
	}

	sub hacer {
		my $self = shift;
		my $personaje = $self->personaje;
		return $personaje;
	}
1;