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

    @all_ratings = []
    #@init_ratings_checkbox = {}
    Movie.select('rating').distinct.each do |rating|
	@all_ratings.push(rating.rating)
	#@init_ratings_checkbox[rating.rating] = 1
    end

    redirect = false

    sort = params[:sort]
    if sort
	session[:sort] = sort
    elsif session[:sort]
	sort = session[:sort]
	redirect = true
    else 
	sort = nil
    end

    checked_ratings_hash = {}
    if params[:ratings]
	checked_ratings_hash = params[:ratings]
	session[:ratings] = params[:ratings]
    elsif session[:ratings]
	checked_ratings_hash = session[:ratings]
	redirect = true
    else
	@all_ratings.each do |rating| checked_ratings_hash[rating]=1 end
	redirect = nil
    end

    if redirect
	flash.keep
	redirect_to movies_path :sort=>sort, :ratings=>checked_ratings_hash
    end

    @class = {}
    #call model according to parameters
    if sort
	@movies = Movie.where(rating: checked_ratings_hash.keys).order(sort)
	@class[sort] = "hilite"
    else
	@movies = Movie.where(rating: checked_ratings_hash.keys)
    end

    @init_ratings_checkbox = {}
    checked_ratings_hash.keys.each do |rate| @init_ratings_checkbox[rate]=1 end    

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

end
