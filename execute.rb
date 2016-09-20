$stdout.sync = true
require "json"
require "faraday"
require "filecop"

changed_files = (ENV.fetch("CHANGED_FILES") || ARGF.read).split(' ')
runner = Filecop::Runner.new(changed_files)
data = runner.run

if data.length < 1
  puts "No sensitive files found"
else
  puts "#{data.length} problems found"

  conn = Faraday.new(:url => ENV.fetch("APP_URL")) do |config|
    config.adapter Faraday.default_adapter
  end

  data.each do |warning|
    body = "It looks like you may have accidentally commited this file, if so, this article may be of assistance: https://help.github.com/articles/remove-sensitive-data/"

    discovery = {
      title: warning["message"],
      path: warning["file"],
      line: 1,
      body: body,
      task_id: ENV.fetch("TASK_ID"),
      kind: "line_comment",
      identifier: warning["file"],
      priority: :medium
    }

    res = conn.post do |req|
      req.url '/actions?kind=line_comments'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Basic #{ENV.fetch("ACCESS_TOKEN")}"
      req.body = discovery.to_json
    end
    puts res.inspect
  end
end
