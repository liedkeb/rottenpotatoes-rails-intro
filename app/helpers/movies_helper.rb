module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  
  def sorted(thclass)
    'hilite' if params[:sort] == thclass
  end
end
