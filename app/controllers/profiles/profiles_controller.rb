# frozen_string_literal: true
module Profiles
  # Profiles controller
  class ProfilesController < BaseController
    before_action :check_general_access_profile, only: %i[show]

    def index
      @profiles = Profile.privacy_public
    end

    def show
    end

    def update
      respond_to do |format|
        if @profile.update(profile_params)
          format.turbo_stream do 
            redirect_to profile_path(id: @profile.slug)
          end
        else
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace('profile_errors', partial: 'profile_errors')
          end
        end
      end
    end

    private

    def profile_params
      params.require(:profile).permit(:name, :privacy, :vanity_url)
    end

    def set_profile
      @profile = Profile.friendly.find(params[:id])
    end
  end
end
