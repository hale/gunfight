require './fighters.rb'
require 'rspec'
require 'ap'

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

    it "determine if a given set of cowboys is conflict free" do
        @gunfight.conflict_free?([:a,:c]).should be_true
        @gunfight.conflict_free?([:b,:c]).should be_false
    end

    it "determine if a cowboy is defended by a given group" do
        @gunfight.defended?(:b,[:a,:c]).should be_true
        @gunfight.defended?(:e,[:a,:c]).should be_false
    end

    it "determine if a given group of cowboys is self-defending" do
        @gunfight.self_defended?([:a,:e]).should be_true
        
        @gunfight.self_defended?([:d,:e]).should be_false
        @gunfight.self_defended?([:a,:e,:b]).should be_false
    end


end


