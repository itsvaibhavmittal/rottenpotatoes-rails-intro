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
    @init_ratings_checkbox = {}
    Movie.select('rating').distinct.each do |rating|
	@all_ratings.push(rating.rating)
	@init_ratings_checkbox[rating.rating] = 1
    end

    sort = params[:sort]
    checked_ratings = params[:ratings]

    @class = {}

    if sort
	@movies = Movie.all.order(sort)
	@class[sort] = "hilite"
    elsif checked_ratings
	@movies = Movie.where(rating: checked_ratings.keys)
	@init_ratings_checkbox = {}
	checked_ratings.keys.each do |rate| @init_ratings_checkbox[rate]=1 end
    else
	@movies = Movie.all
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

end
