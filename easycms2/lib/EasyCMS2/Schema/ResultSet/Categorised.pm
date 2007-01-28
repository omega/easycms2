package EasyCMS2::Schema::ResultSet::Categorised;

use base qw(DBIx::Class::ResultSet);

sub find_by_path {
    my $self = shift;
    
    my $path = shift;
    my $catch_all = shift;
    
    my @args = split('/', $path);
    
    my $parent_category;
    my $page;
    my $category;
    while (defined(my $path_part = shift @args)) {
        next if ($path_part eq '');
        $category = $self->result_source->schema->resultset('Category')->search({ url_name => $path_part,
            parent => ($parent_category ? $parent_category->id : undef ) })->first;
        if ($category) {
            # we found a category for this path_part, so we try the next
            $parent_category = $category;
            # The category has signaled that it wants to catch everything!
            if ($catch_all and $category->catch_all) {
                last;
            }
            next;
        } else {
            # we found no category. We should try to find a page perhaps?
            my $objects = $self->search({ category => $parent_category->id });
            while (my $object = $objects->next) {
                if ($object->path_part eq $path_part) {
                    $page = $object;
                    last;
                }
            }
        }
    }
    
    return ($page ? $page : ($category ? $category : undef));
}
1;
