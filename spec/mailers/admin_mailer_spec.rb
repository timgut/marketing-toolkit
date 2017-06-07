require "rails_helper"

RSpec.describe AdminMailer, type: :mailer do
  let(:approved_user)   { create(:user, approved: true,  rejected: false) }
  let(:rejected_user)   { create(:user, approved: false, rejected: true)  }
  let(:unapproved_user) { create(:user, approved: false, rejected: false) }

  describe "#new_user_waiting_for_approval" do
    let!(:mail) { AdminMailer.new_user_waiting_for_approval(unapproved_user).deliver_now }

    it "sends the email to the correct user" do
      expect(mail.to).to eq ["#{unapproved_user.email}"]
    end

    it "has the correct subject line" do
      expect(mail.subject).to eq "Thanks for registering for the AFSCME Toolkit"
    end

    it "mentions the user's name in the email" do
      expect(mail.body).to include approved_user.name
    end

    it "sends an email" do
      expect {
        AdminMailer.new_user_waiting_for_approval(unapproved_user).deliver_now
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  describe "#notification_to_approvers" do
    let!(:approver1) { create(:user) }
    let!(:approver2) { create(:user) }

    let!(:mail) { AdminMailer.notification_to_approvers(unapproved_user, [approver1, approver2]).deliver_now }

    it "sends the email to the correct approvers" do
      expect(mail.to).to include approver1.email
      expect(mail.to).to include approver2.email
    end

    it "has the correct subject line" do
      expect(mail.subject).to eq "Toolkit account request from #{unapproved_user.name}"
    end

    it "mentions the user's name in the email" do
      expect(mail.body).to include approved_user.name
    end

    it "sends an email" do
      expect {
        AdminMailer.notification_to_approvers(unapproved_user, [approver1, approver2]).deliver_now
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  describe "#send_account_activation" do
    let!(:mail) { AdminMailer.send_account_activation(approved_user).deliver_now }

    it "sends the email to the correct user" do
      expect(mail.to).to eq ["#{approved_user.email}"]
    end

    it "has the correct subject line" do
      expect(mail.subject).to eq "Your AFSCME Toolkit account is now active"
    end

    it "mentions the user's name in the email" do
      expect(mail.body).to include approved_user.name
    end

    it "sends an email" do
      expect {
        AdminMailer.send_account_activation(approved_user).deliver_now
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  describe "#send_account_rejection" do
    let!(:mail) { AdminMailer.send_account_rejection(rejected_user).deliver_now }

    it "sends the email to the correct user" do
      expect(mail.to).to eq ["#{rejected_user.email}"]
    end

    it "has the correct subject line" do
      expect(mail.subject).to eq "Your AFSCME Toolkit account has been declined"
    end

    it "mentions how the user should follow up" do
      expect(mail.body).to include "administrators@toolkit.afscme.org"
    end

    it "sends an email" do
      expect {
        AdminMailer.send_account_rejection(rejected_user).deliver_now
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  describe "#send_account_suspension" do
    let!(:mail) { AdminMailer.send_account_suspension(unapproved_user).deliver_now }

    it "sends the email to the correct user" do
      expect(mail.to).to eq ["#{unapproved_user.email}"]
    end

    it "has the correct subject line" do
      expect(mail.subject).to eq "Your AFSCME Toolkit account has been suspended"
    end

    it "mentions how the user should follow up" do
      expect(mail.body).to include "administrators@toolkit.afscme.org"
    end

    it "sends an email" do
      expect {
        AdminMailer.send_account_suspension(unapproved_user).deliver_now
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
