package Class::Info;
use Moose;
use Moose::Util::TypeConstraints;
use Class::Info::Method;

subtype 'Meta',
    as 'Class::MOP::Class';
coerce 'Meta',
    from 'Str',
    via { Class::MOP::load_class(@_); Class::MOP::Class->initialize($_) };

has metaclass => (
    is       => 'ro',
    isa      => 'Meta',
    required => 1,
    init_arg => 'class',
    coerce   => 1,
    handles  => {
        name      => 'name',
        does_role => 'does_role',
    },
);

has methods => (
    is       => 'ro',
    isa      => 'ArrayRef[Class::Info::Method]',
    auto_deref => 1,
    lazy     => 1,
    default  => sub {[
        map { Class::Info::Method->new($_) } shift->metaclass->get_all_methods
    ]},
);

sub BUILDARGS {
    my $class = shift;
    return { class => $_[0] } if @_ == 1;
    return $class->SUPER::BUILDARGS(@_);
}

sub classify_methods {
    my $self = shift;
    my @methods = $self->methods;
    my @local_methods = ();
    my %role_methods = ();
    my %superclass_methods = ();
    my %imports = ();
    for my $method (@methods) {
        my $origin = $method->package_name;
        if ($self->name eq $origin) {
            push @local_methods, $method;
        }
        elsif ($self->name->isa($origin)) {
            push @{ $superclass_methods{$origin} ||= [] }, $method;
        }
        elsif ($self->does_role($origin)) {
            push @{ $role_methods{$origin} ||= [] }, $method;
        }
        else {
            push @{ $imports{$origin} ||= [] }, $method;
        }
    }
    return {
        local     => \@local_methods,
        composed  => \%role_methods,
        inherited => \%superclass_methods,
        imported  => \%imports,
    };
}

1;
