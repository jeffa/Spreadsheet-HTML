package Spreadsheet::HTML::Presets::Beadwork;
use strict;
use warnings FATAL => 'all';
use Carp;

use Spreadsheet::HTML::Presets;
use Spreadsheet::HTML::File::Loader;

sub beadwork {
    my ($self,$data,$args);
    $self = shift if ref($_[0]) =~ /^Spreadsheet::HTML/;
    ($self,$data,$args) = $self ? $self->_args( @_ ) : Spreadsheet::HTML::_args( @_ );

    my %presets = (
        dk    => \&_dk,
        mario => \&_mario,
        '1up' => \&_1up,
    );

    if ($args->{preset}) {
        my $sub = $presets{ $args->{preset} };
        $sub->( $args ) if ref $sub eq 'CODE';
    }

    unless (defined $args->{art} and defined $args->{map}) {
        $args->{data} = [[ 'Error' ],[ 'art is required' ]] unless defined $args->{art};
        $args->{data} ||= [[ 'Error' ],[ 'map is required' ]] unless defined $args->{map};
        return $self ? $self->generate( %$args ) : Spreadsheet::HTML::generate( %$args );
    }

    if ($args->{art} !~ /\n/ and -r $args->{art}) {
        open FH, '<', $args->{art} or die "Cannot read $args->{art}\n";
        $args->{art} = do{ local $/; <FH> };
    }

    if (!ref $args->{map} and -r $args->{map}) {
        $args->{map} = Spreadsheet::HTML::File::Loader::parse({ file => $args->{map} });
    }

    unless (ref $args->{map}) {
        $args->{data} = [[ 'Error' ],[ 'map is not valid JSON' ]];
        return $self ? $self->generate( %$args ) : Spreadsheet::HTML::generate( %$args );
    }

    $args->{map}{'.'} = $args->{bgcolor} if defined $args->{bgcolor};

    my @lines = grep ! $_ =~ /^\s*$/, split /\n/, $args->{art};
    my $total_rows = scalar @lines;
    my $total_cols;

    my @cells;
    for my $row (0 .. $#lines) {
        my @chars = split //, $lines[$row];
        $total_cols ||= scalar @chars;
        for my $col (0 .. $#chars) {
            next unless my $color = $args->{map}{ $chars[$col] };
            push @cells, ( 
                "-r${row}c${col}" => {
                    width  => 16,
                    height => 8,
                    style  => { 'background-color' => $color },
                }
            );
        }
    }

    my @args = (
        @_,
        @cells,
        pinhead  => 0,
        tgroups  => 0,
        headless => 0,
        matrix   => 1,
        wrap     => 0,
        fill     => join( 'x', $total_rows, $total_cols ),
    );

    $self ? $self->generate( @args ) : Spreadsheet::HTML::generate( @args );
}

sub _dk {
    my $args = shift;
    $args->{art} = '
..........................................
..................1111111.................
.................414141414................
................11221112211...............
...............1122221222211..............
............221122233233222122............
...........22211122312132211222...........
...........22211122222222211222...........
.........511122222221112222221115.........
.......5511122222222222222222211155.......
......511111222211111111111222111115......
....5511111122212222222222212211111155....
...511111111111222222222222211111111115...
..11111511111112222222222222111111511111..
..11111155111111122222222211111155111111..
..11111115551111111111111111115551111111..
..11111111555122211111111222155511111111..
...111111111112222251152222211111111111...
....1111111111121222552221211111111111....
.....11111111111222255222211111111111.....
........11111112122255222121111111........
........51151522222522522222515115........
.......5111151555552222555551511115.......
......511111111522222222225111111115......
.....51111111115252522525251111111115.....
....5111111111115252521525111111111115....
....5111111111151151511511511111111115....
....5111111111111........1111111111115....
.....11111111111..........11111111111.....
.....1111111111............1111111111.....
...21221112212..............21221112212...
..252212222122..............221222212252..
.252222222222................22222222225..
..........................................
';

    $args->{map} = {
        '.' => '#FFFFFF',
        1 => '#AA0000',
        2 => '#FFAA55',
        3 => '#FFFFFF',
        4 => '#D50000',
        5 => '#FF5500',
    };

    return $args;
}

sub _1up {
    my $args = shift;

    $args->{art} = '
.....111111.....
...1122223311...
..133222233331..
.13222222233331.
.13223333222331.
1222333333222221
1222333333223321
1322333333233331
1332233332233331
1332222222223321
1322111111112221
.11133133133111.
..133313313331..
..133333333331..
...1333333331...
....11111111....
';

    $args->{map} = {
        '.' => 'white',
        1 => 'black',
        2 => 'green',
        3 => 'white',
    };

    return $args;
}

sub _mario {
    my $args = shift;

    $args->{art} = '
...111111....
..1111111111.
..22244434...
.24244443444.
.242244442444
.22444442222.
...44444444..
..3313331....
.33313331333.
3333111113333
4431111111344
4441111111444
4411111111144
..111...111..
.333.....333.
2222.....2222
';

    $args->{map} = {
        '.' => 'white',
        1 => '#D91F26', # red
        2 => '#481E1D', # black
        3 => '#3D59A8', # blue
        4 => '#F5Af9D', # flesh
    };

    return $args;
}

1;

=head1 NAME

Spreadsheet::HTML::Presets::Beadwork - create artful patterns.

=head1 DESCRIPTION

This is a container for L<Spreadsheet::HTML> preset methods.
These methods are not meant to be called from this package.
Instead, use the Spreadsheet::HTML interface:

  use Spreadsheet::HTML;
  my $generator = Spreadsheet::HTML->new;
  print $generator->beadwork(
      art => '/path/to/ascii-art.txt',
      map => '/path/to/mappings.json',
  );

  # or
  use Spreadsheet::HTML qw( beadwork );
  print beadwork(
      art => '/path/to/ascii-art.txt',
      map => '/path/to/mappings.json',
  );

=head1 METHODS

=over 4

=item * C<beadwork( art, map, bgcolor, preset, %params )>

Generates beadwork patters in the name of ASCII art.

  beadwork(
      art => '/path/to/ascii-art.txt',
      map => '/path/to/mappings.json',
      bgcolor => 'gray',
  )

Some prefabricated examples are available via the C<preset> param:

=over 4

=item * C<mario>

=item * C<dk>

=item * C<1up>

=back

  beadwork( preset => 'dk' )

=back

=head1 SEE ALSO

=over 4

=item L<Spreadsheet::HTML>

=item L<Spreadsheet::HTML::Presets>

=back

=head1 AUTHOR

Jeff Anderson, C<< <jeffa at cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2015 Jeff Anderson.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=cut

1;
