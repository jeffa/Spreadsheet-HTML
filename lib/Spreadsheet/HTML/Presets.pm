package Spreadsheet::HTML::Presets;
use strict;
use warnings FATAL => 'all';

use Spreadsheet::HTML;
use Spreadsheet::HTML::Presets::Conway;

sub layout {
    Spreadsheet::HTML::generate(
        encodes => '',
        matrix  => 1,
        table   => {
            role => 'presentation',
            ( map {$_ => 0} qw( border cellspacing cellpadding ) ),
        },
        _layout => 1,
        @_,
    );
}

sub checkerboard {
    my $colors = _extract_arg( colors => @_ );

    Spreadsheet::HTML::generate(
        td => { style  => { 'background-color' => $colors } },
        @_,
    );
}

sub checkers {
    my @rows;
    $rows[0] = [ '', '&#9922;', '', '&#9922;', '', '&#9922;', '', '&#9922;', '', '&#9922;' ];
    $rows[1] = [ '&#9922;', '', '&#9922;', '', '&#9922;', '', '&#9922;', '', '&#9922;', '' ];
    $rows[2] = [ '', '&#9922;', '', '&#9922;', '', '&#9922;', '', '&#9922;', '', '&#9922;' ];
    $rows[5] = [ '&#9920;', '', '&#9920;', '', '&#9920;', '', '&#9920;', '', '&#9920;', '' ];
    $rows[6] = [ '', '&#9920;', '', '&#9920;', '', '&#9920;', '', '&#9920;', '', '&#9920;' ];
    $rows[7] = [ '&#9920;', '', '&#9920;', '', '&#9920;', '', '&#9920;', '', '&#9920;', '' ];

    Spreadsheet::HTML::generate(
        tgroups  => 0,
        headless => 0,
        pinhead  => 0,
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
}

sub chess {
    my @black = ( '&#9820;', '&#9822;', '&#9821;', '&#9819;', '&#9818;', '&#9821;', '&#9822;', '&#9820;' );
    my @white = ( '&#9814;', '&#9816;', '&#9815;', '&#9813;', '&#9812;', '&#9815;', '&#9816;', '&#9814;' );
    Spreadsheet::HTML::generate(
        tgroups  => 0,
        headless => 0,
        pinhead  => 0,
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
}

sub dk {

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

    my (@args);
    my @lines = grep ! $_ =~ /^\s*$/, split /\n/, $tmpl;
    my $total_rows = scalar @lines;
    my $total_cols;
    for my $row (0 .. $#lines) {
        my @chars = split //, $lines[$row];
        $total_cols ||= scalar @chars;
        for my $col (0 .. $#chars) {
            next unless my $color = $map{ $chars[$col] };
            push @args, ( 
                "-row${row}col${col}" => {
                    width  => 16,
                    height => 8,
                    style  => { 'background-color' => $color },
                }
            );
        }
    }

    layout(
        pinhead  => 0,
        tgroups  => 0,
        headless => 0,
        fill     => join( 'x', $total_rows, $total_cols ),
        @args,
        @_,
    );
}

sub shroom {

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

    my (@args);
    my @lines = grep ! $_ =~ /^\s*$/, split /\n/, $tmpl;
    my $total_rows = scalar @lines;
    my $total_cols;
    for my $row (0 .. $#lines) {
        my @chars = split //, $lines[$row];
        $total_cols ||= scalar @chars;
        for my $col (0 .. $#chars) {
            next unless my $color = $map{ $chars[$col] };
            push @args, ( 
                "-row${row}col${col}" => {
                    width  => 16,
                    height => 8,
                    style  => { 'background-color' => $color },
                }
            );
        }
    }

    layout(
        pinhead  => 0,
        tgroups  => 0,
        headless => 0,
        fill     => join( 'x', $total_rows, $total_cols ),
        @args,
        @_,
    );
}

sub conway {
    my ($self,$data,$args) = Spreadsheet::HTML::_args( @_ );
    $args->{on}    ||= '#00BFA5';
    $args->{off}   ||= '#EEE';

    my @args;
    for my $r ( 1 .. $args->{_max_rows} ) {
        for my $c ( 1 .. $args->{_max_cols} ) {
            push @args,
                sprintf( "-row%scol%s", $r - 1, $c - 1 ) => {
                    id     => ( $r . $c ),
                    class  => 'conway',
                    width  => '30px',
                    height => '30px',
                    style  => { 'background-color' => $args->{off} },
                };
        }
    }

    Spreadsheet::HTML::Presets::Conway::_javascript( $args->{_max_rows} . $args->{_max_cols}, $args->{off}, $args->{on} ) .
    Spreadsheet::HTML::generate(
        pinhead  => 0,
        tgroups  => 0,
        headless => 0,
        matrix   => 1,
        caption  => { '<button onClick="start()">start</button>' => { align => 'bottom' } },
        @args,
        @_,
    );
}

sub _extract_arg {
    my ($arg) = shift;
    for (0 .. $#_) {
        return $_[$_+1] if $_[$_] eq $arg;
    }
}

=head1 NAME

Spreadsheet::HTML::Presets - Preset tables for fun and games.

See L<Spreadsheet::HTML>

=head1 METHODS

=over 4

=item * C<layout( %args )>

Layout tables are not recommended, but if you choose to
use them you should label them as such. This adds W3C
recommended layout attributes to the table tag and features:
emiting only <td> tags, no padding or pruning of rows, forces
no HTML entity encoding in table cells.

=item * C<checkerboard( colors, %args )>

Preset for tables with checkerboard colors.

  checkerboard( data => [], colors => [qw(red green orange)] )

=item * C<conway( on, off, %args )>

Game of life. Current Javascript implementation
Copyright 2015 Sandeep kumar H R.

  conway( fill => '8x8', on => 'red' )

=item * C<checkers( %args )>

Generates a static checkers game board (US).

=item * C<chess( %args )>

Generates a static chess game board.

=item * C<dk( %args )>

=item * C<shroom( %args )>

=back

=cut

1;
