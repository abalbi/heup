package Service::Atributo;
use strict; 
use JSON;
use base qw(Service);
use fields qw(_atributos);
our $AUTOLOAD;
use Data::Dumper;
use Util;


our $logger = Log::Log4perl->get_logger(__PACKAGE__);
our $stash;

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
		my $class = shift;
		my $self = __PACKAGE__->instancia;
		my $filter = shift;
		my $atributos = [];
		if($filter) {
			foreach my $atributo (@{$self->{_atributos}}) {
				push @$atributos, $atributo if scalar grep { $filter->{$_} eq $atributo->$_} keys %$filter;
			}	
		} else {
			$atributos = $self->{_atributos};
		}
		return $atributos;
	}

	sub init {
		my $self = __PACKAGE__->instancia;
		$logger->info('INIT: inicializando');
		$self->load_etc;
	}

	sub traer_o_crear {
		my $class = shift;
		my $self = __PACKAGE__->instancia;
		my $key = shift;
		my $atributo;
		eval {
			$atributo = $self->traer($key);
		};
		if ($@) {
			$self->crear({ key => $key }) if !$atributo;
		}
		return $atributo;
	}

	sub crear {
		my $class = shift;
		my $self = __PACKAGE__->instancia;
		my $args = shift;
		my $clase = $args->{clase};
		delete $args->{clase};
		$clase = 'Atributo' if !$clase;
		my $atributo = $clase->new($args);
		push @{$self->atributos}, $atributo;
		return $atributo;
	}

	sub load_etc {
		my $self = __PACKAGE__->instancia;
		my $etc = 'etc/';
		opendir(my $dh, $etc) || die "Can't opendir $etc: $!";
    my @heups = grep { $_ !~ /^\./ && $_ =~ /.*.heup/ } readdir($dh);
    closedir $dh;
    foreach my $file (@heups) {
			$logger->info("INIT: cargando $file");
    	open my $fh, $etc.$file;
    	my $lines = [<$fh>];
    	close $fh;

	    $stash = {};
    	foreach my $line (@{$lines}) {
    		my $key;
	    	foreach my $frase (@{$self->frases}) {
	    		if($line =~ $frase->{re}) {
	    			my $args = {%+};
	    			$key = lc($+{key}) if $+{key};
	    			$args->{stash} = $stash;
	    			my $res = &{$frase->{code}}($args);
	    			if($res eq '__END__') {
	    				$logger->debug("Se crea el atributo: ", l $stash);
	    				$stash->{src} = $file;
							Service::Atributo->crear($stash);
	    				$stash = {}
	    			}
	    		}
	    	}
    	}

    }
	}

	sub frases {
		return [
			{ 
				re => qr/(?<key>\w+) es un atributo/,
				code => sub {
					my $args = shift;
					$args->{stash}->{key} = lc $args->{key};
				}
			},
			{ 
				re => qr/que tiene todos los personajes/,
				code => sub {
					my $args = shift;
					$args->{stash}->{es_requerido} = 1;
				}
			},
			{ 
				re => qr/(?<key>\w+) es de la clase (?<clase>[\w:]+)/,
				code => sub {
					my $args = shift;
					$args->{stash}->{clase} = $args->{clase};
				}
			},
			{ 
				re => qr/Los valores (?<lista>posibles|validos) de (?<key>\w+) son.*\: (?<valores>[\w ]+)\./i,
				code => sub {
					my $args = shift;
					$args->{stash}->{$args->{lista}} = [split ' ', $args->{valores}];
				}
			},
			{ 
				re => qr/Los valores (?<lista>posibles|validos) de (?<key>\w+) para personajes de (?<atributo>\w+) '(?<valor>\w+)' son.*\: (?<valores>[\w ]+)\./i,
				code => sub {
					my $args = shift;
					my $valores = [split ' ', $args->{valores}];
					push @{$args->{stash}->{$args->{lista}}}, map {{ valor => $_ , atributos => {$args->{atributo} => $args->{valor}}}} @$valores;
				}
			},
			{ 
				re => qr/^\=/,
				code => sub {
					my $args = shift;
					return '__END__';
				}
			},
		]
	}

1;