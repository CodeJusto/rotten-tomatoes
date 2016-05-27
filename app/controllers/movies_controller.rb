class MoviesController < ApplicationController
  def index
    @movies = Movie.order(created_at: :desc)
    if (params[:search].present?) 
      @movies = @movies.search(params[:search])
    end

    if (params[:duration].present?) 
      @movies = @movies.movie_duration(params[:duration])
    end

    unless @movies.empty?
      @feature = @movies.first 
      @remaining = @movies[1..-1] 
    end
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def new
    @movie = Movie.new
  end

  def edit
    @movie = Movie.find(params[:id])
  end

 def create
  @movie = Movie.new(movie_params)
    if @movie.save
      redirect_to movies_path, notice: "#{@movie.title} was submitted successfully!"
    else
      render :new
    end
  end

  def update
    @movie = Movie.find(params[:id])
    if @movie.update_attributes(movie_params)
      redirect_to movie_path(@movie)
    else
      render :edit
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    redirect_to movies_path
  end

  protected

  def movie_params
    params.require(:movie).permit(
      :title, :release_date, :director, :runtime_in_minutes, :description, :image
    )
  end

end
