Sunny::Exchange.new :attachments do
  only_if awaiting_moment: :unset do
    set_state :awaiting_moment, 1
  end

  invoke_last :moment
end
