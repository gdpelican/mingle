module Mingle
  Mixer = Struct.new(:users) do
    def mix!
      filtered_users = users
        .real
        .not_suspended
        .activated
      filtered_users.to_a.shuffle!
      a_users, *b_users = filtered_users.in_groups(SiteSetting.mingle_group_size)
      a_users.zip(*b_users)
    end
  end
end
