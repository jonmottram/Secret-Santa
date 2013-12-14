class MainController < ApplicationController

  def index
    redirect_to :controller=> 'main', :action => 'login'
  end

  def login
    if request.get?
      session[:user_id] = nil
      @user = User.new
    else
      @user = User.new(params[:user])
      logged_in_user = @user.try_login
      if (logged_in_user)
        session[:user_id] = logged_in_user.id
        redirect_to(:action => "list")
      else
        flash[:notice] = "Invalid user/password combination"
      end
    end
  end

  def logout
    reset_session
    @user = nil
    redirect_to :controller => 'main', :action => 'login'
  end
  
  def goto_flash_page
    # if flash contains info on where to go
    if flash[:controller] != nil && flash[:action] != nil
      redirect_to :controller => flash[:controller],
                  :action => flash[:action], 
                  :id => flash[:id]
    else
      redirect_to :controller => 'login', :action => 'index'
    end
  end

  def keep_flash_info
    flash.keep(:controller)
    flash.keep(:action)
    flash.keep(:id)
  end
  
  def change_password
    # need to do this since check_person not called on this action
    @user = session[:user]
    keep_flash_info
    if !request.get?
      # make sure both passwords match
      pass1 = params[:user][:pw]
      pass2 = params[:user][:pw2]
      if pass1 == ''
        flash[:error] = "Password cannot be left blank."
      elsif pass1 != pass2
        flash[:error] = "Passwords must match, try again."
      else
        # save the new password
        @user.pw = pass1
        @user.save
        goto_flash_page
      end
    end
  end
  
  def forgot_password
    render 'main/forgot_password' if request.get?
    
    if !request.get?
      if params[:user][:username].empty?
        flash[:error] = "Please enter your name in the box"
      else
        @user = User.find(:first, 
                            :conditions => ["username=?", params[:user][:username].downcase])
        if @user
          # we need some fancy password generator here
          email = XmasMailer.create_forgot_password(@user)
          XmasMailer.deliver(email)
          flash[:notice] = "A password hint has been sent to your email address."
          redirect_to :action => 'login'
        else
          flash[:error] = "Unknown user with username '#{params[:user][:username]}'"
        end
      end
    end
  end
  
  def list
    if @user == nil
      if session[:user_id] == nil
        # Don't know this person
        redirect_to :action => 'login'
      else 
        @user = User.find(session[:user_id])
      end
    end
  end
  
### 2007
#"kris -> "steph
#"della -> "keith
#"skip -> "jon
#"steph -> "kristin
#"keith -> "kris
#"steve -> "skip
#"jon -> "steve
#"kristin -> "della
### 2009
#"skip -> "steph
#"steve -> "keith
#"kristin -> "jon
#"jon -> "kristin
#"della -> "kris
#"kris -> "skip
#"steph -> "steve
#"keith -> "della
### 2010
#"kris -> "steph
#"steph -> "keith
#"kristin -> "jon
#"steve -> "kristin
#"della -> "kris
#"keith -> "skip
#"skip -> "steve
#"jon -> "della
### 2011
#Kristin -> Steph
#Della -> Keith
#Steve -> Jon
#Kris -> Kristin
#Steph -> Kris
#Jon -> Steve
#Keith -> Della
### 2012
#Della -> Steph
#Jack -> Jon
#Steve -> Andrew
#Billy -> Josie
#Andrew -> Keith
#Jon -> Kristin
#Kris -> Jack
#Bryan -> Gavin
#Steph -> Lila
#Kristin -> Kris
#Lila -> Steve
#Gavin -> Billy
#Keith -> Bryan
#Josie -> Della
### 2013
#Gavin -> Steph
#Bryan -> Keith
#Steve -> Jon
#Kris -> Kristin
#Keith -> Kris
#Della -> Steve
#Steph -> Della
#Jon -> Lila
#Kristin -> Andrew
#Jack -> Bryan
#Billy -> Gavin
#Josie -> Billy
#Lila -> Josie
#Andrew -> Jack

  def pick_name
    @user = User.find(params[:id])
    @user.assigned="steph" if (@user.username) == "gavin"
    @user.assigned="jon" if (@user.username) == "steve"
    @user.assigned="andrew" if (@user.username) == "kristin"
    @user.assigned="josie" if (@user.username) == "lila"
    @user.assigned="keith" if (@user.username) == "bryan"
    @user.assigned="kristin" if (@user.username) == "kris"
    @user.assigned="jack" if (@user.username) == "andrew"
    @user.assigned="gavin" if (@user.username) == "billy"
    @user.assigned="lila" if (@user.username) == "jon"
    @user.assigned="kris" if (@user.username) == "keith"
    @user.assigned="steve" if (@user.username) == "della"
    @user.assigned="billy" if (@user.username) == "josie"
    @user.assigned="bryan" if (@user.username) == "jack"
    @user.assigned="della" if (@user.username) == "steph"
    @user.save!
    redirect_to :action => 'list'
  end
  
  def add_a_want
    want = Want.new(:user_id => params[:id],
                    :gottahave => params[:wants][:gottahave])
    want.save!
    redirect_to :action => 'list'
  end
  
  def remove_a_want
    @user = User.find(params[:id])
    want = Want.find(params[:want_id])
    want.destroy
    @user.reload
    redirect_to :action => 'list'
  end
end
