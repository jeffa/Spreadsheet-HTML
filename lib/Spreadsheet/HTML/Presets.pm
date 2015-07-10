package Spreadsheet::HTML::Presets;
use strict;
use warnings FATAL => 'all';

use Spreadsheet::HTML;
use Spreadsheet::HTML::Presets::Animate;
use Spreadsheet::HTML::Presets::Calculator;
use Spreadsheet::HTML::Presets::Conway;
use Spreadsheet::HTML::Presets::Chess;
use Spreadsheet::HTML::Presets::Handson;
use Spreadsheet::HTML::Presets::Sudoku;

eval "use JavaScript::Minifier";
our $NO_MINIFY = $@;
eval "use Text::FIGlet";
our $NO_FIGLET = $@;
eval "use Time::Piece";
our $NO_TIMEPIECE = $@;
eval "use List::Util";
our $NO_LISTUTIL = $@;

sub layout {
    my ($self,$data,$args);
    $self = shift if ref($_[0]) =~ /^Spreadsheet::HTML/;
    ($self,$data,$args) = $self ? $self->_args( @_ ) : Spreadsheet::HTML::_args( @_ );

    my @args = (
        @_,
        table   => {
            %{ $args->{table} || {} },
            role => 'presentation',
            ( map {$_ => 0} qw( border cellspacing cellpadding ) ),
        },
        encodes => '',
        matrix  => 1,
        _layout => 1,
    );

    $self ? $self->generate( @args ) : Spreadsheet::HTML::generate( @args );
}

sub checkerboard {
    my ($self,$data,$args);
    $self = shift if ref($_[0]) =~ /^Spreadsheet::HTML/;
    ($self,$data,$args) = $self ? $self->_args( @_ ) : Spreadsheet::HTML::_args( @_ );

    my $colors = $args->{colors} ? $args->{colors} : [qw(red green)];
    $colors = [ $colors ] unless ref $colors;
    $args->{extra} ||= 'white';
    push @$colors, $args->{extra} unless $args->{_max_cols} % @$colors;

    my @args = (
        matrix   => 1,
        headings => sub { join(' ', map { sprintf '<b>%s</b>', ucfirst(lc($_)) } split ('_', shift || '')) },
        @_,
        wrap => 0,
        td => { %{ $args->{td} || {} }, style  => { %{ $args->{td}{style} || {} }, 'background-color' => $colors } },
    );

    $self ? $self->generate( @args ) : Spreadsheet::HTML::generate( @args );
}

sub banner {
    my ($self,$data,$args);
    $self = shift if ref($_[0]) =~ /^Spreadsheet::HTML/;
    ($self,$data,$args) = $self ? $self->_args( @_ ) : Spreadsheet::HTML::_args( @_ );

    my @cells = ();
    unless ($NO_FIGLET) {

        my @banner;
        eval {
            @banner = Text::FIGlet
                ->new( -d => $args->{dir}, -f => $args->{emboss} ? 'block' : 'banner' )
                ->figify( -A => uc( $args->{text} || '' ), -w => 9999 );
        };

        if (@banner) {
            push @cells, ( fill => join 'x', scalar( @banner ), length( $banner[0] ) );
            my $on  = $args->{on}  || 'black';
            my $off = $args->{off} || 'white';

            for my $row (0 .. $#banner) {
                my @line = split //, $banner[$row];
                for my $col (0 .. $#line) {
                    my $key = sprintf '-r%sc%s', $row, $col;
                    if ($args->{emboss}) {
                        if ($line[$col] eq ' ') {
                            push @cells, ( $key => { style => { 'background-color' => $off } } );
                        } elsif ($line[$col] eq '_') {
                            push @cells, ( $key => { style => { 'background-color' => $off, 'border-bottom' => "1px solid $on" } } );
                        } elsif ($args->{flip}) {
                            push @cells, ( $key => { style => { 'background-color' => $off, 'border-right' => "1px solid $on" } } );
                        } else {
                            push @cells, ( $key => { style => { 'background-color' => $off, 'border-left' => "1px solid $on" } } );
                        }
                    } else {
                        my $color = $line[$col] eq ' ' ? $off : $on;
                        push @cells, ( $key => { style => { 'background-color' => $color } } );
                    }
                }
            }
        }
    }

    my @args = (
        @_,
        @cells,
        wrap => 0,
    );

    my $table = $self ? $self->generate( @args ) : Spreadsheet::HTML::generate( @args );
    return $table;
}

sub maze {
    my ($self,$data,$args);
    $self = shift if ref($_[0]) =~ /^Spreadsheet::HTML/;
    ($self,$data,$args) = $self ? $self->_args( @_ ) : Spreadsheet::HTML::_args( @_ );

    my @cells = ();
    unless ($NO_LISTUTIL) {

        my $rows = $args->{_max_rows} == 1 ? 20 : $args->{_max_rows};
        my $cols = $args->{_max_cols} == 1 ? 16 : $args->{_max_cols};
        my $off  = $args->{off}    || 'white';
        my $on   = $args->{on}     || 'black';

        push @cells, ( fill => "${rows}x${cols}" );

        my (@grid,@stack);
        for my $h (0 .. $rows - 1) {
            $grid[$h] = [ map {
                x     => $_, y => $h,
                walls => [1,1,1,1], # W S E N
            }, 0 .. $cols - 1 ];
        }

        my %neighbor = ( 0 => 2, 1 => 3, 2 => 0, 3 => 1 );
        my $visited = 1;
        my $curr = $grid[rand $rows][rand $cols];
        while ($visited < $rows * $cols) {
            my @neighbors;
            for (
                [ 3, $grid[ $curr->{y} - 1 ][ $curr->{x} ] ], # north
                [ 2, $grid[ $curr->{y} ][ $curr->{x} + 1 ] ], # east
                [ 1, $grid[ $curr->{y} + 1 ][ $curr->{x} ] ], # south
                [ 0, $grid[ $curr->{y} ][ $curr->{x} - 1 ] ], # west
            ) { no warnings; push @neighbors, $_ if List::Util::sum( @{ $_->[1]->{walls} } ) == 4 }

            if (@neighbors) {
                my ($pos,$cell) = @{ $neighbors[rand @neighbors] };
                $curr->{walls}[$pos] = 0;
                $cell->{walls}[$neighbor{$pos}] = 0;
                push @stack, $curr;
                $curr = $cell;
                $visited++;
            } else {
                $curr = pop @stack;
            }
            @neighbors = ();
        }

        my %style_map = (
           0 => 'border-left', 
           1 => 'border-bottom', 
           2 => 'border-right', 
           3 => 'border-top', 
        );

        for my $row (0 .. $#grid) {
            for my $col (0 .. @{ $grid[$row] }) {
                my $key = sprintf '-r%sc%s', $row, $col;
                my %style = ( 'background-color' => $off );
                for (0 .. $#{ $grid[$row][$col]{walls} } ) {
                    $style{$style_map{$_}} = "2px solid $on" if $grid[$row][$col]{walls}[$_]; 
                } 
                push @cells, ( $key => { height => '20px', width => '20px', style => {%style} } );
            }
        }
    }

    my @args = (
        @_,
        @cells,
        matrix   => 1,
        tgroups  => 0,
        flip     => 0,
        theta    => 0,
        headless => 0,
    );

    my $table = $self ? $self->generate( @args ) : Spreadsheet::HTML::generate( @args );
    return $table;
}

sub calendar {
    my ($self,$data,$args);
    $self = shift if ref($_[0]) =~ /^Spreadsheet::HTML/;
    ($self,$data,$args) = $self ? $self->_args( @_ ) : Spreadsheet::HTML::_args( @_ );

    my @cal_args;
    unless ($NO_TIMEPIECE) {
        my $time = Time::Piece->strptime(
            join( '-', 
                $args->{month} || (localtime)[4]+1,
                $args->{year}  || (localtime)[5]+1900,
            ), '%m-%Y'
        );
        my $first = $time->wday;
        my $last  = $time->month_last_day;
        my @flat  = ( 
            (map Time::Piece->strptime($_,"%d")->day, 4 .. 10),
            ('') x ($first - 1),
            1 .. $last
        );
        
        push @cal_args, ( data => \@flat );

        my %day_args = map {($_ => $args->{$_})} grep /^-\d+$/, keys %$args;
        for (keys %day_args) {
            my $day = abs($_);
            next if $day > $last;
            my $index = $day + $first + 5;
            my $row = int($index / 7);
            my $col = $index % 7;
            push @cal_args, ( sprintf( '-r%sc%s', $row, $col ) => $day_args{$_} );
        }

        my $caption = join( ' ', $time->fullmonth, $time->year );
        if ($args->{animate}) {
            $caption = qq{<p>$caption</p><button id="toggle" onClick="toggle()">Start</button>};
        }

        my $attr = { style => { 'font-weight' => 'bold' } };
        if ($args->{caption} and ref $args->{caption} eq 'HASH') {
            ($attr) = values %{ $args->{caption} };
        }

        push @cal_args, ( caption => { $caption => $attr } );
    }

    my @args = (
        @cal_args,
        @_,
        wrap    => 7,
        theta   => 0,
        flip    => 0,
        matrix  => 0,
    );        

    return $self ? $self->generate( @args ) : Spreadsheet::HTML::generate( @args );
}

sub checkers {
    my ($self,$data,$args);
    $self = shift if ref($_[0]) =~ /^Spreadsheet::HTML/;
    ($self,$data,$args) = $self ? $self->_args( @_ ) : Spreadsheet::HTML::_args( @_ );

    my @data = (
        [ '', '&#9922;', '', '&#9922;', '', '&#9922;', '', '&#9922;' ],
        [ '&#9922;', '', '&#9922;', '', '&#9922;', '', '&#9922;', '' ],
        [ '', '&#9922;', '', '&#9922;', '', '&#9922;', '', '&#9922;' ],
        [ ('') x 8 ], [ ('') x 8 ],
        [ '&#9920;', '', '&#9920;', '', '&#9920;', '', '&#9920;', '' ],
        [ '', '&#9920;', '', '&#9920;', '', '&#9920;', '', '&#9920;' ],
        [ '&#9920;', '', '&#9920;', '', '&#9920;', '', '&#9920;', '' ],
    );

    my $sub = sub { sprintf '<div class="game-piece">%s</div>', shift };

    my @args = (
        table => {
            width => '65%',
            style => {
                border => 'thick outset',
                %{ $args->{table}{style} || {} },
            },
            %{ $args->{table} || {} },
        },
        @_,
        td => [
            {
                height => 65,
                width  => 65,
                align  => 'center',
                style  => { 
                    'font-size' => 'xx-large',
                    border => 'thin inset',
                    'background-color' => [ ('white', 'red')x4, ('red', 'white')x4 ]
                }
            }, sub { $_[0] ? qq(<div class="game-piece">$_[0]</div>) : '' }
        ],
        tgroups  => 0,
        headless => 0,
        pinhead  => 0,
        matrix   => 1,
        wrap     => 0,
        fill     => '8x8',
        data     => \@data,
    );

    my $js    = Spreadsheet::HTML::Presets::Chess::_javascript( %$args );
    my $table = $self ? $self->generate( @args ) : Spreadsheet::HTML::generate( @args );
    return $js . $table;
}

sub chess {
    my ($self,$data,$args);
    $self = shift if ref($_[0]) =~ /^Spreadsheet::HTML/;
    ($self,$data,$args) = $self ? $self->_args( @_ ) : Spreadsheet::HTML::_args( @_ );

    my @data = (
        [ '&#9820;', '&#9822;', '&#9821;', '&#9819;', '&#9818;', '&#9821;', '&#9822;', '&#9820;' ],
        [ '&#9823;', '&#9823;', '&#9823;', '&#9823;', '&#9823;', '&#9823;', '&#9823;', '&#9823;' ],
        [ ('') x 8 ], [ ('') x 8 ], [ ('') x 8 ], [ ('') x 8 ],
        [ '&#9817;', '&#9817;', '&#9817;', '&#9817;', '&#9817;', '&#9817;', '&#9817;', '&#9817;' ],
        [ '&#9814;', '&#9816;', '&#9815;', '&#9813;', '&#9812;', '&#9815;', '&#9816;', '&#9814;' ],
    );

    my @args = (
        table => {
            width => '65%',
            style => {
                border => 'thick outset',
                %{ $args->{table}{style} || {} },
            },
            %{ $args->{table} || {} },
        },
        @_,
        td => [
            {
                height => 65,
                width  => 65,
                align  => 'center',
                style  => { 
                    'font-size' => 'xx-large',
                    border => 'thin inset',
                    'background-color' => [ ('white', '#aaaaaa')x4, ('#aaaaaa', 'white')x4 ]
                }
            }, sub { $_[0] ? qq(<div class="game-piece">$_[0]</div>) : '' }
        ],
        tgroups  => 0,
        headless => 0,
        pinhead  => 0,
        matrix   => 1,
        wrap     => 0,
        fill     => '8x8',
        data     => \@data,
    );

    my $js    = Spreadsheet::HTML::Presets::Chess::_javascript( %$args );
    my $table = $self ? $self->generate( @args ) : Spreadsheet::HTML::generate( @args );
    return $js . $table;
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
                "-r${row}c${col}" => {
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
        wrap     => 0,
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
                "-r${row}c${col}" => {
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
        wrap     => 0,
        fill     => join( 'x', $total_rows, $total_cols ),
        @cells,
        @_,
    );

    $self ? $self->generate( @args ) : Spreadsheet::HTML::generate( @args );
}

sub _js_wrapper {
    my %args = @_;

    unless ($NO_MINIFY) {
        $args{code} = JavaScript::Minifier::minify(
            input      => $args{code},
            copyright  => $args{copyright} || 'Copyright (C) 2015 Jeff Anderson',
            stripDebug => 1,
        );
    }

    my $js = $args{_auto}->tag( tag => 'script', cdata => $args{code}, attr => { type => 'text/javascript' } );
    return $js if $args{bare};

    $args{jquery} ||= 'https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js';

    my $html = $args{_auto}->tag( tag => 'script', cdata => '',    attr => { src => $args{jquery} } );
    $html   .= $args{_auto}->tag( tag => 'script', cdata => '',    attr => { src => $args{jqueryui} } ) if $args{jqueryui};
    $html   .= $args{_auto}->tag( tag => 'script', cdata => '',    attr => { src => $args{handsonjs} } ) if $args{handsonjs};
    $html   .= $args{_auto}->tag( tag => 'link', attr => { rel => 'stylesheet', media => 'screen', href => $args{css} } ) if $args{css};

    return $html . $js;
}

=head1 NAME

Spreadsheet::HTML::Presets - Preset tables for fun and games.

=head1 DESCRIPTION

This is a container for L<Spreadsheet::HTML> preset methods.
These methods are not meant to be called from this package.
Instead, use the Spreadsheet::HTML interface:

  use Spreadsheet::HTML;
  my $generator = Spreadsheet::HTML->new( data => [[1],[2]] );
  print $generator->layout();

  # or
  use Spreadsheet::HTML qw( layout );
  print layout( data => [[1],[2]] );

=head1 METHODS

=over 4

=item * C<layout( %params )>

Layout tables are not recommended, but if you choose to
use them you should label them as such. This adds W3C
recommended layout attributes to the table tag and features:
emit only <td> tags, no padding or pruning of rows, forces
no HTML entity encoding in table cells.

=item * C<checkerboard( colors, %params )>

Preset for tables with checkerboard colors.

  checkerboard( colors => [qw(yellow orange)], extra => 'blue' )

Attempts to form diagonal patterns by adding an extra color
if need be. C<colors> default to red and green and C<extra>
defaults to white.

=item * C<banner( dir, text, emboss, on, off, fill, %params )>

Will generate and display a banner using the given C<text> in the
'banner' font. Set C<emboss> to a true value and the font 'block'
will be emulated by highlighting the left and bottom borders of the cell.
Set the foreground color with C<on> and the background with C<off>.
You Must have L<Text::FIGlet> installed in order to use this preset.

  banner( dir => '/path/to/figlet/fonts', text => 'HI', on => 'red' )

=item * C<calendar( month, year, %params )>

Generates a static calendar. Defaults to current month and year.

  calendar( month => 7, year, 2015 )

Mark a day of the month like so:

  calendar( month => 12, -25 => { bgcolor => 'red' } )

Default rules still apply to styling columns by any heading:

  calendar( -Tue => { class => 'ruby' } )

=item * C<maze( on, off, fill, %params )>

Generates a static maze.

  maze( fill => '10x10', on => 'red', off => 'black' ) 

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
