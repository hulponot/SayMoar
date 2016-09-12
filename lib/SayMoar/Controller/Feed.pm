package SayMoar::Controller::Feed;

use Kelp::Base 'SayMoar::Controller';

sub feed { 
#    return "hello";
    my $self = shift;
    $self->template('feed');
}
1;
