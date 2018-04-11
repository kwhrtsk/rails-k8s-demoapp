class MessagesController < ApplicationController
  before_action :set_messages

  def index
    @message = Message.new
  end

  def create
    @message = Message.create(create_params)
    ResponseMessageJob.set(wait: 3.seconds).perform_later(@message)
    if @message.valid?
      redirect_to messages_url
    else
      render :index
    end
  end

  private

    def set_messages
      @messages = Message.order(id: :desc).limit(30)
    end

    def create_params
      params.require(:message).permit(:body)
    end
end
