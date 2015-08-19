class InternalPost < Post
  belongs_to :user
  validates :user, :title, :body_markdown, presence: true
  has_many :comments, as: :parent

  before_save do
    parser = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)
    self.body_html = parser.render(body_markdown)
  end

  def username
    self.user.username
  end

  def number_of_comments
    comments.count
  end

  def create_tags_from_tag_string
    tags.clear
    @tags_list.each do |tag_title|
      existing_tag = Tag.find_by(title: tag_title)

      if existing_tag
        tags << existing_tag
      else
        tags.create!(title: tag_title, user_id: user_id)
      end
    end
  end
end
