package Bot::BasicBot::Pluggable::Module::8Ball;

use base qw(Bot::BasicBot::Pluggable::Module);
use common::sense;

our $VERSION = '2';

sub help {
	return "Asks the Magic 8-Ball a question! Usage: .8ball <question>";
}

sub init {
	our @answers = map { chomp; $_ } <DATA>;
}

sub told {
	my ($self,$message) = @_;
	my $body = $message->{body};
	return unless defined($body);

	my ($command,$arguments) = split(/\s+/, $body, 2);
	return unless $command =~ /^(?:!|\.)8(?:ball)?$/i;

	our @answers; return $answers[int rand @answers];
}

1;


__DATA__
As I see it, yes.
Better not tell you.
Can I lie about the answer?
Concentrate and ask again.
Corner pocket.
Flip a coin.
Go ask Atosen.
Hahahahahaha. What a dumb question. No.
How the hell should I know?
I don't think I should answer that.
I plead the Fifth.
I slept with your SO.
I'm in a bad mood, go away.
If I told you that, I'd have to kill you.
Maybe, but don't count on it.
Maybe.
Mostly.
My lawyer says I shouldn't answer that on the grounds that I may incriminate myself.
My sources are mysteriously quiet on that subject.
My sources say no.
My sources say yes.
No.
Not for a while.
Of course!
Once in a blue moon.
Only under certain conditions.
Outlook not good.
Reply hazy, try again.
Results uncertain. Try again later.
Scratch.
Side pocket.
That's a question you should ask yourself.
Why do you want to know?
Without a doubt.
Yes, but not for a while.
Yes.
I'll only tell you if Godwinson leaves the channel.
That's beneath my concern. Go ask Galle.
If I told you that Saithis would ban me.
