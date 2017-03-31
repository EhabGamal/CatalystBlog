package Blog::Controller::Users;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Blog::Controller::Users - Catalyst Controller

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

sub auto :Private {
    my ($self, $c) = @_;

    #if (!$c->user->has_role('admin')) {
    #    $c->detach('/error_noperms');
    #    return 0;
    #}
    return 1;
}

sub error_404 :Chained('base') :Args(0){
    my ($self, $c) = @_;
    $c->stash(template => '404.tt');
}

sub base :Chained('/') :PathPart('users') :CaptureArgs(0) {
    my ($self, $c) = @_;
    $c->stash(resultset => $c->model('DB::User'));
    $c->load_status_msgs;
}

sub list :Chained('base') :PathPart('list') :Args(0) {
    my ($self, $c) = @_;
    $c->detach('/error_noperms') if (!$c->user->has_role('admin'));
    $c->stash(users => [$c->stash->{resultset}->all]);
    $c->stash(template => 'users/list.tt');
}

sub object :Chained('base') :PathPart('id') :CaptureArgs(1) {
    my ($self, $c, $id) = @_;

    $c->stash(object => $c->stash->{resultset}->find($id));

    $c->detach('error_404') if !$c->stash->{object};
}

sub delete :Chained('object') :PathPart('delete') :Args(0) {
    my ($self, $c) = @_;

    # Check permissions
    $c->detach('/error_noperms') if (!$c->user->has_role('admin'));

    my $id = $c->stash->{object}->id;
    $c->stash->{object}->delete;
    # Redirect the user back to the list page
    $c->response->redirect($c->uri_for($self->action_for('list'),
        {mid => $c->set_status_msg("Deleted user $id")}));
}

sub view :Chained('object') :PathPart('view') :Args(0) {
    my ($self, $c) = @_;
    $c->stash(user => $c->stash->{object});
    my @comments = $c->stash->{user}->comments;
    my @posts = $c->stash->{user}->posts;
    $c->stash(comments => $#comments+1);
    $c->stash(posts => $#posts+1);
    $c->stash(template => 'users/view.tt');
}

sub edit :Chained('object') :PathPart('edit') :Args(0) {
    my ($self, $c) = @_;

    $c->detach('/error_noperms') if (!$c->user->has_role('admin') && $c->user->id != $c->stash->{object}->id);

    $c->stash(user => $c->stash->{object});
    $c->stash(action => "Update User Data");
    $c->stash(template => 'users/add.tt');
}

sub add :Chained('base') : PathPart('add') :Args(0){
    my ($self, $c) = @_;
    $c->detach('/error_noperms') if (!$c->user->has_role('admin'));
    $c->stash(action => "Insert New User");
    $c->stash(template => 'users/add.tt');
}
=pod
sub save :Chained('base') :PathPart('save') :Args(0) {
    my ($self, $c) = @_;

    my $user;
    my $userid = $c->request->params->{userid} || "";
    my $fname = $c->request->params->{fname} || "";
    my $lname = $c->request->params->{lname} || "";
    my $username = $c->request->params->{username} || "";
    my $email = $c->request->params->{email} || "";
    my $password = $c->request->params->{password} || "";
    my $rpassword = $c->request->params->{rpassword} || "";
    my $gender = $c->request->params->{gender} || "m";

    if( $c->request->params->{userid} ){
        $user = $c->stash->{resultset}->find($c->request->params->{userid});
        $user->update({
            username => $c->request->params->{username},
            fname => $c->request->params->{fname},
            lname => $c->request->params->{lname},
            email => $c->request->params->{email},
            password => $c->request->params->{password},
            gender => $c->request->params->{gender}
        });
    }else{
        $user = $c->stash->{resultset}->create({
            username => $c->request->params->{username},
            fname => $c->request->params->{fname},
            lname => $c->request->params->{lname},
            email => $c->request->params->{email},
            gender => $c->request->params->{gender},
            password => $c->request->params->{password},
            regdate => \'NOW()'
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
    $c->response->redirect('id/'.$user->id.'/view');
    $c->response->header('Cache-Control' => 'no-cache');
}
=cut

sub save :Chained('base') :PathPart('save') :Args(0) {
    my ($self, $c) = @_;

    my $user;
    my $userid = $c->request->params->{userid} || "";
    my $fname = $c->request->params->{fname} || "";
    my $lname = $c->request->params->{lname} || "";
    my $username = $c->request->params->{username} || "";
    my $email = $c->request->params->{email} || "";
    my $password = $c->request->params->{password} || "";
    my $rpassword = $c->request->params->{rpassword} || "";
    my $oldpassword = $c->request->params->{oldpassword} || "";
    my $gender = $c->request->params->{gender} || "m";

        if( $fname && $lname && $username && $email ){
            if( !$oldpassword or ($password eq $rpassword)){
                my $regex = $email =~ /^[a-z0-9.]+\@[a-z0-9.-]+$/;
                if($regex){
                    if( $c->request->params->{userid} ) {
                        $user = $c->stash->{resultset}->find($userid);
                        if (($c->model('DB::User')->search({ email => $email }) == 1
                            && $c->model('DB::User')->search({ username => $username }) == 1
                            && $user->email == $email && $user->username == $username)
                            || ($c->model('DB::User')->search({ email => $email }) == 0
                            && $c->model('DB::User')->search({ username => $username }) == 0)) {
                            $user->update({
                                username => $username,
                                fname    => $fname,
                                lname    => $lname,
                                email    => $email,
                                gender   => $gender,
                                password => $password
                            });
                            $c->stash(status_msg => "User Information updated successfully");
                        } else {
                            $c->stash(error_msg => "Username or email already exists!");
                        }
                    } else {
                        if ($c->model('DB::User')->search({ email => $email }) == 0 && $c->model('DB::User')->search({ username => $username }) == 0) {
                            $c->model('DB::User')->create({
                                username => $username,
                                fname => $fname,
                                lname => $lname,
                                email => $email,
                                gender => $gender,
                                password => $password,
                                regdate => \'NOW()'
                            });
                            $c->stash(status_msg => "New user added successfully");
                        } else {
                            $c->stash(error_msg => "Username or email already exists!");
                        }
                    }
                }else{
                    $c->stash(error_msg => "Invalid email address!");
                }
            }else{
                $c->stash(error_msg => "Password does not match the confirm!");
            }
        }else{
            $c->stash(error_msg => "Please complete all your data before submitting the form!");
        }
        $c->stash(template => 'users/add.tt');

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
