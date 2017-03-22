package Blog::Controller::Comments;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Blog::Controller::Comments - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Blog::Controller::Comments in Comments.');
}

sub error_404 :Chained('base') :Args(0){
    my ($self, $c) = @_;
    $c->stash(template => 'comments/404.tt');
}

sub base :Chained('/') :PathPart('comments') :CaptureArgs(0) {
    my ($self, $c) = @_;

    # Store the ResultSet in stash so it's available for other methods
    $c->stash(resultset => $c->model('DB::Comment'));

    # Print a message to the debug log
    $c->log->debug('*** INSIDE BASE METHOD ***');

    # Load status messages
    $c->load_status_msgs;
}

sub object :Chained('base') :PathPart('id') :CaptureArgs(1) {
    my ($self, $c, $id) = @_;

    $c->stash(object => $c->model('DB::Comment')->find($id));

    $c->detach('error_404') if !$c->stash->{object};
}

sub delete :Chained('object') :PathPart('delete') :Args(0) {
    my ($self, $c) = @_;

    $c->detach('/error_noperms')
        unless ( $c->user->has_role('admin') || $c->stash->{object}->userid->id == $c->user->id);

    my $postid = $c->stash->{object}->postid->id;
    $c->stash->{object}->delete;
    # Redirect the user back to the list page
    #$c->response->redirect($c->uri_for($c->controller('posts')->action_for('view'), [id=>$postid]));
    $c->response->redirect('/posts/id/'.$postid.'/view');
}

sub edit :Chained('object') :PathPart('edit') :Args(0) {
    my ($self, $c) = @_;

    $c->detach('/error_noperms')
        unless ( $c->user->has_role('admin') || $c->stash->{object}->userid->id == $c->user->id);

    $c->stash(comment => $c->stash->{object});
    $c->stash(template => 'comments/edit.tt');
}

sub save :Chained('base') :PathPart('save') :Args(0) {
    my ($self, $c) = @_;

    my $comment;
    if( $c->request->params->{commentid} ){
        $comment = $c->model('DB::Comment')->find($c->request->params->{commentid});
        $comment->update({
            comment => $c->request->params->{comment},
            comment_date => \'NOW()'
        });
    }else{
        $comment = $c->model('DB::Comment')->create({
            postid => $c->request->params->{postid},
            userid => $c->user->id,
            comment => $c->request->params->{comment},
            comment_date => \'NOW()'
        });
    }
    # Retrieve the values from the form
    #my $userid = $c->request->params->{userid} || 1;
    #my $title = $c->request->params->{title} || 'Untitled';
    #my $content = $c->request->params->{content} || 'No Content!';

    #    my $post = $c->model('DB::Post')->create({
    #        userid => $userid,
    #        title => $title,
    #        content => $content,
    #        publish => \'NOW()',
    #        edit => \'NOW()'
    #    });
    $c->response->redirect('/posts/id/'.$comment->postid->id.'/view');
    #$c->response->redirect($c->uri_for($c->controller('posts')->action_for('view'),[id=>31]));
    $c->response->header('Cache-Control' => 'no-cache');
}

=encoding utf8

=head1 AUTHOR

Ehab Gamal,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
