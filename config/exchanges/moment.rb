Joy::Exchange.new :moment do
  only_if awaiting_moment: true do
    store_moment

    only_if awaiting_moment_1: true do
      invoke_first :moment_1
    end

    only_if awaiting_moment_2: true do
      invoke_first :moment_2
    end

    only_if awaiting_moment_3: true do
      invoke_first :moment_3
    end

    set_state :awaiting_yes_no
    unset_state :awaiting_moment
  end
end
