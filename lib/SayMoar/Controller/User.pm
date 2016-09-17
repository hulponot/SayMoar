package SayMoar::Controller::User;

use strict;
use warnings;
use Kelp::Base 'SayMoar::Controller';

sub profile {
    my $self = shift;
    my $name = $self->param('name') || $self->named('name') || 'default';
    $self->user_db->db_put('name', $name);
    $self->user_db->db_get('name', $name);
    return $self->template('profile', { name =>  $name });
}

sub auth {
    my $self = shift;
    $self->template('auth');
}

sub reg {

}
1;
