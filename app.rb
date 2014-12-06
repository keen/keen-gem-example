require 'json'

class App < Sinatra::Base

  get '/' do
    erb :index
  end

  # a simple proxy that shows the Keen client querying capability
  get '/results.json' do
    content_type :json
    { :result => Keen.count("votes", :group_by => "character") }.to_json
  end

  get '/events' do
    redirect "/"
  end

  post '/events' do
    start_time = Time.now.to_f

    quantity, model, character = params.values_at(
      :quantity, :model, :character)

    quantity = quantity.to_i
    if quantity < 1 || quantity > 50
      quantity = 1
    end

    character = 'No answer' unless character && character.length > 0

    collection = "votes"
    event_properties = { :character => character }

    if model =~ /batch/
      votes = []
      quantity.times do
        votes << event_properties
      end

      begin
        if model == "asynchronously as a batch"
          Keen.publish_batch_async(:votes => votes).callback {
            puts "#{quantity} votes for '#{character}' successful."
          }
        else
          Keen.publish_batch(:votes => votes)
          puts "#{quantity} votes for '#{character}' successful."
        end
      rescue => e
        puts e
        puts "#{quantity} votes for '#{character}' failed!"
      end
    else
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
          rescue => e
            puts e
            puts "Vote for '#{character}' failed!"
          end
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
