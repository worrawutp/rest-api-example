class HeroesController < ApplicationController
  def index
    heroes = Hero.all
    render json: heroes
  end

  def create
    if hero_name_missing? || find_duplicated_hero?
      render_error("cannot create hero. the hero name may be missing or duplicated")
      return
    end

    hero = Hero.new(hero_create_params)
    if hero.save
      render json: hero
    else
      render_error("cannot create hero")
    end
  end

  def show
    if hero = find_hero
      render json: hero
    else
      render_error("cannot find hero")
    end
  end

  def edit
    if hero = find_hero
      if hero.update(hero_update_params)
        render json: hero
      else
        render_error("cannot update hero")
      end
    else
      render_error("cannot find hero")
    end
  end

  private

  def hero_update_params
    hero_create_params
  end

  def hero_create_params
    params.require('hero').permit(:name, :job, :gender)
  end


  def render_error(msg)
    render json: { error: msg }, status: 500
  end

  def find_hero
    Hero.find_by_id params[:id]
  end

  def hero_name_missing?
    return true if params[:hero].present?
    return true if params[:hero][:name].present?
  end

  def find_duplicated_hero?
    ipnut_name = params[:hero][:name]
    input_name.downcase == Hero.where(name: params[:heroa][:name]).last.name.downcase
  end
end
