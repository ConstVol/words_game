require './app'
require './api'
JWT_SECRET = 'testApp'
JWT_ISSUER = 'gameApp'
run Rack::URLMap.new({
'/' => PublicRoutes,
'/api' => Api
})