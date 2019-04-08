require "spec"
require "../src/allq_client"
require "random/secure"

def build_test_job
  data = Hash(String, String).new
  data["body"] = "dafsdfsdsdf"
  job_factory = JobFactory.new(data, "default", 5)
  job_factory.get_job
end

def preload_job
  c = AllqClient::Client.new
  job = build_test_job
  job_id = c.job_post("default", job)
  job_id
end

def delete_default_tube
  c = AllqClient::Client.new
  c.tube_delete("default")
end

def get_client
  AllqClient::Client.new
end
