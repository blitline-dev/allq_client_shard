class HandlerBase
  def initialize(connection : AllqClient::Connection)
    @connection = connection
  end

  def send_and_parse_response(request_json)
    begin
      response_json = @connection.send(request_json) || "{}"
      parsed_json = JSON.parse(response_json)
      if parsed_json["response"]?
        return parsed_json["response"]
      end
      return parsed_json
    rescue ex
      puts "Failed to send_and_parse"
      puts request_json
      puts "Error: #{ex.inspect}"
    end
  end

  def get_job_id_from_response(data) : String
    job_id = nil
    if data
      job_id = data["job_id"]? ? data["job_id"] : ""
    end
    return job_id.to_s
  end

  def normalize_json_hash(json_hash : JSON::Any)
    h = Hash(String, String).new
    json_hash.as_h.each do |k, v|
      h[k.to_s] = v.to_s
    end
    return h
  end

  def build_action_with_data_hash(action_name, data_hash : Hash(String, String))
    string = JSON.build do |json|
      json.object do
        json.field "action", action_name
        json.field "params" do
          json.object do
            data_hash.each do |key, val|
              json.field key, val
            end
          end
        end
      end
    end
    string
  end

  def build_action_with_field_tuple(action_name : String, field_name : String, field_value : String)
    string = JSON.build do |json|
      json.object do
        json.field "action", action_name
        json.field "params" do
          json.object do
            json.field field_name, field_value
          end
        end
      end
    end
    string
  end

  def build_action_job(action_name : String, job)
    string = JSON.build do |json|
      json.object do
        json.field "action", action_name
        json.field "params" do
          json.raw JobFactory.to_hash(job).to_json
        end
      end
    end
    string
  end

  def build_action_job_with_data_hash(action_name : String, job, data_hash : Hash(String, String))
    string = JSON.build do |json|
      json.object do
        json.field "action", action_name
        json.field "params" do
          json.object do
            data_hash.each do |key, val|
              json.field key, val
            end
            json.field "job" do
              json.raw JobFactory.to_hash(job).to_json
            end
          end
        end
      end
    end
    string
  end
end
