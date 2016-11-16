package Service::Historia;
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
		my $constructor = Service::Historia::Constructor->new($args);
		my $historia = Historia->new;
		$constructor->historia($historia);
		$historia = $constructor->hacer;
		return $historia;
	}

1;