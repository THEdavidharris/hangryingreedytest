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
    @ingreds ||= []
    @parsed_ingredients.each { |x, parsed| 
        ingredientHash = {
            :fullString => x.to_s, 
            :amount => parsed.amount.to_s,
            :unit => parsed.unit.to_s,
            :ingredient => parsed.ingredient.to_s   
        }
        @ingreds.push(ingredientHash)
    }
     
    content_type :json
    @ingreds.to_json    
 
  else
    haml :app, locals: { recipe: @recipe, parsed_ingredients: @parsed_ingredients }
  end
end
