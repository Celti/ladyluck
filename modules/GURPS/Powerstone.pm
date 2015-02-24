package Bot::BasicBot::Pluggable::Module::GURPS::Powerstone;

our $VERSION = '1';

use common::sense;
use base qw(Bot::BasicBot::Pluggable::Module);
use Math::SigFigs;

sub help {
	return "Calculates the cost of a power item of a given strength.";
}

sub told {
	my ($self,$message) = @_;
	my $body = $message->{body};
	return unless defined($body);

	my ($command,$arguments) = split(/\s+/, $body, 2);
	return unless lc($command) =~ /^(?:!|\.)pow$/i;
	return "Item strength must be greater than 0." if $arguments < 1;

	my $cost = 10*((54/53)**$arguments)*$arguments*(4+$arguments);
	return "A $arguments-point power item costs \$" . int(FormatSigFigs($cost,2));
}

1;
