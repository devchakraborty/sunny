Joy::Exchange.new :yes_no_3 do
  only_if awaiting_yes_no_3: true do
    only_if just_expressed_yes_no: "yes" do
      message do
        text "Wow even more? Please share!"
      end

      set_state :awaiting_moment
      set_state :awaiting_moment_3
    end

    only_if just_expressed_yes_no: "no" do
      message do
        text "Ok no worries, I'll definitely remember those stories though!"
      end
    end

    unset_state :awaiting_yes_no_3
  end
end
