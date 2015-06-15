package Spreadsheet::HTML::Presets;
use strict;
#use warnings FATAL => 'all';
use warnings;

use Spreadsheet::HTML;
use Spreadsheet::HTML::Presets::Conway;

sub layout {
    my $self = shift if ref($_[0]) =~ /^Spreadsheet::HTML/;
    my @args = (
        encodes => '',
        matrix  => 1,
        table   => {
            role => 'presentation',
            ( map {$_ => 0} qw( border cellspacing cellpadding ) ),
        },
        _layout => 1,
        @_,
    );
    $self ? $self->generate( @args ) : Spreadsheet::HTML::generate( @args );
}

sub checkerboard {
    my ($self,$data,$args);
    $self = shift if ref($_[0]) =~ /^Spreadsheet::HTML/;
    ($self,$data,$args) = $self ? $self->_args( @_ ) : Spreadsheet::HTML::_args( @_ );

    my $colors = $args->{colors} ? $args->{colors} : [qw(red white)];
    my @args = (
        td       => { style  => { 'background-color' => $colors } },
        matrix   => 1,
        headings => sub { join(' ', map { sprintf '<b>%s</b>', ucfirst(lc($_)) } split ('_', shift || '')) },
        @_,
    );
    $self ? $self->generate( @args ) : Spreadsheet::HTML::generate( @args );
}

sub conway {
    my ($self,$data,$args);
    $self = shift if ref($_[0]) =~ /^Spreadsheet::HTML/;
    ($self,$data,$args) = $self ? $self->_args( @_ ) : Spreadsheet::HTML::_args( @_ );

    $args->{on}    ||= '#00BFA5';
    $args->{off}   ||= '#EEE';
    $args->{jquery} ||= 'https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js';

    my @cells;
    for my $r ( 0 .. $args->{_max_rows} - 1 ) {
        for my $c ( 0 .. $args->{_max_cols} - 1 ) {
            push @cells,
                sprintf( "-row%scol%s", $r, $c ) => {
                    id     => join( '-', $r, $c ),
                    class  => 'conway',
                    width  => '30px',
                    height => '30px',
                    style  => { 'background-color' => $args->{off} },
                };
        }
    }

    my @args = (
        pinhead  => 0,
        tgroups  => 0,
        headless => 0,
        matrix   => 1,
        caption  => { '<button onClick="start()">Step</button>' => { align => 'bottom' } },
        @cells,
        @_,
    );

    my $table = $self ? $self->generate( @args ) : Spreadsheet::HTML::generate( @args );
    my $js = Spreadsheet::HTML::Presets::Conway::_javascript(
        @{ $args }{qw( jquery _max_rows _max_cols off on )}
    );

    delete $args->{$_} for qw( jquery off on );

    return $js . $table;
}

sub checkers {
    my $self = shift if ref($_[0]) =~ /^Spreadsheet::HTML/;

    my @rows;
    $rows[0] = [ '', '&#9922;', '', '&#9922;', '', '&#9922;', '', '&#9922;', '', '&#9922;' ];
    $rows[1] = [ '&#9922;', '', '&#9922;', '', '&#9922;', '', '&#9922;', '', '&#9922;', '' ];
    $rows[2] = [ '', '&#9922;', '', '&#9922;', '', '&#9922;', '', '&#9922;', '', '&#9922;' ];
    $rows[5] = [ '&#9920;', '', '&#9920;', '', '&#9920;', '', '&#9920;', '', '&#9920;', '' ];
    $rows[6] = [ '', '&#9920;', '', '&#9920;', '', '&#9920;', '', '&#9920;', '', '&#9920;' ];
    $rows[7] = [ '&#9920;', '', '&#9920;', '', '&#9920;', '', '&#9920;', '', '&#9920;', '' ];

    my @args = (
        tgroups  => 0,
        headless => 0,
        pinhead  => 0,
        matrix   => 1,
        -row0 => sub { shift @{ $rows[0] } },
        -row1 => sub { shift @{ $rows[1] } },
        -row2 => sub { shift @{ $rows[2] } },
        -row5 => sub { shift @{ $rows[5] } },
        -row6 => sub { shift @{ $rows[6] } },
        -row7 => sub { shift @{ $rows[7] } },
        fill  => '8x8',
        table => {
            width => '65%',
            style => {
                border => 'thick outset',
            },
        },
        td => {
            height => 65,
            width  => 65,
            align  => 'center',
            style  => { 
                'font-size' => 'xx-large',
                border => 'thin inset',
                'background-color' => [ ('white', 'red')x4, ('red', 'white')x4 ]
            }
        },
        @_,
    );

    $self ? $self->generate( @args ) : Spreadsheet::HTML::generate( @args );
}

sub chess {
    my $self = shift if ref($_[0]) =~ /^Spreadsheet::HTML/;

    my @black = ( '&#9820;', '&#9822;', '&#9821;', '&#9819;', '&#9818;', '&#9821;', '&#9822;', '&#9820;' );
    my @white = ( '&#9814;', '&#9816;', '&#9815;', '&#9813;', '&#9812;', '&#9815;', '&#9816;', '&#9814;' );

    my @args = (
        tgroups  => 0,
        headless => 0,
        pinhead  => 0,
        matrix   => 1,
        -row0 => sub { shift @black },
        -row1 => sub {'&#9823;'},
        -row6 => sub {'&#9817;'},
        -row7 => sub { shift @white },
        fill  => '8x8',
        table => {
            width => '65%',
            style => {
                border => 'thick outset',
            },
        },
        td => {
            height => 65,
            width  => 65,
            align  => 'center',
            style  => { 
                'font-size' => 'xx-large',
                border => 'thin inset',
                'background-color' => [ ('white', '#aaaaaa')x4, ('#aaaaaa', 'white')x4 ]
            }
        },
        @_,
    );

    $self ? $self->generate( @args ) : Spreadsheet::HTML::generate( @args );
}

sub dk {
    my $self = shift if ref($_[0]) =~ /^Spreadsheet::HTML/;

my $tmpl = '
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

    my %map = (
        '.' => '#FFFFFF',
        1 => '#AA0000',
        2 => '#FFAA55',
        3 => '#FFFFFF',
        4 => '#D50000',
        5 => '#FF5500',
    );

    my (@cells);
    my @lines = grep ! $_ =~ /^\s*$/, split /\n/, $tmpl;
    my $total_rows = scalar @lines;
    my $total_cols;
    for my $row (0 .. $#lines) {
        my @chars = split //, $lines[$row];
        $total_cols ||= scalar @chars;
        for my $col (0 .. $#chars) {
            next unless my $color = $map{ $chars[$col] };
            push @cells, ( 
                "-row${row}col${col}" => {
                    width  => 16,
                    height => 8,
                    style  => { 'background-color' => $color },
                }
            );
        }
    }

    my @args = (
        pinhead  => 0,
        tgroups  => 0,
        headless => 0,
        matrix   => 1,
        fill     => join( 'x', $total_rows, $total_cols ),
        @cells,
        @_,
    );

    $self ? $self->generate( @args ) : Spreadsheet::HTML::generate( @args );
}

sub shroom {
    my $self = shift if ref($_[0]) =~ /^Spreadsheet::HTML/;

my $tmpl = '
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

    my %map = (
        '.' => 'white',
        1 => 'black',
        2 => 'green',
        3 => 'white',
    );

    my (@cells);
    my @lines = grep ! $_ =~ /^\s*$/, split /\n/, $tmpl;
    my $total_rows = scalar @lines;
    my $total_cols;
    for my $row (0 .. $#lines) {
        my @chars = split //, $lines[$row];
        $total_cols ||= scalar @chars;
        for my $col (0 .. $#chars) {
            next unless my $color = $map{ $chars[$col] };
            push @cells, ( 
                "-row${row}col${col}" => {
                    width  => 16,
                    height => 8,
                    style  => { 'background-color' => $color },
                }
            );
        }
    }

    my @args = (
        pinhead  => 0,
        tgroups  => 0,
        headless => 0,
        matrix   => 1,
        fill     => join( 'x', $total_rows, $total_cols ),
        @cells,
        @_,
    );

    $self ? $self->generate( @args ) : Spreadsheet::HTML::generate( @args );
}

=head1 NAME

Spreadsheet::HTML::Presets - Preset tables for fun and games.

=head1 DESCRIPTION

This is a container for L<Spreadsheet::HTML> preset methods.
These methods are not meant to be called from this package.
Instead, use the Spreadsheet::HTML interface:

  use Spreadsheet::HTML;
  my $table = Spreadsheet::HTML->new( data => [[1],[2]] );

  # or
  use Spreadsheet::HTML qw( layout );
  print layout( data => [[1],[2]] );

=head1 CUSTOMIZATION

You can use the methods in this package as an example for
constructing your own custom Spreadsheet::HTML generators.

  use Spreadsheet::HTML;

  sub my_generator {
      my ($self,$data,$params);
      $self = shift if ref($_[0]) =~ /^Spreadsheet::HTML/;
      ($self,$data,$params) = $self 
          ? $self->_args( @_ ) 
          : Spreadsheet::HTML::_args( @_ );

      # pull out custom named parameters from $params
      my $color = $params->{color};

      my @args = (
          # add custom args here
          @_,
      );

      $self ? $self->generate( @args ) : Spreadsheet::HTML::generate( @args );
  }

It is not pretty, but it keeps the named parameters in line even
if stray, bare array references are used by the client:

  $table->my_generator( [ 'data here' ], color => 'red' );

A simpler, less flexible form is available if you do not need to
pull out custom args:

  use Spreadsheet::HTML;

  sub my_generator {
      my $self = shift if ref($_[0]) =~ /^Spreadsheet::HTML/;

      my @args = (
          # add custom args here
          @_,
      );

      $self ? $self->generate( @args ) : Spreadsheet::HTML::generate( @args );
  }

=head1 METHODS

=over 4

=item * C<layout( %params )>

Layout tables are not recommended, but if you choose to
use them you should label them as such. This adds W3C
recommended layout attributes to the table tag and features:
emiting only <td> tags, no padding or pruning of rows, forces
no HTML entity encoding in table cells.

=item * C<checkerboard( colors, %params )>

Preset for tables with checkerboard colors.

  checkerboard( colors => [qw(red green orange)] )

=item * C<conway( on, off, %params )>

Game of life. From an implementation i wrote back in college.

  conway( on => 'red', off => 'gray' )

=item * C<checkers( %params )>

Generates a static checkers game board (US).

=item * C<chess( %params )>

Generates a static chess game board.

=item * C<dk( %params )>

=item * C<shroom( %params )>

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
