package SayMoar;
use Kelp::Base 'Kelp';
use Mouse;
use SayMoar::Controller::Feed;
use SayMoar::Controller::Wall;
use SayMoar::Controller;
use SayMoar::Controller::User;

sub build {
    my $self = shift;
    $self->load_module('DBD::SQLite');
    my $r    = $self->routes;

    $r->add( '/', 'home' );
    $r->add( '/profile', { to => 'auth#auth', bridge => 1 });
    $r->add( '/profile/:name', { method => 'GET', to => 'user#profile'} );
    $r->add( '/profile/:name', { method => 'POST', to => 'user#post'} );

    $r->add( '/post', 'wall#post');

    $r->add( '/wall', 'wall#resolve_user');
    $r->add( '/wall/:user', 'wall#show');

    $r->add( '/config', sub { $_[0]->config_hash } );
    $r->add( '/login', {method => 'GET', to => 'auth#login'});
    $r->add( '/login', {method => 'POST', to => 'auth#check'} );
    $r->add( '/reg', {method => 'POST', to => 'auth#registration'} );
    
    $r->add( '/success', 'success' );
}

sub home {
    my $self = shift;
    $self->template('home');
}

sub success {
    my $self = shift;
    $self->template('success', { message => $self->param('id') || $self->named('id') || 'something successed' });
}

1;
