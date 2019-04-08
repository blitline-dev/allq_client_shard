class JobGetHandler < HandlerBase
  def process(tube, action_name = "get") : Job | Nil
    job = nil
    request_json = build_action_with_field_tuple(action_name, "tube", tube)

    data = send_and_parse_response(request_json)
    if data && data["job"]?
      job_factory = JobFactory.build_job_factory_from_hash(data["job"])
      job = job_factory.get_job
    end
    return job
  end
end
