package Spreadsheet::HTML;
use strict;
use warnings FATAL => 'all';
our $VERSION = '0.22';

use Exporter 'import';
our @EXPORT_OK = qw( generate portrait landscape north east south west );

use Clone;
use HTML::AutoTag;
use Math::Matrix;
use Spreadsheet::HTML::File::Loader;

sub portrait    { generate( @_, theta =>   0 ) }
sub landscape   { generate( @_, theta => -270, tgroups => 0 ) }

sub north   { generate( @_, theta =>    0 ) }
sub east    { generate( @_, theta =>   90, tgroups => 0, pinhead => 1 ) }
sub south   { generate( @_, theta => -180, tgroups => 0, pinhead => 1 ) }
sub west    { generate( @_, theta => -270, tgroups => 0 ) }

sub layout {
    generate( @_,
        encodes => '',
        matrix  => 1,
        table   => {
            role => 'presentation',
            ( map {$_ => 0} qw( border cellspacing cellpadding ) ),
        },
        _layout => 1,
    );
}

sub generate {
    my %args = _process( @_ );

    $args{theta} *= -1 if $args{theta} and $args{flip};

    if (!$args{theta}) { # north

        $args{data} = $args{flip} ? [ map [ CORE::reverse @$_ ], @{ $args{data} } ] : $args{data};

    } elsif ($args{theta} == -90) {

        $args{data} = [ CORE::reverse @{ Math::Matrix::transpose( $args{data} ) }];
        $args{data} = ($args{pinhead} and !$args{headless})
            ? [ map [ @$_[1 .. $#$_], $_->[0] ], @{ $args{data} } ]
            : [ map [ CORE::reverse @$_ ], @{ $args{data} } ];

    } elsif ($args{theta} == 90) { # east

        $args{data} = Math::Matrix::transpose( $args{data} );
        $args{data} = ($args{pinhead} and !$args{headless})
            ? [ map [ @$_[1 .. $#$_], $_->[0] ], @{ $args{data} } ]
            : [ map [ CORE::reverse @$_ ], @{ $args{data} } ];

    } elsif ($args{theta} == -180) { # south

        $args{data} = ($args{pinhead} and !$args{headless})
            ? [ @{ $args{data} }[1 .. $#{ $args{data} }], $args{data}[0] ]
            : [ CORE::reverse @{ $args{data} } ];

    } elsif ($args{theta} == 180) {

        $args{data} = ($args{pinhead} and !$args{headless})
            ? [ map [ CORE::reverse @$_ ], @{ $args{data} }[1 .. $#{ $args{data} }], $args{data}[0] ]
            : [ map [ CORE::reverse @$_ ], CORE::reverse @{ $args{data} } ];

    } elsif ($args{theta} == -270) { # west

        $args{data} = [@{ Math::Matrix::transpose( $args{data} ) }];

    } elsif ($args{theta} == 270) {

        $args{data} = [ CORE::reverse @{ Math::Matrix::transpose( $args{data} ) }];
    }

    return _make_table( %args );
}

sub new {
    my $class = shift;
    my %attrs = ref($_[0]) eq 'HASH' ? %{+shift} : @_;
    return bless { %attrs }, $class;
}

sub _process {
    my ($self,$data,$args) = _args( @_ );

    if ($self and $self->{is_cached}) {
        return wantarray ? ( data => $self->{data}, %{ $args || {} } ) : $data;
    }

    my $empty = exists $args->{empty} ? $args->{empty} : '&nbsp;';
    my $max_cols = scalar @{ $data->[0] };

    # headings is an alias for -row0
    $args->{-row0} = delete $args->{headings} if exists $args->{headings};

    # headings to index mapping for -colX
    my %index = ();
    if ($#{ $data->[0] }) {
        %index = map { '-' . $data->[0][$_] || '' => $_ } 0 .. $#{ $data->[0] };
        for (grep /^-/, keys %$args) {
            $args->{"-col$index{$_}" } = delete $args->{$_} if exists $index{$_};
        }
    }

    for my $row (0 .. $#$data) {

        unless ($args->{_layout}) {
            push @{ $data->[$row] }, undef for 1 .. $max_cols - $#{ $data->[$row] } + 1;  # pad
            pop  @{ $data->[$row] } for $max_cols .. $#{ $data->[$row] };                 # truncate
        }

        for my $col (0 .. $#{ $data->[$row] }) {
            my $tag = (!$row and !($args->{headless} or $args->{matrix})) ? 'th' : 'td';
            my ( $val, $attr ) = _expand_code_or_hash( $args->{$tag}, $data->[$row][$col] );
            $args->{$tag} = [ $args->{$tag} ] unless ref( $args->{$tag} ) eq 'ARRAY';

            # -colX
            if (exists $args->{"-col$col"}) {
                ( $val, $attr ) = _expand_code_or_hash( $args->{"-col$col"}, $val );
            }

            # -rowX (overides -colX)
            if (exists $args->{"-row$row"}) {
                my $new_attr;
                ( $val, $new_attr ) = _expand_code_or_hash( $args->{"-row$row"}, $val );
                $attr = $new_attr if ref( $new_attr );
            }
            # --empty
            do{ no warnings; $val =~ s/^\s*$/$empty/g };

            $data->[$row][$col] = { 
                tag => $tag, 
                (defined( $val ) ? (cdata => $val) : ()), 
                (defined( $attr ) ? (attr => $attr) : ()),
            };
        }
    }

    if ($args->{cache} and $self and !$self->{is_cached}) {
        $self->{data} = $data;
        $self->{is_cached} = 1;
    }

    shift @$data if $args->{headless};

    return wantarray ? ( data => $data, %$args ) : $data;
}

sub _make_table {
    my %args = @_;

    for (qw( table tr thead tbody tfoot )) {
        delete $args{$_} unless ref($args{$_}) eq 'HASH';
    }

    my @cdata = ( _caption( %args ), _colgroup( %args ) );

    if ($args{tgroups}) {

        my ($head, @body) = @{ $args{data} };
        my $foot = pop @body if $args{tgroups} > 1 and scalar @{ $args{data} } > 2;

        my $head_row  =     { tag => 'tr', attr => $args{tr}, cdata => $head };
        my $foot_row  =     { tag => 'tr', attr => $args{tr}, cdata => $foot };
        my @body_rows = map { tag => 'tr', attr => $args{tr}, cdata => $_ }, @body;

        push @cdata, (
            { tag => 'thead', attr => $args{thead}, cdata => $head_row },
            ( $foot ? { tag => 'tfoot', attr => $args{tfoot}, cdata => $foot_row } : () ),
            { tag => 'tbody', attr => $args{tbody}, cdata => [@body_rows] }
        );

    } else {
        push @cdata, map { tag => 'tr', attr => $args{tr}, cdata => $_ }, @{ $args{data} };
    }

    my $encodes = exists $args{encodes} ? $args{encodes} : '';
    my $auto = HTML::AutoTag->new( encodes => $encodes, indent => $args{indent}, level => $args{level} );
    return $auto->tag( tag => 'table', attr => $args{table}, cdata => [ @cdata ] );
}

sub _caption {
    my %args = @_;

    my $caption;

    if (ref($args{caption}) eq 'HASH') {
        (my $cdata) = keys %{ $args{caption} };
        (my $attr)  = values %{ $args{caption} };
        $caption = { tag => 'caption', attr => $attr, cdata => $cdata };
    } elsif (defined $args{caption} ) {
        $caption = { tag => 'caption', cdata => $args{caption} };
    } 
    
    return $caption ? $caption : ();
}

sub _colgroup {
    my %args = @_;

    my @colgroup;
    $args{col} = [ $args{col} ] if ref($args{col}) eq 'HASH';

    if (ref($args{col}) eq 'ARRAY') {

        @colgroup = ({
            tag   => 'colgroup',
            attr  => $args{colgroup},
            cdata => [ map { tag => 'col', attr => $_ }, @{ $args{col} } ]
        }); 

    } else {

        $args{colgroup} = [ $args{colgroup} ] if ref($args{colgroup}) eq 'HASH';
        if (ref($args{colgroup}) eq 'ARRAY') {
            @colgroup = map { tag => 'colgroup', attr => $_ }, @{ $args{colgroup} };
        }
    }

    return @colgroup;
}

sub _args {
    my ($self,$data,$args);
    $self = shift if UNIVERSAL::isa( $_[0], __PACKAGE__ );

    if (@_ > 1 && defined($_[0]) && !ref($_[0]) ) {
        $args = {@_};
        $data = delete $args->{data} if exists $args->{data};
    } elsif (@_ > 1 && ref($_[0]) eq 'ARRAY') {
        if (ref($_[0]->[0]) eq 'ARRAY') {
            $data = shift;
        }
        my @args;
        for (@_) {
            if (ref($_) eq 'ARRAY') {
                push @$data, $_;
            } else {
                push @args, $_; 
            }
        }
        $args = {@args};
    } elsif (@_ == 1) {
        $data = $_[0];
    }

    if ($self) {
        return ( $self, $self->{data}, $args ) if $self->{is_cached};
        $args = { %{ $self || {} }, %{ $args || {} } };
        delete $args->{data};
        $data = $self->{data} unless $data or $args->{file};
    }

    $data = _fill_data( $args ) if $args->{fill};
    $data = Spreadsheet::HTML::File::Loader::parse( $args->{file} ) if $args->{file};
    $data = [ $data ] unless ref($data);
    $data = [ $data ] unless ref($data->[0]);
    $data = [ [undef] ] if !scalar @{ $data->[0] };

    return ( $self, Clone::clone($data), $args );
}

sub _fill_data {
    my $args = shift;
    my ($rows,$cols) = $args->{fill} =~ /(\d+)\D+(\d+)/;
    $rows = 1 if $rows < 1;
    $cols = 1 if $cols < 1;
    $args->{matrix} = 1 unless defined $args->{matrix};
    return [ map [ map {''} 1 .. $cols ], 1 .. $rows ];
}

sub _expand_code_or_hash {
    my ( $thingy, $val ) = @_;
    my $attr;
    $thingy = [ $thingy ] unless ref( $thingy ) eq 'ARRAY';
    for (@{ $thingy }) {
        if (ref($_) eq 'CODE') {
            $val = $_->($val);
        } elsif (ref($_) eq 'HASH') {
            $attr = $_;
        }
    }
    return ( $val, $attr );
}

sub transpose   { no warnings; warn "transpose is deprecated, use landscape";       generate( @_, theta => -270, tgroups => 0 ) }
sub earthquake  { no warnings; warn "earthquake is deprecated, use east";           generate( @_, theta =>  90, tgroups => 0 ) }
sub reverse     { no warnings; warn "reverse is deprecated, use south with flip";   generate( @_, theta => 180, tgroups => 0 ) }
sub mirror      { no warnings; warn "mirror is deprecated, use portrait with flip"; generate( @_, theta =>    0, flip => 1 ) }
sub tsunami     { no warnings; warn "tsunami is deprecated, use east with flip";    generate( @_, theta =>  -90, tgroups => 0 ) }
sub flip        { no warnings; warn "flip is deprecated, use south";                generate( @_, theta => -180, tgroups => 0 ) }

sub chessboard {
    my @black = ( '&#9820;', '&#9822;', '&#9821;', '&#9819;', '&#9818;', '&#9821;', '&#9822;', '&#9820;' );
    my @white = ( '&#9814;', '&#9816;', '&#9815;', '&#9813;', '&#9812;', '&#9815;', '&#9816;', '&#9814;' );
    generate( @_,
        -row0 => sub { shift @black },
        -row1 => sub {'&#9823;'},
        -row6 => sub {'&#9817;'},
        -row7 => sub { shift @white },
        table => { width=>'100%'},
        fill  => '8x8',
        td => {
            height => 100,
            width  => 100,
            align  => 'center',
            style  => { 
                'font-size' => 75,
                'background-color' => [ (qw(white gray))x4, (qw(gray white))x4]
            }
        }
    );
}


1;

__END__
=head1 NAME

Spreadsheet::HTML - Generate HTML tables with ease.

=head1 SYNOPSIS

    use Spreadsheet::HTML;

    $data = [ [qw(a1 a2 a3)], [qw(b1 b2 b3)], [qw(c1 c2 c3)] ];

    $table = Spreadsheet::HTML->new( data => $data, indent => "\t" );
    print $table->portrait;
    print $table->landscape;

    # load from files (first table found)
    $table = Spreadsheet::HTML->new( file => 'data.xls', cache => 1 );

    # non OO
    use Spreadsheet::HTML qw( portrait landscape );
    print portrait( $data );
    print landscape( $data );

=head1 DESCRIPTION

Generates HTML4, XHTML and HTML5 tables with ease. Provides a handful of distinctly
named methods to control overall table orientation. These methods
in turn accept a number of distinctly named attributes for directing
what tags and attributes to use.

THIS MODULE IS AN ALPHA RELEASE! Although we are very close to BETA.

=head1 METHODS

All methods (except C<new>) are exportable as functions. With the
exception of C<new>, all methods return HTML as a scalar string and
they accept the same named parameters (see PARAMETERS below).

=over 4

=item * C<new( %args )>

  my $table = Spreadsheet::HTML->new( data => $data );

Constructs object. Accepts the same named parameters as the table
generating functions below:

=item * C<generate( %args )>

  $html = $table->generate( table => {border => 1}, encode => '<>' );
  print Spreadsheet::HTML::generate( data => $data, indent => "\t" );

=item * C<portrait( %args )>

=item * C<north( %args )>

Headers on top. Same as

  generate( theta => 0 )

=item * C<landscape( %args )>

=item * C<west( %args )>

Headers on left. Same as

  generate( theta => -270 )

=item * C<south( %args )>

Headers on bottom. Same as

  generate( theta => -180, pinhead => 1 )

=item * C<east( %args )>

Headers on right. Same as

  generate( theta => 90, pinhead => 1 )

Note that C<tgroups> are not allowed for C<south()> because the table
is inverted horizontally and not allowed for C<west()> and C<east()>
because the table rows contain both headings and cells. You can override
this behavior by using C<generate> with args listed above instead of 
C<south()>, C<east()> or C<west()>.

=item * C<layout( %args )>

Layout tables are not recommended, but if you choose to
use them you should label them as such. This adds W3C
recommended layout attributes to the table tag and features:
emiting only <td> tags, no padding or pruning of rows, forces
no HTML entity encoding in table cells.

=item * C<chessboard( %args )>

Generates a static chess board.

=back

For most cases, C<portrait()> and C<landscape()> are all you need.
Everything else is C<bells_and_whistles>.

=head2 DEPRECATED METHODS

These methods will be removed soon. Using them now will
emit warning messages that inform of alternatives.

=over 4

=item * C<transpose( %args )>

Deprecated: use C<landscape()>

=item * C<earthquake( %args )>

Deprecated: use C<east()>

=item * C<tsunami( %args )>

Deprecated: use C<east( 'flip', 1 )>

=item * C<mirror( %args )>

Deprecated: use C<north( 'flip', 1 )>

=item * C<reverse( %args )>

Deprecated: use C<south( 'flip', 1 )>

=item * C<flip( %args )>

Deprecated: use C<south()>

=back

=head1 PARAMETERS

All methods/procedures accept the same named parameters.
If named parameters are detected: the data has to be
an array ref assigned to the key 'data'. If no
named args are detected then the parameter list is
treated as the data itself, either an array containing
array references or an array reference containing
array references.

=over 4

=item * C<data>

The data to be rendered into table cells. Should be
an array ref of array refs.

  data => [["a".."c"],[1..3],[4..6],[7..9]]

=item * C<file>

The name of the data file to read. Supported formats
are XLS, CSV, JSON, YAML and HTML (first table found).

  file => 'foo.json'

=item * C<fill>

Can be supplied instead of C<data> to generate empty
cells.

  fill => '5x12'

=item * C<theta: 0, 90, 180, 270, -90, -180, -270>

Rotates table clockwise. Default to 0: headers at top.
90: headers at right. 180: headers at bottom.
270: headers at left. To achieve landscape, use -270.

=item * C<flip: 0 or 1>

Flips table horizontally.
Can be used in conjunction with C<theta>.

=item * C<indent>

Render the table with nested indentation. Defaults to
undefined which produces no indentation. Adds newlines
when set to any value that is defined.

  indent => '    '

  indent => "\t"

=item * C<level>

Start indentation at this level. Useful for matching
nesting styles of original HTML text that you may want
to insert into to.

  level => 4

=item * C<encodes>

HTML Encode contents of td tags. Defaults to empty string
which performs no encoding of entities. Pass a string like
'<>&=' to perform encoding on any characters found. If the
value is 'undef' then all unsafe characters will be
encoded as HTML entites.

  encodes => '<>"'

=item * C<empty>

Replace empty cells with this value. Defaults to &nbsp;
Set value to undef to avoid any substitutions.

  empty => '&#160;'

=item * C<tgroups: 0, 1 or 2>

Group table rows into <thead>, <tbody> and <tfoot> sections.

When C<tgroups> is set to 1, the <tfoot> section is
omitted. The last row of the data is found at the end
of the <tbody> section instead. (loose)

When C<tgroups> is set to 2, the <tfoot> section is found
in between the <thead> and <tbody> sections. (strict)

=item * C<cache: 0 or 1>

Preserve data after it has been processed (and loaded).
Useful for loading data from files only once.

=item * C<matrix: 0 or 1>

Treat headings as a regular row. Render the table with
only td tags, no th tags.

=item * C<headless: 0 or 1>

Render the table with without the headings row at all. 

=item * C<pinhead: 0 or 1>

Works in conjunction with C<theta> to produces tables with
headings placed on sides other than the top and perserve
data alignment for reporting readability. Used by C<south()>
and C<east()>.

=item * C<headings>

Apply anonymous subroutine to each cell in headings row.

  headings => sub {join(" ",map{ucfirst lc$_}split"_",shift)}

Or apply hash ref as attributes:

  headings => { class => 'some-class' }

Or both:

  headings => [ sub { uc shift }, { class => "foo" } ]

=item * C<-rowX>

Apply this anonymous subroutine to the entire row X.
(0 index based)

  -row3 => sub { uc shift }

Or apply hash ref as attributes:

  -row3 => { class => 'some-class' }

Or both:

  -row3 => [ sub { uc shift }, { class => "foo" } ]

=item * C<-colX>

Apply this anonymous subroutine to the entire column X.
(0 index based)

  -col4 => sub { sprintf "%02d", shift || 0 }

Or apply hash ref as attributes:

  -col4 => { class => 'some-class' }

Or both:

  -col4 => [ sub { uc shift }, { class => "foo" } ]

You can alias any column number by the value of the heading
name in that column:

  -my_heading3 => sub { "<b>$_[0]"</b>" }

  -my_heading3 => { class => 'special-row' }

  -my_heading3 => [ sub { uc shift }, { class => "foo" } ]

Override headings with either C<headings> or C<th> or indirectly
with <thead> via CSS definitions for a class you assign.

=item * C<caption>

Caption is special in that you can either pass a string to
be used as CDATA or a hash whose only key is the string
to be used as CDATA:

  caption => "Just Another Title"

  caption => { "With Attributes" => { align => "bottom" } }

=item * C<colgroup>

Add colgroup tag(s) to the table. Use an AoH for multiple.

  colgroup => { span => 2, style => { 'background-color' => 'orange' } }

  colgroup => [ { span => 20 }, { span => 1, class => 'end' } ]

=item * C<col>

Add col tag(s) to the table. Use an AoH for multiple. Wraps
tags within a colgroup tag. Same usage as C<colgroup>.

=item * C<table>

=item * C<thead>

=item * C<tfoot>

=item * C<tbody>

=item * C<tr>

Hash ref. Apply these attributes to the specified tag.

  table => { class => 'spreadsheet' }

  tr => { style => { background => [qw( color1 color2 )]' } }

=item * C<th>

=item * C<td>

<th> and <td> can additionally accept sub refs

  th => sub { uc shift }

  td => [ sub { uc shift }, { class => 'foo' } ]

=back

=head1 REQUIRES

=over 4

=item * L<HTML::AutoTag>

Used to generate HTML. Handles indentation and HTML entity encoding.
Uses L<Tie::Hash::Attribute> to handle rotation of class attributes.

=item * L<Math::Matrix>

Used for transposing data from portrait to landscape.

=item * L<Clone>

Useful for preventing data from being clobbered.

=back

=head1 OPTIONAL

Used to load data from various different file formats.

=over 4

=item * L<JSON>

=item * L<YAML>

=item * L<Text::CSV>

=item * L<Text::CSV_XS>

=item * L<HTML::TableExtract>

=item * L<Spreadsheet::ParseExcel>

=back

=head1 SEE ALSO

=over 4

=item * L<DBIx::HTML>

Uses this module (Spreadsheet::HTML) to format SQL query results.

=item * L<DBIx::XHTML_Table>

My original from 2001. Can handle advanced grouping, individual cell
value contol, rotating attributes and totals/subtotals.

=item * L<http://www.w3.org/TR/html5/tabular-data.html>

=item * L<http://en.wikipedia.org/wiki/Rotation_matrix>

=back

=head1 BUGS AND LIMITATIONS

Benchmarks have improved since switching from HTML::Element
to HTML::AutoTag but we are still a C- student at best.
The following benchmark was performed by rendering a
500x500 cell table 20 times:

Before switch to HTML::AutoTag

                     s/iter  S::H  H::E H::AT  H::T D::XT
  Spreadsheet::HTML    8.58    --  -13%  -53%  -66%  -78%
  HTML::Element        7.50   14%    --  -47%  -62%  -74%
  HTML::AutoTag        4.01  114%   87%    --  -28%  -52%
  HTML::Tiny           2.87  198%  161%   39%    --  -33%
  DBIx::XHTML_Table    1.92  347%  291%  109%   50%    --


After switch to HTML::AutoTag

                    s/iter  H::E  S::H H::AT  H::T D::XT
  HTML::Element       7.56    --  -34%  -46%  -60%  -74%
  Spreadsheet::HTML   4.96   53%    --  -17%  -39%  -60%
  HTML::AutoTag       4.12   84%   21%    --  -26%  -52%
  HTML::Tiny          3.05  148%   63%   35%    --  -35%
  DBIx::XHTML_Table   1.99  281%  150%  107%   53%    --

Switching to HTML::Tiny would improve speed but this would
complicate rotating attributes. The suggestion from these
benchmarks is to do it the way DBIx::XHTML_Table does it:
by complete brute force. This does not interest me ...
if 1 second can be shaved off of HTML::AutoTag's time this
would suffice.

Please report any bugs or feature requests to either

=over 4

=item * Email: C<bug-spreadsheet-html at rt.cpan.org>

=item * Web: L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Spreadsheet-HTML>

=back

I will be notified, and then you'll automatically be notified of progress
on your bug as I make changes.

=head1 GITHUB

The Github project is L<https://github.com/jeffa/Spreadsheet-HTML>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Spreadsheet::HTML

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here) L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Spreadsheet-HTML>

=item * AnnoCPAN: Annotated CPAN documentation L<http://annocpan.org/dist/Spreadsheet-HTML>

=item * CPAN Ratings L<http://cpanratings.perl.org/d/Spreadsheet-HTML>

=item * Search CPAN L<http://search.cpan.org/dist/Spreadsheet-HTML/>

=back

=head1 ACKNOWLEDGEMENTS

Thank you very much! :)

=over 4

=item * Neil Bowers

Helped with Makefile.PL suggestions and corrections.

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
