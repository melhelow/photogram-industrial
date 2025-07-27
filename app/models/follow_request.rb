class FollowRequest < ApplicationRecord
  # Possible status values: 'pending', 'accepted', 'rejected' (adjust as needed)
  
  # Scopes
  scope :pending, -> { where(status: 'pending') }
  scope :accepted, -> { where(status: 'accepted') }

  # Associations
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User"

   def pending?
    status == 'pending'
  end

  def accepted?
    status == 'accepted'
  end

  def rejected?
    status == 'rejected'
  end

  
  # Validations, enums, or other logic here if needed
end
