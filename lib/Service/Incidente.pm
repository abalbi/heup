package Service::Incidente;
use strict; 
use JSON;
use base qw(Service);
use fields qw(_tipos);
our $AUTOLOAD;
use Data::Dumper;
use Util;

our $logger = Log::Log4perl->get_logger(__PACKAGE__);
our $instancia;

  sub new {
    my $self = shift;
    my $key = shift;
    $self = fields::new($self);
    $self->{_tipos} = [];
    return $self;
  }

  sub instancia {
    my $class = shift;
    $instancia = $class->new if !$instancia;
    return $instancia;
  }

  sub crear {
    my $class = shift;
    my $self = __PACKAGE__->instancia;
    my $args = shift;
    my $tipo = azar $self->tipos;
    $args->{tipo} = $tipo;
    my $incidente = Incidente->new($args);
    $incidente->hacer;
    return $incidente;
  }

  sub init {
    my $self = __PACKAGE__->instancia;
    $logger->info('INIT: inicializando');
    $self->load_etc;
  }

  sub traer {
    my $class = shift;
    my $self = __PACKAGE__->instancia;
    my $key = shift;
    my $tipo = $self->tipo($key);
    return $tipo;
  }

  sub tipo {
    my $class = shift;
    my $self = __PACKAGE__->instancia;
    my $key = shift;
    return [grep {$_->key eq $key} @{$self->tipos}]->[0];
  }

  sub tipos {
    my $class = shift;
    my $self = __PACKAGE__->instancia;
    my $filter = shift;
    my $tipos = [];
    if($filter) {
      foreach my $tipo (@{$self->{_tipos}}) {
        push @$tipos, $tipo if scalar grep { $filter->{$_} eq $tipo->$_} keys %$filter;
      } 
    } else {
      $tipos = $self->{_tipos};
    }
    return $tipos;
  }

  sub load_etc {
    my $class = shift;
    my $self = __PACKAGE__->instancia;
    push @{$self->{_tipos}}, Incidente::Tipo->new({
      key => 'romance',
      roles => [
        {
          amante => {},
        },
        {
          amante => {},
        },
      ],
    });    
  }

1;