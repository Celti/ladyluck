package Bot::BasicBot::Pluggable::Module::UserJoin;

use base qw(Bot::BasicBot::Pluggable::Module);
use common::sense;

our $VERSION = '1';

sub help {
	return "Joins and leaves channels. Usage: !join <channel> [key], !part <channel>";
}

sub told {
	my ($self,$message) = @_;
	my $body = $message->{body};
	return unless defined($body);
	
	my ($command,$arguments) = split(/\s+/, $body, 2);
	$command = lc($command);
	return unless $command =~ /^(?:!|\.)(join|part|leave)$/;
	$command = $1;
	
	if ($command eq 'join') {
		return "You must specify a channel." unless $arguments;
		my ($channel, $key) = split(/\s+/, $arguments, 2);
		$self->bot->join($channel, $key // '');
		return "Joining $channel.";
	} elsif ($command eq 'part' or $command eq 'leave') {
		$self->bot->part($arguments || $message->{channel});
		return "Leaving $arguments.";
	}
}

1;

__END__
