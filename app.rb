class App < Sinatra::Base

  get '/' do
    erb :index
  end

  post '/events' do
    start_time = Time.now.to_f

    quantity, model, character = params.values_at(
      :quantity, :model, :character)

    quantity = quantity.to_i
    if quantity < 1 || quantity > 50
      quantity = 1
    end

    model = "asynchronously" unless model == "synchronously"
    character = 'No answer' unless character && character.length > 1

    collection = "votes"
    event_properties = { :character => character }

    quantity.times do
      if model == "asynchronously"
        Keen.publish_async(collection, event_properties)
          .callback {
            puts "Vote for '#{character}' successful."
          }.errback {
            puts "Vote for '#{character}' failed!"
          }
      else
        begin
          Keen.publish(collection, event_properties)
          puts "Vote for '#{character}' successful."
        rescue
          puts "Vote for '#{character}' failed!"
        end
      end
    end

    erb :results, :locals => {
      :model => model,
      :quantity => quantity,
      :character => character,
      :response_time => Time.now.to_f - start_time }
  end
end
