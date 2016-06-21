module Pageflow
  ActiveAdmin.register Invitation, as: 'Invitation' do
    menu false

    actions :new, :create

    form partial: 'admin/memberships/form'

    controller do
      belongs_to :entry, parent_class: Pageflow::Entry, polymorphic: true
      belongs_to :account, parent_class: Pageflow::Account, polymorphic: true
      belongs_to :user, parent_class: User, polymorphic: true

      helper Pageflow::Admin::MembershipsHelper
      helper Pageflow::Admin::FormHelper

      def create_resource(invitation)
        if resource.first_name.blank?
          if params[:user_id]
            invitation_user = User.find(params[:user_id])
          else
            invitation_user = User.find(params[:invitation][:user_id])
          end
          resource.first_name = invitation_user.first_name
          resource.last_name = invitation_user.last_name
        end
        super
      end

      def index
        if params[:user_id].present?
          redirect_to admin_user_url(params[:user_id])
        elsif params[:entry_id].present?
          redirect_to admin_entry_url(params[:entry_id])
        else
          redirect_to admin_account_url(params[:account_id])
        end
      end

      def permitted_params
        result = params.permit(invitation: [:user_id, :entity_id, :entity_type, :role,
                                            :first_name, :last_name])
        restrict_attributes(result[:invitation]) if result[:invitation]
        result
      end

      private

      def restrict_attributes(attributes)
        attributes[:role] = attributes[:role].to_sym if !attributes[:role].nil?
      end
    end
  end
end
