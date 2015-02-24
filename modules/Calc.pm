package Bot::BasicBot::Pluggable::Module::Calc;

use base qw(Bot::BasicBot::Pluggable::Module);
use common::sense;
use WWW::Google::Calculator;

our $VERSION = '2';

sub help {
	return "Queries Google Calculator and returns the result. Usage: .calc <expression>";
}

sub told {
	my ($self,$message) = @_;
	my $body = $message->{body};
	return unless defined($body);

	my ($command,$arguments) = split(/\s+/, $body, 2);
	return unless $command =~ /^(\.|!)calc$/i;
	return "You must specify a query." unless defined($arguments);

	my $calc = WWW::Google::Calculator->new;
	my $result = $calc->calc($arguments);
	defined($result) ? return $result : return "No result.";
}

1;

__END__
