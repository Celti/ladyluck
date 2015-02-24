package Bot::BasicBot::Pluggable::Module::GURPS::Supervalue;

our $VERSION = '1';

use common::sense;
use base qw(Bot::BasicBot::Pluggable::Module);
use Math::SigFigs;

sub help {
	return "GURPS module: Calculates the supervalue (inverse of size/speed/range modifier) for a given value.";
}

sub told {
	my ($self,$message) = @_;
	my $body = $message->{body};
	return unless defined($body);

	my ($command,$arguments) = split(/\s+/, $body, 2);
	return unless lc($command) =~ /^(?:!|\.)super$/i;

	my $super = 10**(($arguments+2)/6);
	my $round = ($arguments+1)%6?1:2;
	return "The supervalue for $arguments is " . FormatSigFigs($super,$round);
}

1;
