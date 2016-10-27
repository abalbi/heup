package Service::Personaje;
use strict; 
use JSON;
use base qw(Service);
use fields qw();
our $AUTOLOAD;
use Data::Dumper;

our $logger = Log::Log4perl->get_logger(__PACKAGE__);

	sub new {
		my $self = shift;
		my $key = shift;
		$self = fields::new($self);
		return $self;
	}

	sub crear {
		my $self = __PACKAGE__->instancia;
		my $constructor = Constructor->new;
		my $personaje = Personaje->new;
		$constructor->personaje($personaje);
		$personaje = $constructor->hacer;
		return $personaje;
	}

1;