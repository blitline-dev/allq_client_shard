class PausePutHandler < HandlerBase
  def process(tube, is_paused)
    data_hash = Hash(String, String).new
    data_hash["tube"] = tube
    action = is_paused ? "pause" : "unpause"
    request_json = build_action_with_data_hash(action, data_hash)
    data = send_and_parse_response(request_json)
    return JSON.parse("{\"tube\" : \"#{tube}\", \"is_paused\" : \"#{is_paused}\"}")
  end
end
