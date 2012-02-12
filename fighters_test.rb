require './fighters.rb'
require 'rspec'
require 'ap'


describe "A gunfight" do

    before(:all) do
        @cowboys = [:a,:b,:c]
        @attacks = [[:a,:b],[:b,:c],[:c,:a],[:a,:c]]
        @gunfight= Fighters.new @cowboys,@attacks
        ap @gunfight
    end

    it "should have a populated list of cowboys" do
        @gunfight.cowboys.should =~ @cowboys
    end

    it "should have a populated list of attacks" do
        @gunfight.attacks.should =~ @attacks
    end

end

