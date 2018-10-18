class ActionMailbox::Ingresses::Amazon::InboundEmailsController < ActionMailbox::BaseController
  before_action :ensure_verified

  # TODO: Lazy-load the AWS SDK
  require "aws-sdk-sns/message_verifier"
  cattr_accessor :verifier, default: Aws::SNS::MessageVerifier.new

  def create
    ActionMailbox::InboundEmail.create_and_extract_message_id! params.require(:content)
    head :no_content
  end

  private
    def ensure_verified
      head :unauthorized unless verified?
    end

    def verified?
      verifier.authentic?(request.body)
    end
end
