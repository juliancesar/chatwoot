class Api::V1::Accounts::Contacts::ConversationsController < Api::V1::Accounts::Contacts::BaseController
  def index
    @conversations = Current.account.conversations.includes(
      :assignee, :contact, :inbox, :taggings
    ).where(inbox_id: inbox_ids, contact_id: @contact.id).order(id: :desc).limit(20)
  end

  # Novo método que retorna a última atividade da conversa do contato
  def last_activity
    @conversations = Current.account.conversations.includes(
      :inbox
    ).where(inbox_id: inbox_ids, contact_id: @contact.id).order(last_activity_at: :desc).limit(1)    
  end

  private

  def inbox_ids
    if Current.user.administrator? || Current.user.agent?
      Current.user.assigned_inboxes.pluck(:id)
    else
      []
    end
  end
end