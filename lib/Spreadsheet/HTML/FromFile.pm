package Spreadsheet::HTML::YAML;
=head1 NAME

Spreadsheet::HTML::YAML - Load data from YAML encoded data files.

=head1 METHODS

=over 4

=item * C<load()>

=back

=head1 REQUIRES

=over 4

=item * L<YAML>

=back

=cut

use Carp;
use strict;
use warnings FATAL => 'all';

eval "use YAML";
our $NOT_AVAILABLE = $@;

sub load {
    my $file = shift;
    return [[ "cannot load $file" ],[ 'please install YAML' ]] if $NOT_AVAILABLE;

    my $data = YAML::LoadFile( $file );
    return $data;
}

1;



package Spreadsheet::HTML::JSON;
=head1 NAME

Spreadsheet::HTML::JSON - Load data from JSON encoded data files.

=head1 METHODS

=over 4

=item * C<load()>

=back

=head1 REQUIRES

=over 4

=item * L<JSON>

=back

=cut

use Carp;
use strict;
use warnings FATAL => 'all';

eval "use JSON";
our $NOT_AVAILABLE = $@;

sub load {
    my $file = shift;
    return [[ "cannot load $file" ],[ 'please install JSON' ]] if $NOT_AVAILABLE;

    open my $fh, '<', $file or croak "Cannot read $file: $!\n";
    my $data = decode_json( do{ local $/; <$fh> } );
    close $fh;
    return $data;
}

1;



package Spreadsheet::HTML::CSV;
=head1 NAME

Spreadsheet::HTML::CSV - Load data from comma seperated value files.

=head1 METHODS

=over 4

=item * C<load()>

=back

=head1 REQUIRES

=over 4

=item * either L<Text::CSV_XS>

=item * or L<Text::CSV>

=back

=cut

use Carp;
use strict;
use warnings FATAL => 'all';

our $PARSER = '';
eval "use Text::CSV_XS";
if ($@) {
    eval "use Text::CSV";
    $PARSER = 'Text::CSV' unless $@;
} else {
    $PARSER = 'Text::CSV_XS';
}

sub load {
    my @data;
    my $file = shift;

    open my $fh, '<', $file or croak "Cannot read $file: $!\n";

    if ($PARSER) {
        my $csv = $PARSER->new;
        while (my $row = $csv->getline( $fh )) {
            push @data, $row;
        }

    } else {

        while (<$fh>) {
            chomp;
            push @data, [ split /\s*,\s*/, $_ ];
        }
    }

    close $fh;
    return [ @data ];
}

1;



package Spreadsheet::HTML::HTML;
=head1 NAME

Spreadsheet::HTML::HTML - Load data from Hypertext Markup files.

=head1 METHODS

=over 4

=item * C<load()>

=back

=head1 REQUIRES

=over 4

=item * L<HTML::TableExtract>

=back

=cut

use Carp;
use strict;
use warnings FATAL => 'all';

eval "use HTML::TableExtract";
our $NOT_AVAILABLE = $@;

sub load {
    my $file = shift;
    return [[ "cannot load $file" ],[ 'please install HTML::TableExtract' ]] if $NOT_AVAILABLE;

    my @data;
    my $extract = HTML::TableExtract->new( keep_headers => 1 );
    $extract->parse_file( $file );
    return [ $extract->tables ? $extract->rows : [undef] ];
}

1;



package Spreadsheet::HTML::XLS;
=head1 NAME

Spreadsheet::HTML::XLS - Load data from Excel files.

=head1 METHODS

=over 4

=item * C<load()>

=back

=head1 REQUIRES

=over 4

=item * L<Spreadsheet::ParseExcel>

=back

=cut

use Carp;
use strict;
use warnings FATAL => 'all';

eval "use Spreadsheet::ParseExcel";
our $NOT_AVAILABLE = $@;

sub load {
    my $file = shift;
    return [[ "cannot load $file" ],[ 'please install Spreadsheet::ParseExcel' ]] if $NOT_AVAILABLE;

    my $parser   = Spreadsheet::ParseExcel->new;
    my $workbook = $parser->parse( $file );
    return [[ "cannot load $file" ],[ $parser->error ]] unless defined $workbook;

    # can only handle first worksheet found for now
    my ($worksheet) = $workbook->worksheets;
    my ( $row_min, $row_max ) = $worksheet->row_range;
    my ( $col_min, $col_max ) = $worksheet->col_range;
     
    my @data;
    for my $row ( $row_min .. $row_max ) {
        my @row;
        for my $col ( $col_min .. $col_max ) {
            my $cell = $worksheet->get_cell( $row, $col );
            next unless $cell;
            push @row, $cell ? $cell->unformatted : undef;
        }
        push @data, [@row];
    }

    return [ @data ];
}

1;



package Spreadsheet::HTML::FromFile;
=head1 NAME

Spreadsheet::HTML::FromFile - Load data from files.

=head1 METHODS

=over 4

=item * load()

=back

=cut

use Carp;
use strict;
use warnings FATAL => 'all';

sub load {
    my $file = shift;

    if ($file =~ /\.csv$/) {
        return Spreadsheet::HTML::CSV::load( $file );
    } elsif ($file =~ /\.html?$/) {
        return Spreadsheet::HTML::HTML::load( $file );
    } elsif ($file =~ /\.jso?n$/) {
        return Spreadsheet::HTML::JSON::load( $file );
    } elsif ($file =~ /\.ya?ml$/) {
        return Spreadsheet::HTML::YAML::load( $file );
    } elsif ($file =~ /\.xls$/) {
        return Spreadsheet::HTML::XLS::load( $file );
    }
}

1;
