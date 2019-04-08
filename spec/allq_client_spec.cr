require "./spec_helper"
TEST_JOB_ID = "arbitrary_job_id"

describe AllqClient do
  it "can create a client" do
    c = get_client
  end

  it "can send data to a server" do
    c = get_client
    data = c.job_get("default")
  end

  it "can add a job" do
    c = get_client
    job = build_test_job
    result = c.job_post("default", job)
    result.size.should eq(30)
  end

  it "can get a job" do
    job_id = preload_job
    c = get_client
    job = c.job_get("default")
    job.should be_a(Job)
    if job
      job.body.should eq("dafsdfsdsdf")
    end
  end

  it "can touch a job" do
    job_id = preload_job
    c = get_client
    job = c.job_get("default")
    if job
      data = c.touch_put(job.id)
      data.size.should eq(30)
    end
  end

  it "can release a job" do
    delete_default_tube
    job_id = preload_job
    c = get_client
    job = c.job_get("default")
    if job
      data = c.release_put(job.id)
      data.size.should eq(30)
    end
  end

  # it "can throttle a tube" do
  #   c = get_client
  #   data = c.throttle_post("default", 10)
  #   data["tube"].should eq("default")
  # end

  # it "can pause and unpause" do
  #   c = get_client
  #   data = c.pause_put("default", true)
  #   data["tube"].should eq("default")
  #   data = c.pause_put("default", false)
  #   data["tube"].should eq("default")
  # end

  # it "can get multiple" do
  #   delete_default_tube
  #   job_id = preload_job
  #   job_id = preload_job
  #   job_id = preload_job
  #   job_id = preload_job
  #   job_id = preload_job
  #   c = get_client
  #   data = c.multiple_job_get("default", 5)
  #   job = data[0]
  #   job.should be_a(Job)
  #   if job
  #     job.body.should eq("dafsdfsdsdf")
  #   end
  # end

  it "can set parent job" do
    delete_default_tube
    job_id = preload_job
    c = get_client
    job = build_test_job
    result = c.parent_job_post("default", job, 300, true, 1)
    result.size.should eq(30)
  end
end
