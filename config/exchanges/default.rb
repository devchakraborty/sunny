Sunny::Exchange.new :default do
  only_if awaiting_yes_no: :set do
    invoke_first :yes_no
  end

  only_if awaiting_moment: :set do
    invoke_first :moment
  end

  otherwise do
    invoke_first :hello
  end

  unset_state :just_expressed_default
end
