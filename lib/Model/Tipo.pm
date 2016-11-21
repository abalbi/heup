package Tipo;
use strict; 
use JSON;
use fields qw(_key _pasos);
our $AUTOLOAD;
use Data::Dumper;
use Util;

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

	sub pasos {return shift->{_pasos}}

1;