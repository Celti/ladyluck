package Bot::BasicBot::Pluggable::Module::Subst;

use base qw(Bot::BasicBot::Pluggable::Module);
use common::sense;

our $VERSION = '1';

sub help {
	return "Runs a substitution over previous lines and returns the new line. Usage: s/<match>/<replace>/[g]";
}

sub init {
	my $self = shift;
	$self->config({user_history_lines => 10});
}

sub seen {
	my ($self,$message) = @_;

	my $channel = $message->{channel};
	return if $channel eq 'msg';

	my $body = $message->{body};
	return unless defined($body);
	return if $body =~ m{^(?:!|\.)?s/(.+)/(.+)/(g?)$};

	my @channel_history = $self->get("history_$channel");
	unshift (@channel_history, [$message->{who}, $body, 'm']);
	pop @channel_history if @channel_history >= $self->get('user_history_lines');
	$self->set("history_$channel" => @channel_history);
}

sub emoted {
	my ($self,$message, $priority) = @_;
	return unless $priority == 0;

	my $body = $message->{body};
	return unless defined($body);

	my $channel = $message->{channel};
	return if $channel eq 'msg';
	
	my @channel_history = $self->get("history_$channel");
	unshift (@channel_history, [$message->{who}, $body, 'a']);
	pop @channel_history if $#channel_history >= $self->get('user_history_lines');
	$self->set("history_$channel" => @channel_history);
}

sub told {
	my ($self,$message) = @_;
	my $body = $message->{body};
	return unless defined($body);

	my $channel = $message->{channel};
	return if $channel eq 'msg';

	return unless $body =~ m{^(?:!|\.)?s/(.+)/(.+)/(g?)$};
	my $match = $1;
	my $replace = $2;
	my $options = $3;

	my @channel_history = $self->get("history_$channel") // [''];

	for my $line (@channel_history) {
		if ($line->[0] eq $message->{who}) {
			my $matched;
			if ($options eq 'g') {
				$matched = 1 if $line->[1] =~ s/$match/$replace/g;
			} else {
				$matched = 1 if $line->[1] =~ s/$match/$replace/;
			}
			if ($matched) {
				if ($line->[2] eq 'a') {
					return "* $line->[0] $line->[1]";
				} else {
					return "<$line->[0]> $line->[1]";
				}
			}
		}
	}
}

1;

__END__
