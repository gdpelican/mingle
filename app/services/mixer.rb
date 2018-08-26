module Mingle
  Mixer = Struct.new(:users) do
    def mix!
      a_users, *b_users = users
        .real
        .not_suspended
        .activated
        .order("RANDOM()")
        .in_groups(SiteSetting.mingle_group_size)
      a_users.zip(*b_users)
    end
  end
end
