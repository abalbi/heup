package Atributo;
use strict; 
use JSON;
use fields qw(_key);
our $AUTOLOAD;
use Data::Dumper;

our $logger = Log::Log4perl->get_logger(__PACKAGE__);

	sub new {
		my $self = shift;
		my $args = shift;
		$self = fields::new($self);
		$self->{_key} = $args->{key};
		return $self;
	}

	sub key {return shift->{_key}}

1;