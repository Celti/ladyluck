package Bot::BasicBot::Pluggable::Module::DuckDuckGo;

use base qw(Bot::BasicBot::Pluggable::Module);
use common::sense;
use WWW::DuckDuckGo;

our $VERSION = '1';

sub help {
	return "Queries DuckDuckGo and returns their Instant Answer. Usage: .d, .duck, .duckduckgo";
}

sub told {
	my ($self,$message) = @_;
	my $body = $message->{body};
	return unless defined($body);

	my ($command,$arguments) = split(/\s+/, $body, 2);
	$command = lc($command);
	return unless $command =~ /^(?:!|\.)(d|duck|duckduckgo)$/i;
	return "You must specify a query." unless defined($arguments);
	my $full = 'true' if $1 eq 'duckduckgo';
	my $short = 'true' if $1 eq 'd';

	my $duck = WWW::DuckDuckGo->new(safeoff => '1');
	my $zero = $duck->zeroclickinfo("$arguments");

	if ($short) {
		return "[$arguments] " . $zero->answer if $zero->has_answer;
		return "[$arguments] No answer.";
	}

	$self->bot->say({%$message, body => "Redirected to " . $zero->redirect}) if $zero->has_redirect;
	
	if ($zero->has_answer) {
		$self->bot->say({%$message, body => "The answer is..."});
		$self->bot->say({%$message, body => $zero->answer});
	}
	
	if ($zero->has_heading) {
		my $heading = $zero->heading;
		$heading .= " (" . $zero->type_long . ")" if $zero->has_type;
		$self->bot->say({%$message, body => $heading});
	}

	if ($zero->has_definition) {
		my $definition = $zero->definition;
		$definition .= " (" . $zero->definition_source . ")" if $zero->has_definition_source;
		$definition .= " [" . $zero->definition_url->as_string . "]" if $zero->has_definition_url;
		$self->bot->say({%$message, body => $definition});
	}

	if ($zero->has_abstract_text) {
		my $abstract = $zero->abstract_text;
		$abstract .= " (" . $zero->abstract_source . ")" if $zero->has_abstract_source;
		$abstract .= " [" . $zero->abstract_url->as_string . "]" if $zero->has_abstract_url;
		$self->bot->say({%$message, body => $abstract});
	}

	if ($full or $zero->type_long eq 'disambiguation') {
		return "Full responses are only available in private messages." unless $message->{channel} eq 'msg';

		if ($zero->has_default_related_topics) {
			$self->bot->say({%$message, body => "Related topics:"});

			for (@{$zero->default_related_topics}) {
				if ($_->has_text or $_->has_first_url) {
					my $topic = ' — ';
					$topic .= $_->text if $_->has_text;
					$topic .= ' [' if $_->has_text and $_->has_first_url;
					$topic .= $_->first_url->as_string if $_->has_first_url;
					$topic .= ']' if $_->has_text and $_->has_first_url;
					$self->bot->say({%$message, body => $topic});
				}
			}
		}

		if ($zero->has_results) {
			$self->bot->say({%$message, body => "Other results:"});
			for (@{$zero->results}) {
				if ($_->has_text or $_->has_first_url) {
					my $result = ' — ';
					$result .= $_->text if $_->has_text;
					$result .= ' [' if $_->has_text and $_->has_first_url;
					$result .= $_->first_url->as_string if $_->has_first_url;
					$result .= ']' if $_->has_text and $_->has_first_url;
					$self->bot->say({%$message, body => $result});
				}
			}
		}
	}

	return "I got no result for “$arguments”." unless $zero->has_answer or $zero->has_heading or $zero->has_results;
}

1;

__END__
