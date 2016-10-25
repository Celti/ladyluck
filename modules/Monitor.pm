package Bot::BasicBot::Pluggable::Module::Monitor;

use base qw(Bot::BasicBot::Pluggable::Module);
use common::sense;
use POSIX qw(strftime);

our $VERSION = '3';

sub help {
	return "Monitors the bot's internal state. Requires auth.";
}

sub init {
	my $self = shift;

	$self->config({user_monitor_log => 'monitor.log'});

	open (MONITOR, ">>", $self->get('user_monitor_log'))
		or die "Couldn't open logfile.\n";

	binmode (MONITOR, ':unix');
	say MONITOR strftime('%a, %d %b %Y %T %z', localtime), " Opening log.";
}

sub stop {
	say MONITOR strftime('%a, %d %b %Y %T %z', localtime), " Closing log.";
	close MONITOR;
}

sub seen {
	my ($self,$message) = @_;
	say MONITOR strftime('%a, %d %b %Y %T %z', localtime), " $message->{channel}: <$message->{who}> $message->{body}";
}

sub emoted {
	my ($self, $message, $priority) = @_;
	return unless $priority == 0;
	say MONITOR strftime('%a, %d %b %Y %T %z', localtime), " $message->{channel}: * $message->{who} $message->{body}";
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
