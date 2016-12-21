package Service::Historia;
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
    my $constructor = Service::Historia::Constructor->new($args);
    my $historia = Historia->new;
    $constructor->historia($historia);
    $historia = $constructor->hacer;
    return $historia;
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
<<<<<<< HEAD
    push @{$self->{_tipos}}, Historia::Tipo->new({
=======
    push @{$self->{_tipos}}, Tipo->new({
>>>>>>> 3a17a97b9d5d3dce774d02aeaa1192860d7eb1ab
      key => 'overcoming_the_monster',
      pasos => [
        'Se descubre la amenaza que es <monstruo>, que daña a <victima>',
        '<protagonista> es llamado a vencer a <monstruo>',
        '<protagonista> se prepara',
        '<protagonista> se enfrenta a <monstruo>',
        '<protagonista> vence a <monstruo>',
      ],
    });    
<<<<<<< HEAD
    push @{$self->{_tipos}}, Historia::Tipo->new({
=======
    push @{$self->{_tipos}}, Tipo->new({
>>>>>>> 3a17a97b9d5d3dce774d02aeaa1192860d7eb1ab
      key => 'rags_to_riches',
      pasos => [
        '<protagonista> esta en un ambiente miserable',
        '<protagonista> consigue un éxito inicial y conoces a <aliado>',
        'Crisis: <adversario> hace que <protagonista> pierda lo que ha conseguido y se separa de <aliado>',
        '<protagonista> descubre su verdadera capacidad, se enfrenta a <adversario>',
        '<protagonista> recupera su alto estatus y a <aliado> esta vez de forma permanente',
      ],
    });    
<<<<<<< HEAD
    push @{$self->{_tipos}}, Historia::Tipo->new({
=======
    push @{$self->{_tipos}}, Tipo->new({
>>>>>>> 3a17a97b9d5d3dce774d02aeaa1192860d7eb1ab
      key => 'the_quest',
      pasos => [
        '<protagonista> esta en una situacion deplorable',
        '<protagonista> recibe la llamada a la aventura',
        '<protagonista> pasa pruebas y se le une <aliado>',
        '<protagonista> pasa una gran prueba y se enfrenta a <adversario>',
        '<protagonista> consigue la meta',
      ],
    });    
<<<<<<< HEAD
    push @{$self->{_tipos}}, Historia::Tipo->new({
=======
    push @{$self->{_tipos}}, Tipo->new({
>>>>>>> 3a17a97b9d5d3dce774d02aeaa1192860d7eb1ab
      key => 'voyage_and_return',
      pasos => [
        '<protagonista> esta aburrido y quiere nuevas experiencias',
        '<protagonista> llega al mundo fantastico',
        '<protagonista> explora el mundo fantastico',
        '<protagonista> sufre una amenaza por estar en el mundo fantastico',
        '<protagonista> se enfrenta a la amenaza',
        '<protagonista> el protagonista vuelve',
      ],
    });    
  }

1;