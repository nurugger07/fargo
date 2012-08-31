require 'net/ftp'

module Fargo

  class Net::FTP
    HOSTNAME = 'localhost'
    FTP_PORT = '21'
    DEFAULT_BLOCKSIZE = 4096
    USER = 'anonymous'
    CURRENT_PATH = ''
    CRLF = '\r\n'

    def self.open(host, user = nil, passwd = nil, acct = nil)
      if block_given?
        ftp = new(host, user, passwd, acct)
        begin
          yield ftp
        ensure
          ftp.close
        end
      else
        new(host, user, passwd, acct)
      end
    end

    def initialize(host = nil, user = nil, passwd = nil, acct = nil)
      @binary           = true
      @closed           = false
      @current_path     = CURRENT_PATH
      @host             = host || HOSTNAME
      @user             = user || USER
      @status           = "225 Data connection open; no transfer in progress"
    end

    def login(user = "anonymous", passwd = nil, acct = nil)
      @status = anonymous_user(user) || invalid_password(passwd) || valid_login(user)
    end

    def status
      @status
    end

    def closed?
      !!@closed
    end

    def close
      @closed = true
    end

    def mkdir(dirname)
      dirname
    end

    def getdir
      "/#{@current_path}"
    end

    def chdir(dirname)
      @current_path = dirname
    end

    # Theses are private because they are not part of the
    # Net::FTP library
    private

    def anonymous_user(user)
      "332 Need account for login" if user == "anonymous"
    end

    def invalid_password(passwd)
      "430 Invalid username or password" if passwd == nil
    end

    def valid_login(user)
      @user = user
      "230 User logged in, proceed. Logged out if appropriate "
    end
  end

end
