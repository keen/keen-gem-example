module PassengerEM
  def self.start
    PhusionPassenger.on_event(:starting_worker_process) do |forked|
      if forked && EM.reactor_running?
        EM.stop
      end
      Thread.new { EM.run }
      die_gracefully_on_signal
    end
  end

  def self.die_gracefully_on_signal
    Signal.trap("INT")  { EM.stop }
    Signal.trap("TERM") { EM.stop }
  end
end
