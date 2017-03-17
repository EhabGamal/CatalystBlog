use utf8;
package Blog::Schema::Result::Post;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Blog::Schema::Result::Post

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

=head1 TABLE: C<posts>

=cut

__PACKAGE__->table("posts");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 userid

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 title

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 content

  data_type: 'mediumtext'
  is_nullable: 1

=head2 publish

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 edit

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
  "userid",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "title",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "content",
  { data_type => "mediumtext", is_nullable => 1 },
  "publish",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
  "edit",
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

=head1 RELATIONS

=head2 comments

Type: has_many

Related object: L<Blog::Schema::Result::Comment>

=cut

__PACKAGE__->has_many(
  "comments",
  "Blog::Schema::Result::Comment",
  { "foreign.postid" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 post_tags

Type: has_many

Related object: L<Blog::Schema::Result::PostTag>

=cut

__PACKAGE__->has_many(
  "post_tags",
  "Blog::Schema::Result::PostTag",
  { "foreign.postid" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 userid

Type: belongs_to

Related object: L<Blog::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "userid",
  "Blog::Schema::Result::User",
  { id => "userid" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-17 15:38:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:l+K+/GFKcd9H/czSbyEBUA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
