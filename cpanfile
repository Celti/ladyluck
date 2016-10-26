# Global requirements.
requires 'common::sense';

# The bot engine itself.
requires 'Bot::BasicBot::Pluggable::WithConfig';
requires 'Bot::BasicBot::Pluggable::Module::RD';

# Fundamental support components.
# requires 'Filter::Indent::HereDoc'; # Maybe. Might not need this.
requires 'IRC::Utils';
requires 'POE::Component::SSLify';

# Specific module requirements.
recommends 'Math::Random::Secure';    # Dice.pm
recommends 'Inline::Files';           # Several GURPS modules.

# # Individual module pieces.
# recommends 'HTTP::Request::Common';
# recommends 'Inline::Files';
# recommends 'LWP::JSON::Tiny';
# recommends 'LWP::Simple';
# recommends 'Math::Calc::Units';
# recommends 'Math::Random::Secure';
# recommends 'Math::SigFigs';
# recommends 'REST::Google::Search';
# recommends 'Text::ParseWords';
# recommends 'WWW::DuckDuckGo';
# recommends 'WWW::Google::Calculator';
# recommends 'WWW::Shorten';
# recommends 'XML::Simple';
