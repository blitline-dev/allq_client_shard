class TubeDeleteHandler < HandlerBase
  def process(tube) : String
    data_hash = Hash(String, String).new
    data_hash["tube"] = tube

    request_json = build_action_with_data_hash("clear", data_hash)
    data = send_and_parse_response(request_json)

    return "{\"tube\":\"#{tube}\"}"
  end
end
