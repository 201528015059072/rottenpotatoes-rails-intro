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
     # Rails.logger.debug("调用index")
      @all_ratings=["G","PG","PG-13","R"]
     @movies=Movie.all 
     mytemp= Array(params[:ratings])
      Rails.logger.debug("oooooooooooooootemp: #{mytemp}")

     if mytemp==nil || mytemp=='' || mytemp==[]
        if session[:chsult]!=nil
          checksult=session[:chsult]
          else
            checksult=nil
        end
      else 
         toresult=to_Checksult(mytemp);
         session[:chsult]=toresult;
          @checklast=mycheckrating(mytemp)
      end
  
    
    
    
     #调用session，是否为空，为空则调用all，否则，调用sort
     if session[:sorttype]=='title'  
              redirect_to sortbyTitle_movies_path
      elsif session[:sorttype]=='date'  
            redirect_to sortbyDate_movies_path
      elsif  @checklast==nil|| @checklast == ""|| @checklast ==[]
      else
        @movies= @checklast
      end
  
  end

  def to_Checksult(temp)
     
   
    checksult =temp   #.split(",")
    checksql=""
    count=1;
    checksult.each do |rat|
      
      if count<checksult.size
        checksql=checksql+"'"+rat[0]+"'"+",";
      else
       checksql=checksql+"'"+rat[0]+"'";
      end
      count+=1;
      
    end
    return checksql
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
     session[:sorttype]='date'
    if session[:chsult]!=nil
      sql="rating IN ("+session[:chsult]+")"
      @movies=Movie.where(sql).order("release_date")
    else
      @movies=Movie.all.order("release_date")
    end
  end


  def sortbyTitle
    @all_ratings=["G","PG","PG-13","R"]
    session[:sorttype]='title'
    if session[:chsult]!=nil
      sql="rating IN ("+session[:chsult]+")"
      @movies=Movie.where(sql).order("title")
    else
      @movies=Movie.all.order("title")
    end
  end


def checksql 
  checksult=session[:chsult];
  sql=""
  count=1;
  checksult.each do |rat|
      
      if count<checksult.size
        checksql= sql+"'"+rat[0]+"'"+",";
      else
       checksql=sql+"'"+rat[0]+"'";
      end
      count+=1;
      
    end
    return sql
end
   

 def mycheckrating (checkpame)
    @all_ratings=["G","PG","PG-13","R"]
    if checkpame==nil
      return Movie.all
    end
    checksult =checkpame   #.split(",")
    checksql=""
    count=1;
    checksult.each do |rat|
      
      if count<checksult.size
        checksql=checksql+"'"+rat[0]+"'"+",";
      else
       checksql=checksql+"'"+rat[0]+"'";
      end
      count+=1;
      
    end
    sql="select * from movies where rating in ("+checksql+" )"
    # Rails.logger.debug("checksult: #{sql.inspect}")
    # @checkmovies=Movie.where(:rating =>rat[0])

     checkmovies=Movie.find_by_sql(sql);
    return checkmovies
  end












end
