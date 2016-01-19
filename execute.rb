$stdout.sync = true
require "json"
require "faraday"

data = JSON.parse(ARGF.read)

if data.length < 1
  puts "No problems found"
else
  puts "#{data.length} problems found"
  
  conn = Faraday.new(:url => ENV.fetch("APP_URL")) do |config|
    config.adapter Faraday.default_adapter
  end
  
  data.each do |warning|
    discovery = {
      title: warning["message"],
      path: warning["file"],
      line: 1,
      task_id: ENV.fetch("TASK_ID"),
      kind: "sensitive file",
      identifier: warning["file"],
      priority: :medium
    }
    
    res = conn.post do |req|
      req.url '/discoveries'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Basic #{ENV.fetch("ACCESS_TOKEN")}"
      req.body = discovery.to_json
    end
    puts res.inspect
  end
end