class PokemonController < ApplicationController
	def pokemon_params
		params.require(:pokemon).permit(:name)
	end
		
	def new
		@pokemon = Pokemon.new
	end
	
	def capture
		@pokemon = Pokemon.find(params[:id])
		@pokemon.trainer = current_trainer
		@pokemon.save
		redirect_to :root
	end
	
	def create
		@pokemon = Pokemon.new(pokemon_params)
		@pokemon.trainer = current_trainer
		@pokemon.level = 1
		@pokemon.health = 100
		if @pokemon.save
			redirect_to trainer_path(:id => current_trainer.id)
		else
			falsh[:error] = @pokemon.errors.full_messages.to_sentence
			redirect_to :back
		end
	end			

	def damage
		@pokemon = Pokemon.find(params[:id])
		@pokemon.trainer = current_trainer
		if @pokemon.trainer
			if params[:attack_pokemon]
				attacker = Pokemon.find(params[:attack_pokemon])
				damage = attacker == @pokemon ? 5 : [((attacker.level / @pokemon.level) * 10), 5].max
				@pokemon.health = [@pokemon.health - damage, 0].max
				@pokemon.health
			
		end	
		redirect_to trainer_path(current_trainer)
		if @pokemon.health <= 0
			exp = [((@pokemon.level ** 2) / attacker.level), 2].max
			attacker.add_exp(exp)
			attacker.save
			flash.alert = "You gained #{exp} experience."
			redirect_to trainser_path(:id => @pokemon.trainer.id)
		end	
	end

	def heal
		@pokemon = Pokemon.find(params[:id])
		if @pokemon.trainer == current_trainer
			if @pokemon.health < 100
				@pokemon.health += 10
			end
			if @pokemon.health > 100
				@pokemon.health = 100
			end
			@pokemon.save
			redirect_to trainser_path(:id => @pokemon.trainer.id)
		else
			redirect_to :back, :alert => "You can only heal your own Pokemon"
		end
	end					
	
end	
