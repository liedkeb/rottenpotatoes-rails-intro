class MoviesController < ApplicationController

  before_filter :before, :only => :index
  after_filter :after, :only => :index

  def before
    # providing default value for session ratings by first start of the page
    # all ratings should be selected if session[:ratings] is nil
    session[:ratings] ||= Hash[Movie.filter_list.map {|v| [v,1]}]
    # manualy create url if something is wrong with params variables
    flash.keep and redirect_to movies_url(ratings: params[:ratings]||session[:ratings], sort: params[:sort]||session[:sort]) if 
      session[:sort].present? and session[:ratings].present? and (params[:ratings].nil? or params[:sort].nil?)

    params[:ratings] ||= session[:ratings]
    params[:sort] ||= session[:sort]
  end
  def after
    session[:sort] = params[:sort]
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
    # @movies = Movie.sort_by(params[:sort])

    @movies = Movie.filter_using_keys(params[:ratings]).reorder(params[:sort])
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
