package Dist::Zilla::Plugin::PERLANCAR::CheckPendingRelease;

# AUTHORITY
# DATE
# DIST
# VERSION

use namespace::autoclean;
use Moose;
with qw(Dist::Zilla::Role::BeforeRelease);

use File::Which qw(which);
use IPC::System::Options qw(system);

sub before_release {
  my $self = shift;

  my $prog = "my-pending-perl-release";
  unless (which $program) {
      $self->log_debug("Program $prog is not in PATH, skipping check of pending releases");
      return;
  }

  my $dist = $self->zilla->name;
  my $output;
  system(
      {log=>1, die=>1, capture_stdout=>\$output},
      $prog, "dist", $dist,
  );
  if ($output =~ /\S/) {
      $self->log_fatal("There is a pending release of $dist, aborting build");
  } else {
      $self->log_debug("There is no pending release of $dist, continuing build");
  }
}

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: Check for pending release before releasing

=for Pod::Coverage .+

=head1 SYNOPSIS

In your F<dist.ini>:

 [PERLANCAR::CheckPendingRelease]


=head1 DESCRIPTION

In the BeforeRelease phase, this plugin checks whether the program
L<my-pending-perl-release> is found in PATH. If the program is found, this
plugin uses the program to check whether a previous release of the distro being
built is pending release. And when that is the case, the plugin aborts the build
to avoid releasing a newer version of the distro while another, older version
has been built but not yet released.

This plugin is most probably only useful to me, as I often build but not
immediately release my distros using L<Dist::Zilla>. I release this plugin
because this plugin is included in my standard bundle. When the
C<my-pending-perl-release> program is not found in PATH, this plugin will do
nothing.


=head1 CONFIGURATION


=cut
