package Bot::BasicBot::Pluggable::Module::GURPS::Range;

our $VERSION = '1';

use common::sense;
use base qw(Bot::BasicBot::Pluggable::Module);
use Math::Calc::Units qw(convert);

sub help {
	return "GURPS module: Calculates the range penalty or size modifier for a given measurement.";
}

sub told {
	my ($self,$message) = @_;
	my $body = $message->{body};
	return unless defined($body);

	my ($command,$arguments) = split(/\s+/, $body, 2);
	return unless lc($command) =~ /^(?:!|\.)(sm|range)$/i;

	$command = $1;

	$arguments .= " yards" if $arguments =~ /\d+\s*$/;
	my ($yards, undef) = convert($arguments, "yards", "exact");
	
	my $modifier = int(6*(log($yards)/log(10))-1.5);
	
	return "$arguments = SM" . ($modifier >= 0 ? "+" : "") . $modifier if $command eq 'sm';
	return "$arguments = range penalty " . ($modifier >= 0 ? "" : "+") . $modifier*-1 if $command eq 'range';
}

1;
