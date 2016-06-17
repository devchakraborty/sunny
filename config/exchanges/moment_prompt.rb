Sunny::Exchange.new :moment_prompt do
  message do
    text "Sure! How's your week going?"
  end

  set_state :awaiting_moment, 1
  unset_state :just_expressed_moment_prompt
  unset_state :awaiting_yes_no
end
