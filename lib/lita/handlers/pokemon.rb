module Lita
  module Handlers
    class Pokemon < Handler

      route(/^throw a pokeball!$/i, :throw, command: false, help: { "throw a pokeball!" => "Gets a random pokemon and names it.."} )
      route(/^pokemon\s+(.+)$/i, :search, command: false, help: { "pokemon <number>" => "Gets a specific pokemon via the National pokedex and gives some stats"} )

      def throw(request)
        random_number = rand(001..778)
        name = get_pokemon(random_number)
        request.reply "http://assets14.pokemon.com/assets/cms2/img/pokedex/detail/#{random_number.to_s.rjust(3, "0")}.png"
        request.reply "I choose you #{name}!"
      end

      def search(request)
        pokemon_number = request.matches[0][0]
        if pokemon_number.to_i > 778
          request.reply "You've picked a too high of a pokedex number!"
        else
          name = get_pokemon(pokemon_number)
          request.reply "http://assets14.pokemon.com/assets/cms2/img/pokedex/detail/#{pokemon_number.to_s.rjust(3, "0")}.png"
          request.reply "I choose you #{name}!"
        end
      end

      def get_pokemon(pokemon_number)
        url = "http://pokeapi.co/api/v1/pokemon/#{pokemon_number}/"
        http_response = http.get(url)
        data = MultiJson.load(http_response.body)
        name = data["name"]
        # pkdx_id = data["pkdx_id"]
        # sp_atk = data["sp_atk"]
        # sp_def = data["sp_def"]
        # speed = data["speed"]
        # attack = data["attack"]
        # defense = data["defense"]
      end
    end

    Lita.register_handler(Pokemon)
  end
end
