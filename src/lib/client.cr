module AllqClient
  class Client
    def initialize
      @connection = AllqClient::Connection.new
    end

    def job_post(tube : String, job) : String
      handler = JobPostHandler.new(@connection)
      handler.process(tube, job)
    end

    def job_get(tube) : Job | Nil
      handler = JobGetHandler.new(@connection)
      handler.process(tube, "get")
    end

    def peek_get(tube) : Job | Nil
      handler = JobGetHandler.new(@connection)
      handler.process("peek")
    end

    def release_put(job_id, delay = 0) : String
      handler = JobReleaseHandler.new(@connection)
      handler.process(job_id, delay)
    end

    def multiple_job_get(tube, count) : Array(Job)
      handler = MultipleJobGetHandler.new(@connection)
      handler.process(tube, count)
    end

    def parent_job_post(tube, job, timeout = 3600, run_on_timeout = true, limit = nil)
      handler = ParentJobPostHandler.new(@connection)
      handler.process(tube, job, timeout, run_on_timeout, limit)
    end

    def set_children_started_put(job_id)
      handler = SetChildrenStartedPutHandler.new(@connection)
      handler.process(job_id)
    end

    def tube_delete(tube)
      handler = TubeDeleteHandler.new(@connection)
      handler.process(tube)
    end

    def throttle_post(tube, tps)
      handler = ThrottlePostHandler.new(@connection)
      handler.process(tube, tps)
    end

    def stats
      handler = StatsHandler.new(@connection)
      handler.process
    end

    def pause_put(tube, is_paused)
      handler = PausePutHandler.new(@connection)
      handler.process(tube, is_paused)
    end

    # --- Generics

    def job_delete(job_id) : String
      handler = GenericJobIdHandler.new(@connection)
      handler.process("delete", job_id)
    end

    def touch_put(job_id) : String
      handler = GenericJobIdHandler.new(@connection)
      handler.process("touch", job_id)
    end

    def bury_put(job_id) : String
      handler = GenericJobIdHandler.new(@connection)
      handler.process("bury", job_id)
    end
  end
end
