module Pageflow
  module AdmissionMixin
    extend ActiveSupport::Concern

    included do
      belongs_to :user
      belongs_to :entity, polymorphic: true
      validates :user, :entity, :role, presence: true
      validates :user_id, uniqueness: {scope: [:entity_type, :entity_id]}
      validates :role,
                inclusion: {in: %w(previewer editor publisher manager).map(&:to_sym)},
                if: :on_entry?
      validates :role,
                inclusion: {in: %w(member previewer editor publisher manager).map(&:to_sym)},
                if: :on_account?

      scope :on_entries, -> { where(entity_type: 'Pageflow::Entry') }
      scope :on_accounts, -> { where(entity_type: 'Pageflow::Account') }
      scope :as_manager, -> { where(role: :manager) }
      scope :as_publisher_or_above, -> { where(role: %w(publisher manager)) }
      scope :as_previewer_or_above, -> { where(role: %w(previewer editor publisher manager)) }
    end

    private

    def on_entry?
      entity_type == 'Pageflow::Entry'
    end

    def on_account?
      entity_type == 'Pageflow::Account'
    end
  end
end
