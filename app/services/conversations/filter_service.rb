class Conversations::FilterService < FilterService
  ATTRIBUTE_MODEL = 'conversation_attribute'.freeze

  def initialize(params, user, filter_account = nil)
    @account = filter_account || Current.account
    super(params, user)
  end

  def perform
    validate_query_operator
    @conversations = query_builder(@filters['conversations'])
    mine_count, unassigned_count, all_count, = set_count_for_all_conversations
    assigned_count = all_count - unassigned_count

    {
      conversations: conversations,
      count: {
        mine_count: mine_count,
        assigned_count: assigned_count,
        unassigned_count: unassigned_count,
        all_count: all_count
      }
    }
  end

  def base_relation
    @account.conversations.includes(
      :taggings, :inbox, { assignee: { avatar_attachment: [:blob] } }, { contact: { avatar_attachment: [:blob] } }, :team, :messages, :contact_inbox
    )
  end

  def current_page
    @params[:page] || 1
  end

  def filter_config
    {
      entity: 'Conversation',
      table_name: 'conversations'
    }
  end

  def conversations
    
    # Faz o filtro pela atribuição
    hideAllTabs = ENV.fetch('EKIPES_HIDE_ALL_TABS_WHEN_AGENT', '').split(',').map(&:to_i)
    if @user.administrator? || (@user.agent? && !hideAllTabs.include?(Current.account.id))
      @conversations.sort_on_last_activity_at.page(current_page)
    else
      @conversations.sort_on_last_activity_at.page(current_page).assigned_to(@user)
    end
  
  end
end
