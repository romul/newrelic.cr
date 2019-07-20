module NewRelic
  class Agent
    def self.instance
      default_app_name = ::PROGRAM_NAME.split("/").last
      @@instance ||= self.start(default_app_name)
    end

    def self.start(config : Pointer(LibNewRelic::AppConfigT))
      @@instance ||= new(config)
    end

    def self.start(app_name : String)
      config = self.create_app_config(app_name, ENV["NEWRELIC_LICENSE_KEY"])
      @@instance ||= new(config)
    end

    def self.configure_log(filename : String, level = LibNewRelic::LogLevel::Info)
      LibNewRelic.configure_log(filename, level)
    end

    def self.create_app_config(app_name : String, license_key : String)
      LibNewRelic.create_app_config(app_name, license_key)
    end

    def self.terminate
      self.instance.terminate
    end

    @app : LibNewRelic::AppT

    def initialize(config : Pointer(LibNewRelic::AppConfigT))
      LibNewRelic.init(nil, 0)
      @app = LibNewRelic.create_app(config, 10000)
      LibNewRelic.destroy_app_config(pointerof(config))
    end

    def terminate
      return if @app.address == 0
      LibNewRelic.destroy_app(pointerof(@app))
    end

    def app
      @app
    end

    def start_web_transaction(txn_name : String) : LibNewRelic::TxnT
      LibNewRelic.start_web_transaction(@app, txn_name)
    end

    def start_non_web_transaction(txn_name : String) : LibNewRelic::TxnT
      LibNewRelic.start_non_web_transaction(@app, txn_name)
    end

    def end_transaction(txn : LibNewRelic::TxnT) : Bool
      return false if txn.address == 0
      LibNewRelic.end_transaction(pointerof(txn))
    end

    def start_segment(txn : LibNewRelic::TxnT, name : String, category : String) : LibNewRelic::SegmentT
      return Pointer(Void).new(0).as(LibNewRelic::SegmentT) if txn.address == 0
      LibNewRelic.start_segment(txn, name, category)
    end

    def end_segment(txn : LibNewRelic::TxnT, segment : LibNewRelic::SegmentT) : Bool
      return false if txn.address == 0 || segment.address == 0
      LibNewRelic.end_segment(txn, pointerof(segment))
    end
  end
end
