class AddBrainTreeSubscriptionToAccounts < ActiveRecord::Migration
  def change
    change_table :accounts do |t|
      t.string :braintree_customer_id # braintree's 'vault' id for store credit cards
      t.date :billing_start # prior to this date a customer is in their trial period
      t.integer :billing_day # the day this customer will be charged each month
      t.boolean :invoice # customers can pay via invoice or credit card
      t.string :vat_number # don't charge VAT to EU customers with a valid VAT number
    end
  end
end
