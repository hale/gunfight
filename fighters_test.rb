require './fighters.rb'
require 'rspec'

describe "A gunfight should" do    

    before(:all) do
        @cowboys = [:a,:b,:c,:d,:e]
        @attacks = [[:a,:d],[:b,:a],[:b,:c],[:b,:d],[:d,:b],[:e,:b]]
        @attacks_hash = {
            :a => [:d],
            :b => [:a,:c,:d],
            :d => [:b],
            :e => [:b]
        }
        @gunfight= Fighters.new @cowboys,@attacks

    end

    it "have a populated list of cowboys" do
        @gunfight.cowboys.should == @cowboys
    end

    it "create a hash listing attacks" do
        @gunfight.attacks.should == @attacks_hash
    end

    # A group of cowboys is conflict-free if 
    # none of the cowboys are attacking each other.
    it "determine if a given set of cowboys is conflict free" do
        @gunfight.conflict_free?([:c,:e]).should be_true
        @gunfight.conflict_free?([:c,:d]).should be_true
        @gunfight.conflict_free?([:b]).should be_true
        @gunfight.conflict_free?([:e]).should be_true

        @gunfight.conflict_free?([:b,:c]).should be_false
        @gunfight.conflict_free?([:a,:b,:c,:d,:e]).should be_false
        @gunfight.conflict_free?([:b,:d]).should be_false
    end

    # true if a member of group is attacking any of the cowboys attacking cowboy
    #   find the group's targets (1)
    #   find the attackers of the cowboy (2)
    #   return true if the intersection of 1 and 2 is not empty
    it "determine if a cowboy is defended by a given group" do
        @gunfight.defended?(:b,[:a,:c]).should be_true        
        @gunfight.defended?(:d,[:b,:c]).should be_true
        @gunfight.defended?(:b,[:b]).should be_true
        @gunfight.defended?(:c,[:e,:c]).should be_true
        @gunfight.defended?(:b,[:b,:d]).should be_true

        @gunfight.defended?(:e,[:a,:c]).should be_false
        @gunfight.defended?(:e,[:a,:b,:d]).should be_false
        @gunfight.defended?(:e,[:e]).should be_false

    end

    # A group is self defended if it is conflict free and if every cowboy
    # in the group is defended by the group
    it "determine if a given group of cowboys is self-defending" do
        @gunfight.self_defended?([:b]).should be_true
                
        @gunfight.self_defended?([:a,:e]).should be_false
        @gunfight.self_defended?([:d,:e]).should be_false
        @gunfight.self_defended?([:a,:e,:b]).should be_false
    end

=begin

Create methods called **unconditionally\_alive** and
**unconditionally\_dead** which compute (and return as an array) those
cowboys which are definitely alive and dead.

#### **Hint:**

To compute these, start with the cowboys which have no one aiming at
them; these are unconditionally alive. Those cowboys being aimed at by
these unconditionally alive cowboys are unconditionally dead, and those
aimed at only by unconditionally dead cowboys are unconditionally alive
and so on.

=end
    
    it "compute those cowboys which are unconditionally alive" do
        @gunfight.unconditionally_alive.should =~ [:e,:a,:c]
    end

    it "compute those cowboys which are unconditionally dead" do
        @gunfight.unconditionally_dead.should =~ [:b,:d]
    end



end


