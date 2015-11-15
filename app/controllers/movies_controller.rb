class MoviesController < ApplicationController

  before_filter :before
  after_filter :after

  def before
    if session[:ratings].nil?
      session[:ratings]=Hash.new
      Movie.filter_list.each {|a| session[:ratings][a]=1} 
    end
    params[:ratings] ||= session[:ratings]
    params[:sort_by] ||= session[:sort_by]
  end
  def after
    session[:sort_by] = params[:sort_by]
    session[:ratings] = params[:ratings]
  end
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    params[:ratings].present? ? @init_checked = params[:ratings].keys : @init_checked = []
    
    @all_ratings = Movie.filter_list
    # @movies = Movie.sort_by(params[:sort_by])
    
    
    @movies = Movie.filter_using_keys(params[:ratings]).reorder(params[:sort_by])
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
  
  private 
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
end
