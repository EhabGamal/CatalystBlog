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

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

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

=head2 role

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

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
  "role",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
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
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 posts

Type: has_many

Related object: L<Blog::Schema::Result::Post>

=cut

__PACKAGE__->has_many(
  "posts",
  "Blog::Schema::Result::Post",
  { "foreign.userid" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 role

Type: belongs_to

Related object: L<Blog::Schema::Result::Role>

=cut

__PACKAGE__->belongs_to(
  "role",
  "Blog::Schema::Result::Role",
  { id => "role" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-17 15:38:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:hQDHcFEeuN9Zj9bJDMQG0Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
