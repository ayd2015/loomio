class MotionSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id,
             :key,
             :discussion_id,
             :discussion_key,
             :name,
             :description,
             :outcome,
             :activity_count,
             :did_not_votes_count,
             :created_at,
             :updated_at,
             :closing_at,
             :closed_at,
             :last_vote_at,
             :vote_counts,
             :activity_count

  has_one :author, serializer: UserSerializer, root: 'users'
  has_one :outcome_author, serializer: UserSerializer, root: 'users'


  def filter(keys)
    keys.delete(:outcome_author) unless object.outcome_author.present?
    keys
  end
end
