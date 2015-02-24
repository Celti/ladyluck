package Bot::BasicBot::Pluggable::Module::Frink;

use base qw(Bot::BasicBot::Pluggable::Module);
use common::sense;
use Language::Frink::Eval;

our $VERSION = '1';

sub help {
	return "Runs arbitrary expressions in the Frink language. Usage: .f <expression>";
}

sub told {
	my ($self,$message) = @_;
	my $body = $message->{body};
	return unless defined($body);

	my ($command,$arguments) = split(/\s+/, $body, 2);
	return unless $command =~ /^(\.|!)f$/i;
	return "You must specify a query." unless defined($arguments);

	my $calc = Language::Frink::Eval->new();
	my $result = $calc->eval($arguments);
	defined($result) ? return $result : return "No result.";
}

1;

__END__
