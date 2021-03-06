###
UNTV - torrent-search class
Author: Gordon Hall
###

request = require "request"
jade    = require "jade"
fs      = require "fs"
qstring = require "querystring"

class TorrentSearch
  constructor: ->
    @history = []

  base_url: "http://yify-torrents.com/api/"
  data_type: "json"

  templates:
    upcoming: fs.readFileSync "#{__dirname}/views/upcoming-list.jade"
    list: fs.readFileSync "#{__dirname}/views/results-list.jade"
    details: fs.readFileSync "#{__dirname}/views/torrent-details.jade"

  compileTemplate: (template_name) =>
    if not template_name in @templates then throw "Invalid Template: #{template_name}"
    jade.compile @templates[template_name]

  upcoming: (callback) =>
    request "#{@base_url}upcoming.#{@data_type}", (err, response, body) =>
      data = if not err then (results: JSON.parse body) else null
      if typeof callback is "function" then callback err data

  list: (data, callback) =>
    query = qstring.stringify data or {}
    request "#{@base_url}list.#{@data_type}?#{query}", (err, response, body) =>
      data = if not err then (JSON.parse body) else null
      if typeof callback is "function" then callback err, data?.MovieList

  # latest should get us the default sort 
  latest: (callback) => 
    @list 
      quality: "1080p"
      limit: 50
    , callback

  get: (id, callback) =>
    request "#{@base_url}movie.#{@data_type}?id=#{id}", (err, response, body) =>
      data = if not err then (JSON.parse body) else null
      if typeof callback is "function" then callback err, data



module.exports = TorrentSearch
