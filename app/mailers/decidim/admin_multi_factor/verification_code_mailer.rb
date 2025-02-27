# frozen_string_literal: true

module Decidim
  module AdminMultiFactor
    class VerificationCodeMailer < ApplicationMailer
      # Public: Sends the verification email to the provided email address.
      #
      # email - The email address the veirfication code is to be sent to.
      # verification = The verification code  to be sent.
      # locale - The locale that will be used for the email content (optional).
      #
      # Returns nothing.
      helper_method :confirm_path_url

      def verification_code(email:, verification:, organization:, expires_at:)
        @verification = verification.strip
        @organization = organization
        @expires_at = expires_at

        I18n.with_locale(locale || organization.default_locale) do
          mail(to: email, subject: I18n.t("subject", scope: "decidim.admin_multi_factor.admin_multi_factor.email", verification: verification))
        end
      end

      private

      def confirm_path_url
        "#{root_url}#{decidim_friendly_signup.confirmation_codes_path(confirmation_token: @token)}"
      end

      def root_url
        @root_url ||= decidim.root_url(host: @organization.host)[0..-2]
      end
    end
  end
end
