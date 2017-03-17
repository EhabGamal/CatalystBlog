package Blog::View::HTML;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    # Set the location for TT files
    INCLUDE_PATH => [
        Blog->path_to( 'root', 'src' ),
    ],
    # Set to 1 for detailed timer stats in your HTML as comments
    TIMER              => 0,
    # This is your wrapper template located in the 'root/src'
    WRAPPER => 'wrapper.tt',
);

=head1 NAME

Blog::View::HTML - TT View for Blog

=head1 DESCRIPTION

TT View for Blog.

=head1 SEE ALSO

L<Blog>

=head1 AUTHOR

Ehab Gamal,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
