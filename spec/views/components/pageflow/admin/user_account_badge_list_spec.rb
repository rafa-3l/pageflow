require 'spec_helper'

module Pageflow
  describe Admin::UserAccountBadgeList, type: :view_component do
    it 'renders only accounts the current user is member of' do
      current_user = create(:user)
      user = create(:user)
      common_account = create(:account, name: 'Common')
      invited_account = create(:account, name: 'Invited')
      other_account = create(:account, name: 'Other')
      create(:membership, user: current_user, entity: common_account, role: :manager)
      create(:membership, user: current_user, entity: invited_account, role: :manager)
      create(:membership, user: user, entity: common_account)
      create(:invitation, user: user, entity: invited_account)
      create(:membership, user: user, entity: other_account)

      allow(helper).to receive(:current_ability).and_return(Ability.new(current_user))
      allow(helper).to receive(:authorized?).and_return(true)

      render(current_user)

      expect(rendered).to have_selector('li', text: /Common/)
      expect(rendered).to have_selector('li', text: /Invited/)
      expect(rendered).not_to have_selector('li', text: /Other/)
    end
  end
end
