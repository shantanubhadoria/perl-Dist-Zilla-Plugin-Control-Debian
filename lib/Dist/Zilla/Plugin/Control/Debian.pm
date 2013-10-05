use strict;
use warnings;
package Dist::Zilla::Plugin::Control::Debian;
# PODNAME: Dist::Zilla::Plugin::Control::Debian
# ABSTRACT: Add a debian/control file to your distribution 
# COPYRIGHT
# VERSION

# Dependencies

use Moose;
use Moose::Autobox;
with 'Dist::Zilla::Role::FileGatherer';

use Software::Release;
use Software::Release::Change;

=attr file_name

 file_name=debian/control
You will not need to change this from the default.

=cut

has file_name => (
	is      => 'ro',
	isa     => 'Str',
	default => 'debian/control',
);

=attr priority

 priority=optional
 
Default value is 'optional'

=cut

has priority => (
    is      => 'ro',
    isa     => 'Str',
    default => 'optional',
);

=attr buildDepends

    buildDepends=debhelper (>= 8)

value for Build-Depends

=cut

has buildDepends => (
    is      => 'ro',
    isa     => 'Str',
    default => 'debhelper (>= 8)',
);

=method gather_files
    
imported from FileGatherer

=cut

sub gather_files {
	my ($self, $arg) = @_;
	my $file = Dist::Zilla::File::InMemory->new(
		{
			content => $self->render_control,
			name    => $self->file_name,
		}
	);

	$self->add_file($file);
}

=method render_control

Simple method used to generate the content for control files

=cut

sub render_control {
	my ($self) = @_;
    my $content = "Source: lib" . lc($self->zilla->name) . "-perl
Section: perl
Priority: " . $self->priority . "
Maintainer: " . $self->maintainer_name . " <" . $self->maintainer_email . ">
Build-Depends: " . $self->buildDepends . "
Build-Depends-Indep: perl
Standards-Version: 3.9.2
Homepage: http://search.cpan.org/dist/" . $self->zilla->name . "/

Package: lib" . lc($self->zilla->name) . "-perl
Architecture: all
Depends: \${misc:Depends}, \${perl:Depends}
Desciprion: " . $self->zilla->abstract ; 
    return $content;
}

1;
