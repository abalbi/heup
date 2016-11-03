package Service::Personaje;
use strict; 
use JSON;
use base qw(Service);
use fields qw();
our $AUTOLOAD;
use Data::Dumper;

our $logger = Log::Log4perl->get_logger(__PACKAGE__);

	sub crear {
		my $class = shift;
		my $self = __PACKAGE__->instancia;
		my $args = shift;
		my $constructor = Constructor->new($args);
		my $personaje = Personaje->new;
		$constructor->personaje($personaje);
		$personaje = $constructor->hacer;
		return $personaje;
	}

1;