package Bot::BasicBot::Pluggable::Module::LadyLuck;
use base 'Bot::BasicBot::Pluggable::Module';

use Bot::BasicBot::Pluggable::Module::RD;
use common::sense;

our $VERSION = '0.0.1';

our $grammar = <<'END';
<autotree>

command:
	  'say' message
	| 'tell' recipient message
	| 'Sorry'

recipient: nick | channel

nick:    /\w+/
channel: /[#&+*!]\w+/
message: /.*/
END

sub init {
	my $self = shift;
	Bot::BasicBot::Pluggable::Module::RD->extend($grammar, __PACKAGE__);
}

sub help {
return <<'END';
Core module commands:
say <message>
tell <recipient> <message>
END
}

package Bot::BasicBot::Pluggable::Module::LadyLuck::Command;
use base 'Parse::RecDescent::Topiary::Base';

use common::sense;

sub say {
	my ($self, $bot, $context) = @_;

	my $message = $self->{message}{__VALUE__};
	$bot->say(
		%$context,
		address => '',
		body => $message
	);
}

sub tell {
	my ($self, $bot, $context) = @_;

	my $recipient = $self->{recipient};

	if (exists $recipient->{nick}) {
		$bot->say(
			%$context,
			body    => $self->{message}{__VALUE__},
			channel => 'msg',
			who     => $recipient->{nick}{__VALUE__},
		);
	} else {
		$bot->say(
			%$context,
			address => '',
			body    => $self->{message}{__VALUE__},
			channel => $recipient->{channel}{__VALUE__},
		);
	}
}

1;
