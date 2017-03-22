package Blog::Controller::Register;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Blog::Controller::Register - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ($self, $c) = @_;

    my $user;

    my $fname = $c->request->params->{fname} || "";
    my $lname = $c->request->params->{lname} || "";
    my $username = $c->request->params->{username} || "";
    my $email = $c->request->params->{email} || "";
    my $password = $c->request->params->{password} || "";
    my $rpassword = $c->request->params->{rpassword} || "";
    my $gender = $c->request->params->{gender} || "m";

    if( $fname && $lname && $username && $email && $password && $rpassword ){
        if($password eq $rpassword){
            my $regex = $email =~ /^[a-z0-9.]+\@[a-z0-9.-]+$/;
            if($regex){
                if($c->model('DB::User')->search({email => $email}) == 0 && $c->model('DB::User')->search({username => $username}) == 0){
                    $user = $c->model('DB::User')->create({
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
            $c->stash(error_msg => "Password does not match the confirm!");
        }
    }else{
        $c->stash(error_msg => "Please complete all your data before submitting the form!");
    }
    $c->stash(template => 'register.tt');
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
