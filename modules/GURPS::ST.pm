package Bot::BasicBot::Pluggable::Module::GURPS::ST;

our $VERSION = '1';

use common::sense;
use base qw(Bot::BasicBot::Pluggable::Module);
use POSIX qw(fmod);

sub init {
	my $self = shift;
	$self->config({user_st_colours => 1});

	if $self->get('user_st_colours') == 1 {
		use IRC::Utils qw(NORMAL BOLD ITALIC);
	} else {
		use constant NORMAL => '';
		use constant BOLD   => '';
		use constant ITALIC => '';
	}
}

sub help {
	return "Calculates Basic Lift and Damage for a given ST.";
}

sub told {
	my ($self,$message) = @_;
	my $body = $message->{body};
	return unless defined($body);

	my ($command,$arguments) = split(/\s+/, $body, 2);
	return unless lc($command) =~ /^(?:!|\.)st$/i;

	my $ST = $arguments;

	my ($thrust_dice, $thrust_mod, $thrust_adds, $thrust);
	my ($swing_dice, $swing_mod, $swing_adds, $swing);
	my $basic_lift;

	return "ST must be greater than 0." if $ST < 1;

	$basic_lift = $ST*$ST/5;
	$thrust = ($ST-5)/8;
	$swing = ($ST-6)/4;

	$basic_lift = int($basic_lift) if $basic_lift > 10;

	if ($ST < 11) {
		$thrust = 1; $swing = 1;

		for ($ST) {
			when ([1,2]) { $thrust_adds="-6"; $swing_adds="-5"; }
			when ([3,4]) { $thrust_adds="-6"; $swing_adds="-5"; }
			when ([5,6]) { $thrust_adds="-4"; $swing_adds="-3"; }
			when ([7,8]) { $thrust_adds="-3"; $swing_adds="-2"; }
			when (9)     { $thrust_adds="-2"; $swing_adds="-1"; }
			when (10)    { $thrust_adds="-2"; $swing_adds=""; }
		}
	} else {
		$thrust_mod = fmod($thrust,1);
		$swing_mod = fmod($swing,1);

		for ($thrust_mod) {
			when ([0, .125])   { $thrust_adds=""; }
			when ([.25, .375]) { $thrust_adds="+1"; }
			when ([.50, .625]) { $thrust_adds="+2"; }
			when ([.75, .875]) { $thrust_adds="-1"; $thrust+=1; }
		}

		for ($swing_mod) {
			when ([0, .125])   { $swing_adds=""; }
			when ([.25, .375]) { $swing_adds="+1"; }
			when ([.50, .625]) { $swing_adds="+2"; }
			when ([.75, .875]) { $swing_adds="-1"; $swing+=1; }
		}
	}

	return sprintf(BOLD."ST".NORMAL." %s: ".BOLD."Basic Lift".NORMAL." %s; ".BOLD."Damage".NORMAL." ".ITALIC."Thr".NORMAL." %sd%s, ".ITALIC."Sw".NORMAL." %sd%s\n", $ST, $basic_lift, int($thrust), $thrust_adds, int($swing), $swing_adds);
}

1;
