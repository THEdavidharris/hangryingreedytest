require 'hangry'
require 'ingreedy'
require 'open-uri'
require 'sinatra'
require 'json'

def parse_recipe(recipe_url)
  recipe_html_string = open(recipe_url).read
  @recipe = Hangry.parse(recipe_html_string)

  @parsed_ingredients = {}.tap do |additions_and_parsed|
    @recipe.ingredients.each do |ingredient_addition|
      additions_and_parsed[ingredient_addition] = Ingreedy.parse(ingredient_addition)
    end
  end
end


get '/' do
  if params[:recipe_url]
    parse_recipe(params[:recipe_url])
    puts @parsed_ingredients
    puts @parsed_ingredients
  end

  
  #render json: @parsed_ingredients

  haml :app, locals: { recipe: @recipe, parsed_ingredients: @parsed_ingredients }
end
