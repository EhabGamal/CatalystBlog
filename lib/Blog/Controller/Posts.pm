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

    $c->response->body('Matched Blog::Controller::Posts in Posts.');
}

sub base :Chained('/') :PathPart('posts') :CaptureArgs(0) {
    my ($self, $c) = @_;

    # Store the ResultSet in stash so it's available for other methods
    $c->stash(resultset => $c->model('DB::Post'));

    # Print a message to the debug log
    $c->log->debug('*** INSIDE BASE METHOD ***');
}

sub list :Local {
    # Retrieve the usual Perl OO '$self' for this object. $c is the Catalyst
    # 'Context' that's used to 'glue together' the various components
    # that make up the application
    my ($self, $c) = @_;

    # Retrieve all of the book records as book model objects and store in the
    # stash where they can be accessed by the TT template
    # $c->stash(posts => [$c->model('DB::Post')->all]);
    $c->stash(posts => [$c->model('DB::Post')->search({},{
                order_by => 'publish DESC',
                rows => 5,
                offset => 0
            })]);

    # Set the TT template to use.  You will almost always want to do this
    # in your action methods (action methods respond to user input in
    # your controllers).
    $c->stash(template => 'posts/list.tt');
}

sub add :Chained('base') : PathPart('add') :Args(0){
    my ($self, $c) = @_;
    $c->stash(template => 'posts/add.tt');
}

sub object :Chained('base') :PathPart('id') :CaptureArgs(1) {
    # $id = primary key of book to delete
    my ($self, $c, $id) = @_;

    # Find the book object and store it in the stash
    $c->stash(object => $c->stash->{resultset}->find($id));

    # Make sure the lookup was successful.  You would probably
    # want to do something like this in a real app:
    #   $c->detach('/error_404') if !$c->stash->{object};
    die "Book $id not found!" if !$c->stash->{object};

    # Print a message to the debug log
    $c->log->debug("*** INSIDE OBJECT METHOD for obj id=$id ***");
}

sub delete :Chained('object') :PathPart('delete') :Args(0) {
    my ($self, $c) = @_;

    # Use the book object saved by 'object' and delete it along
    # with related 'book_author' entries
    $c->stash->{object}->delete;

    # Set a status message to be displayed at the top of the view
    $c->stash->{status_msg} = "Book deleted.";

    # Forward to the list action/method in this controller
    $c->response->redirect($c->uri_for($self->action_for('list'),{status_msg => "Book deleted."}));
}

sub save :Chained('base') :PathPart('save') :Args(0) {
    my ($self, $c) = @_;

    my $post;
    if( $c->request->params->{postid} ){
        $post = $c->model('DB::Post')->create({
            id => $c->request->params->{postid} || 1,
            title => $c->request->params->{title},
            content => $c->request->params->{content},
            edit => \'NOW()'
        });
    }else{
        $post = $c->model('DB::Post')->create({
            userid => $c->request->params->{userid} || 1,
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
    my @args = keys(@_);
    $c->stash(post => $post, template => 'posts/done.tt', args => $#args);
    $c->response->header('Cache-Control' => 'no-cache');
}

sub update :Chained('base') :PathPart('update') :Args(0) {
    my ($self, $c) = @_;

    # Retrieve the values from the form

    my $post = $c->model('DB::Post')->find(25);
    $post->update({
        title => 'after update',
        edit => \'NOW()'
    });
    my @args = keys(@_);
    $c->stash(post => $post, template => 'posts/done.tt', args => $#args);
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
