atom_feed do |feed|
  feed.title @group.name
  feed.subtitle @group.description
  feed.updated(@discussions.min_by(&:created_at).created_at) if @discussions.any?
	
  @discussions.each do |discussion|
  feed.entry(discussion) do |entry|
  	entry.title(discussion.title)
  	  entry.content(discussion.description, type: :text)
	  entry.link discussion_url(discussion)
	  entry.published discussion.created_at
	  entry.author do |author|
	    author.name discussion.author.name
	  end
    end
  end
end if @group.is_visible_to_public?
