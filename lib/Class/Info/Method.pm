package Class::Info::Method;
use Moose;

has method => (
    is       => 'ro',
    isa      => 'Class::MOP::Method',
    required => 1,
    handles  => qr/.*/,
);

sub BUILDARGS {
    my $class = shift;
    return { method => $_[0] } if @_ == 1;
    return $class->SUPER::BUILDARGS(@_);
}

sub as_string {
    my $self = shift;
    return $self->name . " (" . blessed($self->method) . ")";
}

1;
