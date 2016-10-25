package Bot::BasicBot::Pluggable::Module::Monitor;

use base qw(Bot::BasicBot::Pluggable::Module);
use common::sense;
use POSIX qw(strftime);

our $VERSION = '1';
our $monitor;

sub help {
	return "Monitors the bot's internal state. Requires auth.";
}

sub init {
	open ($monitor, ">>", $self->bot->nick() . "monitor.log")
		or die "Couldn't open logfile.\n";
	binmode ($monitor, ':unix');
	say $monitor strftime('%a, %d %b %Y %T %z', localtime), " Opening log.";
}

sub stop {
	say $monitor strftime('%a, %d %b %Y %T %z', localtime), " Closing log.";
	close $monitor;
}

sub seen {
	my ($self,$message) = @_;
	say $monitor strftime('%a, %d %b %Y %T %z', localtime), " $message->{channel}: <$message->{who}> $message->{body}";
}

sub emoted {
	my ($self, $message, $priority) = @_;
	return unless $priority == 0;
	say $monitor strftime('%a, %d %b %Y %T %z', localtime), " $message->{channel}: * $message->{who} $message->{body}";
}

sub told {
	my ($self,$message) = @_;
	my $body = $message->{body};
	return unless defined($body);
	return unless $self->authed($message->{who});
	
	my ($command,$arguments) = split(/\s+/, $body, 2);
	$command = lc($command);
	return unless $command =~ /^(?:!|\.)(channels)$/;
	$command = $1;

	if ($command eq "channels") {
		my @channels = $self->bot->channels;
		return "I'm not in any channels!" if @channels == 0;
		return "I'm in $channels[0]." if @channels == 1;
		return "I'm in $channels[0] and $channels[1]." if @channels == 2;
		return "I'm in " . join(', ', @channels[0..$#channels-1]) . " and $channels[-1].";
	}
}

1;

__END__
