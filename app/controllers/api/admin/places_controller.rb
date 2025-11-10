class Api::Admin::PlacesController < ApplicationController
    before_action :authorize_request
    before_action :authorize_admin

    # POST /api/admin/places/:id/approve
    def approve
      place = Place.find(params[:id])
      place.update!(approved: true)
      render json: place
    end

    # POST /api/admin/places/:id/unapprove
    def unapprove
      place = Place.find(params[:id])
      place.update!(approved: false)
      render json: place
    end
end
