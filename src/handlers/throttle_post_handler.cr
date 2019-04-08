class ThrottlePostHandler < HandlerBase
  def process(tube, tps)
    data_hash = Hash(String, String).new
    data_hash["tube"] = tube
    data_hash["tps"] = tps.to_s
    request_json = build_action_with_data_hash("throttle", data_hash)
    data = send_and_parse_response(request_json)

    return JSON.parse("{\"tube\" : \"#{tube}\"}")
  end
end
