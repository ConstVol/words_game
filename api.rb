class Api < Sinatra::Base

  use Auth

  post '/phrases' do
    data = JSON.parse(request.body.read.to_s)
    @phrase = Phrase.create(user_name: data['user'], last_user: data['user'])
    unless data['phrase']['first'].nil?
      @word = Word.create(text: data['phrase']['first'], user_name: data['user'],
                          phrase_id: @phrase.id, time: Time.new.to_s)
      Pusher.trigger('messages', 'my_event', {
          text: "LOOOOL"
      })
      @phases = Phrase.all.to_json
    end
  end

  get '/users' do
    User.all.to_json
  end

  get '/phrases/:id/words' do
    @phrase = Phrase.find(params['id'])
    @phrase.words.to_json
  end

  post '/phrases/:id/words' do
    data = JSON.parse(request.body.read.to_s)
    @phrase = Phrase.find(params['id'])
    if @phrase.last_user != data['user'] && data['word']['text'] != 'null'
      @phrase.last_user = data['user']
      @word = Word.create(text: data['word']['text'], phrase_id: params['id'],
                          user_name: data['user'],  time: Time.new.to_s)
      @phrase.save!
      Pusher.trigger('messages', 'my_event', {
          text: "LOOOOL"
      })
    end
    Phrase.all.to_json
  end
end