
def __fetch_current_access
  @current_access = Access.last
end

attr_reader :current_access

def last_credential
  Credential.last
end

def current_user
  current_access.user
end
