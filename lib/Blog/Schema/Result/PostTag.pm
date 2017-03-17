use utf8;
package Blog::Schema::Result::PostTag;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Blog::Schema::Result::PostTag

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

=head1 TABLE: C<post_tags>

=cut

__PACKAGE__->table("post_tags");

=head1 ACCESSORS

=head2 postid

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 tagid

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "postid",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "tagid",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
);

=head1 RELATIONS

=head2 postid

Type: belongs_to

Related object: L<Blog::Schema::Result::Post>

=cut

__PACKAGE__->belongs_to(
  "postid",
  "Blog::Schema::Result::Post",
  { id => "postid" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 tagid

Type: belongs_to

Related object: L<Blog::Schema::Result::Tag>

=cut

__PACKAGE__->belongs_to(
  "tagid",
  "Blog::Schema::Result::Tag",
  { id => "tagid" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-17 15:38:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ajpHCyBh9u+HWLRjIl1bow


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
