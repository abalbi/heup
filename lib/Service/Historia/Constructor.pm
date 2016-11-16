package Service::Historia::Constructor;
use strict; 
use JSON;
use fields qw(_argumentos _historia);
our $AUTOLOAD;
use Data::Dumper;
use Util;

our $logger = Log::Log4perl->get_logger(__PACKAGE__);

  sub new {
    my $self = shift;
    my $args = shift;
    $self = fields::new($self);
    $self->argumentos($args);
    return $self;
  }

  sub argumentos {
    my $self = shift;
    my $argumentos = shift;
    $self->{_argumentos} = $argumentos if defined $argumentos;
    $self->{_argumentos} = {} if not defined $self->{_argumentos};
    return $self->{_argumentos};
  }

  sub historia {
    my $self = shift;
    my $historia = shift;
    $self->{_historia} = $historia if defined $historia;
    return $self->{_historia};
  }

  sub hacer {
    my $self = shift;
    my $historia = $self->historia;
    push @{$historia->pasos}, 'Se descubre la amenaza que es <monstruo>, que daña a <victima>';
    push @{$historia->pasos}, '<protagonista> es llamado a vencer a <monstruo>';
    push @{$historia->pasos}, '<protagonista> se prepara';
    push @{$historia->pasos}, '<protagonista> se enfrenta a <monstruo>';
    push @{$historia->pasos}, '<protagonista> vence a <monstruo>';
    foreach my $paso (@{$historia->pasos}) {
      my $roles = [$paso =~ /\<\w+\>/g];
      foreach my $rol (@$roles) {
        $rol =~ /\<(\w+)\>/;
        $historia->roles->{$1} = {};
      }
    }
    foreach my $rol (sort keys %{$historia->roles}) {
      $historia->roles->{$rol} = Service::Personaje->crear;
    }
  	return $historia;
  }


1;