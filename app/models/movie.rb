class Movie < ActiveRecord::Base
  def self.filter_list
    Movie.select(:rating).uniq.reduce([]) {|mem, m| mem << m.rating}.sort
  end
end
