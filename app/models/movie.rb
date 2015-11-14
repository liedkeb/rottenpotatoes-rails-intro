class Movie < ActiveRecord::Base
  def self.filter_list
    Movie.select(:rating).uniq.reduce([]) {|mem, m| mem << m.rating}.sort
  end
  
  def self.sort_by(sort_arg)
    # make that given argument is one of the attributes of the model
    if self.column_names.include? sort_arg
      self.all.sort {|a,b| a.send(sort_arg.to_sym) <=> b.send(sort_arg.to_sym)}
    else
      # otherwise return all
      self.all
    end
  end
end
