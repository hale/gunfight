require './Fighters.rb'
require 'rspec'

describe "A gunfight" do    

  before(:each) do
    @cowboys = [:a,:b,:c,:d,:e,:f,:g,:h]
    @attacks = [ [:a,:d],[:b,:a],[:b,:c],[:b,:d],[:d,:b],[:e,:b],[:g,:h],[:h,:g] ]
    @attacks_hash = {
      :a => [:d],
      :b => [:a,:c,:d],
      :d => [:b],
      :e => [:b],
      :g => [:h],
      :h => [:g]
    }
    @gunfight= Fighters.new @cowboys,@attacks
  end

  describe "gunfight initialization" do
    
    it "should have a populated list of cowboys" do
      @gunfight.cowboys.should == @cowboys
    end

    it "should create a hash listing attacks" do
      @gunfight.attacks.should == @attacks_hash
    end
  end

  describe "conflict free" do

    it "should be false if one cowboy attacks another" do
      @gunfight.conflict_free?([ :a,:d ]).should be_false
    end

    it "should be true if the cowboys only attack outside the group" do
      @gunfight.conflict_free?([ :a,:c,:e ]).should be_true
    end

    it "should be true if none of the cowboys are attacking" do
      @gunfight.conflict_free?([ :f ]).should be_true
    end
  end

  describe "cowboy defended by group" do

    # trivially defended
    it "should be true if the cowboy has no attackers" do
      @gunfight.defended?( :e, [:d,:c,:a] ).should be_true
      @gunfight.defended?( :e, [:e,:c,:a] ).should be_true
    end

    it "should be true if a member of the group
                      is attacking any of the cowboy's attackers" do
      @gunfight.defended?( :d, [:b,:c,:a] ).should be_true
    end      

    it "should be false if the group is empty" do
      @gunfight.defended?( :a, [] ).should be_false
    end

    it "should be false if none of the group are attacking" do
      @gunfight.defended?( :a, [:f,:c] ).should be_false
    end

    it "should be false if none of the group are attacking cowboy's attackers" do
      @gunfight.defended?( :a, [:a,:c] ).should be_false
    end
  end

  describe "self defended" do

    it "should be false if the group is conflict free and if every member is
                       *not* defended by the group" do
      @gunfight.self_defended?([ :b,:g,:h ]).should be_false
    end

    it "should be false if the group is *not* conflict free and if every member 
                       is *not* defended by the group" do
      @gunfight.self_defended?([ :b,:d ]).should be_false
    end
        
    it "should be false if the group is *not* conflict free and if every member
                       is defended by the group" do
      @gunfight.self_defended?([ :g,:h ]).should be_false
    end

    it "should be true if the group is conflict free and if every member is
                      defended by the group" do
      @gunfight.self_defended?([ :b ]).should be_true
      @gunfight.self_defended?([ :e,:f ]).should be_true
      @gunfight.self_defended?([ :e,:a,:c ]).should be_true
    end   
  end

  describe "dead or alive" do

    it "should compute those cowboys which are unconditionally alive" do
      @gunfight.unconditionally_alive.should =~ [:e,:a,:c,:f]
    end

    it "should compute those cowboys which are unconditionally dead" do
      @gunfight.unconditionally_dead.should =~ [:b,:d]
    end
  end

end


