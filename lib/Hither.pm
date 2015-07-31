use strict; use warnings;
package Hither;
our $VERSION = '0.0.2';

use YAML::XS;
use Exporter 'import';

our @EXPORT = qw(
  read_input
  type_to_field
);

sub read_input {
  do {local $/; <>};
}

1;
