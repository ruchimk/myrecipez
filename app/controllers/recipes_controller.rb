class RecipesController < ApplicationController
  before_action(:find_user, except: [:search_results])
  before_action(:new_recipe, only: [:search_result, :new, :create])
  before_action(:find_recipe, only: [:show, :edit, :update, :destroy])

  def search_results
    # http://api.bigoven.com/console
    #Search Recipes: http://api.bigoven.com/recipes?title_kw=oysters&pg=1&rpp=20&api_key={your-api-key}
    #Get a recipe: http://api.bigoven.com/recipe/47725?api_key={your-api-key}
    @search_terms = params[:q].gsub(" ", "+")
    response_hash = HTTParty.get("http://api.bigoven.com/recipes?title_kw=#{@search_terms}&pg=1&rpp=20&api_key=#{API_KEY}")
    @search_results = response_hash["RecipeSearchResult"]["Results"]["RecipeInfo"]
  end

  def search_result
    get_json
  end

  def new
  end

  def create
    @recipe[:title] = params["recipe"]["title"]
    @recipe[:imageURL] = params["recipe"]["imageURL"]
    @recipe[:description] = params["recipe"]["description"]
    @recipe[:cuisine] = params["recipe"]["cuisine"]
    @recipe[:ingredients] = params["recipe"]["ingredients"].split("$")
    @recipe[:instructions] = params["recipe"]["instructions"].split("$")
    @recipe[:serving_size] = params["recipe"]["serving_size"]
    @recipe[:time] = params["recipe"]["time"]
    @recipe[:user_id] = params[:user_id]
    @recipe.save
    redirect_to user_recipes_path(@user)
  end

  def index
    @recipes = Recipe.where(user_id: @user.id)
  end

  def show
  end

  def edit
  end

  def update
    @recipe[:title] = params[:recipe][:title]
    @recipe[:imageURL] = params[:recipe][:imageURL]
    @recipe[:description] = params[:recipe][:description]
    @recipe[:cuisine] = params[:recipe][:cuisine]
    @recipe[:ingredients] = params[:recipe][:ingredients].split(', ')
    @recipe[:instructions] = params[:recipe][:instructions].split('. ')
    @recipe[:serving_size] = params[:recipe][:serving_size].split('. ')
    @recipe[:time] = params[:recipe][:time]
    @recipe[:user_id] = params[:user_id]
    @recipe.save
    redirect_to user_recipes_path(@user)
  end

  def destroy
    @recipe.destroy
    redirect_to user_recipes_path
  end

  private

  def get_json
    @recipe_id = params[:recipe_id]
    response = HTTParty.get("http://api.bigoven.com/recipes?title_kw=#{@search_terms}&pg=1&rpp=20&api_key=#{API_KEY}")
    @recipe_imageURL = response["Recipe"]["ImageURL"]
    @recipe_title = response["Recipe"]["Title"]
    @recipe_description = response["Recipe"]["Description"]
    @recipe_cuisine = response["Recipe"]["Cuisine"]
    @recipe_time = response["Recipe"]["TotalMinutes"]
    @recipe_rating = response["Recipe"]["StarRating"].to_f.round(2)
    @recipe_ingredient_array = response["Recipe"]["Ingredients"]["Ingredient"].map do |ingredient_hash|
      "#{ingredient_hash["Quantity"].to_f.round(2) } #{ingredient_hash["Unit"]} #{ingredient_hash["Name"]}"
    end
    @recipe_instructions = response["Recipe"]["Instructions"].split(". ")
  end

  def recipe_params
    params.require(:recipe).permit(:title, :imageURL, :description, :cuisine, :serving_size)
  end

  def find_user
    @user = current_user
  end

  def find_recipe
    @recipe = Recipe.find(params[:id])
  end

  def new_recipe
    @recipe = Recipe.new
  end

end


