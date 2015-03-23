class ChargesController < ApplicationController
  def create

    # Creates a Stripe Customer object, for associating
    # with the charge
    customer = Stripe::Customer.create(
      email: current_user.email,
      card: params[:stripeToken]
    )
   
    # Where the real magic happens
    begin
      charge = Stripe::Charge.create(
        customer: customer.id, # Note -- this is NOT the user_id in the app
        amount: 100_00,
        description: "Blocipedia Membership = #{current_user.email}",
        currency: 'usd'
      )

      if current_user.update_attribute(:role, "premium")
        flash[:success] = "Thanks for all the money, #{current_user.email}! Feel free to pay me again."       
      else
        flash[:success] = "There was an error upgrading your account. Please contact support!"        
      end
      
       redirect_to edit_user_registration_path

      # Stripe will send back CardErrors, with friendly messages
      # when something goes wrong.
      # This `rescue block` catches and displays those errors.
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_charge_path
    end
  end

  def new
    @stripe_btn_data = {
     key: "#{ Rails.configuration.stripe[:publishable_key] }",
     description: "BigMoney Membership - #{current_user.name}",
     amount: 100_00
   }
 end
end