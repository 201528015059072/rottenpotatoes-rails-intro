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
    @all_ratings=["G","PG","PG-13","R"]
    @movies=Movie.all
     

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

  def sortbyDate
    @all_ratings=["G","PG","PG-13","R"]
    @movies=  Movie.all.order("release_date DESC")
  end
  def sortbyTitle
    @all_ratings=["G","PG","PG-13","R"]
    @movies=  Movie.all.order("title ASC")
  end

   

  def checkrating
    @all_ratings=["G","PG","PG-13","R"]
    @checksult = Array(params[:ratings])
    # Rails.logger.debug("checksult: #{@checksult.inspect}")
    checksql=""
    count=1;
    @checksult.each do |rat|
      
      if count<@checksult.size
        checksql=checksql+"'"+rat[0]+"'"+",";
      else
       checksql=checksql+"'"+rat[0]+"'";
      end
      count+=1;
      
    end
    sql="select * from movies where rating in ("+checksql+" )"
    # Rails.logger.debug("checksult: #{sql.inspect}")
    # @checkmovies=Movie.where(:rating =>rat[0])

    @checkmovies=Movie.find_by_sql(sql);

     
  end





end
