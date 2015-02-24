package Bot::BasicBot::Pluggable::Module::LART;

use base qw(Bot::BasicBot::Pluggable::Module);
use common::sense;

our $VERSION = '2';

sub help {
	return "Adjust the target's attitude. Usage: .lart [#channel] <target>";
}

sub told {
	my ($self,$message) = @_;
	my $body = $message->{body};
	return unless defined($body);
	my ($command,$arguments) = split(/\s+/, $body, 2);
	$command = lc($command);

	return unless $command =~ /^(?:!|\.)lart$/;
	
	my ($channel, $target);

	if ($arguments =~ /^(\#\S+)\s+(\S+)/) {
		$channel = $1;
		$target = $2;
	} else {
		$channel = $message->{channel};
		$target = $arguments;
	}

	if ($target eq $self->bot->nick) {
		return $self->bot->emote({%$message, body => "LARTs $message->{who} with a clue-by-four. (No way I'm LARTing myself!)"});
	} elsif (not grep {$_ eq $channel} $self->bot->channels) {
		return $self->bot->emote({%$message, body => "LARTs $message->{who} with a clue-by-four. (I'm not in that channel!)"});
	} elsif (not grep {$_ eq $target} $self->bot->names($channel)) {
		return $self->bot->emote({%$message, body => "LARTs $message->{who} with a clue-by-four. ($target isn't in that channel!)"});
	} elsif ($target eq $message->{who}) {
		return $self->bot->emote({channel => $channel, body => "LARTs $message->{who} with a clue-by-four. (You asked for it!)"});
	} else {
		return $self->bot->emote({channel => $channel, body => "LARTs $target with a clue-by-four. ($message->{who} made me!)"});
	}
}

1;

__END__
