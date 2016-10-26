package Bot::BasicBot::Pluggable::Module::GURPS::RPM;

our $VERSION = '5';

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

	return unless $command =~ /^(?:!|\.)(rs|rpm)$/i;
	my $system = $1;

	return unless $arguments =~ /
		^(?:.+:\s+)?                # Ritual:      Optionally, any text followed by a colon and whitespace.
		[\w\s]+ (?:\s|-)            # Skill:       Any words, separated by spaces, ending in either a space or a dash.
		( -? \d+ )                  # Level():     Any integer, positive or negative.
		,? \s+                      # separator:   A comma and-or whitespace.
		(\d+) \s+ energy            # Energy():    A positive number followed by whitespace and the word 'energy'.
		(?:                         # Start non-capturing group.
			,? \s+                   # separator:   A comma and-or whitespace.
			([0-3]) \s+ rerolls      # Criticals(): A positive number followed by whitespace and the word 'rerolls'
		)?                          # End non-capturing group (optional).
		/xi;

	my $base_skill    = $1;
	my $target_energy = $2;
	my $criticals     = $3;

	my $energy  = 0;
	my $quirks  = 0;
	my $time    = 0;

	my $roll_number = 1;
	my $reroll      = 0;

	my ($skill, $roll, $margin);
	my ($time_increment, $roll_increment);

	given ($system) {
		when (/^rpm$/) { $time_increment =  5; $roll_increment = 3; }
		when (/^rs$/)  { $time_increment = 10; $roll_increment = 5; }
		default { return "You tried to cast a Ritual Path Magic spell without indicating the type. That's bad juju!"; }
	}

	ATTEMPT: while ($energy < $target_energy) {
		$skill = $base_skill - int($roll_number/$roll_increment);
		$roll = int(rand(6))+int(rand(6))+int(rand(6))+3;
		$margin = $skill - $roll;

		if ( ($roll < 10)
			and ( ($roll <  5)
				or ($roll <  6 and $skill > 14)
				or ($roll <  7 and $skill > 15)
				or ($roll <  8 and $skill > 16 and $criticals > 0)
				or ($roll <  9 and $skill > 17 and $criticals > 1)
				or ($roll < 10 and $skill > 18 and $criticals > 2)
			)
		) { # Critical success!
			$energy += $margin;
			$time += 1;
			next ATTEMPT;
		} elsif ($roll > 16 or $margin < -9) {
			if ( $skill > 15 and $roll == 17 ) {
				# Automatic failure.
				$time += $time_increment;
				$energy += 1;
				$quirks += 1;
			} elsif ( $reroll < $criticals ) {
				# Critical failure averted by Enhanced Criticals.
				$reroll += 1;
				redo ATTEMPT;
			} else {
				# Critical failure!
				$time += (int(rand(6))+1) * ($time_increment / 5);
				$energy = $energy > 15 ? $energy*2 : 30;
				return "$message->{who}: Critical failure after $time minutes; $energy energy and $quirks quirk" . ($quirks == 1 ? "" : "s") . ".";
			}
		} elsif ( $margin >= 0 ) {
			# Ordinary success.
			$energy += ($margin > 0 ? $margin : 1);
			$time += $time_increment;
		} else {
			# Ordinary failure.
			$energy += 1;
			$time += $time_increment;
			$quirks += 1;
		}
	} continue {
		$roll_number++;
		$reroll = 0;
	}

	return "$message->{who}: Success after $time minutes; $energy energy and $quirks quirk" . ($quirks == 1 ? "" : "s") . ".";
}

1;
