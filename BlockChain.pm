package BlockChain;

use v5.10;

use strict;
use warnings;

use DateTime;
use JSON::XS;
use IO::All;

use Math::Round qw(nearest);
use BlockChain::Block;
use Data::Dumper;

sub new {
	my $class = shift;
	my %data = @_;
	my $self = {
		display_width => 46,
		created => DateTime->now(time_zone => 'UTC')->epoch(),
		difficulty => 2
	};
	foreach my $key (keys %data){
        $self->{$key} = $data{$key} if ($key =~ /^difficulty$/igm);
    }
	$self->{chain} = [genesisBlock()];
	bless( $self, $class );
	return $self;        
}

sub genesisBlock {
	return BlockChain::Block->new(data => {});
}

sub getLatestBlock {
	my $self = shift;
	return $self->{chain}->[-1];
}

sub addBlock {
	my $self = shift;
	my %data = @_;
	my $newBlock = BlockChain::Block->new(data => \%data);
	my $latest = $self->getLatestBlock();
	$newBlock->{previous_hash} = $latest->{hash};
	$newBlock->mineBlock($self->{difficulty});
	push @{$self->{chain}}, $newBlock;
}

sub isValid {
	my $self = shift;
	my $length = $self->chainLength();
	foreach my $i (1..$length){
		my $previousBlock = $self->{chain}->[$i-1];
		my $currentBlock = $self->{chain}->[$i];

		if($currentBlock->{hash} ne $currentBlock->calculateHash() || $currentBlock->{previous_hash} ne $previousBlock->{hash}){
			return 0;
		}
		warn "$i is valid";
	}
	return 1;
}

sub chainLength {
	my $self = shift;
	return $#{$self->{chain}};
}

sub displayChain {
	my $self = shift;
	my $counter = 0;
	my $time_spent = 0;
	my $tab = " " x 4;
	$self->displayLine("BCHAIN");
	$self->displayLine("Chain Created:", $self->{created});
	$self->displayLine();
	foreach my $block (@{$self->{chain}}){
		$self->displayLine("Block $counter", undef, 1);
		$time_spent += $block->{mined} if $block->{mined};
		foreach my $display_values (['Created','timestamp'],['Mined In','mined',' seconds']){
			$self->displayLine($tab.$display_values->[0].":", (($display_values->[1] eq 'mined') ? (nearest(0.01, $block->{$display_values->[1]})) : $block->{$display_values->[1]}).(($display_values->[2]) ? $display_values->[2] : '')) if $block->{$display_values->[1]};
		}
		if(keys %{$block->{data}}){
			$self->displayLine($tab."Data: {",' ');
			foreach my $key (sort keys %{$block->{data}}){
				$self->displayLine(($tab x 2)."$key:", $block->{data}->{$key});
			}
			$self->displayLine($tab."}",' ');
		}else{
			$self->displayLine($tab."Data: {}",' ');
		}
		$counter++;
	}
	$self->displayLine();
	$self->displayLine("Chain Status:",($self->isValid() ? 'Valid' : 'Invalid'));
	$self->displayLine("Chain Mining Time:",nearest(0.01, $time_spent)." seconds");
	$self->displayLine("END");
}

sub displayLine {
	my $self = shift;
	my ($title, $value, $header) = @_;
	if($title && !$value){
		if(!$header){
			my $s = int(($self->{display_width} - length($title))/2);
			my $e = ('=' x ($self->{display_width} - (($s*2) + length($title))));
			say (('=' x $s).$title.('=' x $s).$e);
		}else{
			say ( $title . ( '=' x ( $self->{display_width} - ( length($title) ) ) ) );
		}
	}elsif(!$title && !$value){
		say ('=' x $self->{display_width});
	}else{
		my $s = $self->{display_width} - (length($title) + length($value));
		if($s > 0){
			say ($title.(' ' x $s).$value);
		}else{
			say $title;
			say ((' ' x ($self->{display_width} - length($value))).$value);
		}
	}
}

1;
