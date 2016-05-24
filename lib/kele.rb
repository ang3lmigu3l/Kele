require_relative "./kele/version"
require_relative "./kele/errors"
require_relative './kele/roadmap'
require 'httparty'
require 'json'

class Kele
   include HTTParty
   include Roadmap
   base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    response = self.class.post('/sessions',
    body: { email: email, password: password } )
    raise InvalidStudentCodeError.new() if response.code == 401
    @auth_token = response['auth_token']
    @user_id = response['user']['id']

  end

  def get_me
    response = self.class.get('/users/me', headers: { "authorization" => @auth_token })
    @current_user = JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get("/mentors/#{mentor_id}/student_availability" , headers: {"authorization" => @auth_token})
    body = JSON.parse(response.body)
  end

  def get_messages(page)
    response = self.class.get("/message_threads?page=#{page}", headers: { "authorization" => @auth_token})
    body = JSON.parse(response.body)

  end

  #keep getting http error 500 still needs fix

  def create_message(user_id, recipient_id, token , subject, message)
    response = self.class.post('/messages', body: { "user_id": user_id, "recipient_id": recipient_id,"token": token , "subject": subject, "stripped-text": message }, headers: { "authorization" => @auth_token })
    puts response

  end

  def create_submission(assignment_branch, assignment_commit_link, checkpoint_id, comment, user_id)
    response = self.class.post('/checkpoint_submissions', body: {assignment_branch: assignment_branch, assignment_commit_link: assignment_commit_link, checkpoint_id: checkpoint_id, comment: comment, enrollment_id: user_id}, headers: {"authorization" => @auth_token})

    puts response
  end

  def version
    VERSION
  end

end
