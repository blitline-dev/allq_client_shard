require "socket"
require "file_utils"
require "json"

class MockServer
  UNIX_SOCKET_PATH = "/tmp/allq_client.sock"

  def handle_client(client)
    puts "Connected client: #{client}"
    while message = client.gets
      puts "[#{client}] Message: #{message}"
      puts "Returning: #{canned_response(message)}"
      client.puts canned_response(message)
    end
  end

  def initialize
    File.delete(UNIX_SOCKET_PATH)
    start
    loop do
      sleep(100)
    end
  end

  def start
    spawn do
      puts "STARTED Server with #{UNIX_SOCKET_PATH}..."
      server = UNIXServer.new(UNIX_SOCKET_PATH)
      while client = server.accept?
        spawn handle_client(client)
      end
    end
  end

  def canned_response(data)
    body_hash = JSON.parse(data)
    response = "{}"
    if body_hash["action"]
      response = map_response(body_hash["action"])
    end
    response
  end

  def map_response(action) : String
    v = ""
    case action
    when "put"
      v = %({
          "response": {
              "action": "put",
              "job_id": "S4SxW/9,dFJhySVCznMfo3rm2VjzsA"
          },
          "job": {
              "job_id": "S4SxW/9,dFJhySVCznMfo3rm2VjzsA"
          }
      })
    when "get", "get_multiple_jobs"
      v = %({
          "response": {
              "action": "get",
              "job": {
                  "job_id": "S4SxW/9,dFJhySVCznMfo3rm2VjzsA",
                  "body": "dafsdfsdsdf",
                  "tube": "default",
                  "expireds": "0",
                  "releases": "0"
              }
          }
      })
    when "stats"
      v = %({
          "default": {
              "ready": "0",
              "delayed": "4",
              "reserved": "4",
              "buried": "0",
              "parents": "0"
          },
          "docker": {
              "ready": "0",
              "delayed": "0",
              "reserved": "0",
              "buried": "0",
              "parents": "0"
          },
              "global": {
              "action_count": "209949646"
          }
      })
      return v
    when "delete"
      return %({"response":{"action":"delete","job_id":"1UlU8ptPR4co76p65nwOLg"}})
    when "done"
      return %({"response":{"action":"done","job_id":"1UlU8ptPR4co76p65nwOLg"}})
    when "set_parent_job"
      return %({"response":{"action":"set_parent_job","job_id":"1UlU8ptPR4co76p65nwOLg"}})
    when "set_children_started"
      return %({"response":{"action":"set_children_started","job_id":"1UlU8ptPR4co76p65nwOLg"}})
    when "touch"
      return %({"response":{"action":"touch","job_id":"BUlU8ptPR4co76p65nwOLg"}})
    when "clear"
    when "peek"
      v = %({
          "response": {
              "action": "get",
              "job": {
                  "job_id": "lseQMxLRhD8HRdJR25ZhqA",
                  "body": "dafsdfsdsdf",
                  "tube": "default",
                  "expireds": "0",
                  "releases": "0"
              }
          }
      })
    when "pause"
      return %({"response":{"action":"pause"}})
    when "unpause"
      return %({"response":{"action":"unpause"}})
    when "bury"
      return %({"response":{"action":"bury","job_id":"1UlU8ptPR4co76p65nwOLg"}})
    when "kick"
      return %({"response":{"action":"kick","job_id":"1UlU8ptPR4co76p65nwOLg"}})
    when "release"
      return %({"response":{"action":"release","job_id":"1UlU8ptPR4co76p65nwOLg"}})
    when "throttle"
      return %({"response":{"action":"throttle"}})
    when "admin"
    else
      puts "illegal action"
    end

    # Normalize
    json = JSON.parse(v).to_json
    return json
  end
end

MockServer.new
