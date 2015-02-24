package Bot::BasicBot::Pluggable::Module::GoogleAPI;

use base qw(Bot::BasicBot::Pluggable::Module);
use common::sense;
use REST::Google::Search qw(IMAGES);

our $VERSION = '2';

sub help {
	return "Queries Google and returns the first result. Usage: .google, .image, .wiki";
}

sub told {
	my ($self,$message) = @_;
	my $body = $message->{body};
	return unless defined($body);

	my ($command,$arguments) = split(/\s+/, $body, 2);
	$command = lc($command);
	return unless $command =~ /^(?:!|\.)(google|image|wiki)$/i;
	return "You must specify a query." unless defined($arguments);

	my $query = $arguments;
	$query .= " site:en.wikipedia.org" if $1 eq 'wiki';
	REST::Google::Search->service(IMAGES) if $1 eq 'image';

	my $response = REST::Google::Search->new(q => $query);

	return "[$arguments] " . $response->responseDetails unless $response->responseStatus == 200;
	return "[$arguments] No result." unless defined $response->responseData->cursor->currentPageIndex;
	return "[$arguments] " . $response->responseData->results->[0]->url;
}

1;

__END__
