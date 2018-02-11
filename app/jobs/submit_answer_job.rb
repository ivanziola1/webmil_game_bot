class SubmitAnswerJob
  include SuckerPunch::Job

  def perform(from:, photo:)
    SubmitAnswer.call(from: from, photo: photo)
  end
end
