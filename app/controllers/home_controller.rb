class HomeController < ApplicationController
    before_action :require_login

    # GET /
    def index

    end
end
