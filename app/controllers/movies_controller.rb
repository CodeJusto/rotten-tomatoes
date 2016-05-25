class MoviesController < ApplicationController
  def index
    # @movies = Movie.search(params[:title], params[:director], params[:duration])
    # @movies = Movie.title.director.duration
  
    @movies = Movie.all

    if (params[:title].present?) 
      @movies = @movies.title(params[:title])
    end

    if (params[:director].present?) 
      @movies = @movies.director(params[:director])
    end

    if (params[:duration].present?) 
      @movies = @movies.search(params[:duration])
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
