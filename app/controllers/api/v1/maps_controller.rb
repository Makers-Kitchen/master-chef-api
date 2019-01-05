require 'net/http'
require 'uri'
require 'json'

class Api::V1::MapsController < ApplicationController
    protect_from_forgery with: :null_session

    def pin
        # # get a maker's slack details + current location

        if params[:team_id] == "TBLCZTAHF"
            if !params[:text].nil? && !params[:text].empty?
                if params[:text].count("a-zA-Z") > 0
                    user_id = params[:user_id]
                    user_name = params[:user_name]
                    location = params[:text]
                    response_url = params[:response_url]

                    bot_response = [
                        "Awesome! 😀 Have fun in ",
                        "Woohoo! 🎉 Enjoy your stay in ",
                        "Sounds fun 🙌 Stay safe and have fun while you are in ",
                        "Thanks 👌 I've pinned your location and shared with other makers here. Have fun in ",
                        "Sweet! 🗺 Exploring ha? Have fun exploring ",
                        "Niceee 🙌 Stay safe, drive safe, explore well and be mindful in ",
                        "OMG! I'm kinda jealous right now 😋 Have fun in ",
                        "I 👏 am 👏 jealous haha! Enjoy your stay in ",
                        "Oh wow, travelling ha? 💼 Stay safe and eat well while you are in ",
                        "What a place to be in! 🙌 Stay fed and brush your teeth while you are in ",
                        "Thanks for letting me know 👌 I'll let the other makers know that you are in ",
                        "Awesome! 😀 I'll update the maker map to draw a giant pin (like your face) in ",
                        "Take me with you! 😅 Drive safe, eat well and stay hydrated while you are in ",
                        "Explore well and experience well. I'll update the maker map! Make some memories in "
                    ]
                    response_text = bot_response.sample + location.to_s + "!"

                    render json: { text: response_text }, status: :created

                    # save location
                    pin = Pin.new(user_id: user_id, user_name: user_name, location: location)
                    pin.save!
                else
                    render json: { text: "That doesn't seem like a valid location 😅 Is this a trick question?" }, status: :created
                end
            else
                render json: { text: "To pin your location, I need to know your current city name. For example: Melbourne, Colombo, Austin 🏖" }, status: :created
            end
        else
            render json: { error: { type: "UNAUTHORIZED", message: "You don't seem like a Maker's Kitchen Chef to me 🤔 🛡" } }, status: 401
        end

    end

    def search
        if !params[:text].nil? && !params[:text].empty?
            if params[:text].count("a-zA-Z") > 0
                location = params[:text]
                user_id = params[:user_id]
                response_text = ""

                no_makers_responses = 
                [
                    "Oh boy you are in uncharted territory. Looks like there aren't anyone in that area 🤔",
                    "Sorry, <@" + user_id + ">, there aren't any makers in " + location + " right now 🙁 But hey.. YOU ARE THE FIRST! 😃",
                    "Umm <@" + user_id + ">, looks like there are no makers from the kitchen in that area. But we have one now... YOU! 😅",
                    "No one is in " + location + " right now, sorry 🙂",
                    "Sorry, <@" + user_id + ">, I couldn't find anyone in " + location
                ]

                found_maker_intro_responses = 
                [
                    "I smell makers in " + location + "! 😃 ",
                    "You are in luck, <@" + user_id + "> ",
                    "Woohoo! 🙌  <@" + user_id + ">! ",
                    "Yay! 😄😄  "
                ]

                pins = Pin.where("upper(location) like ?", "%" + location.upcase + "%")
                if pins.size > 0
                    # found makers in the required location
                    intro_response = found_maker_intro_responses.sample
                    if pins.size == 1
                        # only one result. respond with singular terms
                        response_text = intro_response + "<@" + pins[0].user_id + "> is in " + pins[0].location
                    else
                        # multiple results. get plural, baby
                        response_text = intro_response

                        counter = 0;
                        # iterate each pin
                        pins.each do |pin|
                            counter+=1

                            if counter == 1
                                # if its the 1st pin, don't add a comma in front
                                response_text = response_text + "<@" + pins[0].user_id + ">"
                            else
                                # if its not the 1st pin, add a comma in front
                                response_text = response_text + ", <@" + pins[0].user_id + ">"
                            end
                        end

                        # add outro message
                        response_text = response_text + " are in " + location
                    end

                    # render response
                    render json: { text: response_text }
                else
                    # no makers in the location
                    render json: { text: no_makers_responses.sample }                    
                end
            else
                render json: { text: "That doesn't seem like a valid location 😅 Is this a trick question?" }, status: :created
            end
        else
            render json: { text: "To find makers in a location, pass the location name. For example: Melbourne, Colombo, Austin 🏖" }, status: :created
        end
    end

    def list_all
        makers = Array.new
        pins = Pin.select("*")
        pins.each do |pin|
            profile = get_profile(pin.user_id)
            if !profile.nil?
                maker = { 
                    name: profile['real_name'], 
                    display_name: profile['display_name'], 
                    username: pin['user_name'], 
                    current_location: pin['location'], 
                    avatar: profile['image_512']
                }
                makers.push(maker)
            end
        end
        render :json => makers
    end

    def get_profile slack_user_id
        uri = URI('https://slack.com/api/users.profile.get?token=' + ENV["slack_token"].to_s + '&user=' + slack_user_id)
        result = Net::HTTP.get(uri)
        response = ActiveSupport::JSON.decode(result) 
        return response['profile']
    end

    def find
        if !params[:location].nil? && !params[:location].empty?
            if params[:location].count("a-zA-Z") > 0
                location = params[:location]

                pins = Pin.where("upper(location) like ?", "%" + location.upcase + "%")
                render :json => pins
            else
                render json: { text: "That doesn't seem like a valid location 😅 Is this a trick question?" }, status: :created
            end
        else
            render json: { text: "To pin your location, I need to know your current city name. For example: Melbourne, Colombo, Austin 🏖" }, status: :created
        end
    end

    def show
    end

end
