package Service;
use strict; 
use JSON;
our $AUTOLOAD;
use Data::Dumper;

our $instancia;

	sub instancia {
		my $class = shift;
		$instancia = $class->new if !$instancia;
		return $instancia;
	}

1;