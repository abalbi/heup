package Incidente::Tipo;
use strict; 
use JSON;
use fields qw(_key _roles _hacer);
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

	sub roles {return shift->{_roles}}

	sub hacer {
		my $self = shift;
		return $self->{_hacer};
	}

1;