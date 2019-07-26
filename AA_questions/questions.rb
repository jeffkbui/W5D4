require 'sqlite3'
require 'singleton'

class QuestionsDBConnection < SQLite3::Database
  include Singleton

  def initialize 
      super('questions.db')
      self.type_translation = true 
      self.results_as_hash = true
  end

end





class Users 
  attr_accessor :id, :fname, :lname
  def self.all
    data = QuestionsDBConnection.instance.execute("SELECT * FROM users")
    data.map { |datum| Users.new(datum)}
  end

  def initialize(columns)
    @id = columns['id']
    @fname = columns['fname']
    @lname = columns['lname']
  end

  def self.find_by_id(id)
    user = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    Users.new(user.first)
  end

  def self.find_by_name(fname, lname)
    users = QuestionsDBConnection.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL
    Users.new(users.first)
  end
  def authored_question
    Questions.find_by_author_id(self.id)
  end
  def authored_replies
    Replies.find_by_user_id(self.id)
  end

end








class Questions
  attr_accessor :id, :title, :body, :author_id
  def self.all
    data = QuestionsDBConnection.instance.execute("SELECT * FROM questions")
    data.map { |datum| Questions.new(datum)}
  end

  def initialize(columns)
    @id = columns['id']
    @title = columns['title']
    @body = columns['body']
    @author_id = columns['author_id']
  end
  def self.find_by_author_id(author_id)
    question = QuestionsDBConnection.instance.execute(<<-SQL,author_id)
      SELECT *
      FROM questions
      WHERE
      author_id = ?
    SQL
    Questions.new(question.first)
  end

  def self.find_by_id(id)
    questions = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    Questions.new(questions.first)
  end
  def author 
    user = Users.find_by_id(self.author_id)
    user.fname + " " + user.lname
  end

  def replies 
    Replies.find_by_questions_id(self.id)
  end
end








class Question_Follows
  attr_accessor :id, :users_id, :questions_id
  def self.all
    data = QuestionsDBConnection.instance.execute("SELECT * FROM question_follows")
    data.map { |datum| Question_Follows.new(datum)}
  end

  def initialize(columns)
    @id = columns['id']
    @users_id = columns['users_id']
    @questions_id = columns['questions_id']
  end

  def self.find_by_id(id)
    question_follows = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?
    SQL
    Question_Follows.new(question_follows.first)
  end
  def self.followers_for_question_id(questions_id)
    question_follows = QuestionsDBConnection.instance.execute(<<-SQL, questions_id)
    SELECT
      users.id, users.fname, users.lname
    FROM
      users
    JOIN 
      question_follows ON users.id = question_follows.users_id
    WHERE
      questions_id = ?

    SQL
    users = []
    question_follows.each do |user|
      users << Users.new(user)
    end
    users
    # [Users.new(question_follows.first)]
  end
  def self.followed_questions_for_user_id(users_id)
    question_follows = QuestionsDBConnection.instance.execute(<<-SQL, users_id)
    SELECT
      questions.id,questions.title, questions.body, questions.author_id
    FROM 
      questions
    JOIN
      question_follows ON questions.id = question_follows.questions_id
    WHERE
      users_id = ?
  SQL
  questions = []
  question_follows.each do |question|
    questions << Questions.new(question)
  end
  questions
  end
end








class Replies
  attr_accessor :id, :users_replying_id, :questions_id, :parent_id, :body
  def self.all
    data = QuestionsDBConnection.instance.execute("SELECT * FROM replies")
    data.map { |datum| Replies.new(datum)}
  end

  def initialize(columns)
    @id = columns['id']
    @users_replying_id = columns['users_replying_id']
    @questions_id = columns['questions_id']
    @parent_id = columns['parent_id']
    @body = columns['body']
  end
  def author 
    Users.find_by_id(self.users_replying_id)
  end
  def question
    Questions.find_by_id(self.questions_id)
  end

  def parent_reply
    Replies.find_by_id(parent_id)
  end
  def child_replies
    Replies.all.each do |reply|
      return reply if reply.parent_id == self.id 
    end
    return nil
  end
  def self.find_by_user_id(users_replying_id)
    replies = QuestionsDBConnection.instance.execute(<<-SQL, users_replying_id)
      SELECT
        *
      FROM
        replies
      WHERE
        users_replying_id = ?
    SQL
    Replies.new(replies.first)
  end

  def self.find_by_questions_id(questions_id)
    replies = QuestionsDBConnection.instance.execute(<<-SQL, questions_id)
      SELECT
        *
      FROM
        replies
      WHERE
        questions_id = ?
    SQL
    Replies.new(replies.first)
  end

  def self.find_by_id(id)
    replies = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL
    Replies.new(replies.first)
  end
end







class Question_likes
  attr_accessor :id, :users_replying_id, :questions_id, :parent_id, :body
  def self.all
    data = QuestionsDBConnection.instance.execute("SELECT * FROM question_likes")
    data.map { |datum| Question_likes.new(datum)}
  end

  def initialize(columns)
    @id = columns['id']
    @users_id = columns['users_id']
    @questions_id = columns['questions_id']
  end

  def self.find_by_id(id)
    question_likes = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = ?
    SQL
    Question_likes.new(question_likes.first)
  end
end