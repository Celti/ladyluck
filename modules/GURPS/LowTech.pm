package Bot::BasicBot::Pluggable::Module::GURPS::LowTech;

our $VERSION = '1';

use common::sense;
use Math::SigFigs;
use base qw(Bot::BasicBot::Pluggable::Module);

sub help {
	return "GURPS module: Calculates the base weight and cost of a container of given material and size. Usage: .bag|.jar <material> <gallons>";
}

sub told {
	my ($self,$message) = @_;
	my $body = $message->{body};
	return unless defined($body);

	my ($command,$arguments) = split(/\s+/, $body, 2);
	return unless lc($command) =~ /^(?:!|\.)(bag|jar)$/i;
	my $container = $1;

	my ($material, $capacity) = split(/\s+/, $arguments, 2);

	my ($cost, $weight);

	for ($material) {
		when (/cloth/i) {
			$material = "Cloth";
			return "Capacity for cloth must be between 0.125 and 120 gallons." if ($capacity < 0.125 or $capacity > 120);
			# Weight: 7.73189×10^-6 x^3-0.00151996 x^2+0.11952 x+0.18862
			# Cost: 0.000020444 x^3-0.00509718 x^2+0.656767 x+1.32118
			$weight = 7.73189*10**-6*$capacity**3-0.00151996*$capacity**2+0.11952*$capacity+0.18862;
			$cost = 0.000020444*$capacity**3-0.00509718*$capacity**2+0.656767*$capacity+1.32118;
		}
		when (/(?:leather|hide)/i) {
			$material = "Leather";
			return "Capacity for cloth must be between 0.125 and 120 gallons." if ($capacity < 0.125 or $capacity > 120);
			# Weight: 0.0000104112 x^3-0.00253537 x^2+0.305796 x+0.342802
			# Cost: 0.0000573876 x^3-0.014376 x^2+1.8071 x+2.1818
			$weight = 0.0000104112*$capacity**3-0.00253537*$capacity**2+0.305796*$capacity+0.342802;
			$cost = 0.0000573876*$capacity**3-0.014376*$capacity**2+1.8071*$capacity+2.1818;
		}
		when (/(?:earth|ceramic|porcelain)/i) {
			$material = "Earthenware";
			return "Capacity for ceramic must be between 0.125 and 20 gallons." if ($capacity < 0.125 or $capacity > 20);
			# Weight: 0.016553 x^3-0.485565 x^2+5.70279 x-0.254892
			# Cost: 0.00967953 x^3-0.296997 x^2+4.12302 x-0.0984435
			$weight = 0.016553*$capacity**3-0.485565*$capacity**2+5.70279*$capacity-0.254892;
			$cost = 0.00967953*$capacity**3-0.296997*$capacity**2+4.12302*$capacity-0.0984435;
		}
		default {
			return "You must specify a material (cloth, leather, or ceramic)."
		}
	}

	return sprintf('%s %s, %g gal.: $%g, %g lbs.', $material, $container, FormatSigFigs($capacity, 2), FormatSigFigs($cost, 2), FormatSigFigs($weight, 2));
}

1;
