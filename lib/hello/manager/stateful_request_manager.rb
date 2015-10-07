module Hello
  module Manager
    class StatefulRequestManager < RequestManager
      def initialize(*args)
        super(*args)
        @finder          = Finder.new(self)
        @session_wrapper = SessionWrapper.new(self)
      end

      delegate :session_token,  :session_token=,
               :session_tokens, :session_tokens=,
               to: :@session_wrapper

      delegate :current_accesses, to: :@finder

      def current_access
        return nil unless session_token.presence
        @current_access ||= current_accesses.find { |a| a.token == session_token }
      end

      def sign_in!(*args)
        super(*args).tap do |access|
          self.session_token = access.token
          session_tokens << access.token
        end
      end

      def sign_out!
        super
        self.session_token = nil
        self.session_tokens = Access.where(token: session_tokens).pluck(:token)
        request.session['impersonated'] = nil
      end
    end
  end
end
