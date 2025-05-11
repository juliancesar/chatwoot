class Api::V1::Accounts::Conversations::BaseController < Api::V1::Accounts::BaseController
  before_action :conversation

  private

  def conversation
    hideAllTabs = ENV.fetch('EKIPES_HIDE_ALL_TABS_WHEN_AGENT', '').split(',').map(&:to_i)
    if current_user.agent? && hideAllTabs.include?(current_account.id)
      @conversation ||= Current.account.conversations.find_by!(display_id: params[:conversation_id], assignee_id: current_user.id)  
    else
      @conversation ||= Current.account.conversations.find_by!(display_id: params[:conversation_id])  
    end
    
    authorize @conversation.inbox, :show?
  end
end
