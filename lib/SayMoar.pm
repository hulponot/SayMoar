package SayMoar;
use Kelp::Base 'Kelp';
use Mouse;
use SayMoar::Controller::Feed;
use SayMoar::Controller;
use SayMoar::Controller::User;


sub build {
    my $self = shift;
    my $r    = $self->routes;

    $r->add( '/', 'home');
    $r->add( '/profile', 'user#profile' );
    $r->add( '/config', sub { $_[0]->config_hash } );
}

sub home {
    my $self = shift;
    $self->template('home');
}

1;
