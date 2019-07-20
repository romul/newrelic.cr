@[Link(ldflags: "/usr/local/lib/libnewrelic.a")]
lib LibNewRelic
  alias LibC::Bool = ::Bool # LibC::Int

  struct AppConfigT
    app_name : LibC::Char[255]
    license_key : LibC::Char[255]
    redirect_collector : LibC::Char[100]
    log_filename : LibC::Char[512]
    log_level : LogLevel
    transaction_tracer : TransactionTracerConfigT
    datastore_tracer : DatastoreSegmentConfigT
    distributed_tracing : DistributedTracingConfigT
    span_events : SpanEventConfigT
  end

  enum LogLevel
    Error   = 0
    Warning = 1
    Info    = 2
    Debug   = 3
  end

  struct TransactionTracerConfigT
    enabled : LibC::Bool
    threshold : TransactionTracerThresholdT
    duration_us : TimeUsT
    stack_trace_threshold_us : TimeUsT
    datastore_reporting : TransactionTracerConfigTDatastoreReporting
  end

  enum TransactionTracerThresholdT
    ThresholdIsApdexFailing = 0
    ThresholdIsOverDuration = 1
  end
  alias Uint64T = LibC::ULong
  alias TimeUsT = Uint64T

  struct TransactionTracerConfigTDatastoreReporting
    enabled : LibC::Bool
    record_sql : TtRecordsqlT
    threshold_us : TimeUsT
  end

  enum TtRecordsqlT
    SqlOff        = 0
    SqlRaw        = 1
    SqlObfuscated = 2
  end

  struct DatastoreSegmentConfigT
    instance_reporting : LibC::Bool
    database_name_reporting : LibC::Bool
  end

  struct DistributedTracingConfigT
    enabled : LibC::Bool
  end

  struct SpanEventConfigT
    enabled : LibC::Bool
  end

  struct DatastoreSegmentParamsT
    product : LibC::Char*
    collection : LibC::Char*
    operation : LibC::Char*
    host : LibC::Char*
    port_path_or_id : LibC::Char*
    database_name : LibC::Char*
    query : LibC::Char*
  end

  struct ExternalSegmentParamsT
    uri : LibC::Char*
    procedure : LibC::Char*
    library : LibC::Char*
  end

  type AppT = Void*
  type TxnT = Void*
  type SegmentT = Void*
  type CustomEventT = Void*

  fun configure_log = newrelic_configure_log(filename : LibC::Char*, level : LogLevel) : LibC::Bool
  fun init = newrelic_init(daemon_socket : LibC::Char*, time_limit_ms : LibC::Int) : LibC::Bool
  fun version = newrelic_version : LibC::Char*

  fun create_app_config = newrelic_create_app_config(app_name : LibC::Char*, license_key : LibC::Char*) : AppConfigT*
  fun destroy_app_config = newrelic_destroy_app_config(config : AppConfigT**) : LibC::Bool

  fun create_app = newrelic_create_app(config : AppConfigT*, timeout_ms : LibC::UShort) : AppT
  fun destroy_app = newrelic_destroy_app(app : AppT*) : LibC::Bool

  fun start_web_transaction = newrelic_start_web_transaction(app : AppT, name : LibC::Char*) : TxnT
  fun start_non_web_transaction = newrelic_start_non_web_transaction(app : AppT, name : LibC::Char*) : TxnT
  fun set_transaction_timing = newrelic_set_transaction_timing(transaction : TxnT, start_time : TimeUsT, duration : TimeUsT) : LibC::Bool
  fun ignore_transaction = newrelic_ignore_transaction(transaction : TxnT) : LibC::Bool
  fun end_transaction = newrelic_end_transaction(transaction_ptr : TxnT*) : LibC::Bool

  fun start_segment = newrelic_start_segment(transaction : TxnT, name : LibC::Char*, category : LibC::Char*) : SegmentT
  fun start_datastore_segment = newrelic_start_datastore_segment(transaction : TxnT, params : DatastoreSegmentParamsT*) : SegmentT
  fun start_external_segment = newrelic_start_external_segment(transaction : TxnT, params : ExternalSegmentParamsT*) : SegmentT
  fun set_segment_parent = newrelic_set_segment_parent(segment : SegmentT, parent : SegmentT) : LibC::Bool
  fun set_segment_parent_root = newrelic_set_segment_parent_root(segment : SegmentT) : LibC::Bool
  fun set_segment_timing = newrelic_set_segment_timing(segment : SegmentT, start_time : TimeUsT, duration : TimeUsT) : LibC::Bool
  fun end_segment = newrelic_end_segment(transaction : TxnT, segment_ptr : SegmentT*) : LibC::Bool

  fun add_attribute_int = newrelic_add_attribute_int(transaction : TxnT, key : LibC::Char*, value : LibC::Int) : LibC::Bool
  fun add_attribute_long = newrelic_add_attribute_long(transaction : TxnT, key : LibC::Char*, value : LibC::Long) : LibC::Bool
  fun add_attribute_double = newrelic_add_attribute_double(transaction : TxnT, key : LibC::Char*, value : LibC::Double) : LibC::Bool
  fun add_attribute_string = newrelic_add_attribute_string(transaction : TxnT, key : LibC::Char*, value : LibC::Char*) : LibC::Bool

  fun notice_error = newrelic_notice_error(transaction : TxnT, priority : LibC::Int, errmsg : LibC::Char*, errclass : LibC::Char*)

  fun create_custom_event = newrelic_create_custom_event(event_type : LibC::Char*) : CustomEventT
  fun discard_custom_event = newrelic_discard_custom_event(event : CustomEventT*)
  fun record_custom_event = newrelic_record_custom_event(transaction : TxnT, event : CustomEventT*)
  fun custom_event_add_attribute_int = newrelic_custom_event_add_attribute_int(event : CustomEventT, key : LibC::Char*, value : LibC::Int) : LibC::Bool
  fun custom_event_add_attribute_long = newrelic_custom_event_add_attribute_long(event : CustomEventT, key : LibC::Char*, value : LibC::Long) : LibC::Bool
  fun custom_event_add_attribute_double = newrelic_custom_event_add_attribute_double(event : CustomEventT, key : LibC::Char*, value : LibC::Double) : LibC::Bool
  fun custom_event_add_attribute_string = newrelic_custom_event_add_attribute_string(event : CustomEventT, key : LibC::Char*, value : LibC::Char*) : LibC::Bool

  fun record_custom_metric = newrelic_record_custom_metric(transaction : TxnT, metric_name : LibC::Char*, milliseconds : LibC::Double) : LibC::Bool

  fun create_distributed_trace_payload = newrelic_create_distributed_trace_payload(transaction : TxnT, segment : SegmentT) : LibC::Char*
  fun accept_distributed_trace_payload = newrelic_accept_distributed_trace_payload(transaction : TxnT, payload : LibC::Char*, transport_type : LibC::Char*) : LibC::Bool
  fun create_distributed_trace_payload_httpsafe = newrelic_create_distributed_trace_payload_httpsafe(transaction : TxnT, segment : SegmentT) : LibC::Char*
  fun accept_distributed_trace_payload_httpsafe = newrelic_accept_distributed_trace_payload_httpsafe(transaction : TxnT, payload : LibC::Char*, transport_type : LibC::Char*) : LibC::Bool
end
