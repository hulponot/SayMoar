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
    my $posts = [];
    foreach (keys %$hash){
        my $post = decode("UTF-8",$hash->{$_}->{title});
        push @$posts, $hash->{$_};
    }

    my $me = 0;
    if(decode('UTF-8',$name) eq $self->session->{name}){
        $me = 1;
    }
    $name = decode("UTF-8",$name);
    return $self->template('profile', { name =>  $name, posts => $posts, me => $me });
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

sub text {
    my $self = shift;
    my $text_id = $self->named('id');
    my $text = decode('UTF-8', $self->main_db->selectrow_hashref("SELECT text FROM posts WHERE id = ?",{},$text_id)->{text});

    my $comments_hash = $self->main_db->selectall_hashref("SELECT * FROM comments WHERE post = ?",'id', {}, $text_id);
    my $user_ids = [ map { $comments_hash->{$_}->{owner} } keys %$comments_hash ];
    my $users = $self->main_db->selectall_hashref("SELECT id,name FROM users WHERE id IN (" . join(',',@$user_ids) . ")",'id');
    foreach (keys %$comments_hash){
        $comments_hash->{$_}->{username} = decode('UTF-8',$users->{ $comments_hash->{$_}->{owner} }->{name});
        $comments_hash->{$_}->{text} = decode('UTF-8',$comments_hash->{$_}->{text});
    }

    my $comments = [ map { $comments_hash->{ $_ } } keys %$comments_hash ];

    $self->template('text', { text => $text, comments => $comments, });

}

sub comment {
    my $self = shift;
    my $comment = decode('UTF-8',$self->param('comment'));
    my $user_id = $self->session->{'user_id'};
    my $post_id = $self->named('id');
    
    $comment = encode('UTF-8',$comment);
    $self->main_db->do("INSERT INTO comments (text,owner,post) VALUES (?,?,?)", {}, $comment,$user_id,$post_id);
    $self->res->redirect_to('/text/'.$self->named('id'), {}, 303);
}

1;
