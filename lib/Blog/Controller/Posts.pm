package Blog::Controller::Posts;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Blog::Controller::Posts - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    $c->response->redirect($c->uri_for($self->action_for('list')));
}

sub error_404 :Chained('base') :Args(0){
    my ($self, $c) = @_;
    $c->stash(template => '404.tt');
}

sub base :Chained('/') :PathPart('posts') :CaptureArgs(0) {
    my ($self, $c) = @_;
    $c->stash(resultset => $c->model('DB::Post'));
    $c->load_status_msgs;
}

sub list :Chained('base') :PathPart('list') :Args(0) {
    my ($self, $c) = @_;

    $c->stash(posts => [$c->model('DB::Post')->search(
            {},
            {
                order_by => 'publish DESC',
                rows => 5,
                offset => 0,
                join => 'user'
            }
        )]
    );

    $c->stash(template => 'posts/list.tt');
}

sub add :Chained('base') : PathPart('add') :Args(0){
    my ($self, $c) = @_;
    $c->stash(action => "Add New Post");
    $c->stash(template => 'posts/add.tt');
}

sub object :Chained('base') :PathPart('id') :CaptureArgs(1) {
    my ($self, $c, $id) = @_;

    $c->stash(object => $c->model('DB::Post')->find($id));
    $c->detach('error_404') if !$c->stash->{object};
}

sub delete :Chained('object') :PathPart('delete') :Args(0) {
    my ($self, $c) = @_;

    # Check permissions
    $c->detach('/error_noperms')
        unless ( $c->user->has_role('admin') || $c->stash->{object}->user->id == $c->user->id);
        #unless $c->stash->{object}->delete_allowed_by($c->user->get_object);

    my $id = $c->stash->{object}->id;
    $c->stash->{object}->delete;
    # Redirect the user back to the list page
    $c->response->redirect($c->uri_for($self->action_for('list'),
        {mid => $c->set_status_msg("Deleted post $id")}));
}

sub view :Chained('object') :PathPart('view') :Args(0) {
    my ($self, $c) = @_;

    $c->stash(post => $c->stash->{object});
    $c->stash(template => 'posts/view.tt');
}

sub edit :Chained('object') :PathPart('edit') :Args(0) {
    my ($self, $c) = @_;
    $c->stash(post => $c->stash->{object});
    $c->detach('/error_noperms')
        unless ( $c->user->has_role('admin') || $c->stash->{object}->user->id == $c->user->id);
    $c->stash(action => "Update Post");
    $c->stash(template => 'posts/add.tt');
}

sub save :Chained('base') :PathPart('save') :Args(0) {
    my ($self, $c) = @_;

    my $post;
    if( $c->request->params->{postid} ){
        $post = $c->model('DB::Post')->find($c->request->params->{postid});
        $post->update({
            title => $c->request->params->{title},
            content => $c->request->params->{content},
            edit => \'NOW()'
        });
    }else{
        $post = $c->model('DB::Post')->create({
            userid => $c->user->id,
            title => $c->request->params->{title},
            content => $c->request->params->{content},
            publish => \'NOW()',
            edit => \'NOW()'
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
    $c->response->redirect('id/'.$post->id.'/view');
    $c->response->header('Cache-Control' => 'no-cache');
}

sub comment :Chained('base') :PathPart('comment') :Args(0) {
    my ($self, $c) = @_;

    $c->model('DB::Comment')->create({
        postid => $c->request->params->{postid},
        userid => $c->user->id,
        comment => $c->request->params->{comment},
        comment_date => \'NOW()'
    });

    $c->response->redirect('id/'.$c->request->params->{postid}.'/view');
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
