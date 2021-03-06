class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :destroy]

  def index
    render locals: { users: User.all }
  end

  def show
    if User.exists?(params[:id])
      @user = User.find(params[:id])
      render locals: { user: @user }
    else
      render html: 'User not found', status: 404
    end
  end

  def new
    render locals: { user: User.new }
  end

  def create
    user = User.new(user_params)

    if params.fetch(:instrument, {}).values.empty?
      UserInstrument.create!(user: user, instrument: Instrument.first)
    else
      user.instruments = params[:instrument].values.map{ |id| Instrument.find(id) }
    end

    if params.fetch(:chord, {}).values.empty?
      UserChord.create!(user: user, chord: Chord.first)
    else
      user.chords = params[:chord].values.map{ |id| Chord.find(id) }
    end

    if params.fetch(:scale, {}).values.empty?
      UserScale.create!(user: user, scale: Scale.first)
    else
      user.scales = params[:scale].values.map{ |id| Scale.find(id) }
    end

    if params.fetch(:reverb, {}).values.empty?
      UserReverb.create!(user: user, reverb: Reverb.first)
    else
      user.reverbs = params[:reverb].values.map{ |id| Reverb.find(id) }
    end

    if user.save
      sign_in_new_user(user)
      redirect_to root_path
    else
      @user = user
      render :new, locals: { user: user }
    end
  end

  def edit
    render locals: { user: User.find(params[:id]) }
  end

  def update
    if User.find(params[:id])
      user = User.find(params[:id])

      if params.fetch(:instrument, {}).values.empty?
        user.instruments.destroy_all
      else
        user.instruments = params[:instrument].values.map{ |id| Instrument.find(id) }
      end

      if params.fetch(:chord, {}).values.empty?
        user.chords.destroy_all
      else
        user.chords = params[:chord].values.map{ |id| Chord.find(id) }
      end

      if params.fetch(:scale, {}).values.empty?
        user.scales.destroy_all
      else
        user.scales = params[:scale].values.map{ |id| Scale.find(id) }
      end

      if params.fetch(:reverb, {}).values.empty?
        user.reverbs.destroy_all
      else
        user.reverbs = params[:reverb].values.map{ |id| Reverb.find(id) }
      end

      if user.update(user_params)
        redirect_to root_path
      else
        render :edit
      end
    else
      render html: 'User not found', status: 404
    end
  end

  def destroy
    if User.exists?(params[:id])
      User.destroy(params[:id])
      flash[:notice] = "User destroyed"
      redirect_to user
    else
      flash[:alert] = "There was an error - please try again"
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
