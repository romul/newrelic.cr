require "./lib_newrelic"
require "./newrelic/agent"

module NewRelic
  VERSION = "1.1.0"

  macro web_transaction(txn_name, &content)
    txn = NewRelic::Agent.instance.start_web_transaction({{txn_name}})
    {{content.body}}
    NewRelic::Agent.instance.end_transaction(txn)
  end

  macro non_web_transaction(txn_name, &content)
    txn = NewRelic::Agent.instance.start_non_web_transaction({{txn_name}})
    {{content.body}}
    NewRelic::Agent.instance.end_transaction(txn)
  end

  macro segment(name, category, &content)
    segment = NewRelic::Agent.instance.start_segment(txn, {{name}}, {{category}})
    {{content.body}}
    NewRelic::Agent.instance.end_segment(txn, segment)
  end
end
