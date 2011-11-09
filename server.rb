require 'sinatra'
require 'digest/md5'
require 'sdbm'

set :port, 3002

post '/upload' do
    id = params['id']
    imagedata = params['imagedata'][:tempfile].read
    hash = Digest::MD5.hexdigest(imagedata)

    create_newid = false
    if not id or id == "" then
        id = Digest::MD5.hexdigest(request.ip + Time.now.to_s)
        create_newid = true
    end

    dbm = SDBM.open('db/id',0644)
    dbm[hash] = id
    dbm.close

    File.open("data/#{hash}.png","w").print(imagedata)

    if create_newid then
        headers "X-Gyazo-Id" => id
    end

    "http://screen.chihaya-pm.org/#{hash}.png"
end