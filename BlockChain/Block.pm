package BlockChain::Block;

use v5.10;

use strict;
use warnings;

use DateTime;
use JSON::XS;
use Data::Dumper;
use Time::HiRes qw(time);
use Digest::SHA qw(sha256_base64);
 
sub new {
	my $class = shift;
	my %data = @_;
	my $self = {};
	foreach my $key (keys %data){
        $self->{$key} = $data{$key} if ($key =~ /^data$/igm);
    }
    $self->{timestamp} = DateTime->now(time_zone => 'UTC')->epoch();
	$self->{nonce} = 0;
    $self->{hash} = calculateHash($self);
	bless( $self, $class );
	return $self;
}

sub calculateHash{
	my $self = shift;
	my $warns = shift;
	local $Data::Dumper::Purity = 1;
	local $Data::Dumper::Terse = 1;
	local $Data::Dumper::Indent = 0;
	local $Data::Dumper::Useqq = 1;
	local $Data::Dumper::Sortkeys = 1;
	return sha256_base64(join('|', $self->{timestamp}, Dumper($self->{data}), ($self->{previous_hash} || '-'), $self->{nonce}));
}

sub mineBlock {
	my $self = shift;
	my $difficulty = int(shift) || 2;
	my $start = time;
	while(substr(($self->{hash} || ''), 0, $difficulty) ne ("0" x $difficulty)){
		$self->{nonce}++;
		$self->{hash} = $self->calculateHash();
	}
	$self->{mined} = time - $start;
}

1;
