package Bot::BasicBot::Pluggable::Module::Flip;

use base qw(Bot::BasicBot::Pluggable::Module);
use common::sense;

our $VERSION = '3';

sub help {
	return "Flips a coin! Usage: .flip";
}

sub told {
	my ($self,$message) = @_;
	my $body = $message->{body};
	return unless defined($body);
	my ($command,$arguments) = split(/\s+/, $body, 2);
	return unless lc($command) =~ /^(?:!|\.)(flip|unflip)$/;

	if ($1 eq 'flip') {
		return '(╯°□°)╯ ︵ ┻━┻' if $arguments =~ /^table$/i;
		return '┬──┬╯︵ /(.□. \）' if $arguments =~ /^(?:soviet|russia)/i;
		return '(╯°□°)╯ ︵ /(.□.\)' if $self->bot->pocoirc->is_channel_member($message->{channel}, $arguments);
		return "Edge!" unless int rand 100;
		return int rand 2 ? "Heads!" : "Tails!";
	} elsif ($1 eq 'unflip') {
		return '┬─┬ノ(º_ºノ)' if $arguments =~ /^table$/i;
		return '/(°_°)\ノ(º_ºノ)' if $self->bot->pocoirc->is_channel_member($message->{channel}, $arguments);
		return $self->bot->emote({%$message, body => "reverse-pickpockets 25¢ onto $message->{who}"});
	} else {
		return "How did you get here? I am not good with computer."
	}
}

1;

__END__
