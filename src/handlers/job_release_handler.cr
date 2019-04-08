class JobReleaseHandler < HandlerBase
  def process(job_id, delay) : String
    data_hash = Hash(String, String).new
    data_hash["job_id"] = job_id
    data_hash["delay"] = delay.to_s

    request_json = build_action_with_data_hash("release", data_hash)
    data = send_and_parse_response(request_json)
    get_job_id_from_response(data)
  end
end
