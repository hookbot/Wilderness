package Object;

use strict;
use warnings;

use Data::Dumper;

use overload
    'bool' => sub {
        my $self = shift;
        return $self;
    },
    '""' => sub {
        my $self = shift;
        return $self->name();
    },
    '==' => sub {
        my $a = shift;
        my $b = shift;
        $a = $a->name() if (ref $a && $a->can('name'));
        $b = $b->name() if (ref $b && $b->can('name'));
        return $a eq $b;
    },
    'eq' => sub {
        my $a = shift;
        my $b = shift;
        $a = $a->name() if (ref $a && $a->can('name'));
        $b = $b->name() if (ref $b && $b->can('name'));
        return $a eq $b;
    };

sub new {
    my $package = shift;
    my $self = {@_};
    $self->{'hidden'} = Container->new();
    $self->{'visible'} = Container->new();
    bless $self, $package;
    return $self;
}

sub get_health { undef }

sub name {
    my $self = shift;
    return $self->{'name'};
}

sub where {
    my $self = shift;
    return $self->{'location'};
}

my $default_description = 'There does not appear to be anything special about it';

sub describe {
    my $self = shift;
    return join ("\n\t", $default_description, $self->get_sub_description());
}

sub get_ingredient { return undef }

sub get_sub_description {
    my $self = shift;
    my @items = $self->get_equipment();
    my @lines;
    if ( @items ) {
        foreach my $item (@items) {
            push @lines, "\tThe $self has a $item";
            my @items_items = $item->get_equipment();
            foreach my $items_item (@items_items) {
                push @lines, "\tThe $item has a $items_item";
            }
        }
    }
    return @lines;
}

sub equip {
    my $self = shift;
    my $item = shift;
    $self->inventory_remove($item);
    $self->equipment_add($item);
}

sub unequip {
    my $self = shift;
    my $item = shift;
    $self->equipment_remove($item);
    $self->inventory_add($item);
}

sub inventory_add {
    my $self = shift;
    my $item = shift;
    $self->{'hidden'}->add($item);
}

sub inventory_remove {
    my $self = shift;
    my $item = shift;
    $self->{'hidden'}->remove($item);
}

sub get_inventory{
    my $self = shift;
    my @items = $self->{'hidden'}->get_all();
    return @items;
}

sub equipment_add {
    my $self = shift;
    my $item = shift;
    $self->{'visible'}->add($item);
}

sub equipment_remove {
    my $self = shift;
    my $item = shift;
    $self->{'visible'}->remove($item);
}

sub get_equipment{
    my $self = shift;
    my @items = $self->{'visible'}->get_all();
    return @items;
}

sub get_all {
    my $self = shift;
    my @possessions = ( $self->get_equipment(), $self->get_inventory() );
    return @possessions;
}

1;
