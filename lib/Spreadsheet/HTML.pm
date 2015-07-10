package Spreadsheet::HTML;
use strict;
use warnings FATAL => 'all';
our $VERSION = '0.36';

use Exporter 'import';
our @EXPORT_OK = qw(
    generate portrait landscape
    north east south west handson
    layout checkerboard animate
    chess checkers conway sudoku
    calculator dk shroom
    calendar banner maze
);

use Clone;
use HTML::AutoTag;
use Math::Matrix;

use Spreadsheet::HTML::Presets;
use Spreadsheet::HTML::File::Loader;

sub portrait    { generate( @_, theta =>   0 ) }
sub landscape   { generate( @_, theta => -270, tgroups => 0 ) }

sub north   { generate( @_, theta =>    0 ) }
sub east    { generate( @_, theta =>   90, tgroups => 0, pinhead => 1 ) }
sub south   { generate( @_, theta => -180, tgroups => 0, pinhead => 1 ) }
sub west    { generate( @_, theta => -270, tgroups => 0 ) }

sub layout          { Spreadsheet::HTML::Presets::layout(           @_ ) }
sub handson         { Spreadsheet::HTML::Presets::Handson::handson( @_ ) }
sub conway          { Spreadsheet::HTML::Presets::Conway::conway(   @_ ) }
sub calculator      { Spreadsheet::HTML::Presets::Calculator::calculator( @_ ) }
sub chess           { Spreadsheet::HTML::Presets::chess(            @_ ) }
sub checkers        { Spreadsheet::HTML::Presets::checkers(         @_ ) }
sub sudoku          { Spreadsheet::HTML::Presets::Sudoku::sudoku(   @_ ) }
sub checkerboard    { Spreadsheet::HTML::Presets::checkerboard(     @_ ) }
sub calendar        { Spreadsheet::HTML::Presets::calendar(         @_ ) }
sub animate         { Spreadsheet::HTML::Presets::Animate::animate( @_ ) }
sub maze            { Spreadsheet::HTML::Presets::maze(             @_ ) }
sub banner          { Spreadsheet::HTML::Presets::banner(           @_ ) }
sub dk              { Spreadsheet::HTML::Presets::dk(               @_ ) }
sub shroom          { Spreadsheet::HTML::Presets::shroom(           @_ ) }

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

    if ($args{animate}) {
        my ($js, %new_args) = Spreadsheet::HTML::Presets::Animate::animate(
            %args,
            data => [ map [ map $_->{cdata}, @$_ ], @{ $args{data} } ],
        );
        for (keys %args) {
            if (ref $args{$_} eq 'HASH') {
                $new_args{$_} = { %{ $new_args{$_} || {} }, %{ $args{$_} || {} } };
            }
        }
        return $js . _make_table( _process( %new_args ) );
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

    # headings is an alias for -r0
    $args->{-r0} = delete $args->{headings} if exists $args->{headings};

    # headings to index mapping (alias for some -cX)
    my %index = ();
    if ($#{ $data->[0] }) {
        %index = map { '-' . ($data->[0][$_] || '') => $_ } 0 .. $#{ $data->[0] };
        for (grep /^-/, keys %$args) {
            $args->{"-c$index{$_}" } = delete $args->{$_} if exists $index{$_};
        }
    }

    my $empty = exists $args->{empty} ? $args->{empty} : '&nbsp;';

    for my $row (0 .. $args->{_max_rows} - 1) {

        unless ($args->{_layout}) {
            push @{ $data->[$row] }, undef for 1 .. $args->{_max_cols} - $#{ $data->[$row] } + 1;  # pad
            pop  @{ $data->[$row] } for $args->{_max_cols} .. $#{ $data->[$row] };                 # truncate
        }

        my $tag = (!$row and !($args->{headless} or $args->{matrix})) ? 'th' : 'td';
        for my $col (0 .. $#{ $data->[$row] }) {

            my ( $cdata, $attr ) = ( $data->[$row][$col], undef );
            for ($tag, "-c$col", "-r$row", "-r${row}c${col}") {
                next unless exists $args->{$_};
                ( $cdata, $attr ) = _expand_code_or_hash( $cdata, $attr, $args->{$_} );
            }

            do{ no warnings; $cdata =~ s/^\s*$/$empty/g };

            $data->[$row][$col] = { 
                tag => $tag, 
                (defined( $cdata ) ? (cdata => $cdata) : ()), 
                (keys( %$attr )    ? (attr => $attr)   : ()),
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

        my @body = @{ $args{data} };
        my $head = shift @body unless $args{matrix} and scalar @{ $args{data} } > 2;
        my $foot = pop @body if !$args{matrix} and $args{tgroups} > 1 and scalar @{ $args{data} } > 2;

        my $head_row  = { tag => 'tr', attr => $args{tr}, cdata => $head };
        my $foot_row  = { tag => 'tr', attr => $args{tr}, cdata => $foot };
        my $body_rows = [ map { tag => 'tr', attr => $args{tr}, cdata => $_ }, @body ];

        if (int($args{group} || 0) > 1) {
            $body_rows = [
                map [ @$body_rows[$_ .. $_ + $args{group} - 1] ],
                _range( 0, $#$body_rows, $args{group} )
            ];
            pop @{ $body_rows->[-1] } while !defined $body_rows->[-1][-1];
        } else {
            $body_rows = [ $body_rows ];
        }

        push @cdata, (
            ( $head ? { tag => 'thead', attr => $args{thead}, cdata => $head_row } : () ),
            ( $foot ? { tag => 'tfoot', attr => $args{tfoot}, cdata => $foot_row } : () ),
            ( map { tag => 'tbody', attr => $args{tbody}, cdata => [ @$_ ] }, @$body_rows ),
        );


    } else {
        push @cdata, map { tag => 'tr', attr => $args{tr}, cdata => $_ }, @{ $args{data} };
    }

    return $args{auto}->tag( tag => 'table', attr => $args{table}, cdata => [ @cdata ] );
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

        if (ref $args{colgroup} eq 'ARRAY') {
            @colgroup = map {
                tag   => 'colgroup',
                attr  => $_,
                cdata => [ map { tag => 'col', attr => $_ }, @{ $args{col} } ]
            }, @{ $args{colgroup} }; 
        } else {
            @colgroup = {
                tag   => 'colgroup',
                attr  => $args{colgroup},
                cdata => [ map { tag => 'col', attr => $_ }, @{ $args{col} } ]
            }; 
        }

    } else {

        $args{colgroup} = [ $args{colgroup} ] if ref($args{colgroup}) eq 'HASH';
        if (ref $args{colgroup} eq 'ARRAY') {
            @colgroup = map { tag => 'colgroup', attr => $_ }, @{ $args{colgroup} };
        }
    }

    return @colgroup;
}

sub _args {
    my ($self,@data,$data,@args,$args);
    $self = shift if UNIVERSAL::isa( $_[0], __PACKAGE__ );
    $data = shift if (@_ == 1);

    while (@_) {
        if (ref( $_[0] )) {
            push @data, shift;
            if (ref( $_[0] )) {
                push @data, shift;
            } elsif (defined $_[0]) {
                push @args, shift, shift;
            }
        } else {
            push @args, shift, shift;
        }
    }

    $data ||= (@data == 1) ? $data[0] : (@data) ? [ @data ] : undef;
    $args = scalar @args ? { @args } : {};
    $data = delete $args->{data} if exists $args->{data};

    my $encodes = exists $args->{encodes} ? $args->{encodes} : '';
    $args->{auto} = HTML::AutoTag->new( encodes => $encodes, indent => $args->{indent}, level => $args->{level} );

    if ($self) {
        return ( $self, $self->{data}, $args ) if $self->{is_cached};
        $args = { %{ $self || {} }, %{ $args || {} } };
        delete $args->{data};
        $data = $self->{data} unless $data or $args->{file};
    }

    $data = Spreadsheet::HTML::File::Loader::parse( $args ) if $args->{file};
    $data = [ $data ] unless ref($data);
    $data = [ $data ] unless ref($data->[0]);

    if ($args->{wrap} and defined $data->[0][0]) {
        my @flat = map @$_, @$data;
        $data = [
            map [ @flat[$_ .. $_ + $args->{wrap} - 1] ],
            _range( 0, $#flat, $args->{wrap} )
        ];
    }

    $args->{_max_rows} = scalar @{ $data }      || 1;
    $args->{_max_cols} = scalar @{ $data->[0] } || 1;

    my %fill;
    if ($args->{fill}) {
        ($fill{row},$fill{col}) = split /\D/, $args->{fill};
        $args->{_max_rows} = $fill{row} if (int($fill{row} || 0)) > ($args->{_max_rows});
        $args->{_max_cols} = $fill{col} if (int($fill{col} || 0)) > ($args->{_max_cols});
    }

    return ( $self, Clone::clone($data), $args );
}

sub _expand_code_or_hash {
    my ( $cdata, $attr, $thingy ) = @_;
    my $new_attr;
    $thingy = [ $thingy ] unless ref( $thingy ) eq 'ARRAY';
    for (@{ $thingy }) {
        if (ref($_) eq 'CODE') {
            $cdata = $_->($cdata);
        } elsif (ref($_) eq 'HASH') {
            $new_attr = $_;
        }
    }
    $attr = { %{ $attr || {} }, %{ $new_attr || {} } };
    return ( $cdata, $attr );
}

sub _range {grep!(($_-$_[0])%($_[2]||1)),$_[0]..$_[1]}


1;

__END__
=head1 NAME

Spreadsheet::HTML - Just another HTML table generator.

=head1 SYNOPSIS

    use Spreadsheet::HTML;

    $data = [ [qw(a1 a2 a3)], [qw(b1 b2 b3)], [qw(c1 c2 c3)] ];

    $generator = Spreadsheet::HTML->new( data => $data, indent => "\t" );
    print $generator->portrait;
    print $generator->landscape( encodes => '<>' );

    # load from files (first table found)
    $generator = Spreadsheet::HTML->new( file => 'data.xls', cache => 1 );
    print $generator->generate( preserve => 1 );

Procedural interface:

    use Spreadsheet::HTML qw( portrait landscape );

    print portrait( $data, td => sub { sprintf "%02d", shift } );
    print landscape( $data, tr => { class => [qw(odd even)] } );

=head1 DESCRIPTION

Generate HTML tables with ease (HTML4, XHTML and HTML5). Provides a handful
of distinctly named methods to control overall table orientation.
These methods in turn accept a number of distinctly named attributes
for directing what tags and attributes to use.

THIS MODULE IS AN ALPHA RELEASE! Although we are very close to BETA.

=head1 METHODS

All methods (except C<new>) are exportable as functions. They all
accept the same named parameters (see PARAMETERS below).  With the
exception of C<new>, all methods return an HTML table as a scalar string.

=over 4

=item * C<new( %params )>

  my $generator = Spreadsheet::HTML->new( data => $data );

Constructs object. Accepts the same named parameters as the table
generating methods below:

=item * C<generate( %params )>

=item * C<portrait( %params )>

=item * C<north( %params )>

These three methods all generate an HTML table with its headings positioned at the top.

=for html
<table style="border: 1px dashed #A0A0A0"><tr><td><b>&nbsp;&nbsp;heading1&nbsp;&nbsp;</b></td><td><b>&nbsp;&nbsp;heading2&nbsp;&nbsp;</b></td><td><b>&nbsp;&nbsp;heading3&nbsp;&nbsp;</b></td><td><b>&nbsp;&nbsp;heading4&nbsp;&nbsp;</b></td></tr><tr><td>&nbsp;&nbsp;row1col1&nbsp;&nbsp;</td><td>&nbsp;&nbsp;row1col2&nbsp;&nbsp;</td><td>&nbsp;&nbsp;row1col3&nbsp;&nbsp;</td><td>&nbsp;&nbsp;row1col4&nbsp;&nbsp;</td></tr><tr><td>&nbsp;&nbsp;row2col1&nbsp;&nbsp;</td><td>&nbsp;&nbsp;row2col2&nbsp;&nbsp;</td><td>&nbsp;&nbsp;row2col3&nbsp;&nbsp;</td><td>&nbsp;&nbsp;row2col4&nbsp;&nbsp;</td></tr><tr><td>&nbsp;&nbsp;row3col1&nbsp;&nbsp;</td><td>&nbsp;&nbsp;row3col2&nbsp;&nbsp;</td><td>&nbsp;&nbsp;row3col3&nbsp;&nbsp;</td><td>&nbsp;&nbsp;row3col4&nbsp;&nbsp;</td></tr></table>

  print $generator->generate();
  print $generator->portrait();
  print $generator->north();

=item * C<landscape( %params )>

=item * C<west( %params )>

These two methods generate an HTML table with its headings positioned at the left.

=for html
<table style="border: 1px dashed #A0A0A0"><tr><td><b>&nbsp;&nbsp;heading1&nbsp;&nbsp;</b></td><td>&nbsp;&nbsp;row1col1&nbsp;&nbsp;</td><td>&nbsp;&nbsp;row2col1&nbsp;&nbsp;</td><td>&nbsp;&nbsp;row3col1&nbsp;&nbsp;</td></tr><tr><td><b>&nbsp;&nbsp;heading2&nbsp;&nbsp;</b></td><td>&nbsp;&nbsp;row1col2&nbsp;&nbsp;</td><td>&nbsp;&nbsp;row2col2&nbsp;&nbsp;</td><td>&nbsp;&nbsp;row3col2&nbsp;&nbsp;</td></tr><tr><td><b>&nbsp;&nbsp;heading3&nbsp;&nbsp;</b></td><td>&nbsp;&nbsp;row1col3&nbsp;&nbsp;</td><td>&nbsp;&nbsp;row2col3&nbsp;&nbsp;</td><td>&nbsp;&nbsp;row3col3&nbsp;&nbsp;</td></tr><tr><td><b>&nbsp;&nbsp;heading4&nbsp;&nbsp;</b></td><td>&nbsp;&nbsp;row1col4&nbsp;&nbsp;</td><td>&nbsp;&nbsp;row2col4&nbsp;&nbsp;</td><td>&nbsp;&nbsp;row3col4&nbsp;&nbsp;</td></tr></table>

  print $generator->landscape();
  print $generator->west();

=item * C<south( %params )>

This method generates an HTML table with its headings positioned at the bottom.

=for html
<table style="border: 1px dashed #A0A0A0"><tr><td>&nbsp;&nbsp;row1col1&nbsp;&nbsp;</td><td>&nbsp;&nbsp;row1col2&nbsp;&nbsp;</td><td>&nbsp;&nbsp;row1col3&nbsp;&nbsp;</td><td>&nbsp;&nbsp;row1col4&nbsp;&nbsp;</td></tr><tr><td>&nbsp;&nbsp;row2col1&nbsp;&nbsp;</td><td>&nbsp;&nbsp;row2col2&nbsp;&nbsp;</td><td>&nbsp;&nbsp;row2col3&nbsp;&nbsp;</td><td>&nbsp;&nbsp;row2col4&nbsp;&nbsp;</td></tr><tr><td>&nbsp;&nbsp;row3col1&nbsp;&nbsp;</td><td>&nbsp;&nbsp;row3col2&nbsp;&nbsp;</td><td>&nbsp;&nbsp;row3col3&nbsp;&nbsp;</td><td>&nbsp;&nbsp;row3col4&nbsp;&nbsp;</td></tr><tr><td><b>&nbsp;&nbsp;heading1&nbsp;&nbsp;</b></td><td><b>&nbsp;&nbsp;heading2&nbsp;&nbsp;</b></td><td><b>&nbsp;&nbsp;heading3&nbsp;&nbsp;</b></td><td><b>&nbsp;&nbsp;heading4&nbsp;&nbsp;</b></td></tr></table>

  print $generator->south();

=item * C<east( %params )>

This method generates an HTML table with its headings positioned at the right.

=for html
<table style="border: 1px dashed #A0A0A0"><tr><td>&nbsp;&nbsp;row1col1&nbsp;&nbsp;</td><td>&nbsp;&nbsp;row2col1&nbsp;&nbsp;</td><td>&nbsp;&nbsp;row3col1&nbsp;&nbsp;</td><td><b>&nbsp;&nbsp;heading1&nbsp;&nbsp;</b></td></tr><tr><td>&nbsp;&nbsp;row1col2&nbsp;&nbsp;</td><td>&nbsp;&nbsp;row2col2&nbsp;&nbsp;</td><td>&nbsp;&nbsp;row3col2&nbsp;&nbsp;</td><td><b>&nbsp;&nbsp;heading2&nbsp;&nbsp;</b></td></tr><tr><td>&nbsp;&nbsp;row1col3&nbsp;&nbsp;</td><td>&nbsp;&nbsp;row2col3&nbsp;&nbsp;</td><td>&nbsp;&nbsp;row3col3&nbsp;&nbsp;</td><td><b>&nbsp;&nbsp;heading3&nbsp;&nbsp;</b></td></tr><tr><td>&nbsp;&nbsp;row1col4&nbsp;&nbsp;</td><td>&nbsp;&nbsp;row2col4&nbsp;&nbsp;</td><td>&nbsp;&nbsp;row3col4&nbsp;&nbsp;</td><td><b>&nbsp;&nbsp;heading4&nbsp;&nbsp;</b></td></tr></table>

  print $generator->east();

=back

For most cases, C<portrait> and C<landscape> are all you need.

=head1 PARAMETERS

All methods/procedures accept the same named parameters.
You do not have to specify C<data>, any bare array references
will be collected and assigned to C<data>.

=head2 LITERAL PARAMETERS

Literal parameters provides the means to modify the macro
aspects of the table, such as indentation, encoding, data
source and table orientation.

=over 4

=item * C<data>

The data to be rendered into table cells. Should be
an array ref of array refs.

  data => [["a".."c"],[1..3],[4..6],[7..9]]

=item * C<file>

The name of the data file to read. Supported formats
are XLS, CSV, JSON, YAML and HTML (first table found).

  file => 'foo.json'

If you want to filter your database queries then install
L<DBIx::HTML> which uses this module as its generator.

  use DBIx::HTML;
  my $generator = DBIx::HTML->connect( @db_credentials );
  $generator->do( $query, @bind_args );
  print $table->portrait( %params );

=item * C<preserve>

Can be supplied in addition to C<file>. Attempts to copy
over all formatting styles from original document to table.
Styles are not currently deduped, so use with care as the
final output will contain a lot of redundant cell styles.
Work is being done to alleviate this.

  file => 'foo.xls', preserve => 1

=item * C<fill>

Can be supplied instead of C<data> to generate empty
cells, or in conjunction with C<data> to pad existing
cells (currently only pads the right and bottom sides.)

  fill => '5x12'

=item * C<wrap>

Can be supplied in conjunction with a 1D C<data> to
automatically wrap into a 2D array matrix. Can also
"rewrap" existed 2D array matrices, but at the expense
of likely mangling the headings.

  wrap => 10 

=item * C<theta: 0, 90, 180, 270, -90, -180, -270>

Rotates table clockwise for positive values and 
counter-clockwise for negative values. Default to 0:
headers at top.  90: headers at right. 180: headers at bottom.
270: headers at left. To achieve landscape, use -270.

=item * C<flip: 0 or 1>

Flips table horizontally from the perspective of the headings
"row" by negating the value of C<theta>.

=item * C<pinhead: 0 or 1>

Works in conjunction with C<theta> to ensure reporting
readability. Without it, C<south()> and C<east()> would
have data cells arranged in reverse order.

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

HTML Encode contents of <tr> and/or <td> tags. Defaults to
empty string which performs no encoding of entities. Pass
a string like '<>&=' to perform encoding on any characters
found.  If the value is C<undef> then all unsafe characters
will be encoded as HTML entites. Uses L<HTML::Entities>.

  encodes => '<>"'

=item * C<empty>

Replace empty cells with this value. Defaults to C<&nbsp;>.
Set value to C<undef> to avoid any substitutions.

  empty => '&#160;'

=item * C<tgroups: 0, 1 or 2>

Group table rows into <thead>, <tbody> and <tfoot> sections.

When C<tgroups> is set to 1, the <tfoot> section is
omitted. The last row of the data is found at the end
of the <tbody> section instead. (loose)

When C<tgroups> is set to 2, the <tfoot> section is found
in between the <thead> and <tbody> sections. (strict)

=item * C<group>

Will chunk body rows into tbody groups of size C<group>.

  group => 4

Currently only accepts integers although it should be possilbe
to group by changes in a column in the future.

=item * C<cache: 0 or 1>

Preserve data after it has been processed (and loaded).
Useful for loading data from files only once.

=item * C<matrix: 0 or 1>

Treat headings as a regular row. Render the table with
only td tags, no th tags.

=item * C<headless: 0 or 1>

Render the table with without the headings row at all. 
The first row after the headings is still C<-r1>, thus
any reference to C<headings> will be discarded too.

=item * C<headings>

Apply callback subroutine to each cell in headings row.

  headings => sub { join(" ", map {ucfirst lc $_} split "_", shift) }

Or apply hash ref as attributes:

  headings => { class => 'some-class' }

Or both:

  headings => [ sub { uc shift }, { class => "foo" } ]

Since C<headings> is a natural alias for the dynamic parameter
C<-r0>, it could be considered as a dynamic parameter. Be
careful not to prepend a dash to C<headings> ... only dynamic
parameters use leading dashes.

=back

=head2 DYNAMIC PARAMETERS

Dynamic parameters provide a means to control the micro
elements of the table, such as modifying headings by their
name and rows and columns by their indices (X). They contain
leading dashes to seperate them from literal and tag parameters.

=over 4

=item * C<-rX>

Apply this callback subroutine to all cells in row X.
(0 index based)

  -r3 => sub { uc shift }

Or apply hash ref as attributes:

  -r3 => { class => 'some-class' }

Or both:

  -r3 => [ sub { uc shift }, { class => "foo" } ]

=item * C<-cX>

Apply this callback to all cells in column X.
(0 index based)

  -c4 => sub { sprintf "%02d", shift || 0 }

Or apply hash ref as attributes:

  -c4 => { class => 'some-class' }

Or both:

  -c4 => [ sub { uc shift }, { class => "foo" } ]

You can alias any column number by the value of the heading
name in that column:

  -occupation => sub { "<b>$_[0]"</b>" }

  -salary => { class => 'special-row' }

  -employee_no => [ sub { sprintf "%08d", shift }, { class => "foo" } ]

=item * C<-rXcX>

Apply this callback or hash ref of attributres
to the cell at row X and column X. (0 index based)

  -r3c4 => { class => 'special-cell' }

=back

=head2 TAG PARAMETERS

Tag parameters provide a means to control the attributes
of the table's tags, and in the case of <th> and <td> the
contents via callback subroutines. Although similar in form,
they are differentiated from litertal parameters because they
share the names of the actual HTML table tags.

=over 4

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

<th> and <td> are the only Tag Parameters that may
additionally accept callback subroutines.

  th => sub { uc shift }

  td => [ sub { uc shift }, { class => 'foo' } ]

=item * C<caption>

Caption is special in that you can either pass a string to
be used as CDATA or a hash whose only key is the string
to be used as CDATA.

  caption => "Just Another Title"

  caption => { "A Title With Attributes" => { align => "bottom" } }

=item * C<colgroup>

Add colgroup tag(s) to the table. Use an AoH for multiple.

  colgroup => { span => 2, style => { 'background-color' => 'orange' } }

  colgroup => [ { span => 20 }, { span => 1, class => 'end' } ]

=item * C<col>

Add col tag(s) to the table. Use an AoH for multiple. Wraps
tags within a colgroup tag. Same usage as C<colgroup>.

  col => { span => 2, style => { 'background-color' => 'orange' } }

  col => [ { span => 20 }, { span => 1, class => 'end' } ]

=back

=head2 PRESETS

The following presets are availble for creating tables that can be used
with little to no additional coding.

=over 4

=item * C<layout( %params )>

=item * C<handson( handsonjs, jquery, css, %params )>

=item * C<conway( on, off, fade, jquery, %params )>

=item * C<calculator( jquery, %params )>

=item * C<calendar( month, year, %params )>

=item * C<checkerboard( colors, %params )>

=item * C<animate( fgdirection, bgdirection, jquery, %params )>

=item * C<banner( on, off, text, font, %params )>

=item * C<maze( on, off, fill, %params )>

=item * C<sudoku( blanks, attempts, %params )>

=item * C<chess( %params )>

=item * C<checkers( %params )>

=item * C<dk( %params )>

=item * C<shroom( %params )>

=back

See L<Spreadsheet::HTML::Presets> for more documentation (and the source
for more usage examples).

=head1 REQUIRES

=over 4

=item * L<HTML::AutoTag>

Used to generate HTML. Handles indentation and HTML entity encoding.
Uses L<Tie::Hash::Attribute> to handle rotation of class attributes
and L<HTML::Entities> for encoding of CDATA.

=item * L<Math::Matrix>

Used for transposing data from portrait to landscape.

=item * L<Clone>

Useful for preventing data from being clobbered.

=back

=head1 OPTIONAL

The following are used to load data from various
different file formats:

=over 4

=item * L<JSON>

=item * L<YAML>

=item * L<Text::CSV>

=item * L<Text::CSV_XS>

=item * L<HTML::TableExtract>

=item * L<Spreadsheet::ParseExcel>

=back

The following are used by some presets to enhance
their output, if installed:

=over 4

=item * L<JavaScript::Minifier>

=item * L<Color::Spectrum>

=item * L<Color::Library>

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
