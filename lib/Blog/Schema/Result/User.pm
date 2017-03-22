use utf8;
package Blog::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Blog::Schema::Result::User

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=item * L<DBIx::Class::TimeStamp>

=item * L<DBIx::Class::PassphraseColumn>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "PassphraseColumn");

=head1 TABLE: C<users>

=cut

__PACKAGE__->table("users");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 username

  data_type: 'varchar'
  is_nullable: 0
  size: 30

=head2 fname

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 lname

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 email

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 password

  data_type: 'char'
  is_nullable: 0
  size: 64

=head2 gender

  data_type: 'char'
  is_nullable: 1
  size: 1

=head2 bio

  data_type: 'varchar'
  is_nullable: 1
  size: 300

=head2 avatar

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 regdate

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "username",
  { data_type => "varchar", is_nullable => 0, size => 30 },
  "fname",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "lname",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "email",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "password",
  { data_type => "char", is_nullable => 0, size => 64 },
  "gender",
  { data_type => "char", is_nullable => 1, size => 1 },
  "bio",
  { data_type => "varchar", is_nullable => 1, size => 300 },
  "avatar",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "regdate",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<email>

=over 4

=item * L</email>

=back

=cut

__PACKAGE__->add_unique_constraint("email", ["email"]);

=head2 C<username>

=over 4

=item * L</username>

=back

=cut

__PACKAGE__->add_unique_constraint("username", ["username"]);

=head1 RELATIONS

=head2 comments

Type: has_many

Related object: L<Blog::Schema::Result::Comment>

=cut

__PACKAGE__->has_many(
  "comments",
  "Blog::Schema::Result::Comment",
  { "foreign.userid" => "self.id" },
  { cascade_copy => 0, cascade_delete => 1 },
);

__PACKAGE__->has_many(
    "posts",
    "Blog::Schema::Result::Post",
    { "foreign.userid" => "self.id" },
    { cascade_copy => 0, cascade_delete => 1 },
);

=head1 RELATIONS

=head2 user_roles

Type: has_many

Related object: L<MyApp::Schema::Result::UserRole>

=cut

__PACKAGE__->has_many(
    "user_roles",
    "Blog::Schema::Result::UserRole",
    { "foreign.user_id" => "self.id" },
    { cascade_copy => 0, cascade_delete => 0 },
);

# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-18 18:02:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NQH/p/yMCdFQj6OusV7jHg

# many_to_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of has_many() relationship this many_to_many() is shortcut for
#     3) Name of belongs_to() relationship in model class of has_many() above
#   You must already have the has_many() defined to use a many_to_many().
__PACKAGE__->many_to_many(roles => 'user_roles', 'role');

# Have the 'password' column use a SHA-1 hash and 20-byte salt
# with RFC 2307 encoding; Generate the 'check_password" method
__PACKAGE__->add_columns(
    'password' => {
        passphrase       => 'rfc2307',
        passphrase_class => 'SaltedDigest',
        passphrase_args  => {
            algorithm   => 'SHA-1',
            salt_random => 20.
        },
        passphrase_check_method => 'check_password',
    },
);

sub delete_allowed_by {
    my ($self, $user) = @_;

    # Only allow delete if user has 'admin' role
    return $user->has_role('admin');
}

=head2 has_role

Check if a user has the specified role

=cut

use Perl6::Junction qw/any/;
sub has_role {
    my ($self, $role) = @_;

    # Does this user posses the required role?
    return any(map { $_->role } $self->roles) eq $role;
}

__PACKAGE__->meta->make_immutable;
1;
