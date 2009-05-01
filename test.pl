#!/usr/bin/perl
use strict;
use warnings;

use Class::Info;
my $info = Class::Info->new('NetHack::Item::Potion');
my $methods = $info->classify_methods;
print "Local methods:\n";
print "  " . $_->as_string . "\n" for @{ $methods->{local} };
print "Role methods:\n";
my $role_methods = $methods->{composed};
for my $role (keys %$role_methods) {
    print "  " . $_->as_string . "\n" for @{ $role_methods->{$role} };
}
print "Inherited methods:\n";
my $inherited_methods = $methods->{inherited};
for my $inherit (keys %$inherited_methods) {
    print "  " . $_->as_string . "\n" for @{ $inherited_methods->{$inherit} };
}
print "Imported methods:\n";
my $imports = $methods->{imports};
for my $import (keys %$imports) {
    print "  " . $_->as_string . "\n" for @{ $imports->{$import} };
}
