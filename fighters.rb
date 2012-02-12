class Fighters
    attr_reader :cowboys
    attr_reader :attacks

    def initialize(cowboys, attacks)
        @cowboys = cowboys
        @attacks = attacks
    end

    def to_s
        "Cowboys: #{@cowboys} | Attacks: #{@attacks}"
    end
end
