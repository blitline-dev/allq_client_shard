class MultipleJobGetHandler < HandlerBase
  def process(tube, count) : Array(Job)
    job_array = Array(Job).new
    data_hash = Hash(String, String).new
    data_hash["tube"] = tube
    data_hash["count"] = count.to_s

    request_json = build_action_with_data_hash("get_multiple_jobs", data_hash)
    data = send_and_parse_response(request_json)
    if data && data["jobs"]?
      data["jobs"].as_a.each do |job_row|
        job_factory = JobFactory.build_job_factory_from_hash(job_row)
        job = job_factory.get_job
        job_array.push(job)
      end
    end
    return job_array
  end
end
