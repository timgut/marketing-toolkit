require "rails_helper"

RSpec.describe AdminMailer, type: :mailer do
  let(:approved_user)   { create(:user, approved: true,  rejected: false) }
  let(:rejected_user)   { create(:user, approved: false, rejected: true)  }
  let(:unapproved_user) { create(:user, approved: false, rejected: false) }

  describe "#send_account_activation" do
    let(:mail) { AdminMailer.send_account_activation(self).deliver_now }

    it 'renders the receiver email' do
      expect(mail.to).to eq ["#{recruiter.email}"]
    end

    it 'renders the sender email' do
      expect(mail.from).to eq ["#{EXPORTABLE_CONFIG['notice_from']}"]
    end
  end
end
