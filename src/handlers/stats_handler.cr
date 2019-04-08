class StatsHandler < HandlerBase
  def process
    data_hash = Hash(String, String).new

    request_json = build_action_with_data_hash("stats", data_hash)
    response_json = @connection.send(request_json)
    data = send_and_parse_response(request_json)
    data
  end
end
