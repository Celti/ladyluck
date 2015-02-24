package Bot::BasicBot::Pluggable::Module::Farnsworth;

use base qw(Bot::BasicBot::Pluggable::Module);
#use common::sense;
use Language::Farnsworth;

our $VERSION = '1';

sub init {
	our $calc = Language::Farnsworth->new();
}

sub help {
	return "Runs arbitrary expressions in the Farnsworth language. Usage: .f <expression>";
}

sub told {
	my ($self,$message) = @_;
	my $body = $message->{body};
	return unless defined($body);

	my ($command,$arguments) = split(/\s+/, $body, 2);
	return unless $command =~ /^(\.|!)f$/i;
	return "You must specify a query." unless defined($arguments);

	my $result = $calc->runString("$arguments");
	defined($result) ? return $result : return "No result.";
}

1;

__END__
