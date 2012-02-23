class Fighters
  attr_reader :cowboys, :attacks, :alive, :dead

  def initialize(cowboys, attacks)
    @cowboys = cowboys
    # This line uses functional programming to group all attacks by attacker, and make it a hash 
    @attacks = Hash[ attacks.group_by(&:first).map{ |k,a| [k,a.map(&:last)] } ]

    @cowboys.freeze
    @attacks.freeze
  end

  def to_s
    "Cowboys: #{@cowboys} | Attacks: #{@attacks}"
  end

  def conflict_free?( group )
    targets = @attacks.values_at( *group ).flatten.uniq
    (targets & group).empty? ? true : false
  end

  # C is defended by X if any cowboy attacking C is attacked by a member of X
  # Given: A list of cowboys attacking C
  #        A list of the cowboys every cowboy in X is attacking
  # C is defended if any of the cowboys in the second list are also in the first
  # 
  def defended?( cowboy, group )  
    #puts "defended?( #{cowboy.to_s} , #{group.to_s} )".upcase
    cowboy_attackers = []

    cowboy_attackers = @attacks.select{ |attacker,targets| targets.include? cowboy }.keys

    # If the cowboy has no attackers, the cowboy is trivially defended
    return true if cowboy_attackers.empty?

    group_targets = @attacks.values_at( *group ).flatten.uniq.compact

=begin debug
         print "Cowboy's attackers:      "
         puts cowboy_attackers.to_s
         print "Group's targets:         "
         puts group_targets.to_s
         print "Intersection of the two: "
         puts (cowboy_attackers & group_targets).to_s
=end

    (cowboy_attackers & group_targets).empty? ? false : true

  end
  
  def self_defended?( group )
    sd = conflict_free?( group )

    group.each do |cowboy|
      sd = sd && (defended?( cowboy,group ) ) 
    end
    return sd     
  end

  def unconditionally_alive
    return compute_attacks( :alive )
  end

  def unconditionally_dead
    return compute_attacks( :dead )

  end

    # to begin with, alive cowboys are those that have nobody aiming at them
    # 
    # Repeat the following steps until all cowboys are either dead or alive
    #   remove all attacks where the atacker is unconditionally alive
    #   check again for all cowboys that have nobody aiming at them
  def compute_attacks( state )
    cowboys = @cowboys
    c_attacks = {}
    @attacks.each do |k,v|
      c_attacks[k] = v.clone
    end

    unconditionally_alive = []
    unconditionally_dead = []
    killing_attacks = [nil]

    # Until there are no killing attacks
    until ( killing_attacks.nil? || killing_attacks.empty?  ) 
=begin DEBUG
        print "Unconditionally alive:   "
        puts unconditionally_alive.to_s
        print "Unconditionally dead:    "
        puts unconditionally_dead.to_s
        print "Cowboys:                 "
        puts cowboys.to_s
        print "Attacks:                 "
        puts c_attacks
        print "killing attacks:         "
        puts killing_attacks
        puts
=end

      # Cowboys not being attacked are unconditionally alive
      unconditionally_alive = (cowboys - c_attacks.values.flatten.uniq) - unconditionally_dead

      # Select those attacks where the attacker is unconditionally alive
      killing_attacks = c_attacks.select { |attacker,targets| unconditionally_alive.include?( attacker ) }

      # The targets of those atttacks are unconditionally dead
      unconditionally_dead = unconditionally_dead + killing_attacks.values.flatten.uniq 

      # Remove attacks where the target is already dead
      c_attacks.each_pair{ |attacker,targets| targets.delete_if{ |target| unconditionally_dead.include?( target ) } }

      # Remove the attacks where the attacker is dead
      c_attacks.delete_if{ |attacker,targets| targets.empty? || unconditionally_dead.include?( attacker ) }

    end


    if state == :alive
      return unconditionally_alive
    elsif state == :dead
      return unconditionally_dead
    else 
      raise(ArgumentError, 'Must be :alive or :dead')
    end
  end




end
