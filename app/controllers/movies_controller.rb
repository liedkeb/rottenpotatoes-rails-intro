class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    
    return @movies if params[:sort_by].nil? 
    
    if params[:sort_by] == 'title'
      # @movies.order!("title")
      @movies = @movies.sort {|a,b| a.title <=> b.title }
      @sort='title' 
    elsif params[:sort_by] == 'date'
      #@movies.order!("release_date")
      @movies = @movies.sort {|a,b| a.release_date <=> b.release_date }
      @sort='date' 
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
#  def title
#    @movies = Movie.all.order(:title)
#  end
  
#  def release_date
#    @movies = Movie.all.order(:release_date)
#  end

end
