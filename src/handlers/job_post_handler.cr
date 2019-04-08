class JobPostHandler < HandlerBase
  def process(tube : String, job : Job) : String
    job.tube = tube
    request_json = build_action_job("put", job)
    data = send_and_parse_response(request_json)
    get_job_id_from_response(data)
  end
end
