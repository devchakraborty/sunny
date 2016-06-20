Sunny::Exchange.new :attachments do
  set_state :awaiting_moment, 1

  invoke_last :moment
end
