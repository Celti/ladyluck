package Bot::BasicBot::Pluggable::Module::GURPS::Critical;

our $VERSION = '2';

use common::sense;
use base qw(Bot::BasicBot::Pluggable::Module);
use Inline::Files;

sub help {
	return "Returns a random critical hit or miss result. Usage: .crit [head|miss|unarmed].";
}

sub init {
	our @critical_hit = map { chomp; $_ } <CRITICAL_HIT>;
	our @critical_miss = map { chomp; $_ } <CRITICAL_MISS>;
	our @critical_head_blow = map { chomp; $_ } <CRITICAL_HEAD_BLOW>;
	our @unarmed_critical_miss = map { chomp; $_ } <UNARMED_CRITICAL_MISS>;
}

sub told {
	my ($self,$message) = @_;
	my $body = $message->{body};
	return unless defined($body);

	my ($command,$arguments) = split(/\s+/, $body, 2);
	return unless lc($command) =~ /^(?:!|\.)(crit|fail)$/i;

	my ($roll, @table);

	if ($arguments =~ /(?:head|face|eye|skull)/) {
		@table = our @critical_head_blow;
	} elsif ($arguments =~ /unarmed/) {
		@table = our @unarmed_critical_miss;
	} elsif ($arguments =~ /(?:miss|fail)/ or $command =~ /fail/) {
		@table = our @critical_miss;
	} else {
		@table = our @critical_hit;
	}

	$roll = $arguments =~ /([3-9]|1[0-8])/ ? $1 : int(rand(6))+int(rand(6))+int(rand(6))+3;
	return "$message->{who}: $roll: $table[$roll]";
}

1;

__DATA__
FIXME

__CRITICAL_HIT__
nil
nil
nil
The blow does triple injury.
The target's DR protects at half value, round down.
The blow does double injury.
The blow does maximum normal damage.
If any damage penetrates DR, treat as a major wound.
If any damage penetrates DR, it inflicts double normal shock. Limbs and extremities are crippled for (16 - HT) seconds, minimum 2.
Normal damage only.
Normal damage only.
Normal damage only.
Normal damage, and the victim drops anything he is holding.
If any damage penetrates DR, treat as a major wound.
If any damage penetrates DR, treat as a major wound.
The blow does maximum normal damage.
The blow does double injury.
The target's DR protects at half value, round down.
The target's DR protects at one-third value, round down.

__CRITICAL_HEAD_BLOW__
nil
nil
nil
The blow does maximum normal damage and ignores DR.
The target's DR protects at half value, round up. If any damage penetrates, treat as a major wound.
The target's DR protects at half value, round up. If any damage penetrates, treat as a major wound.
Treat as an eye hit, even if attack normally can't target the eye. If an eye hit is impossible, treat as 4.
Treat as an eye hit, even if attack normally can't target the eye. If an eye hit is impossible, treat as 4.
Normal damage, and the victim is knocked off balance, he must Do Nothing next turn.
Normal damage only.
Normal damage only.
Normal damage only.
Normal damage; crushing injury causes deafness, other injury causes scarring.
Normal damage; crushing injury causes deafness, other injury causes scarring.
Normal damage, and the victim drops anything he is holding.
The blow does maximum normal damage.
The blow does double damage.
The target's DR protects at half value, round up.
The blow does triple damage.

__CRITICAL_MISS__
nil
nil
nil
Your weapon breaks. Roll again for solid crushing, magic, fine, or very fine weapons, or firearms; any other result means you drop it.
Your weapon breaks. Roll again for solid crushing, magic, fine, or very fine weapons, or firearms; any other result means you drop it.
You hit yourself in the arm or leg. If an impaling or piercing melee or any ranged attack, roll again; a second “hit yourself” confirms.
You hit yourself as per 5, but for half damage.
You lose your balance and can do nothing else until your next turn. All active defenses are at -2 until then.
Your weapon turns in your hand and requires a Ready maneuver before using it again.
You drop your weapon; cheap weapons break instead.
You drop your weapon; cheap weapons break instead.
You drop your weapon; cheap weapons break instead.
Your weapon turns in your hand and requires a Ready maneuver before using it again.
You lose your balance and can do nothing else until your next turn. All active defenses are at -2 until then.
If making a swinging melee attack, your weapon flies 1d yards forward or backward. Anyone in the target hex must roll DX or take half damage. Other attacks are dropped as per 10.
You strain yourself; your weapon arm is “crippled”. You retain your weapon but cannot use it to attack or defend for 30 minutes.
You fall. If making a ranged attack, see 7 instead.
Your weapon breaks. Roll again for sold crushing, magic, fine, or very fine weapons, or firearms; any other result means you drop it.
Your weapon breaks. Roll again for sold crushing, magic, fine, or very fine weapons, or firearms; any other result means you drop it.

__UNARMED_CRITICAL_MISS__
nil
nil
nil
You knock yourself out! Roll vs. HT every 30 minutes to recover.
You strain the limb you're attack with; take 1 HP of injury and the limb is crippled for 30 minutes. For other attacks, suffer moderate pain for the next (20-HT) minutes, minimum one.
You hit a solid object instead of your target. Take crushing damage equal to your thrusting damage or fall on your foe's ready impaling weapon.
As per 5, but half damage only. Natural weapons such as claws or teeth break: -1 damage until healed.
You stumble; on an attack move one yard past your opponent and end your turn facing away from him; on a parry, you fall down.
You fall down.
You lose your balance and can do nothing else until your next turn. All active defenses are at -2 until then.
You lose your balance and can do nothing else until your next turn. All active defenses are at -2 until then.
You lose your balance and can do nothing else until your next turn. All active defenses are at -2 until then.
You trip. Make a DX roll to avoid falling down, at -4 if kicking or twice normal penalty if technique requires roll for normal failure.
You drop your guard. All active defenses are at -2 for the next turn, and Evaluate bonuses or Feint penalties against you are doubled.
You stumble; on an attack move one yard past your opponent and end your turn facing away from him; on a parry, you fall down.
You tear a muscle. Take 1d-3 injury to the limb you used, or neck if biting or butting. You are at -1 to all attacks and defenses for the next turn, and at -3 to any action involving that limb (any action, if neck) until healed (-1 with High Pain Threshold).
You stumble; on an attack move one yard past your opponent and end your turn facing away from him; on a parry, you fall down.
You strain yourself as per 4. IQ 3-5 animals instead lose their nerve and flee, or surrender if cornered.
You knock yourself out! Roll vs. HT every 30 minutes to recover.
