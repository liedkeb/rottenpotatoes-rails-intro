class Movie < ActiveRecord::Base
  def self.filter_list
    # Movie.select(:rating).uniq.reduce([]) {|mem, m| mem << m.rating}.sort
    self.pluck(:rating).uniq
  end
  
  def self.sort_by(sort_arg)
    # make that given argument is one of the attributes of the model
    if self.column_names.include? sort_arg
      # 1. load all records from table
      # 2. sort them in the memory 
      # self.all.sort {|a,b| a.send(sort_arg.to_sym) <=> b.send(sort_arg.to_sym)}
      self.order(sort_arg)
    else
      # otherwise return all
      self.all
    end
  end
  
  def self.filter_using_keys(filter_arg)
    if filter_arg.nil?
      self.all
    else
      self.where(rating: filter_arg.keys)
    end
  end
end
