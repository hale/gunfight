**Exercise 2: Gunfight at the OK Corral**
-----------------------------------------

### **Assessment Description**



### **Overview**

In this practical and assessment you will be creating a small ruby
program to determine the winners of gunfights, as seen in old Western
movies.

The rules governing these gunfights are very simple:

1.  We have a bunch of cowboys
2.  Each cowboy can aim a gun at any number of other cowboys
3.  If a cowboy has a gun aimed at them, we say they are *attacked*,
    with the cowboy aiming the gun doing the *attacking*.
4.  Given a group of cowboys, we say that a subset of this group is
    *conflict-free* if none of the cowboys in the subset are attacking
    each other.
5.  A cowboy (let’s call him **C** is *defended* by some group of
    cowboys (let’s call this group **X**) if any cowboy attacking **C**
    is attacked by a member of **X**.
6.  We say that a group of cowboys is *self-defending* if every cowboy
    in the group is defended by the group, and the group is
    conflict-free.

### **Task 1**

Create a ruby class called Fighters that takes in a set of cowboys and
attacks between cowboys, e.g.

Fighters.new([:a,:b,:c],[[:a,:b],[:b,:c],[:c,:a]])

This represents the situation where we have 3 cowboys **:a,:b,:c** and
**:a** aims at **:b**, **:b** aims at **:c** and **:c** aims at **:a**.

Write rspec tests (in a file called fighters\_test.rb) for the following
methods on this class, and then implement these methods.

1.  **conflict\_free?(cowboys)** which takes in a set of cowboys and
    returns true if this set is conflict-free and false otherwise.
2.  **defended?(cowboy,group)** which returns true if the cowboy is
    defended by the group and false otherwise.
3.  **self\_defended?(group)** which, when given a group, returns true
    if the group is a self defending group.

### **Task 2**

We can identify several different groups of safe cowboys. First, there
are those cowboys that are unconditionally alive. For example, given the
following configuration of fighters

f=Fighters.new([:a,:b,:c],[[:a,:b],[:b,:c]])

Cowboys **:a** and **:c** will survive the fight as **a** would end up
shooting **b** meaning that **c** would not be shot.

Create methods called **unconditionally\_alive** and
**unconditionally\_dead** which compute (and return as an array) those
cowboys which are definitely alive and dead.

#### **Hint:**

To compute these, start with the cowboys which have no one aiming at
them; these are unconditionally alive. Those cowboys being aimed at by
these unconditionally alive cowboys are unconditionally dead, and those
aimed at only by unconditionally dead cowboys are unconditionally alive
and so on.

### **Notes**

The problem described here actually stems from a very active research
area in artificial intelligence called argumentation theory. If you’re
interested in finding out more about these concepts, see the book
\`\`Argumentation in Artificial Intelligence’’ edited by I. Rahwan and
G. Simari. Chapter 6 is particularly relevant. This book is available as
an e-book from the library.