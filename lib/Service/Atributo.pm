package Service::Atributo;
use strict; 
use JSON;
use base qw(Service);
use fields qw(_atributos);
our $AUTOLOAD;
use Data::Dumper;
use Util;

our $logger = Log::Log4perl->get_logger(__PACKAGE__);
$logger->level('TRACE');
our $stash;
our $instancia;

  sub new {
    my $self = shift;
    my $key = shift;
    $self = fields::new($self);
    $self->{_atributos} = [];
    return $self;
  }

  sub instancia {
    my $class = shift;
    $instancia = $class->new if !$instancia;
    return $instancia;
  }


  sub traer {
    my $class = shift;
    my $self = __PACKAGE__->instancia;
    my $key = shift;
    my $atributo = $self->atributo($key);
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
    return undef if not defined $args->{key};
    if(not defined $self->traer($args->{key})) {
      my $atributo = $clase->new($args);
      push @{$self->atributos}, $atributo;
      return $atributo;
    }
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
      my $warns = [];
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
              if($stash->{posibles}) {
                foreach my $valor (@{$stash->{posibles}}) {
                  push @$warns, $valor if !ref $valor && $valor !~ /^\d+$/ && !es_traducible($valor);
                }
              }
              if($stash->{validos}) {
                foreach my $valor (@{$stash->{validos}}) {
                  push @$warns, $valor if $valor && $valor !~ /^\d+$/ && !es_traducible($valor);
                }
              }
              Service::Atributo->crear($stash);
              $stash = {}
            }
          }
        }
      }
      $logger->warn('Los siguientes valores no tiene traduccion:', l($warns)) if scalar @$warns;
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
          my $valores = frases_parsear_valores($args->{valores});
          $args->{stash}->{$args->{lista}} = $valores;
        }
      },
      { 
        re => qr/Los valores (?<lista>posibles|validos) de (?<key>\w+) para personajes de (?<atributo>\w+) '(?<valor>\w+)' son.*\: (?<valores>[\w ]+)\./i,
        code => sub {
          my $args = shift;
          my $valores = frases_parsear_valores($args->{valores});
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
      { 
        re => qr/Los personajes que tiene el (?<si_key>\w+) \'(?<si_valor>\w+)\' siempre tendran (?<entonces_key>\w+) \'(?<entonces_valor>\w+)\'\./i,
        code => sub {
          my $args = shift;
          my $stash = $args->{stash};
          push @{$stash->{alteraciones}}, hacer_alteracion($args);
        }
      },
      { 
        re => qr/Los personajes que tiene el (?<si_key>\w+) \'(?<si_valor>\w+)\' siempre tendran (?<entonces_key>\w+) (?<entonces_valor>desde \d+ a \d+)/i,
        code => sub {
          my $args = shift;
          my $stash = $args->{stash};
          push @{$stash->{alteraciones}}, hacer_alteracion($args);
        }
      },
      { 
        re => qr/Los (?<key>\w+) que heredan de \'(?<valor>\w+)\', que es un de los (?<lista>posibles|validos)\, son.*\: (?<valores>[\w ]+)\./i,        
        code => sub {
          my $args = shift;
          my $stash = $args->{stash};
          $stash->{$args->{lista}} = [] if !$stash->{$args->{lista}};
          my $lista = $stash->{$args->{lista}};
          my $valores = frases_parsear_valores($args->{valores});
          push @$lista, $args->{valor} if not scalar grep {$_ eq lc $args->{valor}} @$lista;
          foreach my $valor (@$valores) {
            push @$lista, $valor if not scalar grep {$_ eq lc $valor} @$lista;
            $stash->{herencias}->{$valor} = [] if !$stash->{herencias}->{$valor};
            push @{$stash->{herencias}->{$valor}}, $args->{valor};
          }
        }
      },
    ]
  }

  sub hacer_alteracion {
    my $args = shift;
    if($args->{entonces_valor} =~ /desde (\d+) a (\d+)/i) {
      my $desde = $1;
      my $hasta = $2;
      $args->{entonces_valor} = [$desde..$hasta];
    }
    return {
      si_key => lc $args->{si_key},
      si_valor => $args->{si_valor},
      entonces_key => lc $args->{entonces_key},
      entonces_valor => $args->{entonces_valor},
    };
  }

  sub frases_parsear_valores {
    my $valores = shift;
    if($valores =~ /(?<min>\d+) a (?<max>\d+)/) {
      $valores = [$+{min}..$+{max}];
    } else {
      $valores = [split ' ', $valores];
    }
    return $valores;
  }

1;