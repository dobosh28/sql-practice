# == Schema Information
#
# Table name: actors
#
#  id          :integer      not null, primary key
#  name        :string
#
# Table name: movies
#
#  id          :integer      not null, primary key
#  title       :string
#  yr          :integer
#  score       :float
#  votes       :integer
#  director_id :integer
#
# Table name: castings
#
#  movie_id    :integer      not null, primary key
#  actor_id    :integer      not null, primary key
#  ord         :integer

require_relative './sqlzoo.rb'

def example_join
  execute(<<-SQL)
    SELECT
      *
    FROM
      movies
    JOIN
      castings ON movies.id = castings.movie_id
    JOIN
      actors ON castings.actor_id = actors.id
    WHERE
      actors.name = 'Sean Connery'
  SQL
end

def ford_films
  # List the films in which 'Harrison Ford' has appeared.
  execute(<<-SQL)
    SELECT 
      title
    FROM
      movies
    JOIN  
      castings ON movies.id = castings.movie_id
    JOIN
      actors ON castings.actor_id = actors.id
    WHERE
      actors.name = 'Harrison Ford'
  SQL
end

def ford_supporting_films
  # List the films where 'Harrison Ford' has appeared - but not in the star
  # role. [Note: the ord field of casting gives the position of the actor. If
  # ord=1 then this actor is in the starring role]
  execute(<<-SQL)
    SELECT 
      title
    FROM
      movies
    JOIN
      castings ON movies.id = castings.movie_id
    JOIN
      actors ON castings.actor_id = actors.id
    WHERE
      castings.ord != 1 AND actors.name = 'Harrison Ford'
  SQL
end

def films_and_stars_from_sixty_two
  # List the title and leading star of every 1962 film.
  execute(<<-SQL)
    SELECT 
      title, name
    FROM
      movies
    JOIN
      castings ON movies.id = castings.movie_id
    JOIN
      actors ON castings.actor_id = actors.id
    WHERE 
      yr = 1962 AND ord = 1
  SQL
end

def travoltas_busiest_years
  # Which were the busiest years for 'John Travolta'? Show the year and the
  # number of movies he made for any year in which he made at least 2 movies.
  execute(<<-SQL)
    SELECT 
      movies.yr, COUNT(movies.id)
    FROM
      movies
    JOIN
      castings ON movies.id = castings.movie_id
    JOIN
      actors ON castings.actor_id = actors.id
    WHERE
      actors.name = 'John Travolta'
    GROUP BY
      movies.yr
    HAVING
      COUNT(movies.id) >= 2
  SQL
end

def andrews_films_and_leads
  # List the film title and the leading actor for all of the films 'Julie
  # Andrews' played in.
  execute(<<-SQL)
    SELECT 
      movies.title, lead_actors.name
    FROM
      movies
    JOIN
      castings AS julie_castings ON movies.id = julie_castings.movie_id
    JOIN 
      actors AS julie_actors ON julie_castings.actor_id = julie_actors.id
    JOIN
      castings AS lead_castings ON movies.id = lead_castings.movie_id
    JOIN
      actors AS lead_actors ON lead_castings.actor_id = lead_actors.id
    WHERE
      julie_actors.name = 'Julie Andrews' AND lead_castings.ord = 1 
  SQL
end

def prolific_actors
  # Obtain a list in alphabetical order of actors who've had at least 15
  # starring roles.
  execute(<<-SQL)
    SELECT
      actors.name
    FROM
      actors
    JOIN
      castings ON actors.id = castings.actor_id
    WHERE
      castings.ord = 1
    GROUP BY 
      actors.name
    HAVING
      COUNT(castings.movie_id) >= 15
    ORDER BY
      actors.name
  SQL
end

def films_by_cast_size
  # List the films released in the year 1978 ordered by the number of actors
  # in the cast (descending), then by title (ascending).
  execute(<<-SQL)
    SELECT  
      movies.title, COUNT(castings.actor_id)
    FROM
      movies
    JOIN
      castings ON movies.id = castings.movie_id
    WHERE
      movies.yr = 1978
    GROUP BY
      movies.title
    ORDER BY
      COUNT(castings.actor_id) DESC, movies.title ASC
  SQL
end

def colleagues_of_garfunkel
  # List all the people who have played alongside 'Art Garfunkel'.
  execute(<<-SQL)
    SELECT
      actors.name
    FROM
      actors
    JOIN
      castings AS art_castings ON actors.id = art_castings.actor_id
    JOIN
      castings AS other_castings ON art_castings.movie_id = other_castings.movie_id
    JOIN
      actors AS other_actors ON other_castings.actor_id = other_actors.id
    WHERE
      art_castings.actor_id != other_castings.actor_id AND other_actors.name = 'Art Garfunkel'
  SQL
end
