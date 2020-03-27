#################### GREETING AND KEY LISTS ###########################################

class CommandLineInterface

  def opening_greeting
    puts ""
    a = Artii::Base.new :font => 'slant'
    puts a.asciify('Movie Quotes!')
    puts ""
    inner_greeting
  end

  def inner_greeting
    puts "Press 'l' for a list of commands."
    puts ""
    command = gets.chomp
    puts ""
    if command == "l"
      list_all_commands
      type_in_next_command
    else
      puts "Invalid key, please try again."        
      inner_greeting
      list_all_commands
      type_in_next_command
    end
  end

  def type_in_next_command
    puts ""
    puts "Please type your next command."
    puts ""
    command = gets.chomp
    system("clear")
    user_command(command) 
  end

  def list_all_commands
    puts ""
    puts "COMMAND LIST"
    puts "-------------"
    puts "list - List all commands"
    puts "1. List all movies"
    puts "2. List all quotes"
    puts "3. List all characters"
    puts "4. Find by genre"
    puts "5. Random quote"
    puts "6. Find movie, quote or character"
    puts "7. Find or create quote"
    puts "8. Delete movie, quote or character"
    puts "9. Update quote"
    puts "10. To try out the quiz!"
    
    puts "exit or x - To exit application"
  end

  def user_command(command)
    case command

    when "list"
      list_all_commands
    when "1" #movie
      row_title("movies")
      puts Movie.all.map{|m| m.title}
      puts ""
    when "2" #quotes
      row_title("quotes")
      puts Quote.all.map{|q| q.line}
      puts ""
    when "3" #characters
      display_characters
    when "4" #genre
      display_genre_quotes_and_movies 
      puts""
    when "5"
      puts ""
      puts "Random quote:"
      puts "-------------"
      puts Quote.all.sample.line
      puts ""
    when "6" #find
      find_by_character_movie_or_quote
    when "7"
      find_or_create
    when "8" #delete
      delete
    when "9" #update 
      update
    when "10" #quiz
      run_quiz 
    when "exit"
      puts ""
      a = Artii::Base.new :font => 'slant'
      puts a.asciify('Thanks For Visiting!')
      exit 0
  end
end

#################### GREETING AND KEY LISTS ###########################################
############################ METHODS ##################################################

def find_by_character_movie_or_quote 
  puts ""
  puts "Press 1. Find by quote:"
  puts "Press 2. Find by character:"
  puts "Press 3. Find by movie:"
  puts ""
  command = gets.chomp
  case command
  when "1"
    puts ""
    puts "Type in your quote"
    puts ""
      quote = gets.chomp
      puts ""
      puts "Your quote is from the movie:"
      puts ""
      puts Quote.find_by(line: quote).movie.title
      puts ""
  when "2"
    puts ""
    puts "Type in your character"
    puts ""
    character_name = gets.chomp
    puts ""
    puts "Your character says these quotes:"
    puts ""
      puts Character.find_by(name: character_name).quotes.map {|q| q.line}
      puts ""
  when "3"
    puts ""
    puts "Type in your movie"
    puts ""
    movie_title = gets.chomp
    puts ""
    puts "Your movie contains these quotes:"
    puts ""
    puts Movie.find_by(title: movie_title).quotes.map {|q| q.line}
    puts ""
  end
end

def find_or_create
  puts ""
  puts "Put your movie title in:"
  puts ""
  movie_title = gets.chomp
  found_movie = Movie.find_by(title: movie_title)
  if found_movie
    puts ""
    puts "This movie is in our Database! Please type in the name of the character who has a quote."
    puts ""
    create_or_find_character_and_quote(found_movie)
  else
      puts ""
      puts "This Movie is not in our database, please type the name of the Movie"
      puts ""
      movie_name = gets.chomp 
      puts "" 
      puts "Now, please put in the year of the Movie."
      puts "" 
      movie_year = gets.chomp
      puts "" 
      puts "Now, please put in the movie Genre."
      puts "" 
      movie_genre = gets.chomp
      puts ""
      new_movie = Movie.create(title: movie_name, year: movie_year, genre: movie_genre)
      puts ""
      puts "This movie is now in our database, please type the character who says the quote."
      puts ""
      create_or_find_character_and_quote(new_movie)
      puts "Thats all now in our database!"
      puts ""
  end
  inner_greeting
end

def update 
  puts ""
  puts "Please type in the quote you would like to update."
  puts ""
  quote = gets.chomp
  puts ""
  found_quote = Quote.all.find_by(line: quote)
  if found_quote 
    puts "This quote is in our system! What would you like to update it to?"
  puts ""
  updated = gets.chomp
  found_quote.update(line: updated)
  puts ""
  puts "Your quote is now '#{updated}''"
  puts ""
  else 
    puts ""
    puts "sorry this is not in our system, please retry!"
    puts ""
    update
  end
end

def create_or_find_character_and_quote(movie)
  found_movie = movie
  new_character = gets.chomp
  found_character = Character.find_by(name: new_character)
    if found_character
      puts ""
      puts "This character is in our Database! Please type in the quote this character says."
      puts ""
      new_quote = gets.chomp
      Quote.create(line: new_quote, movie_id: found_movie.id, character_id: found_character.id)
    else
      puts ""
      puts "This character is not in out Database. Please type in the characters full name."
      puts "" 
      new_character = gets.chomp
      puts ""
      puts "Now, please type in the gender of the character, using either M or F."
      puts ""
      new_gender = gets.chomp
      puts ""
      created_character = Character.create(name: new_character, sex: new_gender)
      puts "This character is now in our Database! Please type in the quote this character says."
      puts ""
      new_quote = gets.chomp
      Quote.create(line: new_quote, movie_id: found_movie.id, character_id: created_character.id)
    end
end

def display_characters
  row_title("characters")
      puts Character.all.map{|c| c.name}
      puts ""
      puts "For more character options press 'c' or press any other key to exit."
      character_options
end

def character_options
    option = gets.chomp
    puts ""
      if option == "c"
      puts "1. For all male characters press" 
      puts "2. For all female characters press"
      puts "3. For longest name press"
      puts "4. For shortest name press"
      puts ""
      character_option = gets.chomp
      puts ""
      case character_option
        when "1"
        puts Character.all_male
        when "2"
        puts Character.all_female
        when "3"
        puts Character.longest_name
        when "4"
        puts Character.shortest_name   
      end
      puts ""
    end
end

def display_genre_quotes_and_movies 
  puts ""
  puts "Enter a film genre:"
  genre = gets.chomp
  puts ""
  
  counter = 0
  movies = Movie.all.select{|m| m.genre == genre}
  puts row_title("movies and quotes by genre")
  while counter < movies.length
    puts movies[counter].title
    puts ""
    puts movies[counter].quotes.map {|q| q.line}
    puts ""
    counter += 1
  end
  
end

  def delete
  puts  "Which item would you like to delete?"
  puts  "------------------------------------"
  puts  "1. Quote"
  puts  "2. Movie"
  puts  "3. Character"
    puts ""
    argument = gets.chomp
    puts ""
    case argument
    when "1"
      puts "" 
      puts "Please put in the quote you would like to delete."
      quote = gets.chomp
      found_quote = Quote.find_by(line: quote)
      found_quote.delete
      puts "" 
      puts "Thats now deleted!"
      puts ""
    when "2"
      puts "" 
      puts "Please put in the movie you would like to delete."
      movie = gets.chomp
      found_movie = Movie.find_by(title: movie)
      found_movie.delete
      puts "" 
      puts "Thats now deleted!"
      puts ""
    when "3"
      puts "" 
      puts "Please put in the character you would like to delete."
      character = gets.chomp
      found_character = Character.find_by(name: character)
      found_character.delete
      puts "" 
      puts "Thats now deleted!"
      puts ""
    end
  end

  def row_title(title)
    puts ""
    puts "List of #{title}:"
    puts "----------------"
  end

################# quiz #####################
  
  
  def quiz 
    counter = 0
    user_points = 0

    while counter < 10
      puts ""
      puts ""
      puts "------------------------"
      puts "Question #{counter + 1}. What movie is this quote from?"
      puts ""
      quote = "#{Quote.all.sample.line}"
      puts quote
      puts "-----------------------"
      puts ""
      puts "Put your answer here:"
      puts ""
      movie_title = gets.chomp
      system("clear")
      puts ""
      found_movie = Movie.find_by(title: movie_title)
      if !found_movie
        puts "-----------------------------------------------------------"
        puts "Oh no! Thats not right. Your score is still #{user_points}!"
        puts "-----------------------------------------------------------"
      else
        if found_movie.quotes.select{ |q| q == quote}
          user_points += 1
          puts ""
          puts "--------------------------------------------"
          puts "Well done! Your score is now #{user_points}!"
          puts "--------------------------------------------"
          puts ""
        else
          puts "-----------------------------------------------------------"
          puts "Oh no! Thats not right. Your score is still #{user_points}!"
          puts "-----------------------------------------------------------"
          puts ""
        end
    end
    counter += 1
    end
        puts ""
        puts ""
      # if user_points = 0
      #   puts "-----------------------------------------------------------"
      #   puts "The worst effort ever! Your final score was #{user_points} out of 10! Try again!"
      #   puts "-----------------------------------------------------------"
      if user_points <= 5
        puts "-----------------------------------------------------------"
        puts "Horrible effort your final score was #{user_points} out of 10! Try again!"
        puts "-----------------------------------------------------------"
      elsif user_points > 5 && user_points < 10
        puts "-----------------------------------------------------------"
        puts "Great effor your your final score was #{user_points} out of 10!"
        puts "-----------------------------------------------------------"
      else user_points == 10 
        puts "-----------------------------------------------------------"
        puts "Amazing you got #{user_points} out of 10!!!!"
        puts "-----------------------------------------------------------"
        puts ""
        puts ""
    end
  end

  def run_quiz 
    puts "" 
    puts "Hello, and welcome to the movie quotes quiz!"
    puts ""
    quiz 
  end


end
