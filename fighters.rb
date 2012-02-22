require 'ap'
class Fighters
  attr_reader :cowboys, :attacks, :alive, :dead

  def initialize(cowboys, attacks)
    @cowboys = cowboys
    # This line uses functional programming to group all attacks by attacker, and make it a hash 
    @attacks = Hash[ attacks.group_by(&:first).map{ |k,a| [k,a.map(&:last)] } ]
  end

  def to_s
    "Cowboys: #{@cowboys} | Attacks: #{@attacks}"
  end

  def conflict_free?( group )
    targets = @attacks.values_at( *group ).flatten.uniq
    (targets & group).empty? ? true : false
  end

  def defended?( cowboy, group )
    cowboy_attackers = @attacks.select{ |attacker,targets| targets.include? cowboy }.keys
    # return true if cowboy_attackers.empty?

   	group_targets = @attacks.values_at( *group ).flatten.uniq.compact

    true unless( (cowboy_attackers & group_targets).empty? )
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
      puts state.to_s.upcase

    
    cowboys = @cowboys
    attacks = @attacks
    unconditionally_alive = []
    unconditionally_dead = []
    killing_attacks = [nil]

    # Until 
    until ( killing_attacks.nil? || killing_attacks.empty?  ) 

      #debug
      print "Unconditionally alive:   "
      puts unconditionally_alive.to_s
      print "Unconditionally dead:    "
      puts unconditionally_dead.to_s
      print "Cowboys:                 "
      puts cowboys.to_s
      print "Attacks:                 "
      puts attacks
      

      # Cowboys not being attacked are unconditionally alive
      unconditionally_alive = (cowboys - attacks.values.flatten.uniq) - unconditionally_dead

      # Select those attacks where the attacker is unconditionally alive
      killing_attacks = attacks.select { |attacker,targets| unconditionally_alive.include?( attacker ) }

      print "killing attacks:         "
      puts killing_attacks

      # The targets of those atttacks are unconditionally dead
      unconditionally_dead = unconditionally_dead + killing_attacks.values.flatten.uniq 

      # Remove attacks where the target is already dead
      attacks.each_pair{ |attacker,targets| targets.delete_if{ |target| unconditionally_dead.include?( target ) } }

      # Remove the attacks where the attacker is dead
      attacks.delete_if{ |attacker,targets| targets.empty? || unconditionally_dead.include?( attacker ) }

      puts
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
