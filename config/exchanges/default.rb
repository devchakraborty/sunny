Joy::Exchange.new :default do
  only_if awaiting_yes_no: true do
    invoke_first :yes_no
  end

  only_if awaiting_moment: true do
    invoke_first :moment
  end

  otherwise do
    invoke_first :hello
  end

  unset_state :just_expressed_intent
end
