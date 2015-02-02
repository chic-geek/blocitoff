class Item < ActiveRecord::Base
  belongs_to :list

  def days_left
    # Get todays date using DateTime object then strip off hrs, mins, secs using `.to_date` method.
    todays_date = DateTime.now.to_date

    # Get the created_at date for that item and strip hrs, mins and secs.
    item_created_at = self.created_at.to_date

    # Note how long an item has before auto delete.
    item_duration = 7.days

    # Figure out the due date, takes the created_at and adds 7 days to it.
    due_date = item_created_at + item_duration

    # Take the due_date and subtract todays date, et voila!
    (due_date - todays_date).to_i
  end
end
