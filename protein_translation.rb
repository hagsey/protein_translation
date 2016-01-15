class InvalidCodonError < RuntimeError; end

class Translation
  PROTEINS = {
    Methionine: %w(AUG),
    Phenylalanine: %w(UUU UUC),
    Leucine: %w(UUA UUG),
    Serine: %w(UCU UCC UCA UCG),
    Tyrosine: %w(UAU UAC),
    Cysteine: %w(UGU UGC),
    Tryptophan: %w(UGG),
    STOP: %w(UAA UAG UGA)
  }

  def self.of_codon(codon)
    PROTEINS.each do |amino_acid, codon_list|
      return amino_acid.to_s if codon_list.include?(codon)
    end
  end

  def self.of_rna(strand)
    fail InvalidCodonError unless valid?(strand)
    amino_acids = []
    until strand.empty?
      codon = strand.slice!(0..2)
      break if PROTEINS[:STOP].include?(codon)
      amino_acids << of_codon(codon)
    end
    amino_acids
  end

  private

  def self.valid?(strand)
    codons = []
    test_strand = strand.dup
    until test_strand.empty?
      codons << test_strand.slice!(0..2)
    end
    valid_codons = PROTEINS.values.flatten
    codons.all? { |codon| valid_codons.include?(codon) }
  end
end
