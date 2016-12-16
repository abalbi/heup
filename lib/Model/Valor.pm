package Valor;
use strict; 
use JSON;
use fields qw(_valor _para_atributos);
our $AUTOLOAD;
use Data::Dumper;
use Util;
use overload 'nomethod' => \&stringify;

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


	sub valor {
		my $self = shift;
		return $self->{_valor};
	}

	sub para_atributos {
		my $self = shift;
		return $self->{_para_atributos};
	}


	sub stringify {
		my $self = shift;
		my $you = shift;
		my $other = shift;
		my $operator = shift;
		if($operator eq 'eq' && $you->isa('Valor')) {
			return $self->{_valor} eq $you->{_valor};
		}
		return $self->{_valor} if $operator eq '""';
		if($operator eq 'eq' && not ref $you) {
			return $self->{_valor} eq $you;
		}
		if($operator eq '==' && $you->isa('Valor')) {
			return $self->{_valor} == $you->{_valor};
		}
		if($operator eq 'eq' && not ref $you) {
			return $self->{_valor} eq $you;
		}
		if($operator eq '==' && not ref $you) {
			return $self->{_valor} == $you;
		}
		return $self->{_valor} if $operator eq 'bool';
		return $self;
	}

1;