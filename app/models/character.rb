class Character < ActiveRecord::Base

    has_many :quotes
    has_many :movies, through: :quotes

    def self.delete_quote_from_name(quote)
        found_quote = Quote.find_by(line: quote)
        Quote.all.delete(found_quote)
    end


    def self.longest_name
        Character.all.max_by{|c| c.name.length }.name
    end

    def self.shortest_name
        Character.all.min_by{|c| c.name.length }.name
    end


    def self.all_female
        Character.all.select{|c| c.sex == "F"}.map{|female_name| female_name.name}
    end

    def self.all_male
        Character.all.select{|c| c.sex == "M"}.map{|male_name| male_name.name}
    end

end