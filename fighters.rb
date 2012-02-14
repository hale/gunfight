require 'ap'
require 'pp'

class Fighters
    attr_reader :cowboys
    attr_reader :attacks

    def initialize(cowboys, attacks)
        @cowboys = cowboys
        # This line uses functional programming to group all attacks by attacker, and make it a hash 
        @attacks = Hash[ attacks.group_by(&:first).map{ |k,a| [k,a.map(&:last)] } ]
    end

    def to_s
        "Cowboys: #{@cowboys} | Attacks: #{@attacks}"
    end

    def conflict_free?(group)
    	# Get the list of cowboys attacked by this group
    	targets = @attacks.values_at(*group)
    	# Make it pretty
    	targets.flatten!.uniq!

   		if (targets & group).empty?
   			# No intersection between the cowboys this group is shooting at, and the cowboys in this group
   			return true
   		else
   			return false
	    end
    end

    # true if a member of group is attacking any of the cowboys attacking cowboy
    def defended?(cowboy, group)
    	# find the group's targets (1) - 
    	# find the attackers of the cowboy (2)
    	# return true if the intersection of 1 and 2 is not empty

    	# from the attacks hash, we need each key whose value contains the cowboy

    	cowboy_attacks = attacks.select{ |attacker,targets| targets.include? cowboy}
    	cowboy_attackers = cowboy_attacks.keys
    	group_targets = @attacks.values_at(*group).flatten.uniq.compact

    	if (cowboy_attackers & group_targets).empty?
    		return false
    	else
    		return true
    	end

    end

end
