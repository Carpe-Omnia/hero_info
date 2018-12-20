class HeroInfo::CLI
  attr_accessor :saved
  
  def initialize
    @saved = []
  end
  
  def saved
    @saved
  end
  
  def call
    greeting
    commands
    user_loop
	puts "Hope you enjoyed using hero_info"
  end

  def greeting
    puts "welcome to hero_info"
    puts "The most efficient source of superhero info"
  end

  def commands
    puts "Type the name of a superhero you'd like to know more about"
    puts "Type 'exit' to leave the program"
    puts "Type 'show all' to display saved heroes"
    puts "Type 'clear' to remove saved heroes"
  end

  def take_input
    puts "What would you like to do?"
    input = gets.strip
    input
  end

  def get_hero(hero_name)
    base_url = "https://superheroes.fandom.com/wiki/"
    full_url = "#{base_url}#{hero_name}"
    doc = Nokogiri::HTML(open(full_url))
    real_name = doc.css("tr")[2].css("div")[1].text
    first_appearance = doc.css("tr")[3].css("div")[1].text
    creators = doc.css("tr")[4].css("div")[1].text
    teams = doc.css("tr")[5].css("div")[1].text
    aliases = doc.css("tr")[6].css("div")[1].text
    base = doc.css("tr")[7].css("div")[1].text
    powers = doc.css("tr")[8].css("div")[1].text
    skills = doc.css("tr")[9].css("div")[1].text
    tools = doc.css("tr")[10].css("div")[1].text
    #puts real_name.class
    #puts real_name
    info_hash = {:real_name => real_name, :first_appearance => first_appearance, :creators => creators,
    :teams => teams, :aliases => aliases, :base => base, :powers => powers, :skills => skills, :tools => tools}
    origin = doc.css("p")[2].text
    description = doc.css("p")[1].text
    info_ray = [description, origin, info_hash]
    info_ray
  end

  def show_hero(info_ray) # displays a hero and asks a user if they'd like to save it.
    puts "Description: #{info_ray[0]}"
    puts "Origin Story: #{info_ray[1]}"
    info_ray[2].each do |entry, value|
      if entry != "Powers" && value =="None"
        #puts "working as intended"
      else
        puts "#{entry}: #{value}"
      end
    end
    save_hero?(info_ray)
  end
  
  def display_hero(info_ray) #exact same as show_hero, but doesn't ask the user if they'd like to save.
    puts "Description: #{info_ray[0]}"
    puts "Origin Story: #{info_ray[1]}"
    info_ray[2].each do |entry, value|
      if entry != "Powers" && value =="None"
        #puts "working as intended"
      else
        puts "#{entry}: #{value}"
      end
    end
  end
  
  def save_hero?(info)
    puts "would you like to save this hero (y/n)"
    save = gets.strip
    if save == "y"
      @saved << info
      puts "hero saved "
      @saved = @saved.uniq
    end
  end

  def user_loop
    input = take_input
    while input != "exit"
      interpret_input(input)
      input = take_input
    end
  end
  
  def interpret_input(input)
    if input == "show all"
      @saved.each do |hero|
        display_hero(hero)
      end
    elsif input == "commands"
      commands
    elsif input == "clear"
      @saved = []
      puts "saved heroes cleared"
    else
      info = get_hero(input)
      show_hero(info)
    end
  end

end #end of CLI
