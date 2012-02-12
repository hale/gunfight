class Fighters
    def initialize(cowboys, *attacks)
        @cowboys = cowboys
        @attacks = attacks
    end

    def to_s
        "Cowboys: #{@cowboys} | Attacks: #{@attacks}"
    end
end
