package Bot::BasicBot::Pluggable::Module::Template;

use base qw(Bot::BasicBot::Pluggable::Module);
use common::sense;

our $VERSION = '1';

sub help {
	return "Returns an appropriate response.";
}

sub told {
	my ($self,$message) = @_;
	my $body = $message->{body};
	return unless defined($body);
	my ($command,$arguments) = split(/\s+/, $body, 2);
	$command = lc($command);

	return unless $command =~ /^(?:!|\.)foo$/;

	return "Bar!"
}

1;

__END__
