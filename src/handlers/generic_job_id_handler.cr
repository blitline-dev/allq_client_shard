class GenericJobIdHandler < HandlerBase
  def process(action_name, job_id) : String
    request_json = build_action_with_field_tuple(action_name, "job_id", job_id)
    data = send_and_parse_response(request_json)
    get_job_id_from_response(data)
  end
end
