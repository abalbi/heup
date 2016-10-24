package Service::Atributo;
use strict; 
use JSON;
use base qw(Service);
use fields qw(_atributos);
our $AUTOLOAD;
use Data::Dumper;


our $logger = Log::Log4perl->get_logger(__PACKAGE__);


	sub new {
		my $self = shift;
		my $key = shift;
		$self = fields::new($self);
		$self->{_atributos} = [];
		return $self;
	}


	sub traer {
		my $class = shift;
		my $self = __PACKAGE__->instancia;
		my $key = shift;
		my $atributo = $self->atributo($key);
		if(!$atributo) {
			$logger->logdie("No existe el atributo '$key'");
		}
		return $atributo;
	}

	sub atributo {
		my $class = shift;
		my $self = __PACKAGE__->instancia;
		my $key = shift;
		return [grep {$_->key eq $key} @{$self->atributos}]->[0];
	}

	sub atributos {
		my $self = __PACKAGE__->instancia;
		return $self->{_atributos};		
	}

	sub init {
		$logger->info('INIT: inicializando');
		my $self = __PACKAGE__->instancia;
		push @{$self->atributos}, Atributo->new({ key => 'name' });
		$logger->info('INIT: Se cargaron los atributos: ', map {$_->key} @{$self->atributos});
	}

1;