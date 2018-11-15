class ConcertsController < ApplicationController
   skip_before_action :verify_authenticity_token
  def index
    if current_user
        render :index
      else
        redirect_to root_path
      end
  end



  def new
    @user = User.find_by(params[:user_id])
  end

  def show
    @concerts = Concert.find_by(params[:concert_id])
  end


  def buy_tickets
    @user = User.find_by(params[:user_id])
    ticket = Ticket.new(user_id: params[:user_id], concert_id: params[:concert_id])
    flash[:notice] = ticket.purchaseticket(@user.id)
    flash[:success] = flash[:notice] if flash[:notice] == "Success"
    redirect_to user_concerts_path(@user)
  end

  def refund
    @user = User.find_by(params[:user_id])
    ticket = Ticket.find(params[:ticket_id])
    concert = ticket.concert
    ticket.user
      if concert.time.to_i > Time.now.to_i
        @user.money = @user.money + concert.cost
        @user.save(validate: false)
        ticket.delete
        flash[:success] = "Successfully Refunded."
      else
        flash[:notice] = "You cannot refund a ticket that has already expired!"
      end
      redirect_to user_concerts_path(@user)
  end

  def most_popular
      @concert = Concert.find(Ticket.top)
    end

end
