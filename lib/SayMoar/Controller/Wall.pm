package SayMoar::Controller::Wall;

use strict;
use warnings;
use BerkeleyDB qw/ DB_NEXT_DUP DB_NEXT /;
use Kelp::Base 'SayMoar::Controller';


sub show {
    my $self = shift;
    my $list = [ "abcd", "efg", "123"];
    for (@$list){
        $self->wall_db->db_put('post', $_);
    }
    undef $list;
    my ($key,$value) = ('post','');
    my $cursor = $self->wall_db->db_cursor;
    while ( $cursor->c_get($key,$value, DB_NEXT) == 0 ){
        push @$list,$value;
    }
    $self->template('wall', {one => 1, list => $list });
}

1;
