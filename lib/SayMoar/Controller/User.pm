package SayMoar::Controller::User;

use strict;
use warnings;
use Kelp::Base 'SayMoar::Controller';

use DBI qw/ :sql_types /;
use SayMoar::Constants;
use Data::Dumper;
use utf8;
use Encode qw/ encode decode /;
use DateTime;

sub profile {
    my $self = shift;
    my $name = $self->named('name');
    my $owner = $self->main_db->selectrow_hashref("SELECT * FROM users WHERE name = ?",{},$name)->{'id'};
    my $hash = $self->main_db->selectall_hashref("SELECT * FROM posts WHERE owner = ?",'id',{},$owner);
    my $headers = [];
    foreach (keys %$hash){
        my $header = decode("UTF-8",$hash->{$_}->{title});
        push @$headers, $header;
    }

    my $me = 0;
    if($name eq $self->session->{name}){
        $me = 1;
    }
    $name = decode("UTF-8",$name);
    return $self->template('profile', { name =>  $name, headers => $headers, me => $me });
}

sub post {
    my $self = shift;
    my $title = $self->param('title');
    my $text = $self->param('text');
    $title = decode('UTF-8', $title);
    $title = encode('UTF-8', $title);

    my $user_id = $self->session->{user_id};
    if ($user_id){
        my $epoch = DateTime->now->epoch;
        
        my $sth_insert = $self->main_db->prepare("INSERT INTO posts (title,text,owner,epoch) VALUES (?,?,?,?)");
        $sth_insert->bind_param(1, $title, SQL_VARCHAR);
        $sth_insert->bind_param(2, $text, SQL_VARCHAR);
        $sth_insert->bind_param(3, $user_id, SQL_VARCHAR);
        $sth_insert->bind_param(4, $epoch, SQL_VARCHAR);

        $sth_insert->execute();
    }
    $self->res->redirect_to('/profile/'.$self->named('name'), {},303);
}

1;
