package Incidente;
use strict; 
use JSON;
use fields qw(_id _roles _tipo);
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

  sub id {
    my $self = shift;
    my $id = shift;
    $self->{_id} = $id if defined $id;
    if(not defined $self->{_id}) {
      my @chars = ('0'..'9', 'A'..'F');
      my $len = 8;
      my $id;
      while($len--){ $id .= $chars[rand @chars] };
      $self->{_id} = $id;
    }
    return $self->{_id};
  }

  sub tipo {
    my $self = shift;
    return $self->{_tipo};
  }

  sub hacer {
    my $self = shift;
    return $self;
  }
1;