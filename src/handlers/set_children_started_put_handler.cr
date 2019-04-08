# ---------------------------------
# {
# 	"action" : "set_children_started",
# 	"data" : {
#       "job_id" : "dfasdffsd"
# 	}
# }
# ---------------------------------
class SetChildrenStartedPutHandler < HandlerBase
  def process(job_id) : String
    data_hash = Hash(String, String).new
    data_hash["job_id"] = job_id

    request_json = build_action_with_data_hash("set_children_started", data_hash)
    data = send_and_parse_response(request_json)
    get_job_id_from_response(data)
  end
end
