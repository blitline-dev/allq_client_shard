# ---------------------------------
# {
# 	"action" : "set_parent_job",
# 	"data" : {
#       "timeout" : 3600,
#       "limit" : 10,
#       "run_on_timeout" : false
# 	}
# }
# ---------------------------------

class ParentJobPostHandler < HandlerBase
  def process(tube : String, job : Job, timeout = 3600, run_on_timeout = true, limit = nil) : String
    job.tube = tube
    data_hash = Hash(String, String).new
    data_hash["timeout"] = timeout.to_s
    data_hash["tube"] = tube
    data_hash["run_on_timeout"] = run_on_timeout.to_s
    if limit
      data_hash["limit"] = limit.to_s
    end
    request_json = build_action_job_with_data_hash("set_parent_job", job, data_hash)
    data = send_and_parse_response(request_json)
    get_job_id_from_response(data)
  end
end
