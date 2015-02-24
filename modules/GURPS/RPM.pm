package Bot::BasicBot::Pluggable::Module::GURPS::RPM;

our $VERSION = '1';

use common::sense;
use base qw(Bot::BasicBot::Pluggable::Module);

sub help {
	return "Automates the process of casting a Ritual Path Magic spell.";
}

sub told {
	my ($self,$message) = @_;
	my $body = $message->{body};
	return unless defined($body);

	my ($command,$arguments) = split(/\s+/, $body, 2);
	return unless lc($command) =~ /^(?:!|\.)rpm$/i;
	return unless $arguments =~ /^(?:\D*)?((?:(?<=[\s-])-)?\d+).*?((?<=energy[\s-])\d+|\d+(?=[\s-]energy))/i;

	my $base_skill = $1;
	my $target = $2;

	my $energy = 0;
	my $quirks = 0;
	my $time = 0;

	my ($skill, $roll, $margin);

	my $rollnum = 1;

	while ($energy < $target) {
		$skill = $base_skill - int($rollnum/3);
		$roll = int(rand(6))+int(rand(6))+int(rand(6))+3;
		$margin = $skill - $roll;

		if (($roll < 7) and (($roll < 5) or ($skill > 14 and $roll < 6) or ($skill > 15 and $roll < 7))) {
			# Critical success!
			$energy += $margin;
			$time += 1;
		} elsif ($roll > 16 or $margin < -9) {
			if ( $skill > 15 and $roll == 17 ) {
				# Automatic failure.
				$energy += 1;
				$time += 5;
				$quirks += 1;
			} else {
				# Critical failure!
				$time += int(rand(6))+1;
				$energy = $energy > 10 ? $energy*2 : 20;
				return "$message->{who}: Critical failure after $time minutes; $energy energy and $quirks quirk" . ($quirks == 1 ? "" : "s") . ".";
			}
		} elsif ( $margin >= 0 ) {
			# Ordinary success.
			$energy += ($margin > 0 ? $margin : 1);
			$time += 5;
		} else {
			# Ordinary failure.
			$energy += 1;
			$time += 5;
			$quirks += 1;
		}
	} continue {
		$rollnum++;
	}

	return "$message->{who}: Success after $time minutes; $energy energy and $quirks quirk" . ($quirks == 1 ? "" : "s") . ".";
}

1;
