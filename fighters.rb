# require 'ap'
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
   	group_targets = @attacks.values_at( *group ).flatten.uniq.compact
   	( cowboy_attackers & group_targets ).empty? ? false : true
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
    attacks = @attacks
    unconditionally_alive = []
    unconditionally_dead = []
    
    until ( (cowboys - (unconditionally_alive + unconditionally_dead) ).empty? )   
      unconditionally_alive = cowboys - attacks.values.flatten.uniq
      killing_attacks = attacks.select { |attacker,targets| unconditionally_alive.include?( attacker ) }
      unconditionally_dead.concat( killing_attacks.values.flatten.uniq )
      attacks.delete_if{ |attacker,target| unconditionally_dead.include?( attacker ) }
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
