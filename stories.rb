=begin
Author: Daniel Castrillo
Project: NBC
Description: Experimenting database of resources

{hack}
=end

class Stories
  attr_accessor :digg, :reddit, :mashable

  def initialize
    @digg = {
      name: "DIGG",
      stories: []
    }
    @reddit = {
      name: "REDDIT",
      stories: []
    }
    @mashable = {
      name: "MASHABLE",
      stories: []
    }
  end
end