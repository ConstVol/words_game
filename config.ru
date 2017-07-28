require './app'
require './api'
JWT_SECRET = 'testApp'
JWT_ISSUER = 'gameApp'
Pusher.app_id = ENV['PUSHER_APP_ID']
Pusher.key = ENV['PUSHER_KEY']
Pusher.secret = ENV['PUSHER_SECRET']
Pusher.host = ENV['PUSHER_HOST']
run Rack::URLMap.new({
'/' => PublicRoutes,
'/api' => Api
})