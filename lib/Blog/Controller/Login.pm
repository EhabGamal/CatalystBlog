package Blog::Controller::Login;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Blog::Controller::Login - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    # Get the username and password from form
    my $username = $c->request->params->{username};
    my $password = $c->request->params->{password};

    # If the username and password values were found in form
    if ($username && $password) {
        # Attempt to log the user in
        if ($c->authenticate({ username => $username,
            password => $password  } )) {
            # If successful, then let them use the application
            $c->response->redirect($c->uri_for(
                $c->controller('Posts')->action_for('list')));
            return;
        } else {
            # Set an error message
            $c->stash(error_msg => "Invalid username or password.");
        }
    } else {
        # Set an error message
        $c->stash(error_msg => "Empty username or password.")
            unless ($c->user_exists);
    }

    # If either of above don't work out, send to the login page
    $c->stash(template => 'login.tt');
}

sub register :Global :Args(0){
    my ( $self, $c ) = @_;
    $c->stash(action => "Register");
    $c->stash(template => 'register.tt');
}

sub save :Global :Args(0) {
    my ($self, $c) = @_;

    my $user;

    my $fname = $c->request->params->{fname} || "";
    my $lname = $c->request->params->{lname} || "";
    my $username = $c->request->params->{username} || "";
    my $email = $c->request->params->{email} || "";
    my $password = $c->request->params->{password} || "";
    my $rpassword = $c->request->params->{rpassword} || "";
    my $gender = $c->request->params->{gender} || "m";

    $user = $c->stash->{resultset}->find($c->request->params->{userid});
    if( $fname && $lname && $username && $email && $password && $rpassword ){
        if($password eq $rpassword){
            my $regex = $email =~ /^[a-z0-9.]+\@[a-z0-9.-]+$/;
            if($regex){
                if($c->model('DB::User')->search({email => $email}) != 0 || $c->model('DB::User')->search({username => $username}) != 0){
                    $user = $c->stash->{resultset}->create({
                        username => $username,
                        fname => $fname,
                        lname => $lname,
                        email => $email,
                        gender => $gender,
                        password => $password,
                        regdate => \'NOW()'
                    });
                    if ($c->authenticate({ username => $username, password => $password  } )) {
                        $c->response->redirect($c->uri_for(
                            $c->controller('Posts')->action_for('list')));
                        return;
                    }
                }else{
                    $c->stash(error_msg => "Username or email already exists!");
                }
            }else{
                $c->stash(error_msg => "Invalid email address!");
            }
        }else{
            $c->stash(error_msg => "PAssword does not match the confirm!");
        }
    }else{
        $c->stash(error_msg => "Please complete all your data before submitting the form!");
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

=encoding utf8

=head1 AUTHOR

Ehab Gamal,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
