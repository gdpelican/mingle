module Mingle
  Mixer = Struct.new(:group) do
    def mix!
      a_users, b_users = pairs
      a_users.zip(b_users)
    end

    def pairs
      @pairs ||= group.users.real.not_suspended.activated.order("RANDOM()").in_groups(2)
    end
  end
end
