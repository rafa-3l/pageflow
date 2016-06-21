module Dom
  module Admin
    class InvitationForm < Domino
      selector 'form.pageflow_invitation'

      attribute :entity_type, '#invitation_entity_type'

      def submit_with(options)
        within(node) do
          select(User.find(options[:user_id]).formal_name,
                 from: 'invitation_user_id') if options[:user_id]

          if options[:entity_id]
            if entity_type == 'Pageflow::Entry'
              select(entity_type.constantize.find(options[:entry_id]).title,
                     from: 'invitation_entity_id')
            else
              select(entity_type.constantize.find(options[:entry_id]).name,
                     from: 'invitation_entity_id')
            end
          end

          select(I18n.t("activerecord.values.pageflow/membership.role.#{options[:role]}"),
                 from: 'invitation_role') if options[:role]

          find('[name="commit"]').click
        end
      end
    end
  end
end
